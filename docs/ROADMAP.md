# AudioProctor — Product Roadmap

A rough sequence of improvements, from "working MVP" to "something a division would pay for."

## Stage 1 — Polish the MVP
*Make it feel finished before anyone else sees it.*

- [x] Proper extension icons (branded, not placeholders)
- [x] Friendly onboarding on first login ("Upload your first assessment to get started")
- [x] Better upload progress — show a real progress bar for large files
- [x] Handle duplicate filenames gracefully in the dashboard
- [x] Add a label/title field to uploads so teachers can name them ("Grade 4 Reading Assessment - May")
- [x] Test on an actual managed Chromebook end-to-end — completed on ChromeOS 146 with the Chrome Web Store deployment
- [x] **Purge em dashes from front-facing copy** — the `—` character appears throughout
  the marketing site and dashboard copy. It's an obvious AI tell. Replace with commas,
  periods, colons, shorter sentences, or restructured phrasing. Scope:
  - `site/index.html` — hero sub, pricing cards, why section (~8 instances)
  - `site/about.html` — problem/solution paragraphs (~5 instances)
  - `site/use-cases.html` — use case cards, FAQ answers (~7 instances)
  - `site/contact.html` — placeholder text, response copy (~2 instances)
  - `site/terms.html`, `site/privacy.html`, `site/request-access.html`
  - `app/dashboard.html` — assessment label hint text
  - Leave alone: page titles (`About — AudioProctor`), admin stat placeholders,
    dashboard option labels, HTML comments
- [x] **Text assessment support** — teachers can create either audio or text assessments
  from the same dashboard. Text assessments store plain text in the database, return it
  from `/api/session`, and render in a fullscreen reader in the extension with built-in
  read-aloud via `chrome.tts`. Migrations 018–019, extension v1.1.0.
- [x] **Audio normalization on upload** — transcode all uploaded files to 32kbps mono MP3
  via a Supabase Edge Function triggered on upload. Reduces file sizes 4–6x, ensures
  consistent playback quality, and protects against teachers uploading large high-bitrate
  files. Implementation: browser uploads original to a staging path in Supabase storage
  → Edge Function runs ffmpeg transcoding → normalized file moves to final path →
  staging file deleted.

---

## Stage 2 — Security & Reliability
*Build the foundation of trust before pitching to anyone in a school.*

- [x] **Rate limiting on the session API** — 10 failed code lookups per IP per hour
  returns 429. Failed attempts (not found + expired) are logged; successful lookups
  are not.
- [x] **Signed URL refresh** — if a student's session expires mid-test (>1 hour), show
  a graceful error rather than silent failure
- [x] **Enforce free tier upload limits server-side** — `check_upload_quota()` Supabase
  RLS policy blocks a 4th upload at the database layer. API returns HTTP 403 if limit
  is reached. Cannot be bypassed by calling the API directly.
- [x] **Free tier quota indicator in the dashboard UI** — quota bar shows "X of 3
  uploads used this month", goes red and disables upload button at limit. Gate message
  includes reset date and link to pricing page.
- [x] **Track storage usage** — `file_size_mb` stored on every upload; `storage_used_mb`
  in profiles updated on each upload and delete.
- [x] **Enforce 50MB free tier storage cap** — check
  `storage_used_mb + file.size / 1024 / 1024 <= 50` in `handleUpload()` before
  uploading, and add a second condition to the RLS policy. Audio normalization
  (Stage 1, deferred) will reduce the practical risk once it ships.
- [x] **Abuse prevention — profile enrichment** — `country_code` captured from
  `navigator.language` on first login and stored in profiles.
- [x] **Abuse prevention — honeypot and division field** — modal on first dashboard
  load (when `division_name` is null). Includes hidden honeypot field. Cannot be
  dismissed without submitting a division name.
- [x] **Abuse prevention — upload rate limiting** — RLS policy blocks more than 10
  uploads per hour per `teacher_id` at the database layer.
- [ ] **Abuse prevention — anomaly monitoring** — monitor the `uploads` table weekly
  for anomalous patterns: high upload counts from a single account, large file sizes,
  non-.mp3 file extensions that slipped through. Deferred: requires a cron endpoint
  (11/12 Vercel function slots used).
- [x] **Marketing site copy audit** — "5 active uploads" → "3 uploads per calendar
  month" on homepage pricing card. FOIP → ATIA on privacy page. Pilot program section
  removed from contact page.
