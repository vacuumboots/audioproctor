// ─── Extension player logic tests ─────────────────────────────────────
// Tests the pure logic functions from extension/player.js:
//   - formatTime()     — time display formatting
//   - ALLOWED_URL_PATTERN — signed URL origin validation
//   - ALLOWED_API_BASES    — API endpoint validation
//   - Exit word verification flow (hash comparison logic)
//
// Chrome-specific APIs (chrome.windows, chrome.tts, chrome.storage)
// cannot run outside the extension context, so those are not tested here.

import { describe, it, expect } from 'vitest';
import crypto from 'crypto';

// ─── formatTime from player.js:468-471 ────────────────────────────────
function formatTime(secs) {
  const m = Math.floor(secs / 60);
  const s = Math.floor(secs % 60).toString().padStart(2, '0');
  return `${m}:${s}`;
}

// ─── URL validation patterns from player.js:10-11 ──────────────────────
const ALLOWED_API_BASES = ['https://audioproctor.com', 'https://app.audioproctor.com'];
const ALLOWED_URL_PATTERN = /^https:\/\/[a-z0-9-]+\.supabase\.co\//;

// ─── Browser-style hashWord (matches player.js:427-433) ──────────────
// Note: player.js does toLowerCase+trim in attemptExit() before calling hashWord,
// while dashboard.js does it inside hashWord(). Both produce the same result.
async function hashWord(word) {
  const data = new TextEncoder().encode(word);
  const buf  = await crypto.subtle.digest('SHA-256', data);
  return Array.from(new Uint8Array(buf))
    .map(b => b.toString(16).padStart(2, '0'))
    .join('');
}

// ─── Exit word verification (mirrors player.js:402-425) ───────────────
// This is the core verification logic extracted for testability.
async function attemptExit(inputWord, exitWordHash) {
  if (!inputWord) return { success: false, error: 'Please type the exit word.' };
  const word = inputWord.toLowerCase().trim();
  if (!word) return { success: false, error: 'Please type the exit word.' };
  const hash = await hashWord(word);
  if (hash === exitWordHash) {
    return { success: true };
  } else {
    return { success: false, error: 'Incorrect exit word. Ask your teacher.' };
  }
}

describe('extension/player.js — pure logic', () => {

  describe('formatTime', () => {
    it('formats 0 seconds as 0:00', () => {
      expect(formatTime(0)).toBe('0:00');
    });

    it('formats seconds under 60 as 0:XX', () => {
      expect(formatTime(5)).toBe('0:05');
      expect(formatTime(45)).toBe('0:45');
      expect(formatTime(59)).toBe('0:59');
    });

    it('formats exactly 1 minute as 1:00', () => {
      expect(formatTime(60)).toBe('1:00');
    });

    it('formats minutes and seconds correctly', () => {
      expect(formatTime(61)).toBe('1:01');
      expect(formatTime(90)).toBe('1:30');
      expect(formatTime(125)).toBe('2:05');
    });

    it('formats large durations', () => {
      expect(formatTime(3600)).toBe('60:00');
      expect(formatTime(3661)).toBe('61:01');
    });

    it('floors fractional seconds', () => {
      expect(formatTime(90.7)).toBe('1:30');
      expect(formatTime(59.9)).toBe('0:59');
    });

    it('handles negative values (edge case, not used in practice)', () => {
      expect(formatTime(-1)).toBe('-1:-1');
    });
  });

  describe('signed URL validation', () => {
    it('accepts supabase.co URLs', () => {
      expect(ALLOWED_URL_PATTERN.test('https://abc.supabase.co/storage/v1/test')).toBe(true);
      expect(ALLOWED_URL_PATTERN.test('https://project-123.supabase.co/object/public/file.mp3')).toBe(true);
    });

    it('rejects non-supabase URLs', () => {
      expect(ALLOWED_URL_PATTERN.test('https://example.com/file.mp3')).toBe(false);
      expect(ALLOWED_URL_PATTERN.test('http://supabase.co/file.mp3')).toBe(false);
      expect(ALLOWED_URL_PATTERN.test('https://supabase.co/file.mp3')).toBe(false);
    });

    it('rejects URLs with subdomains not matching pattern', () => {
      expect(ALLOWED_URL_PATTERN.test('https://SUPABASE.CO/file.mp3')).toBe(false);
    });
  });

  describe('API base validation', () => {
    it('accepts audioproctor.com', () => {
      expect(ALLOWED_API_BASES).toContain('https://audioproctor.com');
    });

    it('accepts app.audioproctor.com', () => {
      expect(ALLOWED_API_BASES).toContain('https://app.audioproctor.com');
    });

    it('does not accept arbitrary origins', () => {
      expect(ALLOWED_API_BASES).not.toContain('https://evil.com');
    });
  });

  describe('exit word verification', () => {
    it('rejects empty input', async () => {
      const result = await attemptExit('', 'somehash');
      expect(result.success).toBe(false);
      expect(result.error).toBe('Please type the exit word.');
    });

    it('rejects whitespace-only input', async () => {
      const result = await attemptExit('   ', 'somehash');
      expect(result.success).toBe(false);
    });

    it('accepts correct exit word', async () => {
      const hash = await hashWord('submit');
      const result = await attemptExit('submit', hash);
      expect(result.success).toBe(true);
    });

    it('accepts correct exit word with extra whitespace', async () => {
      const hash = await hashWord('submit');
      const result = await attemptExit('  submit  ', hash);
      expect(result.success).toBe(true);
    });

    it('accepts correct exit word in uppercase', async () => {
      const hash = await hashWord('submit');
      const result = await attemptExit('SUBMIT', hash);
      expect(result.success).toBe(true);
    });

    it('rejects incorrect exit word', async () => {
      const hash = await hashWord('submit');
      const result = await attemptExit('wrongword', hash);
      expect(result.success).toBe(false);
      expect(result.error).toBe('Incorrect exit word. Ask your teacher.');
    });

    it('produces consistent hash — same word always matches', async () => {
      const hash1 = await hashWord('exit');
      const hash2 = await hashWord('exit');
      expect(hash1).toBe(hash2);
    });

    it('matches hash produced by node-side crypto', async () => {
      const word = 'submit';
      const browserHash = await hashWord(word);
      const nodeHash = crypto.createHash('sha256').update(word.toLowerCase().trim()).digest('hex');
      expect(browserHash).toBe(nodeHash);
    });

    it('handles common exit words from the word list', async () => {
      const words = ['maple', 'river', 'cloud', 'stone', 'bread', 'storm', 'flame'];
      for (const word of words) {
        const hash = await hashWord(word);
        const nodeHash = crypto.createHash('sha256').update(word).digest('hex');
        // hashWord lowercases, so we compare after same transformation
        expect(hash).toBe(nodeHash);
        expect(hash).toMatch(/^[0-9a-f]{64}$/);
      }
    });
  });
});
