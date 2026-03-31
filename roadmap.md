# AudioProctor — Product Roadmap

A rough sequence of improvements, from "working MVP" to "something a division would pay for."

---

## Stage 1 — Polish the MVP
*Make it feel finished before anyone else sees it.*

- [x] Proper extension icons (branded, not placeholders)
- [x] Friendly onboarding on first login ("Upload your first assessment to get started")
- [x] Better upload progress — show a real progress bar for large files
- [x] Handle duplicate filenames gracefully in the dashboard
- [x] Add a label/title field to uploads so teachers can name them ("Grade 4 Reading Assessment - May")
- [ ] Test on an actual managed Chromebook end-to-end
- [ ] **Audio normalization on upload** — transcode all uploaded files to 32kbps mono MP3
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
- [ ] **Domain restriction on Google login** — optionally limit sign-in to a specific
  school email domain (e.g. `@yourschool.ca`)
- [x] **Signed URL refresh** — if a student's session expires mid-test (>1 hour), show
  a graceful error rather than silent failure
- [ ] **Supabase backups enabled** — enable Point in Time Recovery in Supabase →
  Project Settings → Database → Point in Time Recovery
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
  non-.mp3 file extensions that slipped through.
- [x] **Marketing site copy audit** — "5 active uploads" → "3 uploads per calendar
  month" on homepage pricing card. FOIP → ATIA on privacy page. Pilot program section
  removed from contact page.

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
- [ ] Division admins can read aggregated summaries for their division only — no
  drill-down to individual session events (UI in Stage 5)
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
- [ ] **Account management** — deactivate or permanently delete accounts, reassign
  teacher/school to a different division (attach-teacher endpoint exists; full
  deactivate/delete flow not yet built)
- [ ] **Invitation tool** — invitations table and token generation shipped; email
  delivery not yet wired
- [x] **Account flags** — notes field on every division, school, and teacher row;
  saved on blur
- [x] **Anomaly review queue** — surfaces non-Canadian country_code accounts;
  count shown in tab badge

---

### Privacy Policy Update

- [ ] Update Privacy Policy to document session event collection: what is recorded,
  what is not, how long it is retained, and that no student identity is captured
  at any level.

---

## Stage 5 — Analytics & Administration UI
*Surface the Stage 4 data to the right people at the right level.*

---

### Teacher Analytics

- [ ] **Per-upload summary card** — visible on each upload in the dashboard:
  "Used 24 times · 18 completed · 6 exited early · Avg listen time 14:32"
- [ ] **Completion rate indicator** — simple visual (green/yellow/red) showing
  percentage of sessions that reached end of audio
- [ ] **Replay signal** — "Audio was replayed from the beginning 9 times" — useful
  for identifying passages students found difficult
- [ ] **Timeline view** — when during the audio did most pauses and replays occur,
  shown as a simple bar chart over the waveform. Helps teachers identify whether a
  specific question or passage caused difficulty.
- [ ] **Teacher "Insights" tab** — aggregated view across all of a teacher's uploads:
  total sessions delivered, total completions, most-used assessments
- [ ] **Export session data as CSV** — one row per session event, suitable for
  teacher records or inclusion in an IEP review

---

### School Admin UI

- [ ] **Teacher list** — all teachers at the school with upload count, session count,
  and last active date
- [ ] **Invite teacher** — enter email, sends invitation, teacher lands in dashboard
  already attached to the school on first login
- [ ] **Remove teacher** — detaches teacher from school. Teacher account is preserved
  with their existing uploads intact — they revert to unattached free tier. School
  Admin cannot delete accounts, only detach them.
- [ ] **School-wide usage report** — total assessments delivered, active teachers,
  storage used, session completion rate

---

### Division Admin UI

- [ ] **School list** — all schools in the division with per-school usage metrics:
  active teachers, total sessions, storage used
- [ ] **Add school** — create a new school record within the division, assign or
  invite a School Admin by email
- [ ] **Remove school from division** — detaches a school from the division. School
  and its teachers revert to unattached free tier. Division Admin cannot delete
  school accounts, only detach them.
- [ ] **Per-school drill-down** — click into a school to see the same view a School
  Admin sees, without being able to see individual teacher session details
- [ ] **Invite school admin** — enter email and school name, sends invitation
- [ ] **Remove school admin** — revoke a specific teacher's school admin role without
  removing them from the school entirely. Another admin must be assigned before the
  role can be revoked.
- [ ] **Division-wide usage report** — total assessments delivered across all schools,
  active teachers, overall completion rate, storage consumed
- [ ] **Assessment window chart** — usage over time as a simple line chart. Shows
  spikes during provincial assessment periods — compelling visual for demonstrating
  adoption to a superintendent or board.
- [ ] **Active teachers report** — how many teachers have uploaded at least one
  assessment in the current school year
- [ ] **Export division report as CSV** — suitable for board reporting or budget
  justification

---

### Tier Badge & Upgrade Prompts (teacher dashboard)

- [ ] **Tier badge** — visible in dashboard header: "Free", "Teacher Premium",
  "School Plan", "Division Plan"
- [ ] **Upgrade CTA for free tier** — when approaching or at limit, show: "Your
  school isn't on a plan yet. Ask your principal about AudioProctor for your school."
  with a link to the pricing page
