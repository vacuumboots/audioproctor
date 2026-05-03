# AGENTS.md — AudioProctor

This file is for AI agents, coding assistants, and automated systems working on this codebase. Use this as a quick-reference for the project structure, conventions, and critical context.

## One-line summary

AudioProctor is a vanilla-HTML/CSS/JS web app + Chrome extension for K-12 audio accessibility assessments, backed by Supabase, hosted on Vercel.

## Architecture at a glance

```
Marketing domain:  audioproctor.com        (root index.html + site/)
Teacher app:       app.audioproctor.com    (app/ — served via vercel.json rewrites)
API:               app.audioproctor.com/api/*  (Vercel serverless functions)
Extension:         Chrome Web Store        (extension/ — loaded unpacked for dev)
```

No build step. No bundler. No framework. Files are served as-is.

## File map for agents

| Path | What lives there |
|---|---|
| `api/` | Vercel serverless functions (Node.js, root-level) |
| `app/` | Teacher web app: HTML pages, `css/styles.css`, `js/*.js` |
| `app/js/dashboard.js` | Upload form, uploads table, quota display, trial banners, request modal |
| `app/js/admin.js` | Platform admin dashboard (teachers, schools, divisions, analytics) |
| `app/js/auth.js` | Supabase auth helpers, `ensureProfile()`, `getEffectiveTier()` |
| `app/js/supabase-client.js` | Single Supabase client init for the browser |
| `extension/` | Chrome extension Manifest V3: popup + player + options |
| `extension/popup.js` | Validates access code, calls `/api/session`, stores in `chrome.storage.session` |
| `extension/player.js` | Fullscreen audio player + text assessment with TTS read-aloud (voice selection, speed, paragraph navigation, inline images) |
| `extension/lib/sanitize.js` | Minimal HTML sanitizer for text assessment content |
| `supabase/migrations/` | Sequential SQL migrations (001–021) |
| `site/` | Marketing pages (about, contact, privacy, terms) |
| `vercel.json` | URL rewrites: `/about` → `site/about.html`, `/css/*` → `app/css/*` etc. |

## Database schema (the tables that matter)

### `profiles` (one row per teacher)
```
id (uuid PK), tier (text: free|premium|school|division), tier_override, role (teacher|school_admin|division_admin|platform_admin),
school_id, division_id, expires_at (trial/subscription expiry), storage_used_mb, country_code, division_name, notes, is_deactivated
```
Key function: `get_effective_tier(user_id)` resolves the actual tier via cascade: `tier_override` → division → school → `profiles.tier` → `'free'`, respecting `expires_at`.

### `uploads` (teacher audio files)
```
id, teacher_id, filename, label, storage_path, access_code, exit_word, exit_word_hash, expires_at, file_size_mb,
assessment_type, text_content, text_char_count, image_count
```
Audio: stored in Supabase Storage bucket `audio-files` at `{teacher_id}/{access_code}.mp3`.
Text: `text_content` stores HTML (may include `<img data-apimg-idx="N">` placeholders for inline images).
Images: stored in `assessment-images` bucket at `{teacher_id}/{access_code}/img_N.ext`. Session API resolves placeholders to signed URLs.

### `divisions` / `schools`
Org hierarchy. Schools optionally belong to divisions. Both have `tier`, `expires_at`, `notes`.

### `teacher_requests` (access requests)
```
id, name, email, school, division, message, status (pending|approved|rejected), teacher_id, request_type (access|premium_trial|school_plan|division_plan), created_at, reviewed_at, reviewed_by
```
Inserted by `POST /api/request-access`. Reviewed in the admin panel (`/admin.html`).

### `invitations`
```
id, email, role, school_id, division_id, token, expires_at, accepted_at, created_at
```
Created by admin invite or by approving an external access request. Consumed at `accept-invite.html?token=...`.

### `session_events` / `upload_summaries`
Analytics. `session_events` tracks code_entered, playback_started, playback_completed. `upload_summaries` is a materialized view refreshed on a schedule.

## API endpoints (`api/`)

| File | Route | Purpose |
|---|---|---|
| `session.js` | `GET /api/session?code=...` | Validates access code, returns signed URL (audio) or resolved HTML with inline images (text) + exit word hash. No auth. Rate-limited. |
| `admin.js` | `GET/POST /api/admin?action=...` | Platform admin operations. Requires `platform_admin` role. Service role key. |
| `request-access.js` | `POST /api/request-access` | Stores teacher request + emails admin. No auth. |
| `stripe-checkout.js` | `POST /api/stripe-checkout` | Creates Stripe Checkout Session. Requires Bearer token. |
| `stripe-webhook.js` | `POST /api/stripe-webhook` | Validates Stripe sig, updates `profiles.tier`. Raw body required. |
| `contact.js` | `POST /api/contact` | Contact form via Resend. |