- [x] **Automated test suite** — scaffold with vitest config, mock helpers, and test
  directory structure shipped. Full test coverage across these priority areas remains
  deferred work:
  - `api/session.js` — access code validation, expiry checks, rate limiting, typed
    response for audio vs text
  - Exit word SHA-256 hashing — identical behavior in `dashboard.js` and `player.js`
  - `api/event.js` — event type validation, session event insertion
  - `api/admin.js` — role checks, service role boundary
  - Extension player — exit word verification, lockdown enforcement
  - Use `vitest` or `node --test` for API functions; consider Playwright for extension
    smoke tests against a local `vercel dev` instance.
- [x] **Self-host fonts** — both `app/css/styles.css` and `site/site.css` load Playfair
  Display and DM Sans from `fonts.googleapis.com`. The extension already removed this
  dependency for privacy reasons. For the web app, self-hosting the WOFF2 files removes
  a third-party request that leaks page URLs and IPs to Google. Download from Google
  Fonts, place in `app/fonts/`, update `@font-face` declarations.
- [x] **Split monolithic JS files** — `app/js/dashboard.js` (1,786 lines) and
  `app/js/admin.js` (1,214 lines) mix UI rendering, API calls, event handlers,
  validation, and state management with no module boundaries. Split into
  responsibility-focused files (e.g. `dashboard-upload.js`, `dashboard-table.js`,
  `dashboard-quota.js`, `admin-teachers.js`, `admin-schools.js`) loaded via separate
  `<script>` tags. No bundler needed — the pattern is already used elsewhere in the app.
- [x] **Documentation review as release gate** — `README.md` and `docs/ROADMAP.md` drift
  from the live codebase every time a feature ships without a doc review. The README had
  stale file paths for months; the roadmap was missing two shipped features. Add these to
  the release readiness checklist in `docs/OPERATIONS.md`:
  - `README.md` — verify file structure, feature list, and tier model match reality
  - `docs/ROADMAP.md` — verify recently shipped items are checked off
  - One minute of review per release prevents the kind of drift that takes an hour to fix

---

## Stage 3 — Teacher Customization
*Give teachers control without adding complexity.*

- [x] **Custom exit word** — teacher can type their own exit word instead of the
  randomly assigned one
- [x] **Exit word complexity options** — choose between: short word (default), long
  word, two-word phrase, numeric PIN
- [x] **Access code complexity options** — choose between: standard (`ABC-123`), short
  4-char (`AB12`), or a custom code the teacher sets themselves
- [x] **Rename uploads** — edit the display label after uploading
- [x] **Extend expiry** — reset the 7-day clock on an upload without re-uploading
  the file
- [x] **Manual expiry override** — set a specific expiry date/time instead of always
  7 days
- [x] **Duplicate an upload** — generates a new access code and exit word for the
  same audio file

---

## Stage 4 — Database Foundation & Platform Admin
*Build the data layer that everything else depends on, and give the platform admin
visibility before pilots begin.*

The analytics layer serves two audiences with different needs: teachers want to know
if students completed the audio; division admins want to demonstrate that accommodation
obligations are being met at scale. Both needs are served by the same event log —
just presented at different levels of aggregation. No student identity is ever
recorded. All events are anonymous by design.

---

### Session Analytics Schema

- [x] **`session_events` table** — access_code_id, event_type, occurred_at,
  metadata (JSONB)
  - Event types: `code_entered`, `playback_started`, `playback_paused`,
    `playback_resumed`, `playback_completed`, `replay_triggered`,
    `exit_word_used`, `session_expired`
  - Metadata captures position_seconds on pause/resume/replay events
  - No student identity, no device fingerprint, no IP address at any level
- [x] **`upload_summaries` materialized view** — aggregates session_events per upload:
  total sessions, completions, early exits, average listen time, replay count.
  Refreshed on a schedule rather than computed on every dashboard load.
- [x] **Event logging in the session API** — `api/session.js` logs `code_entered` on
  successful lookup; `api/event.js` (new) receives playback events from
  `extension/player.js`. All 8 event types wired.

---

### Account Hierarchy Schema

- [x] **`divisions` table** — name, enrolment_band, tier, admin_email, notes,
  expires_at, created_at
- [x] **`schools` table** — name, division_id (nullable), tier, admin_email, notes,
  expires_at, created_at
- [x] **Update `profiles` table** — added school_id, division_id, tier_override,
  role (teacher / school_admin / division_admin / platform_admin), notes
- [x] **`invitations` table** — email, role, school_id (nullable), division_id
  (nullable), token, expires_at, accepted_at
