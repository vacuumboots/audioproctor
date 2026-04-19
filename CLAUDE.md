# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

AudioProctor is a SaaS tool for K-12 schools in Alberta. Teachers upload MP3 audio tracks for accessibility during assessments; students on managed Chromebooks use a Chrome extension to play audio in a locked-down fullscreen environment with no way to navigate away without a teacher-provided exit word.

## Architecture

**Two domains, one Vercel deployment:**
- `audioproctor.com` — marketing site (root `index.html` + `site/` pages)
- `app.audioproctor.com` — teacher app (`login.html`, `dashboard.html`, `player.html`)

Both are served from the same repo. `vercel.json` rewrites `/use-cases`, `/about`, `/contact`, `/privacy`, `/terms` to `site/*.html`. No host-based routing — it was tried and didn't work reliably on Vercel.

**Web app** (Vercel, vanilla HTML/CSS/JS):
- `login.html` — Google OAuth via Supabase Auth; redirects to `https://app.audioproctor.com/dashboard.html`
- `dashboard.html` — upload form + uploads table; requires auth
- `player.html` — student-facing audio player, no login required; reads `?code=` param

**Chrome Extension** (Manifest V3, `extension/`):
- `popup.js` — validates code format, calls `/api/session`, stores result in `chrome.storage.session`, opens `player.html` tab
- `player.js` — reads session, goes fullscreen, plays audio; exit word verified by SHA-256 hash comparison

**Supabase** (backend):
- `uploads` — teacher uploads: `id`, `teacher_id`, `filename`, `label`, `storage_path`, `access_code`, `exit_word`, `exit_word_hash`, `expires_at`, `file_size_mb`
- `profiles` — one row per teacher: `id`, `tier` (`'free'`|`'premium'`), `storage_used_mb`, `country_code`, `division_name`, `stripe_customer_id`, `stripe_subscription_id`, `exit_word_mode` (persisted preference: `random_short`|`random_long`|`phrase`|`pin`|`custom`)
- `rate_limit_log` — tracks failed `/api/session` lookups by IP for brute-force protection
- Storage bucket `audio-files` (private) — files stored at `{teacher_id}/{access_code}.mp3`
- RLS enforces: upload quota (3/month for free), 50MB storage cap, 10 uploads/hour rate limit — all at the DB layer via the uploads INSERT policy

**Serverless functions** (`api/`):
- `api/session.js` — validates access code, returns `{ signedUrl, filename, exitWordHash }`; uses service role key; rate-limits failed lookups; never exposes `storage_path` or plain exit word
- `api/contact.js` — contact form handler via Resend
- `api/stripe-checkout.js` — POST; creates Stripe Checkout Session for Teacher Premium upgrade; requires Bearer token; returns `{ url }` for browser redirect
- `api/stripe-webhook.js` — POST; validates Stripe signature; on `checkout.session.completed` sets `profiles.tier_override = 'premium'`; on `customer.subscription.deleted` resets it to null; requires raw body (bodyParser disabled)

## Key Flows

**Upload:** `handleUpload()` in `js/dashboard.js` — checks quota and storage cap UI-side (enforced server-side via RLS), uploads file to Supabase Storage, inserts row to `uploads`, updates `storage_used_mb` in `profiles`.

**Student access (extension):** popup enters code → `popup.js` calls `/api/session` → stores `{ signedUrl, exitWordHash, filename }` in `chrome.storage.session` → opens `extension/player.html` tab → `player.js` reads session, loads audio, verifies exit word by hashing input and comparing to stored hash.

**Exit word verification:** Both `dashboard.js` and `extension/player.js` use identical `hashWord()` — SHA-256 via Web Crypto API, lowercased and trimmed before hashing.

## Development

No build step. Serve locally with `vercel dev` (reads `.env.local` for Supabase credentials). The extension must be loaded unpacked from `chrome://extensions` for local testing.

Required environment variables (in `.env.local` locally, and in Vercel project settings):
- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`
- `SUPABASE_SERVICE_ROLE_KEY` — server-side only, never sent to browser
- `RESEND_API_KEY`
- `CONTACT_EMAIL`
- `STRIPE_SECRET_KEY` — Stripe secret key (server-side only)
- `STRIPE_WEBHOOK_SECRET` — from Stripe dashboard → Webhooks → signing secret
- `STRIPE_PRICE_ID` — the recurring Price ID for Teacher Premium (e.g. `price_xxx`)

**Stripe setup:** Create a Product + recurring Price in the Stripe dashboard, copy the Price ID into `STRIPE_PRICE_ID`. Register `/api/stripe-webhook` as a webhook endpoint listening for `checkout.session.completed` and `customer.subscription.deleted`.

## Design System

Editorial print aesthetic — mid-century typeset, The Economist tone. Structure from borders and grid, not color blocks or shadows.

**Colors (CSS vars):** `--ink: #1a1a2e` · `--paper: #f8f5ef` · `--accent: #c0392b` · `--warm-mid: #e8e0d0` · `--muted: #6b6560` · `--light-accent: #fdf0ee`

**Fonts:** Playfair Display (headlines) · DM Sans 300 (body) / 500 (labels, emphasis)

**Conventions:**
- Labels: `0.7rem`, `letter-spacing: 0.14em`, `text-transform: uppercase`
- Borders: `1px solid var(--ink)` — never soft gray
- No border-radius, no box-shadow, no icons except `—` list bullets
- Dark sections invert ink/paper; no graphics needed

App styles live in `css/styles.css`. Marketing-only styles (pricing grid, site nav, FAQ, etc.) live in `site/site.css`.