`admin.js` actions: `overview`, `divisions`, `schools`, `teachers`, `audit-log`, `login-link`, `list-invitations`, `list-requests`, `platform-analytics`, `set-tier`, `set-expires`, `set-notes`, `set-role`, `attach-teacher`, `reassign-teacher`, `create-division`, `create-school`, `approve-request`, `reject-request`, `invite`, `resend-invite`, `seed-demo`, `delete-teacher`, `delete-school`, `delete-division`, `toggle-deactivation`.

## Critical conventions

- **No build step.** `vercel dev` serves files directly. The extension is loaded unpacked from `chrome://extensions`.
- **Design system:** Editorial print aesthetic. Borders not shadows. `1px solid var(--ink)`. No border-radius. Fonts: Playfair Display (headings), DM Sans (body). Labels are `0.7rem`, `letter-spacing: 0.14em`, uppercase.
- **Environment variables:** `SUPABASE_URL`, `SUPABASE_ANON_KEY`, `SUPABASE_SERVICE_ROLE_KEY`, `RESEND_API_KEY`, `CONTACT_EMAIL`, `STRIPE_SECRET_KEY`, `STRIPE_WEBHOOK_SECRET`, `STRIPE_PRICE_ID`. Stored in Vercel dashboard + `.env.local` for local dev.
- **Exit word hashing:** SHA-256 of lowercased+trimmed input. Used identically in `app/js/dashboard.js` (upload) and `extension/player.js` (verification).
- **Auth:** Google OAuth via Supabase Auth. Redirects to `https://app.audioproctor.com/dashboard.html`. `ensureProfile()` creates the `profiles` row on first login with `tier='premium'` and `expires_at` 30 days out.

## How to run locally

```bash
npm i -g vercel
vercel dev      # reads .env.local
```

For extension dev: open Chrome → `chrome://extensions` → Developer mode → Load unpacked → select `extension/` folder.

## Branches and deployment

- `main` → production (`audioproctor.com`, `app.audioproctor.com`)
- `stable` → last known good commit. Fast-forwarded to `main` after production is verified. Instant rollback target.
- `dev` → integration branch. Every push gets a Vercel preview URL.
- Feature branches off `dev`. PR `dev` → `main` for production releases.
- GitHub branch protection is not enforced (private repo without Team plan). Discipline-only.

## Current state of features (as of last update)

- ✅ Teacher upload with access code + exit word
- ✅ Chrome extension fullscreen player
- ✅ Google OAuth login
- ✅ Free tier quota (3 uploads/month, 50MB)
- ✅ Teacher Premium self-serve via Stripe Checkout
- ✅ 30-day auto trial on signup
- ✅ Platform admin dashboard (`/admin.html`) with divisions, schools, teachers, analytics
- ✅ Admin can set tiers, extend trials, reassign teachers, deactivate accounts
- ✅ Teacher request flow for premium trial / school plan / division plan
- ✅ Invitation system for external teachers
- ✅ Demo data seeding from admin panel
- ✅ Trial expiry banner on teacher dashboard (hides 15 days after expiry)
- ✅ Admin audit log
- ✅ Session analytics (per-upload and platform-wide)
- ✅ Text assessment mode with chrome.tts read-aloud, voice selection, paragraph navigation, font size/fullwidth controls, inline image support
- ✅ Inline images in text assessments — paste images in editor, stored in `assessment-images` bucket, rendered in extension player
- ❌ No automated email reminders before trial expiry
- ❌ No full staging environment (single Supabase project shared by dev and prod)

## Common pitfalls for agents

1. **Vercel functions must stay at repo root in `api/`**. Do not move them into `app/api/`.
2. **Supabase migrations are numbered sequentially** but applied manually via SQL editor. There is no automated migration runner.
3. **The extension is Manifest V3.** No background pages. `chrome.storage.session` (not `local`) is used for ephemeral session data.
4. **Stripe webhook requires raw body.** In `vercel.json`, the stripe-webhook route must have `bodyParser: false`.
5. **RLS policies matter.** Upload quota is enforced at the DB layer, not just in JS. Changing `get_effective_tier()` or the uploads policy can silently break uploads.
6. **Two domains, one Vercel deployment.** Routing is done via `vercel.json` rewrites, not host-based routing. Host-based routing was tried and failed.

## If you need to make schema changes

1. Write a new migration file in `supabase/migrations/0XX_description.sql`.
2. Run it on a fresh local database or a throwaway Supabase project first.
3. If the migration is destructive (DROP, UPDATE without WHERE, ALTER...DROP COLUMN), back up production data first.
4. Run during low-traffic hours.
5. Verify uploads, auth, and extension playback immediately after.

## Seeding dev data

See `supabase/seeds/dev-seed.sql` for fake teacher_requests and invitations. Run in Supabase SQL editor.

The admin panel also has a "Seed / Refresh Demo Data" button that creates 9 demo accounts, 2 schools, 1 division, 27 uploads, and ~2,000 session events.

## USERSTEPS.md

Manual steps for the human operator live in `USERSTEPS.md`. When implementation requires hands-on action (Supabase console, Google Cloud, Stripe dashboard, Chrome Web Store), add a checklist item there with clear instructions. Check the file before starting work to see what's pending.