- [x] **`get_effective_tier(user_id)` DB function** — resolves inherited tier at
  runtime: tier_override → division tier → school tier → teacher tier → free.
  SECURITY DEFINER, granted to authenticated role.
- [x] **Update `check_upload_quota()`** — replaced; new `enforce_upload_quota` policy
  calls `get_effective_tier()` so inherited tiers are respected automatically.
- [x] **Update `ensureProfile()`** — added `getEffectiveTier()` to `js/auth.js`;
  `loadQuota()` and `handleUpload()` in `dashboard.js` now use it instead of
  reading `profiles.tier` directly.

---

### Privacy Boundaries (enforced at schema level)

- [x] RLS policies ensure teachers can only read their own session_events
- [x] Division admins can read aggregated summaries for their division only — no
  drill-down to individual session events; enforced at the API layer in `api/org.js`
- [x] Platform admin role bypasses RLS for support and monitoring purposes —
  `api/admin.js` uses service role key server-side; role check enforced before
  any data is returned
- [ ] Analytics data retained for duration of active contract, deleted on account
  closure — document retention policy in Privacy Policy update

---

### Platform Admin Dashboard (`/admin` — platform admin role only)

- [x] **Division list** — all divisions with tier, enrolment band, expiry date;
  inline tier selector and notes field
- [x] **School list** — all schools with division name, tier, notes; inline editing
- [x] **Unattached teachers list** — all teachers with email, org, country code,
  tier override, and notes; client-side filter by email/division
- [x] **Tier management** — inline dropdown on every division, school, and teacher
  row; takes effect immediately via `get_effective_tier()`
- [x] **Account management — reassign** — platform admin can reassign any teacher to
  a different school and/or division via a modal in the admin dashboard. Takes effect
  immediately. Teacher is notified by email.
- [x] **Account management — deactivate/delete** — deactivate or permanently delete
  accounts. Deactivation flips `is_deactivated`; deletion removes all data.
- [x] **Invitation tool** — platform admin creates invitations from `/admin.html`;
  invitation email sent via Resend with a sign-in link. Token acceptance flow wired.
  Resend status shown inline (success / failure with error detail).
- [x] **Account flags** — notes field on every division, school, and teacher row;
  saved on blur
- [x] **Anomaly review queue** — surfaces non-Canadian country_code accounts;
  count shown in tab badge

---

### Privacy Policy Update

- [x] Update Privacy Policy to document session event collection: what is recorded,
  what is not, how long it is retained, and that no student identity is captured
  at any level. Updated March 31, 2026 — covers anonymous session analytics,
  FOIPPA/ATIA positioning, division admin data access scope, and data retention
  on deletion.

---

## Stage 5 — Analytics & Administration UI
*Surface the Stage 4 data to the right people at the right level.*

---

### Teacher Analytics

- [x] **Per-upload summary card** — visible on each upload in the dashboard:
  sessions count, completion rate (colour-coded), replay count, avg listen time.
  Hidden for free tier (no analytics per pricing model).
- [x] **Completion rate indicator** — green ≥80%, amber ≥60%, red <60% shown inline
  on each upload row
- [x] **Replay signal** — replay count shown on each upload row
- [x] **Teacher "Insights" tab** — aggregated view below the uploads table:
  total sessions, completion rate, total replays, most-used assessment
- [x] **Export session data as CSV** — "Export CSV" button in the Insights card;
  uses `get_my_session_events()` RPC; one row per event with upload label, event
  type, timestamp, position

---

### School Admin UI

- [x] **Teacher list** — all teachers at the school with upload count, session count,
  and last active date (`/school-admin.html`)
- [x] **Invite teacher** — email-based invitation from school admin dashboard.
- [x] **Remove teacher** — detaches teacher from school. Teacher account is preserved
  with their existing uploads intact — they revert to unattached free tier. School
  Admin cannot delete accounts, only detach them.
- [x] **School-wide usage report** — total assessments delivered, active teachers,
  storage used, session completion rate — shown as stats row at top of page

---

### Division Admin UI

- [x] **School list** — all schools in the division with per-school teacher count
  and total session count (`/division-admin.html`)
- [x] **Remove school from division** — detaches a school from the division. School
  and its teachers revert to unattached free tier. Division Admin cannot delete
  school accounts, only detach them.
- [x] **Per-school drill-down** — "View Teachers" button opens an inline panel
  showing the same teacher list a School Admin sees, without individual session
  event details
