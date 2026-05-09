// ─── Exit word SHA-256 hash consistency tests ───────────────────────────
// Verifies that the browser-side hashWord() from dashboard.js/player.js
// produces the same result as the Node-side sha256Hex() from admin.js.
//
// dashboard.js hashWord (browser Web Crypto):
//   const data = new TextEncoder().encode(word.toLowerCase().trim());
//   const buf  = await crypto.subtle.digest('SHA-256', data);
//   return Array.from(new Uint8Array(buf)).map(b => b.toString(16).padStart(2, '0')).join('');
//
// player.js hashWord (browser Web Crypto):
//   Same algorithm — encoding is done after lowercasing+trimming in attemptExit().
//
// admin.js sha256Hex (Node crypto):
//   return crypto.createHash('sha256').update(str.toLowerCase().trim()).digest('hex');

import { describe, it, expect } from 'vitest';
import crypto from 'crypto';

// ─── Node-side implementation (mirrors admin.js:904-906) ────────────────
function sha256Hex(str) {
  return crypto.createHash('sha256').update(str.toLowerCase().trim()).digest('hex');
}

// ─── Browser-side implementation (mirrors dashboard.js:121-127, player.js:427-433) ─
// Uses Web Crypto API via Node's global crypto (available in Node 19+)
async function browserHashWord(word) {
  const data = new TextEncoder().encode(word.toLowerCase().trim());
  const buf  = await crypto.subtle.digest('SHA-256', data);
  return Array.from(new Uint8Array(buf))
    .map(b => b.toString(16).padStart(2, '0'))
    .join('');
}

// ─── Test words ──────────────────────────────────────────────────────────
const EXIT_WORDS = [
  'maple', 'river', 'cloud', 'stone', 'bread', 'storm', 'flame',
  'lunar', 'amber', 'cedar', 'crane', 'ember', 'frost', 'grove',
  'submit', 'done', 'finished', 'complete', 'exit',
];

const LONG_EXIT_WORDS = [
  'anchor', 'basket', 'beacon', 'blanket', 'cabinet', 'captain',
  'thunder', 'venture', 'western', 'younger',
];

const EDGE_CASE_WORDS = [
  '',                          // empty string
  '  hello  ',                 // whitespace padding
  'HELLO',                     // uppercase
  '  SPACES  ',                // uppercase with spaces
  'mixedCASE',                 // mixed case
  'a',                         // single char
  '   x   ',                   // single char with whitespace
  '\t\n',                      // whitespace-only
  'áéíóú',                     // unicode
  '   ',                       // spaces only (should hash empty after trim)
];

describe('Exit word SHA-256 hashing', () => {

  describe('cross-environment consistency', () => {
    it('produces identical hashes between Node crypto and browser Web Crypto for standard exit words', async () => {
      for (const word of EXIT_WORDS) {
        const nodeHash = sha256Hex(word);
        const browserHash = await browserHashWord(word);
        expect(browserHash, `Mismatch for word: "${word}"`).toBe(nodeHash);
      }
    });

    it('produces identical hashes for long exit words', async () => {
      for (const word of LONG_EXIT_WORDS) {
        const nodeHash = sha256Hex(word);
        const browserHash = await browserHashWord(word);
        expect(browserHash, `Mismatch for word: "${word}"`).toBe(nodeHash);
      }
    });

    it('produces identical hashes for edge cases', async () => {
      for (const word of EDGE_CASE_WORDS) {
        const nodeHash = sha256Hex(word);
        const browserHash = await browserHashWord(word);
        expect(browserHash, `Mismatch for word: ${JSON.stringify(word)}`).toBe(nodeHash);
      }
    });

    it('is deterministic for the same input', () => {
      const hash1 = sha256Hex('submit');
      const hash2 = sha256Hex('submit');
      expect(hash1).toBe(hash2);
    });

    it('is case-insensitive due to the .toLowerCase() call', async () => {
      const upper = sha256Hex('HELLO');
      const lower = sha256Hex('hello');
      expect(upper).toBe(lower);
    });

    it('trims whitespace', async () => {
      const trimmed = sha256Hex('hello');
      const padded = sha256Hex('  hello  ');
      expect(trimmed).toBe(padded);
    });

    it('hashes empty string after trimming whitespace-only input', () => {
      const hash1 = sha256Hex('');
      const hash2 = sha256Hex('   ');
      expect(hash1).toBe(hash2);
    });

    it('produces a 64-character hex string', () => {
      const hash = sha256Hex('submit');
      expect(hash).toMatch(/^[0-9a-f]{64}$/);
    });
  });

  describe('admin.js sha256Hex behavior', () => {
    it('handles common demo seed words from admin.js', () => {
      // These exit words come from DEMO_UPLOAD_SPECS in admin.js
      const demoWords = ['submit', 'done', 'finished', 'complete', 'exit'];
      for (const word of demoWords) {
        const hash = sha256Hex(word);
        expect(hash).toMatch(/^[0-9a-f]{64}$/);
      }
    });
  });

  describe('hash uniqueness', () => {
    it('produces different hashes for different words', () => {
      const hashes = EXIT_WORDS.map(w => sha256Hex(w));
      const unique = new Set(hashes);
      expect(unique.size).toBe(hashes.length);
    });
  });
});
