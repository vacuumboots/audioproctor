# Changelog

All notable changes to AudioProctor are documented in this file.

## [Unreleased]

### Added
- Email allowlisting via `api/check-access.js` — new signups are gated against
  `ALLOWED_EMAIL_PATTERN` env var (regex). Existing users grandfathered. No
  pattern set = open to everyone.
- Admin content access API — `admin.js` adds `list-teacher-uploads` (paginated,
  with teacher/school/division metadata) and `get-upload-content` (signed audio
  URL or resolved text HTML). `org.js` adds `school-uploads` and `division-uploads`
  scoped to the admin's org.
- Admin content browser — shared `content-browser.js` renders teacher upload
  tables with inline audio player and text viewer, filtering by teacher/school/type,
  and pagination. Wired into admin.html, school-admin.html, and division-admin.html
  via thin role-specific modules.

### Changed
- Non-free tiers (premium, school, division) now get 128kbps mono MP3 audio encoding instead of 32kbps.
  Free tier remains at 32kbps. Server-side ffmpeg transcoding in trigger-normalize.js branches on
  get_effective_tier().

## [1.3.1] - 2026-05-09

Maintenance release: code cleanup, bug fixes, and documentation overhaul.

### Changed
- **Access code format simplified:** removed "Short" (AB12) option. Standard
  (ABC-123) and Custom only.