- [x] **Invite school admin** — email-based invitation from division admin dashboard.
- [x] **Remove school admin** — revoke a specific teacher's school admin role; role
  reverts to teacher immediately
- [x] **Division-wide usage report** — schools, teachers, active teachers this year,
  total sessions — shown as stats row at top of page
- [x] **Assessment window chart** — SVG bar chart showing sessions per week for the
  last 12 weeks. Powered by `division-activity` action in `api/org.js`.
- [x] **Active teachers report** — "Active This Year" stat counts teachers who have
  uploaded at least one assessment since September 1 of the current school year
- [x] **Export division report as CSV** — "Export CSV" button downloads school-level
  summary as a CSV

---

### Tier Badge & Upgrade Prompts (teacher dashboard)

- [x] **Tier badge** — visible in dashboard header: "Free", "Teacher Premium",
  "School Plan", "Division Plan"
- [x] **Upgrade CTA for free tier** — banner below quota bar: "Your school isn't on
  a plan yet" with link to pricing page
- [x] **School/Division plan confirmation** — if on inherited plan, shows "Your
  school/division is on a plan" with link to Settings

---

### Teacher Settings Page (`/settings.html`)

- [x] **Profile section** — display name (editable via `api/account.js`), email
  address (read-only, sourced from Google), school and division affiliation
  (read-only, set by admin)
- [x] **Subscription section** — shows current tier and how it was acquired:
  - "You're on the Free tier" — with upgrade CTA linking to pricing page
  - "You're on Teacher Premium" — read-only; billing management added in Stage 6
  - "Your school is on a School plan" — read-only, no action available
  - "Your division is on a Division plan" — read-only, no action available
- [x] **Delete account section** — clearly separated from the rest of the page,
  below a visual divider. Two-step confirmation: first click shows a warning,
  second click requires typing "DELETE" to confirm. On confirmation:
  - All uploads and storage files are deleted immediately
  - All session_events associated with their uploads are deleted (cascade)
  - The profiles row is deleted
  - The auth.users record is deleted via Supabase admin API
  - Teacher is signed out and redirected to the marketing site
  - If teacher is a School Admin, deletion is blocked with an error message

---

### Detach and Fallback Rule

When a teacher is detached from a school, or a school is detached from a division,
the detached account immediately reverts to free tier. No grace period — quota
enforcement kicks in on the next upload attempt. Existing uploads are preserved and
remain accessible until they expire normally. If a teacher was on an inherited School
or Division plan and had more than 3 uploads active, those uploads continue to
function until expiry but no new uploads are permitted beyond the free tier limit.
The teacher is notified by email at the moment of detachment that their tier has
changed.

---

## Stage 6 — Distribution & Monetization
*Turning it into a real product. The goal of Stage 6 is to remove every manual step
from the sales and onboarding process so that a division can go from "heard about it"
to "deployed across all Chromebooks" without requiring direct involvement at each step.
Early customers will be onboarded manually — that's fine and expected. This stage
systematizes what was learned from those early conversations.*

---

### Account Lifecycle (deferred from Stage 4)

Deactivation and deletion are distinct operations with different consequences:

**Deactivation** (reversible, data preserved):
- `profiles.is_deactivated = true` — column exists since migration 009
- `api/session.js` already blocks code lookups for deactivated teachers
- Teacher retains all uploads, session events, and profile data
- Can be reactivated by platform admin (flip flag back)
- Use case: teacher leaves a school mid-year; codes may still be needed for IEP documentation
- [x] **Admin UI toggle** — platform admin can deactivate/reactivate any teacher, school,
  or division account from the admin dashboard

**Deletion** (irreversible, all data removed):
- Teacher self-service delete exists (`api/account?action=delete-account`)
- Settings page informs teachers to request deactivation instead if leaving a school
- [x] **Admin-initiated deletion** — platform admin can permanently delete a division,
  school, or teacher account and all associated data from the admin dashboard.
  Requires explicit confirmation. Irreversible.

- [x] **Reassign teacher** — move a teacher to a different school without losing upload history.

---

### Invitation Email Delivery

The `invitations` table and token generation shipped in Stage 4. Completed in Stage 3:

- [x] **Send invitation email via Resend** — when a platform admin creates an invitation
  from `/admin.html`, an email is sent to the invitee with a sign-in link containing
  the token. On click, the teacher signs in with Google and lands in the dashboard
  already attached to the correct school/division.
- [x] **Invitation acceptance flow** — `api/accept-invite.js` validates the token,
  confirms it hasn't expired or been accepted, attaches the teacher to the org, marks
  `accepted_at`, and redirects to the dashboard.
