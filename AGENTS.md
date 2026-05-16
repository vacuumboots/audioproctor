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
| `api/` | Vercel serverless functions (Node.js, root-level). **Do not move into `app/api/`.** |
| `app/` | Teacher web app: HTML pages, `css/styles.css`, `js/*.js` |
| `app/js/dashboard.js` → split into: | Legacy (no longer loaded). See modules below. |
| `app/js/dashboard-state.js` | Shared constants and module state (exit words, code pools, `currentTier`, `pendingImages`) |
| `app/js/dashboard-utils.js` | escapeHtml, formatExpiry, file format checks, notice/progress helpers |
| `app/js/dashboard-access-codes.js` | Access code generation (standard + custom), exit word picking, hashWord |
| `app/js/dashboard-audio.js` | WAV-to-MP3 conversion via lamejs |
| `app/js/dashboard-editor.js` | Contenteditable editor, image paste/drop, assessment type toggle, CORS warning |
| `app/js/dashboard-upload.js` | handleUpload, duplicateUpload, inline image uploading |
| `app/js/dashboard-table.js` | Uploads table rendering, insights, CSV export, rename/expiry/delete |
| `app/js/dashboard-quota.js` | loadQuota, tier badges, trial banners, CTA, Stripe upgrade, first login, request flow |
| `app/js/admin.js` → split into: | Legacy (no longer loaded). See modules below. |
| `app/js/admin-state.js` | State vars, initAdmin, adminApi helper |
| `app/js/admin-utils.js` | switchTab, toggleCreateForm, tierOptions, roleOptions, escapeHtml, capitalize |
| `app/js/admin-overview.js` | loadOverview, renderAnomalies |
| `app/js/admin-analytics.js` | loadAnalytics, activity chart, division table |
| `app/js/admin-entities.js` | CRUD for divisions/schools/teachers + setTier/setRole/extend/deactivate/delete |
| `app/js/admin-requests.js` | loadRequests, loadInvitations, approve/reject/resend |
| `app/js/admin-demo.js` | Demo panel, view-as modal, seed demo data |
| `app/js/admin-content.js` | Platform admin content browser init |
| `app/js/content-browser.js` | Shared content browser — table, inline audio player, text viewer, filtering, pagination |
| `app/js/school-admin-content.js` | School admin content browser init |
| `app/js/division-admin-content.js` | Division admin content browser init |
| `app/js/auth.js` | Supabase auth helpers, `ensureProfile()`, `getEffectiveTier()` |
| `app/js/supabase-client.js` | Single Supabase client init for the browser |
| `extension/` | Chrome extension Manifest V3: popup + player + options |
| `extension/popup.js` | Validates access code, calls `/api/session`, stores in `chrome.storage.session` |
| `extension/player.js` | Fullscreen audio player + text assessment with TTS read-aloud (voice selection, speed, paragraph navigation, inline images) |
| `extension/lib/sanitize.js` | Minimal HTML sanitizer for text assessment content |
| `supabase/migrations/` | Sequential SQL migrations (004–025). Run manually in Supabase SQL Editor. |
| `site/` | Marketing pages (about, contact, privacy, terms) |
| `vercel.json` | URL rewrites: `/about` → `site/about.html`, `/css/*` → `app/css/*` etc. |
| `scripts/pre-push` | Doc gate: blocks push if AGENTS.md, CHANGELOG.md, ROADMAP.md, or USERSTEPS.md have drifted from the codebase. Runs automatically on every `git push`. Skip with `git push --no-verify`. |
| `docs/DEFINITION-OF-DONE.md` | Single release checklist. Section 1-5, web and extension rows. Run top to bottom before every release. |

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
assessment_type, text_content, text_char_count, image_count, processing_status
```
Audio: uploaded to Supabase Storage bucket `audio-files` at staging path `staging/{userId}/{accessCode}.mp3`. Server-side ffmpeg transcodes to 128kbps mono MP3 (non-free tiers) or 32kbps (free) via `get_effective_tier()` and moves to final path `{teacher_id}/{access_code}.mp3`. `processing_status`: pending → processing → ready/failed. Text assessments skip the pipeline (always `ready`).
Text: `text_content` stores HTML (may include `<img data-apimg-idx="N">` placeholders for inline images).
Images: stored in `assessment-images` bucket at `{teacher_id}/{access_code}/img_N.ext`. Session API resolves placeholders to signed URLs.

### `divisions` / `schools`
Org hierarchy. Schools optionally belong to divisions. Both have `tier`, `expires_at`, `notes`.

### `teacher_requests` (access requests)
```
id, name, email, school, division, message, status (pending|approved|rejected), teacher_id, request_type (access|premium_trial|school_plan|division_plan), created_at, reviewed_at, reviewed_by
```
Inserted by `POST /api/request-access` or the in-app modal on the teacher dashboard. Reviewed in the admin panel (`/admin.html`).

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
| `event.js` | `POST /api/event` | Logs anonymous session events from the extension (CORS: `*`). |
| `account.js` | `POST /api/account` | Profile update + self-service account deletion. |
| `admin.js` | `GET/POST /api/admin?action=...` | Platform admin operations. Requires `platform_admin` role. Uses service role key. |
| `org.js` | `GET/POST /api/org?action=...` | School/division admin ops. Actions: `school-uploads`, `division-uploads`, `school-teachers`, `school-report`, `school-detail`, `division-schools`, `division-report`, `division-activity`, `detach-teacher`, `detach-school`, `attach-school`, `remove-school-admin`, `invite-teacher`. |
| `request-access.js` | `POST /api/request-access` | Stores teacher access request from the marketing site form. Notifies admin via Resend. |
| `accept-invite.js` | `GET /api/accept-invite?token=...` | Validates invitation token, attaches teacher to org, sends welcome email. |
| `stripe-checkout.js` | `POST /api/stripe-checkout` | Unified Stripe Checkout Session for any tier (teacher, school, division). Routes internally by inspecting caller's profile. School/division uses enrolment band pricing from `division_pricing` table. |
| `stripe-webhook.js` | `POST /api/stripe-webhook` | Validates Stripe sig, updates tiers. Raw body required (`bodyParser: false` in vercel.json). |
| `trigger-normalize.js` | `POST /api/trigger-normalize` | Audio normalization via native ffmpeg. Verifies ownership, idempotent, moves from staging to final path. |
| `check-access.js` | `POST /api/check-access` | Email allowlist gate. Checks user email against `ALLOWED_EMAIL_PATTERN` env var. Existing users grandfathered. |
| `contact.js` | `POST /api/contact` | Contact/demo request form via Resend. |

`admin.js` actions: `list-teacher-uploads`, `get-upload-content`, `overview`, `divisions`, `schools`, `teachers`, `audit-log`, `login-link`, `list-invitations`, `list-requests`, `platform-analytics`, `set-tier`, `set-expires`, `set-notes`, `set-role`, `attach-teacher`, `reassign-teacher`, `create-division`, `create-school`, `approve-request`, `reject-request`, `invite`, `resend-invite`, `seed-demo`, `delete-teacher`, `delete-school`, `delete-division`, `toggle-deactivation`, `cancel-subscription` (cancels school/division Stripe sub with proration).

## Vercel function limit

**The Hobby plan allows 12 serverless functions.** The project currently uses 12 (at the limit):
`session`, `event`, `account`, `admin`, `org`, `request-access`, `accept-invite`, `stripe-checkout`, `stripe-webhook`, `trigger-normalize`, `check-access`, `contact`.

Any new `api/*.js` file counts toward the limit. The onboarding email cron (3 files) was deleted in commit 8148d63 to free slots. The 3 Stripe checkout endpoints were merged into one for the same reason. Before adding a new endpoint, consider whether an existing one can handle the action via a query parameter.

## Critical conventions

- **No build step.** `vercel dev` serves files directly. The extension is loaded unpacked from `chrome://extensions`.
- **Design system:** Editorial print aesthetic. Borders not shadows. `1px solid var(--ink)`. No border-radius. Fonts: Playfair Display (headings), DM Sans (body). Labels are `0.7rem`, `letter-spacing: 0.14em`, uppercase. Fonts are self-hosted in `app/fonts/` — no Google Fonts CDN requests.
- **Stripe billing:** `STRIPE_SECRET_KEY`, `STRIPE_WEBHOOK_SECRET`, `STRIPE_PRICE_ID` (Teacher Premium). Additional tier price IDs are configured in the `division_pricing` DB table. All tiers use the single `stripe-checkout.js` endpoint. Env vars in Vercel dashboard + `.env.local` for local dev.
- **Exit word hashing:** SHA-256 of lowercased+trimmed input. Used identically in `app/js/dashboard-access-codes.js` (upload) and `extension/player.js` (verification).
- **Auth:** Google OAuth via Supabase Auth. Redirects to `https://app.audioproctor.com/dashboard.html`. `ensureProfile()` calls `/api/check-access` to verify email against `ALLOWED_EMAIL_PATTERN` (when set), then creates the `profiles` row on first login with `tier='premium'` and `expires_at` 30 days out. Existing users are grandfathered through the email gate.
- **Access codes:** Standard format (`ABC-123`) or custom (3–20 alphanumeric, teacher-defined). Short format was removed.

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
- ✅ School admin dashboard (`/school-admin.html`) — teacher list, invite, detach, usage report
- ✅ Division admin dashboard (`/division-admin.html`) — school list, drill-down, invite, usage chart
- ✅ Admin can set tiers, extend trials, reassign teachers, deactivate/delete accounts
- ✅ Teacher request flow for premium trial / school plan / division plan (site form + in-app modal)
- ✅ Invitation system for external teachers (platform admin + school/division admin)
- ✅ Demo data seeding from admin panel
- ✅ Trial expiry banner on teacher dashboard (hides 15 days after expiry)
- ✅ Admin audit log
- ✅ Session analytics (per-upload and platform-wide)
- ✅ Text assessment mode with chrome.tts read-aloud, voice selection, paragraph navigation, font size/fullwidth controls, inline image support
- ✅ Inline images in text assessments — paste images in editor, stored in `assessment-images` bucket, rendered in extension player
- ✅ Audio normalization — server-side ffmpeg transcoding to 128kbps (non-free tiers) or 32kbps (free) mono MP3
- ✅ Self-hosted fonts — zero Google Fonts CDN requests
- ✅ Modular JS — dashboard.js and admin.js split into responsibility-focused files
- ✅ Access code format simplified — standard + custom only
- ❌ No automated email reminders before trial expiry (code built then pruned in 8148d63 to stay under Vercel 12-function limit)
- ❌ No full staging environment (single Supabase project shared by dev and prod)
- ❌ Zero automated test coverage (vitest scaffold exists, no tests written)

## Common pitfalls for agents

1. **Vercel functions must stay at repo root in `api/`.** Do not move them into `app/api/`.
2. **Supabase migrations are numbered sequentially** but applied manually via SQL editor. There is no automated migration runner. New migrations go in `supabase/migrations/`. Check the highest existing number and increment. **Migration numbers that collide will be renamed by the human operator — verify the latest number before writing.**
3. **The extension is Manifest V3.** No background pages. `chrome.storage.session` (not `local`) is used for ephemeral session data.
4. **Stripe webhook requires raw body.** In `vercel.json`, the stripe-webhook route must have `bodyParser: false`.
5. **RLS policies matter.** Upload quota is enforced at the DB layer, not just in JS. Changing `get_effective_tier()` or the uploads policy can silently break uploads.
6. **Two domains, one Vercel deployment.** Routing is done via `vercel.json` rewrites, not host-based routing. Host-based routing was tried and failed.
7. **Never `git add -A` without checking what's staged.** Temp scripts containing hardcoded Supabase connection strings were accidentally committed via `git add -A` (incident: 2026-05-09, see `docs/security/`). Use `git add <specific files>` or `git add -p`. Check `git diff --cached` before committing.
8. **When deleting a `_lib` module, grep the entire codebase for require() references first.** Deleting `_lib/schedule-onboarding.js` broke `api/admin.js` and `api/stripe-webhook.js` because their require() calls were not cleaned up. The result: 500 errors on every admin API call, discovered by a user report hours later.
9. **Rotating Supabase credentials breaks Vercel until manually updated.** The `SUPABASE_SERVICE_ROLE_KEY` lives in three places: Supabase, Vercel env vars (all three environments), and `.env.local`. Rotating it in Supabase immediately breaks the other two. After rotation, update Vercel via `vercel env rm`/`vercel env add`, update `.env.local`, then force a redeploy with `vercel redeploy`. See `docs/OPERATIONS.md` section 8 for the full procedure.
10. **The pre-push doc gate blocks pushes when documentation drifts.** `scripts/pre-push` runs 9 checks on every `git push` — stale file references in AGENTS.md, migration count mismatches, API count mismatches, staged migrations/APIs without AGENTS.md updates, ROADMAP drift, CHANGELOG gaps, and stale `require()` references. When it fails, read the ✗ messages — they tell you exactly which file to fix. Skip with `git push --no-verify` only when the gate is wrong, not when you're in a hurry. **The hook auto-installs via `npm run postinstall` (runs after `npm install`).** On a fresh clone, just run `npm install` and the gate is active.

## If you need to make schema changes

1. Write a new migration file in `supabase/migrations/0XX_description.sql`.
2. Run it on a fresh local database or a throwaway Supabase project first.
3. If the migration is destructive (DROP, UPDATE without WHERE, ALTER...DROP COLUMN), back up production data first.
4. Run during low-traffic hours.
5. Verify uploads, auth, and extension playback immediately after.
6. **If the migration requires manual operator action (Supabase SQL Editor), add a checklist item to `USERSTEPS.md`.** Do not assume "someone will figure it out."

## Seeding dev data

See `supabase/seeds/dev-seed.sql` for fake teacher_requests and invitations. Run in Supabase SQL editor.

The admin panel also has a "Seed / Refresh Demo Data" button that creates 9 demo accounts, 2 schools, 1 division, 27 uploads, and ~2,000 session events.

## USERSTEPS.md

Manual steps for the human operator live in `USERSTEPS.md`. When implementation requires hands-on action (Supabase console, Google Cloud, Stripe dashboard, Chrome Web Store), add a checklist item there with clear instructions. Check the file before starting work to see what's pending.

## Key docs

- `docs/DEFINITION-OF-DONE.md` — single release checklist (web + extension). Run top to bottom before every release.
- `docs/ROADMAP.md` — staged product roadmap with checked-off items
- `docs/OPERATIONS.md` — release runbook: attestation, rollback, key rotation (procedural commands)
- `docs/security/` — security incident reports
- `scripts/pre-push` — pre-push doc gate (9 automated drift checks, runs on every push)
- `.gitignore` — includes patterns to prevent credential-containing scripts (`check_db*.js`, `run-*.mjs`)