- **Stripe checkout unified:** 3 separate endpoints merged into one
  (`stripe-checkout.js` routes internally by caller's profile). Freed 2 Vercel
  function slots.
- Paste hint added above text editor: "Paste your assessment text, or paste
  images directly alongside the text."
- Chrome Web Store link added to homepage hero and teacher dashboard top bar.
- Self-hosted fonts confirmed in place — zero Google Fonts CDN requests.

### Fixed
- Admin API returning 500 errors — stale `require('./_lib/schedule-onboarding')`
  crashed before any route handler ran. Module was deleted in the onboarding
  cron removal but `admin.js` and `stripe-webhook.js` still referenced it.
- CORS stripped-image warning now auto-clears when all images are removed from
  the editor.
- Uploads table action-row overflow — buttons now wrap instead of spilling out.

### Removed
- Onboarding email cron system (3 files: `_lib/onboarding-emails.js`,
  `_lib/schedule-onboarding.js`, `send-onboarding-emails.js`). Code was built in
  v1.3.0 but deleted to stay under the Vercel Hobby 12-function limit. Will be
  re-implemented when function budget allows.
- Legacy `app/js/dashboard.js` (1,786 lines) and `app/js/admin.js` (1,114
  lines) — dead code, not loaded by any HTML page. The modular files are the
  active code.
- Temp debug scripts `_debug_mock.js` and `_verify.js`.
- `CLAUDE.md` — `AGENTS.md` is the canonical AI guidance file.
- `oversights.md` — all 16 items resolved by the kanban run.

### Documentation
- `AGENTS.md` rewritten with lessons from kanban run: Vercel function limit,
  credential leak prevention, require() cleanup when deleting modules, key
  rotation procedure, `.gitignore` temp-script patterns.
- `docs/ROADMAP.md` sweep: 6 items removed, 6 checked off, onboarding email
  deferral note, anomaly monitoring deferral note, attestation broadened to
  full publish chain review.
- `docs/OPERATIONS.md` added doc review gate to release checklist and Supabase
  key rotation runbook (section 8).
- `docs/security/2026-05-09-credential-leak.md` — full incident report.
- `README.md` refreshed: fixed stale file references, updated deployment model
  (extension not yet force-installed), added inline image mention, documented
  both access request paths.
- `USERSTEPS.md` deduplicated (had 3 Pending sections), migrations marked done.
- `ROADMAP.md` Parking Lot: documented Chromebook-only extension lock (block
  Windows/Mac/Linux, allow all ChromeOS).
- `.gitignore` patterns added for `check_db*.js` and `run-*.mjs`.

### Security
- Supabase service_role key rotated after credential leak via temp script
  committed with `git add -A`. See `docs/security/2026-05-09-credential-leak.md`.

### Test status
- All 93 tests pass across 5 test files (unit: session, event, admin, exit-word;
  extension: player).

## [1.3.0] - 2026-05-08

Feature release adding audio normalization, image paste from Google Docs and web pages, Stripe school/division billing, and the modular dashboard refactor.

### Added
- Audio normalization pipeline: uploads go to a staging path, server-side ffmpeg transcodes to 32kbps mono MP3, normalized file moves to final path. Dashboard polls for completion with progress feedback.
- `processing_status` column on uploads (pending → processing → ready/failed). Text assessments skip the pipeline and are always `ready`.
- `/api/trigger-normalize` Vercel function — native ffmpeg transcoding with ownership verification, idempotency, and staging cleanup.
- Image paste from Google Docs: GDocs images arrive as `data:image/jpeg;base64` URIs and are captured directly.
- Image paste from web pages: pasted `<img>` tags with external URLs are detected, fetched via CORS, and captured as blobs. CORS-blocked images show a notice suggesting screenshot paste instead.
- CORS warning notice in the dashboard editor: when images are stripped, a red notice explains why and suggests taking a screenshot.
- HTML paste unwrapping: non-whitelisted wrapper elements (figure, a, picture, ul, etc.) are unwrapped instead of removed, preserving images and text content inside them.
- Stripe billing for schools and divisions: `/api/stripe-checkout-school.js`, `/api/stripe-checkout-division.js`, enrolment band pricing via `division_pricing` table.
- Platform admin RLS policies for divisions, schools, and pricing tables.
- Onboarding email sequence infrastructure: `onboarding_emails` table + cron endpoint (pending activation).
- Automated test suite scaffold: vitest config, mock helpers, test directory structure.
- Modular dashboard JS: `dashboard.js` split into 8 responsibility-focused modules (state, utils, access-codes, audio, editor, upload, table, quota) loaded via separate `<script>` tags.

### Changed
- Dashboard first-login modal: replaced basic `<datalist>` with autocomplete dropdown supporting keyboard navigation and division ID matching.
- Extension player: fixed CSP to allow images from `https://*.supabase.co` (`img-src` directive).
- Extension sanitizer: added null-body guard for DOMParser edge cases in extension contexts.
- OAuth redirect URL: uses `window.location.origin` instead of hardcoded production URL, enabling local development with `vercel dev`.
- Upload storage path for audio: files now go to `staging/{userId}/{code}.mp3` before normalization.

### Fixed
- Extension player text mode: `sanitizeHTML` null-body crash when DOMParser fails in extension context.
- Extension player text mode: CSP blocked inline images from Supabase signed URLs.
- Dashboard paste handler: images wrapped in `<figure>`, `<a>`, or `<picture>` tags were destroyed by the HTML stripper instead of being preserved.

### Database migrations
- 020: `image_count` column on uploads
- 021: RLS policies for `assessment-images` bucket
- 022: Stripe school/division columns + `division_pricing` table + helper functions
- 023 (audio): `processing_status` column + staging storage RLS policies + index
- 023 (platform admin): RLS policies for divisions, schools, and pricing tables
- 024: `onboarding_emails` table (not yet activated)

### Manual deployment steps
- Run migrations 020–024 in Supabase SQL Editor.
- Install `ffmpeg-static` dependency (`npm install`).
- Create Stripe Products and Prices for School and Division Plans, update `STRIPE_SCHOOL_PRICE_ID` and `division_pricing` seed data.
- Configure Stripe webhook endpoint for school/division subscription events.
- Deploy to Vercel.
- Bump extension to v1.3.0 and publish to Chrome Web Store.

Feature release adding inline image support in text assessments.

### Added
- Inline images in text assessments: teachers can paste images (PNG/JPEG/WebP, max 2 MB each) directly into the text editor.
- Contenteditable editor replaces plain textarea — supports rich text paste with images appearing inline.
- Images uploaded to new `assessment-images` Supabase Storage bucket at `{teacher_id}/{access_code}/img_N.ext`.
- Session API resolves image placeholders to signed URLs, embedded in returned HTML.
- Extension player renders HTML with inline images; TTS read-aloud silently skips image-only paragraphs.
- Minimal HTML sanitizer (`extension/lib/sanitize.js`) for safe rendering of assessment HTML.
- Image cleanup on upload delete (best-effort removal from `assessment-images` bucket).
- Image duplication support — copying a text assessment copies its images to new storage paths.
- Database migration 020: `image_count` column on uploads.
- Database migration 021: RLS policies for `assessment-images` bucket.

### Changed
- Dashboard upload form: text input hint updated to "Paste text and images · Max 2 MB per image".
- Extension player card widened from 720px to 800px to accommodate inline images.
- `file_size_mb` now includes image storage bytes for text assessments (RLS quota enforcement).
- Dashboard uploads table continues to show assessment type badges (Audio/Text) — unchanged.

### Manual deployment steps
- Run migrations 020 and 021 in Supabase SQL Editor.
- Create `assessment-images` bucket in Supabase Dashboard (Storage → New Bucket, private, 2 MB file size limit).
- Deploy to Vercel.
- Bump extension to v1.2.1 and publish to Chrome Web Store.

## [1.1.0] - 2026-04-28

Feature release adding text assessment support — teachers can now create either audio or text assessments from the same dashboard.

### Added
- Text assessment type: teachers can paste plain text (up to 25,000 chars) as an alternative to audio uploads.
- Assessment type selector in the teacher dashboard upload form.
- Text reader mode in the Chrome extension — fullscreen locked view with paragraph structure.
- Built-in Read Aloud via `chrome.tts` with play/pause, prev/next paragraph, and speed control.
- Keyboard controls for text reader: Space (play/pause), Left/Right arrows (navigate paragraphs).
- Display settings for text reader: font size +/- and full width toggle.
- Dual-mode session API: `/api/session` returns typed payload (audio gets signed URL, text gets content).
- Database migrations 018–019: `assessment_type`, `text_content`, `text_char_count` columns; text session event types.
- Text-safe delete and duplicate in the dashboard — text rows skip storage cleanup.
- FAQ on use cases page explaining the difference between audio and text assessments.

### Changed
- Extension bumped to v1.1.0 with `tts` permission added to manifest.
- Dashboard uploads table shows assessment type badges (Audio/Text).
- Dashboard copy updated: "Create Assessment" replaces "Upload Audio".
- Dashboard assessment type selector replaced with segmented toggle (Audio/Text), moved above label field.
- Assessment label hint now indicates it's shown to students in the extension.
- Landing page, use cases, and about page updated to describe both audio and text accommodation.

## [1.0.1] - 2026-04-27

Extension patch release for managed Chromebook validation and Chrome Web Store promotion.

### Changed
- Extension popup/session fetch flow now permits the live `www.audioproctor.com` redirect target in manifest host permissions and CSP `connect-src`.
- Extension version bumped from `1.0.0` to `1.0.1`.

### Security / privacy hardening
- Removed Google Fonts dependency from extension UI pages.
- Added an explicit Manifest V3 content security policy for extension pages.
- Added `no-referrer` fetch policy on extension network calls.

### Validation
- Chromebook retest confirmed the popup/session flow works after the CSP host allowlist update.

## [0.100.0] - 2026-04-26

Milestone release for demo readiness, extension open-source visibility, and repo doc hygiene.

### Added
- WAV upload support with client-side WAV -> MP3 conversion in the teacher dashboard upload flow.
- Public extension repository synchronization workflow from private `extension/` subtree to `vacuumboots/audioproctor-extension`.
- Public, audit-focused extension README at `extension/README.md`.
- Manual sync trigger for extension mirror workflow (`workflow_dispatch`).
- This changelog file.
- Security disclosure policy file (`SECURITY.md`).
- Operational release checklist (`docs/release-checklist.md`).

### Changed
- Upload cap aligned to infrastructure constraint: 50 MB max file size.
- Dashboard/UI copy aligned to MP3 or WAV support and 50 MB limit.
- Upload filename behavior aligned so converted WAV uploads are recorded/displayed as `.mp3` in dashboard history.

### Internal documentation maintenance
- `.hermes` status-note sweep completed and stale progress text corrected.
- Historical status markers clarified where plans had drifted from current repo state.

### Completed checklist (requested)
- [x] `.hermes` status-note sweep completed and inaccuracies corrected.
- [x] Changelog milestone entry added.
- [x] Security disclosure documentation added.
- [x] Release checklist documentation added.