- [ ] **Billing status in School Admin UI** — current tier, renewal date, and payment
  method visible to the School Admin once Stripe is connected.

---

### Chrome Web Store

- [x] **Publish extension to Chrome Web Store** — the listing is live at
  `https://chromewebstore.google.com/detail/audioproctor/fcphbkffopenkinliokmlopfnglbcfdj`.
  Managed Chromebooks can be deployed by Store ID in Google Admin Console instead of
  uploading a .crx file.
- [x] **Public listing** — listing is public. Organic discovery from Alberta IT
  admins searching the Store is free marketing.
- [ ] **Store listing assets** — branded screenshots, a short demo video (screen
  recording of the teacher upload flow and student player), and a concise description
  written for IT admins, not teachers.
- [ ] **Attestation automation + publish chain review** — audit the full extension
  release pipeline end-to-end: version numbering conventions, the subtree split
  attestation model (`RELEASE_SOURCE_OF_TRUTH.md`), and the Chrome Web Store publish
  step (currently manual). Goal: identify breakage points, then automate what makes
  sense. Extends the existing `sync-extension.yml` workflow.

---

### Google Admin Deployment

- [x] **IT deployment guide (PDF)** — step-by-step document for Google Workspace
  admins covering force-install by Store ID, scoping to student OUs, and smoke
  testing. Lives at `docs/it-pilot-deployment-guide.md` and can be rendered to PDF.

---

### Self-Serve Signup & Access Control

- [x] **Open Google signup with auto-trial** — any Google account can sign in at
  `/login.html`. On first login, `ensureProfile()` creates a profile with
  `tier='premium'` and `expires_at` 30 days out. No approval needed. After 30 days,
  `get_effective_tier()` returns `'free'` and new uploads are blocked by free-tier limits.
  Existing uploads remain accessible until they expire.
- [x] **Teacher request flow** — existing teachers submit in-app requests (premium trial,
  school plan, division plan) from the dashboard. Requests land in the platform admin
  dashboard with an approve/reject button. Admin notified by email via Resend.
- [x] **Platform admin invitation flow** — platform admin creates invitations from
  `/admin.html`; invitation email sent via Resend. Teacher clicks link, signs in with
  Google, lands in the dashboard attached to the correct school/division.
- [x] **School/division admin invitation flow** — School Admins and Division Admins can
  invite teachers directly by email from their own dashboards. Currently only platform
  admin can send invitations.

  *What exists:* The platform admin invite flow in `api/admin.js` (lines 632–670) is
  fully functional — creates an `invitations` row, sends email via Resend, logs to
  `invite_email_log`. The `api/accept-invite.js` endpoint handles token validation,
  profile update, and welcome email for any role and any org. The `invitations` table
  already stores `school_id` and `division_id`. The `buildInviteEmail()` and
  `sendEmail()` helpers are reusable as-is.

  *What's needed:*
  1. **`api/org.js` — add `invite-teacher` action.** Accepts `{ email }`. Caller must
     be `school_admin` or `division_admin`. Auto-fills `school_id` (from
     `profile.school_id`) or `division_id` (from `profile.division_id`) and sets
     `role='teacher'`. Reuses the same insert-to-invitations → send-email → log pattern
     from `api/admin.js`. School admins can only invite into their own school. Division
     admins can only invite into their own division. Cannot invite with elevated roles
     (school_admin, division_admin) — only platform admin can do that.
  2. **`app/school-admin.html` + `app/js/school-admin.js` — invite form.** Add an
     "Invite Teacher" button above or beside the teachers table. Opens a simple modal
     with an email field. On submit, calls `orgApi('invite-teacher', 'POST', { email })`.
     Show success/error feedback inline. Reuse the modal pattern already in
     `dashboard.html` (`.modal-overlay` / `.modal-box`).
  3. **`app/division-admin.html` + `app/js/division-admin.js` — invite form.** Same
     pattern. The division admin's invite attaches the teacher to the division (not a
     specific school). Optionally allow selecting a school from the division's school
     list if the admin wants to target a specific school.
  4. **Accept-invite welcome email** — already sends "Welcome to AudioProctor" on
     acceptance (line 114–122 of `api/accept-invite.js`). Consider personalizing with
     the org name: "Welcome to AudioProctor — you've been added to [School Name]." Low
     priority.
