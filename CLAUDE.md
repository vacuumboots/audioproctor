# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

AudioProctor is a SaaS tool for K-12 schools in Alberta. Teachers upload MP3 audio tracks for accessibility during assessments; students on managed Chromebooks use a Chrome extension to play audio in a locked-down environment.

**The core problem**: Provincial assessments provide MP3 files, but Google Forms (used for lockdown testing on Chromebooks) won't play them. Schools currently use cassettes/CD players.

## Architecture

Two components that communicate through Supabase:

**Web app** (Vercel-hosted, vanilla HTML/CSS/JS):
- Teacher login via Google OAuth (Supabase Auth)
- Upload MP3 → system generates 6-char access code (e.g. "TK4-92A") and exit PIN
- Teachers see a list of uploads with codes and exit PINs
- Simple player page (`/player?code=TK4-92A`) fetches and plays audio by code

**Chrome Extension** (Manifest V3, vanilla JS, deployed via Google Admin Console — not Web Store):
- Code entry screen
- Launches a fullscreen locked window with the audio player
- Student cannot navigate away or close without the teacher's exit PIN
- Exit PIN is checked client-side (stored as a hash in the upload record)

**Supabase** (backend):
- Postgres: `uploads` table (code, exit_pin_hash, storage path, teacher_id, expiry)
- Storage: bucket for MP3 files
- Auth: Google OAuth for teachers only — students have no login

## Folder Structure

```
/
├── index.html          # Teacher login page
├── upload.html         # Teacher upload + uploads list
├── player.html         # Student audio player (code= param)
├── /api                # Vercel serverless functions (if needed)
└── /extension          # Chrome extension
    ├── manifest.json
    ├── popup.html      # Code entry screen
    ├── popup.js
    ├── player.html     # Fullscreen lockdown player
    └── player.js
```

Keep it flat. No build step, no bundler, no framework.

## Key Technical Constraints

- **No student login** — access is purely code-based (access code + exit PIN)
- **Exit PIN is checked client-side** in the extension — stored as a hash in Supabase
- **Extension is force-installed** via Google Admin Console (managed ChromeOS devices)
- **MP3 only** for MVP — audio plays natively in Chrome
- Prefer explicit, readable code over clever abstractions

## MVP Scope

Build only these things, in this order:
1. Supabase project setup (auth, storage bucket, uploads table)
2. Teacher admin: login page, upload page, uploads list with codes + exit PINs
3. Player page: fetches audio by code param and plays it
4. Chrome extension: code entry → lockdown player window → PIN exit
5. Vercel deploy from GitHub

Out of scope: domain restriction on login, multi-school accounts, analytics, payments, mobile support.

## Design System

The aesthetic is **editorial print** — mid-century typeset, quality journalism tone (The Economist style). Structure comes from borders and grid columns, not color blocks or shadows.

**Color palette:**
- Ink `#1a1a2e` — primary text, borders, dark blocks
- Paper `#f8f5ef` — page background (warm off-white)
- Accent `#c0392b` — highlights, used sparingly
- Warm Mid `#e8e0d0` — secondary backgrounds
- Muted `#6b6560` — secondary text, labels
- Light Accent `#fdf0ee` — faintest blush for card backgrounds

**Typography (Google Fonts):**
- **Playfair Display** — headlines, wordmark, lead paragraph
- **DM Sans** — body copy at `font-weight: 300`; labels/emphasis at `500`

**Conventions:**
- Section labels: `0.7rem`, `letter-spacing: 0.14em`, `text-transform: uppercase`
- Borders: `1px solid #1a1a2e` (full ink, never soft gray)
- Body copy `line-height: 1.7`
- Dark blocks invert ink/paper colors (no additional graphics needed)