- [ ] **School/Division plan confirmation** — if on inherited plan, show "Your
  [school/division] is on a plan" instead of an upgrade prompt

---

### Teacher Settings Page (`/dashboard/settings`)

- [ ] **Profile section** — display name (editable), email address (read-only,
  sourced from Google), school and division affiliation (read-only, set by admin)
- [ ] **Subscription section** — shows current tier and how it was acquired:
  - "You're on the Free tier" — with upgrade CTA linking to pricing page
  - "You're on Teacher Premium" — read-only; billing management added in Stage 6
  - "Your school is on a School plan" — read-only, no action available
  - "Your division is on a Division plan" — read-only, no action available
- [ ] **Delete account section** — clearly separated from the rest of the page,
  below a visual divider. Two-step confirmation: first click shows a warning
  ("This will permanently delete your account and all uploaded files. Access codes
  will stop working immediately."), second click requires typing "DELETE" to confirm.
  On confirmation:
  - All uploads and storage files are deleted immediately
  - All session_events associated with their uploads are deleted
  - The profiles row is deleted
  - The auth.users record is deleted via Supabase admin API
  - Teacher is signed out and redirected to the marketing site
  - If teacher is a School Admin, deletion is blocked until they reassign or
    relinquish the admin role first

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

- [ ] **Account deactivation** — platform admin can deactivate any division, school,
  or teacher account. Deactivated accounts lose access immediately; data is preserved
  for 30 days before permanent deletion. Reactivation possible within the grace period.
- [ ] **Account deletion** — permanent deletion of a division, school, or teacher
  account and all associated data (uploads, storage files, session events, profiles row,
  auth record). Irreversible. Requires explicit confirmation in the admin dashboard.
- [ ] **Reassign teacher / school** — move a teacher to a different school, or a
  school to a different division, without losing upload history.

---

### Invitation Email Delivery (deferred from Stage 4)

The `invitations` table and token generation shipped in Stage 4. This completes the flow:

- [ ] **Send invitation email via Resend** — when a platform admin or school/division
  admin creates an invitation, send an email to the invitee with a sign-in link
  containing the token. On click, the teacher signs in with Google and lands in the
  dashboard already attached to the correct school/division.
- [ ] **Invitation acceptance flow** — `api/accept-invite.js` validates the token,
  confirms it hasn't expired or been accepted, attaches the teacher to the org, marks
  `accepted_at`, and redirects to the dashboard.
- [ ] **Billing status in School Admin UI** — current tier, renewal date, and payment
  method visible to the School Admin once Stripe is connected.

---

### Chrome Web Store

- [ ] **Publish extension to Chrome Web Store** — unlisted initially (discoverable
  only by direct link). This eliminates manual sideloading for IT admins — they
  reference the Store ID in Google Admin Console policy instead of uploading a .crx
  file. Unlisted means you control who finds it while still getting the deployment
  benefits.
- [ ] **Public listing** — once the product is stable and FSD38 pilot is complete,
  make the listing public. Organic discovery from Alberta IT admins searching the
  Store is free marketing.
- [ ] **Store listing assets** — branded screenshots, a short demo video (screen
  recording of the teacher upload flow and student player), and a concise description
  written for IT admins, not teachers.

---

### Google Admin Deployment

- [ ] **IT deployment guide (PDF)** — a short, step-by-step document for Google
  Workspace admins covering: force-installing the extension by Store ID, scoping it
  to student OUs, setting any managed extension policies. Written for someone who
  administers Chromebooks but has never heard of AudioProctor. Offered as a download
  on the marketing site and sent automatically on division signup.
- [ ] **Managed extension configuration** — define any policy schema the extension
  accepts (e.g. pre-configured division ID so the extension knows which division it
  belongs to without the teacher typing anything). Makes division-wide deployment
  truly zero-touch for teachers.
- [ ] **Google Workspace Marketplace listing (stretch goal)** — makes AudioProctor
  discoverable to Google Workspace admins directly inside their Admin Console. Higher
  bar to publish but significantly increases visibility with exactly the right audience.

---

### Self-Serve Signup & Access Control

- [ ] **Teacher request flow** — instead of open signup, teachers submit a request
  (name, email, school, division). Request lands in the platform admin dashboard and
  triggers a notification email. You approve or assign them to an existing division.
  Prevents random signups from outside Alberta.
- [ ] **Division admin approval flow** — once a division is on a paid plan, their
  Division Admin receives and approves teacher requests without your involvement.
  You only handle unattached requests.
- [ ] **Email invite flow** — Division and School Admins can invite teachers directly
  by email. Invited teacher clicks link, signs in with Google, lands in the dashboard
  already attached to the correct school. No request approval needed for invited
  teachers.
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
- [ ] **Teacher Premium billing** — self-serve Stripe checkout, annual subscription.
- [ ] **Free tier enforcement on lapse** — automated downgrade if a paid account
  lapses. Teacher data and uploads are preserved for 30 days post-expiry before
  deletion, giving time to resolve payment issues without losing work.

---

### Onboarding & Communication

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

## Parking Lot
*Interesting ideas that need more thought before committing to.*

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