- [ ] **Division admin approval flow** — once a division is on a paid plan, their
  Division Admin receives and approves teacher requests without your involvement.
  You only handle unattached requests.
- [ ] **Domain restriction** — optionally lock a division's account to a specific
  email domain (e.g. `@fsd38.ab.ca`) so only staff from that division can join,
  even if someone shares an invite link externally.

---

### Billing

- [ ] **Stripe integration** — annual invoicing via Stripe. On division signup,
  generate a Stripe invoice for the correct enrolment band. Division pays by credit
  card or requests a PO (Stripe supports both). On payment, tier is automatically
  upgraded in the database.
- [x] **Manual override preserved** — platform admin can manually flip tiers for any
  division, school, or teacher via the `/admin` dashboard. Takes effect immediately
  via `get_effective_tier()`. No Stripe required.
- [ ] **Renewal reminders** — automated email 60 and 30 days before contract renewal.
  Sent to Division Admin. Includes usage summary for the year (total sessions, active
  teachers, storage used) — gives them the data to justify renewal to their
  superintendent before you even ask.
- [ ] **School tier billing** — credit card only via Stripe. School Admin enters card
  details, billed annually. If their division later signs a division contract, a
  prorated credit is applied automatically.
- [x] **Teacher Premium billing** — self-serve Stripe checkout (annual subscription)
  plus in-app request flow for platform-admin approval. Both paths supported.
- [x] **Free tier enforcement on lapse** — automated downgrade when `profiles.expires_at`
  passes. `get_effective_tier()` returns 'free' for expired trials. Teacher data and
  uploads are preserved indefinitely; only new uploads are blocked by free-tier limits.

---

### Onboarding & Communication

Note: Division onboarding email code was built (v1.3.0, commit c074960) then pruned
(commit 8148d63) to stay under the Vercel Hobby 12-function limit. Both sequences
below require a cron endpoint. Deferred until Vercel Pro upgrade or off-platform cron.

- [ ] **Onboarding email sequence — Division** — triggered on first paid activation:
  - Day 0: Welcome + IT deployment guide PDF + Division Admin setup checklist
  - Day 3: "Have you deployed the extension?" — link to deployment guide, offer
    to jump on a call
  - Day 14: "Your teachers are getting started" — usage summary so far, tips for
    running a first assessment
  - Day 60: Check-in — any questions, reminder that support is available
- [ ] **Onboarding email sequence — Free Teacher** — triggered on first login:
  - Day 0: Welcome + link to a 2-minute walkthrough video
  - Day 7: "Ready to run your first assessment?" — if no upload yet, gentle nudge
  - Day 30: "Share AudioProctor with your admin" — template email they can forward
    to their principal or IT director. Seeds the division conversation passively.
- [ ] **All email via Resend** — already configured. Build sequences as simple
  scheduled database jobs, no third-party marketing automation needed at this scale.

---

### Pilot Program Package

- [ ] **Formal pilot agreement (one page)** — covers: free access for one school for
  a defined period, commitment to provide structured feedback at 30/90/180 days,
  written testimonial on completion, right for AudioProctor to reference the division
  by name in marketing. Simple enough to be approved without legal review.
- [ ] **Feedback survey (30/90/180 day)** — three short surveys sent automatically.
  Questions focus on: which assessments it was used for, how many students, what
  worked, what didn't, what would make them recommend it to another division.
- [ ] **Pilot completion report** — auto-generated PDF summarizing the division's
  usage over the pilot period: total sessions, unique assessments delivered, active
  teachers, estimated hours of accommodation support provided. Handed to the Division
  Admin as a record and used as a sales asset for the next division conversation.

---

## Project Health
*What's working, what's not, and how to keep it working. Last reviewed April 2026.*

### What works well

- **Architecture is AI-augmentation friendly.** No build step, no framework, no bundler.
  Every file is readable in isolation. An AI agent can pick up any file, understand it,
  and make changes without running a build pipeline. API endpoints are one file each.
  Extension is separated from the app. Migrations are numbered and self-contained.
- **Privacy model is structural, not policy-based.** No student data column exists in the
  database. The system can't leak what it doesn't store. This is the difference between
  "trust us" and "there's nothing to trust us with."
- **Role model is well-scoped.** Teacher, school admin, division admin, platform admin.
  Each has their own dashboard, their own API scope, their own permissions. The
  `get_effective_tier()` cascade resolves inherited tiers server-side so the UI never
  has to reason about org hierarchy.
- **Extension supply-chain attestation is novel.** The public mirror repo, the subtree
  SHA matching, the artifact hashing, and the Chrome Web Store version mapping give
  AudioProctor a cryptographically verifiable chain of custody. This is unusual for any
  product and effectively unheard of in edtech.
- **Self-serve distribution works.** Open Google login with auto 30-day premium trial,
  teacher request flow with Resend email notification, admin approval with invitation
  email. A teacher can go from "heard about it" to "running assessments" without direct
  platform admin intervention.
- **Design system is consistent.** Editorial print aesthetic applied uniformly across the
  marketing site, teacher dashboard, admin dashboards, and extension. The design
  principles (`docs/design-principles.md`) are documented and followed.

### Process notes (from April 2026 review)

1. **Documentation drift is the biggest process risk.** See Stage 2 item: documentation
   review as release gate. The README, roadmap, and AGENTS.md all drifted from the live
   codebase. One minute of review per release prevents it.
2. **Automated tests are the biggest product risk.** See Stage 2 item. The session API,
   exit word hashing, and access code validation are security-critical paths with zero
   test coverage. A dozen targeted tests would cover the paths where a bug means a
   student is stuck in a locked window.
3. **The `.hermes/plans/` pattern works.** Implementation plans with exact file paths,
   code snippets, verification steps, and commit hashes. Useful for AI agents picking up
   work later, for auditing what was done, and for not re-solving solved problems.
4. **Constraint-setting is the key AI collaboration skill.** "Light cleanup, don't touch
   .hermes/plans, ask before moving files" gives the agent enough structure to work
   independently without guessing. Fast corrections with evidence ("actually, the
   self-serve signup works") keep the agent aligned.
5. **The `AGENTS.md` file should reference files that exist.** It currently references
   `CLAUDE.md` which is not in the repo. Keep it updated or remove the reference.
6. **Docs subdirectories would help at scale.** The `docs/` folder has 14 files with no
   subdirectories. As it grows, grouping by concern (operations/, testing/, pilot/) would
   help both humans and AI agents find the right document faster.

---

## Parking Lot
*Interesting ideas that need more thought before committing to.*

- **Chromebook-only extension lock** — restrict the extension to ChromeOS only.
  Windows, Mac, and Linux users should not be able to launch assessments. Since
  the extension is publicly listed on the Chrome Web Store, any student on any OS
  could install it — the lock must be enforced in the extension itself.
  Implementation:
  - `chrome.runtime.getPlatformInfo()` returns `"chromeos"` for ChromeOS devices.
    Block on all other platforms (`"win"`, `"mac"`, `"linux"`, etc.).
  - On block: show a one-time message: "AudioProctor requires a Chromebook. Ask
    your teacher or IT administrator for help."
  - Managed Chromebooks get additional security via Google Admin force-install
    and policy enforcement, but the OS lock applies universally — managed or not.
  - Consider a bypass token for teacher testing on non-ChromeOS devices (gated
    behind a platform admin flag, never exposed to students)
- Video file support (MP4) for ASL interpretation tracks
- Offline mode — pre-download audio to the extension for no-internet testing
  environments
- Student accessibility options in the player (high contrast mode, larger text)
- Integration with Vretta or other provincial assessment platforms directly
- iOS/Android companion app for teachers to share codes and monitor sessions

---

## Pricing Tiers
*Reference model for when billing is implemented in Stage 6.*

**Free — Individual Teacher**
- 1 teacher account
- 3 uploads per calendar month
- 7-day expiry only (no override)
- Randomly assigned exit words and access codes (no customization)
- No analytics — sessions run but no data is visible to the teacher
- Purpose: gives teachers enough to run real assessments and champion the product
  internally before a school or division decision is made

**Teacher Premium — $75 CAD/year**
- 1 teacher account
- Unlimited uploads
- Extended and manual expiry override
- Custom exit words and access code options
- Basic session analytics and CSV export
- For teachers whose school or division hasn't purchased, but who want full access
  independently

**School — $200 CAD/year**
- All Teacher Premium features for every teacher at the school
- Up to 15 teacher accounts
- School admin role (principal or designate) — invite and remove teachers
- School-wide usage report
- Single annual invoice or credit card payment at the school level
- Intended for schools spending from their own minibudget

**Division — Annual contract, priced by enrolment**
- All School features for every school in the division
- Unlimited teacher accounts across all schools
- Division admin role and school grouping
- Division-wide usage reports and assessment window chart
- Custom subdomain (`yourschool.audioproctor.com`)
- Priority support and onboarding call
- Single annual invoice to the division office

| Division Size | Enrolled Students | Annual Price (CAD) | Example |
|---|---|---|---|
| Small | Under 2,000 | $800 | Most rural Alberta divisions |
| Medium | 2,000–8,000 | $1,500 | Foothills SD, Rocky View SD |
| Large | 8,000–25,000 | $3,000 | Red Deer Public, Lethbridge SD |
| Metro | 25,000+ | $6,000 | Edmonton Public, Calgary Board |

*Enrolment figures from Alberta Education's annual school authority report.*

**Pricing rationale:** Cost scales with the scope of the purchase, not the number of
features used. Every tier gets the same core functionality. A metro division pays more
than a rural division because the contract covers more teachers, more schools, and more
Chromebooks — not because they get a different product. Individual teachers and schools
can purchase independently; a division contract makes the most sense when IT is
deploying to all Chromebooks at once.

**Pilot program:** Offered selectively to early divisions — free for one full school
year in exchange for structured feedback and a written testimonial. Managed manually
through the platform admin dashboard. Not advertised publicly.

---

## Marketing Site — Navigation

- [x] **Sign In link in top nav** — the marketing site (`audioproctor.com`) has no visible
  path to the app. Add a "Sign in" link in the site header pointing to
  `https://app.audioproctor.com/login.html`. Should appear on all marketing pages
  (index, use-cases, about, pricing, etc.) in the top-right beside the existing CTA.

---

## Marketing Site — Pricing Communication
*How the pricing model should be framed consistently across the marketing site.*

- **Home page** — Pricing section after the "Why AudioProctor" columns. Four cards:
  Free, Teacher Premium, School, Division (with enrolment table). Section headline:
  "Pricing that fits how schools actually work." Subhead: "Whether you're a single
  teacher, a school spending from a minibudget, or a division deploying to every
  Chromebook at once — there's a tier for how you actually make decisions." CTA on
  Free card: "Sign in to get started." CTA on Teacher Premium and School cards:
  "Request a quote" → /contact until Stripe is live. CTA on Division card: "Request
  a pilot" → /contact. Footer line below all cards: "All prices in CAD. Division
  pricing is by annual invoice. Teacher Premium and School tiers are self-serve via
  credit card (coming soon — contact us to purchase in the meantime)."

- **Use Cases page** — one-line pricing callout on each card: Provincial Assessment
  card: no pricing mention, focus on credibility. Small School card: "Free tier
  covers it — no infrastructure required." Division Rollout card: "Division tier —
  IT deploys once, every school has it."

- **About page** — short paragraph explaining the pricing philosophy: AudioProctor
  is priced by the scope of the purchase. A teacher can sign up free. A school can
  buy a plan from their minibudget. A division can sign one contract that covers
  every school, every teacher, and every Chromebook. The price scales with how much
  of the organization is covered, not with how many features are unlocked.

- **Contact / Demo Request form** — Division Enrolment dropdown so leads self-segment
  on arrival: Individual teacher / Under 2,000 students / 2,000–8,000 / 8,000–25,000
  / 25,000+. Every demo request arrives pre-qualified for the correct pricing band
  before you reply.

- **Privacy Policy and Terms of Service** — no pricing mention needed.

---

### Premium Audio Quality

- [x] **Premium audio quality** — non-free tiers (premium/school/division) get 128kbps mono MP3
  encoding; free tier stays at 32kbps. Server-side in trigger-normalize.js.

### Email Allowlisting

- [x] **Email allowlist gate** — `api/check-access.js` blocks signups from emails not matching
  `ALLOWED_EMAIL_PATTERN` (configurable regex). Existing users are grandfathered. When no pattern
  is set, the gate is open (fail-open, backward compatible). Client-side in `auth.js` shows
  an "Access Restricted" page on denial.

### Admin Oversight & Content Browser

- [x] **Admin content access API** — `admin.js` adds `list-teacher-uploads` (paginated, with
  teacher/school/division metadata) and `get-upload-content` (signed audio URL or resolved text
  HTML with images). `org.js` adds `school-uploads` and `division-uploads` scoped to the admin's
  org role. All use the service role key — no RLS bypass.
- [x] **Admin content browser UI** — shared `content-browser.js` renders teacher upload tables
  with inline HTML5 audio player and text viewer. Filtering by teacher name, school, and
  assessment type. Pagination at 50/page. Wired into admin.html, school-admin.html, and
  division-admin.html via thin role-specific init modules (admin-content.js,
  school-admin-content.js, division-admin-content.js).