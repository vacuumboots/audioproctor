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
- [ ] Audio normalization on upload — transcode all uploaded files to 32kbps mono MP3 via a Supabase Edge Function triggered on upload. Reduces file, ensures consistent playback quality, and protects against teachers uploading large high-bitrate files. Implementation: browser uploads original to a staging path in Supabase storage → Edge Function runs ffmpeg transcoding → normalized file moves to final path → staging file deleted.

---

## Stage 2 — Security & Reliability
*Build the foundation of trust before pitching to anyone in a school.*

- [x] **Rate limiting on the session API** — 10 failed code lookups per IP per hour returns 429. Failed attempts (not found + expired) are logged; successful lookups are not.
- [ ] **Domain restriction on Google login** — optionally limit sign-in to a specific school email domain (e.g. `@yourschool.ca`)
- [x] **Signed URL refresh** — if a student's session expires mid-test (>1 hour), show a graceful error rather than silent failure
- [ ] **Supabase backups enabled** — enable Point in Time Recovery in Supabase → Project Settings → Database → Point in Time Recovery
- [x] **Enforce free tier upload limits server-side** — `check_upload_quota()` Supabase RLS policy blocks a 4th upload at the database layer. API returns HTTP 403 if limit is reached. Cannot be bypassed by calling the API directly.
- [x] **Free tier quota indicator in the dashboard UI** — quota bar shows "X of 3 uploads used this month", goes red and disables upload button at limit. Gate message includes reset date and link to pricing page.
- [x] **Track storage usage** — `file_size_mb` stored on every upload; `storage_used_mb` in profiles updated on each upload and delete.
- [x] **Enforce 50MB free tier storage cap** — check `storage_used_mb + file.size / 1024 / 1024 <= 50` in `handleUpload()` before uploading, and add a second condition to the RLS policy. Audio normalization (Stage 1, deferred) will reduce the practical risk once it ships.
- [x] **Abuse prevention — profile enrichment** — `country_code` captured from `navigator.language` on first login and stored in profiles.
- [x] **Abuse prevention — honeypot and division field** — modal on first dashboard load (when `division_name` is null). Includes hidden honeypot field. Cannot be dismissed without submitting a division name.
- [x] **Abuse prevention — upload rate limiting** — RLS policy blocks more than 10 uploads per hour per `teacher_id` at the database layer.
- [ ] **Abuse prevention — anomaly monitoring** — monitor the `uploads` table weekly for anomalous patterns: high upload counts from a single account, large file sizes, non-.mp3 file extensions.
- [x] **Marketing site copy audit** — "5 active uploads" → "3 uploads per calendar month" on homepage pricing card. FOIP → ATIA on privacy page. Pilot program section removed from contact page.

## Stage 3 — Teacher Customization
*Give teachers control without adding complexity.*

- [x] **Custom exit word** — teacher can type their own exit word instead of the randomly assigned one
- [x] **Exit word complexity options** — choose between: short word (default), long word, two-word phrase, numeric PIN
- [x] **Access code complexity options** — choose between: standard (`ABC-123`), short 4-char (`AB12`), or a custom code the teacher sets themselves
- [x] **Rename uploads** — edit the display label after uploading
- [x] **Extend expiry** — reset the 7-day clock on an upload without re-uploading the file
- [x] **Manual expiry override** — set a specific expiry date/time instead of always 7 days
- [x] Duplicate an upload (generates a new code for the same audio file)

---

## Stage 4 — Analytics & Playback Tracking
*Useful data for teachers; a compelling feature for division admins.*

The analytics layer serves two audiences with different needs: teachers want to know
if students completed the audio; division admins want to demonstrate that accommodation
obligations are being met at scale. Both needs are served by the same event log —
just presented at different levels of aggregation.

No student identity is ever recorded. All events are anonymous by design.

## Stage 4 — Database Foundation & Platform Admin
*Build the data layer that everything else depends on, and give the 
platform admin visibility before pilots begin.*

---

### Session Analytics Schema

- [ ] **`session_events` table** — access_code_id, event_type, 
  occurred_at, metadata (JSONB)
  - Event types: `code_entered`, `playback_started`, `playback_paused`,
    `playback_resumed`, `playback_completed`, `replay_triggered`,
    `exit_word_used`, `session_expired`
  - Metadata captures position_seconds on pause/resume/replay events
  - No student identity, no device fingerprint, no IP address at any level
- [ ] **`upload_summaries` materialized view** — aggregates session_events
  per upload: total sessions, completions, early exits, average listen
  time, replay count. Refreshed on a schedule rather than computed on
  every dashboard load.
- [ ] **Event logging in the session API** — wire `api/session.js` to
  write to `session_events` on each state change. Successful code entry,
  playback events, and exit word use are all logged. Failed attempts are
  already logged (Stage 2) and remain separate.

---

### Account Hierarchy Schema

- [ ] **`divisions` table** — name, enrolment_band, tier, admin_email,
  expires_at, created_at
- [ ] **`schools` table** — name, division_id (nullable), tier,
  admin_email, expires_at, created_at
- [ ] **Update `profiles` table** — add school_id (nullable),
  division_id (nullable), tier_override, role
  (teacher / school_admin / division_admin / platform_admin)
- [ ] **`invitations` table** — email, role, school_id (nullable),
  division_id (nullable), token, expires_at, accepted_at
- [ ] **`get_effective_tier(user_id)` DB function** — resolves inherited
  tier at runtime: division tier → school tier → teacher tier → free
  (first match wins). Called from quota-checking RLS policies and the
  dashboard. Replaces the current static `tier` read in `ensureProfile()`.
- [ ] **Update `check_upload_quota()`** — replace direct tier read with
  `get_effective_tier()` so quota enforcement reflects inherited tier
  automatically.
- [ ] **Update `ensureProfile()`** — call `get_effective_tier()` on every
  dashboard load so a teacher whose school just upgraded gets correct
  quota immediately without a manual profile update.

---

### Privacy Boundaries (enforced at schema level)

- [ ] RLS policies ensure teachers can only read their own session_events
- [ ] Division admins can read aggregated summaries for their division
  only — no drill-down to individual session events
- [ ] Platform admin role bypasses RLS for support and monitoring purposes
- [ ] Analytics data retained for duration of active contract, deleted on
  account closure — document retention policy in Privacy Policy update

---

### Platform Admin Dashboard (`/admin` — platform admin role only)

- [ ] **Division list** — all divisions with tier, enrolment band,
  expiry date, active teacher count, total storage used, total sessions
  delivered
- [ ] **School list** — all schools, filterable by division, with same
  usage metrics
- [ ] **Unattached teachers list** — teachers with no school or division
  assignment, with signup date and country_code flag for anomaly review
- [ ] **Tier management** — manually set or override tier for any
  division, school, or teacher. Dropdown selector: Free / Teacher
  Premium / School / Division. Takes effect immediately via
  `get_effective_tier()`. Essential for pilot management before Stripe
  is built.
- [ ] **Account management** — invite, deactivate, or permanently delete
  any division, school, or teacher account. Deactivation preserves data
  for 30 days before deletion. Reassign a teacher or school to a
  different division without losing their history.
- [ ] **Invitation tool** — invite a division admin or school admin by
  email directly from the admin dashboard
- [ ] **Account flags** — mark an account with a status note
  (e.g. "demo requested", "invoice sent", "pilot active", "follow up")
  for sales pipeline tracking
- [ ] **Anomaly review queue** — surfaces accounts flagged by abuse
  prevention rules: non-Canadian country_code, high upload volume,
  large file sizes. Reviewable and dismissable from the admin dashboard.

  ### School Admin UI

- [ ] **Teacher list** — all teachers at the school with upload count,
  session count, and last active date
- [ ] **Invite teacher** — enter email, sends invitation, teacher lands
  in dashboard already attached to the school on first login
- [ ] **Remove teacher** — detaches teacher from school. Teacher account
  is preserved with their existing uploads intact — they revert to
  unattached free tier. School Admin cannot delete accounts, only
  detach them.
- [ ] **School-wide usage report** — total assessments delivered, active
  teachers, storage used, session completion rate
- [ ] **Billing status** — current tier, renewal date, payment method
  (if school purchased independently)


### Division Admin UI

- [ ] **School list** — all schools in the division with per-school
  usage metrics: active teachers, total sessions, storage used
- [ ] **Add school** — create a new school record within the division,
  assign or invite a School Admin by email
- [ ] **Remove school from division** — detaches a school from the
  division. School and its teachers revert to unattached free tier.
  Division Admin cannot delete school accounts, only detach them.
- [ ] **Per-school drill-down** — click into a school to see the same
  view a School Admin sees, without being able to see individual teacher
  session details
- [ ] **Invite school admin** — enter email and school name, sends
  invitation
- [ ] **Remove school admin** — revoke a specific teacher's school admin
  role without removing them from the school entirely. Another admin
  must be assigned before the role can be revoked.
- [ ] **Division-wide usage report** — total assessments delivered across
  all schools, active teachers, overall completion rate, storage consumed
- [ ] **Assessment window chart** — usage over time as a simple line
  chart. Shows spikes during provincial assessment periods — compelling
  visual for demonstrating adoption to a superintendent or board.
- [ ] **Active teachers report** — how many teachers have uploaded at
  least one assessment in the current school year
- [ ] **Export division report as CSV** — suitable for board reporting
  or budget justification
---

### Privacy Policy Update

- [ ] Update Privacy Policy to document session event collection:
  what is recorded, what is not, how long it is retained, and that
  no student identity is captured at any level.

---

## Stage 5 — Analytics & Administration UI
*Surface the Stage 4 data to the right people at the right level.*

---

### Teacher Analytics

- [ ] **Per-upload summary card** — visible on each upload in the
  dashboard: "Used 24 times · 18 completed · 6 exited early · 
  Avg listen time 14:32"
- [ ] **Completion rate indicator** — simple visual (green/yellow/red)
  showing percentage of sessions that reached end of audio
- [ ] **Replay signal** — "Audio was replayed from the beginning 9 times"
- [ ] **Timeline view** — when during the audio did most pauses and
  replays occur, shown as a simple bar chart. Helps identify whether a
  specific passage caused difficulty.
- [ ] **Teacher "Insights" tab** — aggregated across all of a teacher's
  uploads: total sessions delivered, total completions, most-used
  assessments
- [ ] **Export session data as CSV** — one row per session event,
  suitable for teacher records or IEP review documentation

---

### School Admin UI

- [ ] **Teacher list** — all teachers at the school with upload count,
  session count, last active date
- [ ] **Invite teacher** — enter email, sends invitation, teacher lands
  in dashboard already attached to the school on first login
- [ ] **Remove teacher** — detaches teacher from school (preserves their
  uploads and account)
- [ ] **School-wide usage report** — total assessments delivered, active
  teachers, storage used, session completion rate
- [ ] **Billing status** — current tier, renewal date, payment method
  (if school purchased independently)

---

### Division Admin UI

- [ ] **School list** — all schools in the division with per-school
  usage metrics: active teachers, total sessions, storage used
- [ ] **Per-school drill-down** — click into a school to see the same
  view a School Admin sees, without being able to see individual teacher
  session details
- [ ] **Invite school admin** — enter email and school name, sends
  invitation
- [ ] **Division-wide usage report** — total assessments delivered across
  all schools, active teachers, overall completion rate, storage consumed
- [ ] **Assessment window chart** — usage over time as a simple line
  chart. Shows spikes during provincial assessment periods — compelling
  visual for demonstrating adoption to a superintendent or board.
- [ ] **Active teachers report** — how many teachers have uploaded at
  least one assessment in the current school year
- [ ] **Export division report as CSV** — suitable for board reporting
  or budget justification

---

### Tier Badge & Upgrade Prompts (teacher dashboard)

- [ ] **Tier badge** — visible in dashboard header: "Free", "Teacher
  Premium", "School Plan", "Division Plan"
- [ ] **Upgrade CTA for free tier** — when approaching or at limit,
  show: "Your school isn't on a plan yet. Ask your principal about
  AudioProctor for your school." with a link to the pricing page
- [ ] **School/Division plan confirmation** — if on inherited plan, show
  "Your [school/division] is on a plan" instead of an upgrade prompt
.

---

### Privacy Policy Update

- [ ] Update Privacy Policy to document session event collection:
  what is recorded, what is not, how long it is retained, and that
  no student identity is captured at any level.

---
---


## Stage 5 — Administration & Tiers (Revised)
*The hierarchy that makes a division demo compelling and a school purchase practical.*

---

### Tier Structure

Three purchasable tiers, each cascading down to the levels below it.

| Tier | Who buys it | How they pay | Who it covers |
|---|---|---|---|
| **Free** | Individual teacher (default) | Nothing | That teacher only |
| **Teacher Premium** | Individual teacher | Credit card, self-serve | That teacher only |
| **School** | Principal or school admin | Credit card or PO | All teachers at that school |
| **Division** | Division office | Invoice or PO | All schools and all teachers in the division |

**Cascade rule:** A Division purchase gives every school in that division School-tier access, which gives every teacher in those schools premium access. A School purchase gives every teacher at that school premium access. A teacher can also upgrade themselves independently if their school or division hasn't purchased.

---

### What Each Tier Unlocks

**Free (default for all new teachers)**
- 1 teacher account
- 3 uploads per calendar month
- 7-day expiry only (no override)
- Randomly assigned exit words and access codes (no customization)
- No analytics — sessions run but no data is visible to the teacher
- Upgrade prompt when limits are reached: "Your school isn't on a plan yet. Ask your principal about AudioProctor for your school."
- Rationale: generous enough to evaluate the product and run real assessments, limited enough that any teacher using it seriously for more than one class will hit the ceiling naturally during assessment season

**Teacher Premium — ~$75 CAD/year**
- Unlimited active uploads
- Extended and manual expiry override
- Custom exit words and access code options
- Basic session analytics and CSV export
- For teachers whose school or division hasn't purchased, but who want full access independently

**School — ~$200 CAD/year**
- All Teacher Premium features for every teacher at the school
- School admin role (principal or designate)
- Teacher management — invite and remove teachers by email
- School-wide usage report
- Single invoice or credit card payment at the school level
- Intended for schools spending from their own minibudget

**Division — Annual contract, priced by enrolment**
- All School features for every school in the division
- Division admin role
- School grouping and per-school usage reports
- Division-wide usage report
- Teacher management delegated to school admins or managed centrally
- Custom subdomain
- Priority support and onboarding call
- Priced by enrolment band (see Pricing Tiers section)

---

### Account Hierarchy
```
Platform Admin (Adam)
└── Division Admin (division office staff)
    └── School Admin (principal or LAC coordinator)
        └── Teacher
```

- A teacher can belong to a school, or be unattached (independent)
- A school can belong to a division, or be independent
- Tier is inherited downward — a division purchase trickles down automatically
- A teacher or school can purchase upward independently if their parent org hasn't

**Detach and fallback rule:** When a teacher is detached from a school,
or a school is detached from a division, the detached account immediately
reverts to free tier. No grace period — quota enforcement kicks in on
the next upload attempt. Existing uploads are preserved and remain
accessible until they expire normally. If a teacher was on an inherited
School or Division plan and had more than 3 uploads active, those uploads
continue to function until expiry but no new uploads are permitted beyond
the free tier limit. The teacher is notified by email at the moment of
detachment that their tier has changed.

### Teacher Analytics

- [ ] **Per-upload summary card** — visible on each upload in the
  dashboard: "Used 24 times · 18 completed · 6 exited early · 
  Avg listen time 14:32"
- [ ] **Completion rate indicator** — simple visual (green/yellow/red)
  showing percentage of sessions that reached end of audio
- [ ] **Replay signal** — "Audio was replayed from the beginning 9 times"
- [ ] **Timeline view** — when during the audio did most pauses and
  replays occur, shown as a simple bar chart. Helps identify whether a
  specific passage caused difficulty.
- [ ] **Teacher "Insights" tab** — aggregated across all of a teacher's
  uploads: total sessions delivered, total completions, most-used
  assessments
- [ ] **Export session data as CSV** — one row per session event,
  suitable for teacher records or IEP review documentation

---

### School Admin UI

- [ ] **Teacher list** — all teachers at the school with upload count,
  session count, last active date
- [ ] **Invite teacher** — enter email, sends invitation, teacher lands
  in dashboard already attached to the school on first login
- [ ] **Remove teacher** — detaches teacher from school (preserves their
  uploads and account)
- [ ] **School-wide usage report** — total assessments delivered, active
  teachers, storage used, session completion rate
- [ ] **Billing status** — current tier, renewal date, payment method
  (if school purchased independently)


### Division Admin UI

- [ ] **School list** — all schools in the division with per-school
  usage metrics: active teachers, total sessions, storage used
- [ ] **Per-school drill-down** — click into a school to see the same
  view a School Admin sees, without being able to see individual teacher
  session details
- [ ] **Invite school admin** — enter email and school name, sends
  invitation
- [ ] **Division-wide usage report** — total assessments delivered across
  all schools, active teachers, overall completion rate, storage consumed
- [ ] **Assessment window chart** — usage over time as a simple line
  chart. Shows spikes during provincial assessment periods — compelling
  visual for demonstrating adoption to a superintendent or board.
- [ ] **Active teachers report** — how many teachers have uploaded at
  least one assessment in the current school year
- [ ] **Export division report as CSV** — suitable for board reporting
  or budget justification

---

### Tier Badge & Upgrade Prompts (teacher dashboard)

- [ ] **Tier badge** — visible in dashboard header: "Free", "Teacher
  Premium", "School Plan", "Division Plan"
- [ ] **Upgrade CTA for free tier** — when approaching or at limit,
  show: "Your school isn't on a plan yet. Ask your principal about
  AudioProctor for your school." with a link to the pricing page
- [ ] **School/Division plan confirmation** — if on inherited plan, show
  "Your [school/division] is on a plan" instead of an upgrade prompt

  ### Teacher Settings Page (`/dashboard/settings`)

- [ ] **Profile section** — display name (editable), email address
  (read-only, sourced from Google), school and division affiliation
  (read-only, set by admin)
- [ ] **Subscription section** — shows current tier and how it was
  acquired:
  - "You're on the Free tier" — with upgrade CTA linking to pricing page
  - "You're on Teacher Premium — renews [date]" — with manage/cancel
    placeholder (Stripe not yet connected; show "Contact us to manage
    your subscription" linking to hello@audioproctor.com for now)
  - "Your school is on a School plan" — read-only, no action available
  - "Your division is on a Division plan" — read-only, no action available
- [ ] **Delete account section** — clearly separated from the rest of
  the page, below a visual divider. Two-step confirmation: first click
  shows a warning ("This will permanently delete your account and all
  uploaded files. Access codes will stop working immediately."), second
  click requires typing "DELETE" to confirm. On confirmation:
  - All uploads and storage files are deleted immediately
  - All session_events associated with their uploads are deleted
  - The profiles row is deleted
  - The auth.users record is deleted via Supabase admin API
  - Teacher is signed out and redirected to the marketing site
  - If teacher is a School Admin, deletion is blocked until they
    reassign or relinquish the admin role first

## Stage 6 
### Chrome Web Store

- [ ] **Publish extension to Chrome Web Store** — unlisted initially (discoverable only
  by direct link). This eliminates manual sideloading for IT admins — they reference
  the Store ID in Google Admin Console policy instead of uploading a .crx file.
  Unlisted means you control who finds it while still getting the deployment benefits.
- [ ] **Public listing** — once the product is stable and FSD38 pilot is complete,
  make the listing public. Organic discovery from Alberta IT admins searching the
  Store is free marketing.
- [ ] **Store listing assets** — branded screenshots, a short demo video (screen
  recording of the teacher upload flow and student player), and a concise description
  written for IT admins, not teachers.

---

### Google Admin Deployment

- [ ] **IT deployment guide (PDF)** — a short, step-by-step document for Google Workspace
  admins covering: force-installing the extension by Store ID, scoping it to student
  OUs, setting any managed extension policies. Written for someone who administers
  Chromebooks but has never heard of AudioProctor. Offered as a download on the
  marketing site and sent automatically on division signup.
- [ ] **Managed extension configuration** — define any policy schema the extension
  accepts (e.g. pre-configured division ID so the extension knows which division it
  belongs to without the teacher typing anything). Makes division-wide deployment
  truly zero-touch for teachers.
- [ ] **Google Workspace Marketplace listing (stretch goal)** — makes AudioProctor
  discoverable to Google Workspace admins directly inside their Admin Console.
  Higher bar to publish but significantly increases visibility with exactly the right
  audience.

---

### Self-Serve Signup & Access Control

- [ ] **Teacher request flow** — instead of open signup, teachers submit a request
  (name, email, school, division). Request lands in the platform admin dashboard
  and triggers a notification email to you. You approve or assign them to an
  existing division. Prevents random signups from outside Alberta.
- [ ] **Division admin approval flow** — once a division is on a paid plan, their
  Division Admin receives and approves teacher requests without your involvement.
  You only handle unattached requests.
- [ ] **Email invite flow** — Division and School Admins can invite teachers directly
  by email. Invited teacher clicks link, signs in with Google, lands in the dashboard
  already attached to the correct school. No request approval needed for invited teachers.
- [ ] **Domain restriction** — optionally lock a division's account to a specific
  email domain (e.g. `@fsd38.ab.ca`) so only staff from that division can join,
  even if someone shares an invite link externally.

---

### Billing

- [ ] **Stripe integration** — annual invoicing via Stripe. On division signup,
  generate a Stripe invoice for the correct enrolment band. Division pays by
  credit card or requests a PO (Stripe supports both). On payment, tier is
  automatically upgraded in the database.
- [ ] **Manual override preserved** — platform admin can still manually flip tiers
  for pilot customers, multi-year deals, or edge cases without going through Stripe.
- [ ] **Renewal reminders** — automated email 60 and 30 days before contract renewal.
  Sent to Division Admin. Includes usage summary for the year (total sessions,
  active teachers, storage used) — gives them the data to justify renewal to their
  superintendent before you even ask.
- [ ] **School tier billing** — credit card only via Stripe. School Admin enters card
  details, billed annually. If their division later signs a division contract, a
  prorated credit is applied automatically.
- [ ] **Free tier enforcement** — automated downgrade if a paid account lapses. 
  Teacher data and uploads are preserved for 30 days post-expiry before deletion,
  giving time to resolve payment issues without losing work.

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

- [ ] **Formal pilot agreement (one page)** — covers: free access for one school for a length of time,
  commitment to provide structured feedback at 30/90/180 days, written testimonial
  on completion, right for AudioProctor to reference the division by name in marketing.
  Simple enough to be approved without legal review.
- [ ] **Feedback survey (30/90/180 day)** — three short surveys sent automatically.
  Questions focus on: which assessments it was used for, how many students, what
  worked, what didn't, what would make them recommend it to another division.
- [ ] **Pilot completion report** — auto-generated PDF summarizing the division's
  usage over the pilot year: total sessions, unique assessments delivered, active
  teachers, estimated hours of accommodation support provided. Handed to the Division
  Admin as a record and used by you as a sales asset for the next division conversation.


---

## Parking Lot
*Interesting ideas that need more thought before committing to.*

- Video file support (MP4) for ASL interpretation tracks
- Offline mode — pre-download audio to the extension for no-internet testing environments
- Student accessibility options in the player (high contrast mode, larger text)
- Integration with Vretta or other provincial assessment platforms directly
- iOS/Android companion app for teachers to share codes and monitor sessions


---

### Pricing Tiers
*Reference model for when billing is implemented in Stage 6.*

**Free — Individual Teacher**
- 1 teacher account
- 3 uploads per calendar month
- 7-day expiry only (no override)
- Randomly assigned exit words and access codes (no customization)
- No analytics
- Purpose: gives teachers enough to run real assessments and champion
  the product internally before a school or division decision is made

**Teacher Premium — $75 CAD/year**
- 1 teacher account
- Unlimited uploads
- Extended and manual expiry override
- Custom exit words and access code options
- Basic session analytics and CSV export
- For teachers whose school or division hasn't purchased, but who want
  full access independently

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
- Division-wide usage reports
- Custom subdomain
- Priority support and onboarding call
- Single annual invoice to the division office

| Division Size | Enrolled Students | Annual Price (CAD) | Example |
|---|---|---|---|
| Small | Under 2,000 | $800 | Most rural Alberta divisions |
| Medium | 2,000–8,000 | $1,500 | Foothills SD, Rocky View SD |
| Large | 8,000–25,000 | $3,000 | Red Deer Public, Lethbridge SD |
| Metro | 25,000+ | $6,000 | Edmonton Public, Calgary Board |

*Enrolment figures from Alberta Education's annual school authority report.*

**Pricing rationale:** Cost scales with the scope of the purchase, not
the number of features used. Every tier gets the same core functionality.
A metro division pays more than a rural division because the contract
covers more teachers, more schools, and more Chromebooks — not because
they get a different product. Individual teachers and schools can purchase
independently; a division contract makes the most sense when IT is
deploying to all Chromebooks at once.

**Pilot program:** Offered selectively to early divisions — free for one
full school year in exchange for structured feedback and a written
testimonial. Managed manually through the platform admin dashboard.
Not advertised publicly.

---

## Marketing Site — Pricing Communication
*How the pricing model should be framed consistently across the marketing site.*

- **Home page** — Pricing section after the "Why AudioProctor" columns.
  Four cards: Free, Teacher Premium, School, Division (with enrolment
  table). Section headline: "Pricing that fits how schools actually work."
  Subhead: "Whether you're a single teacher, a school spending from a
  minibudget, or a division deploying to every Chromebook at once —
  there's a tier for how you actually make decisions." CTA on Free card:
  "Sign in to get started." CTA on Teacher Premium and School: "Request
  a quote" → /contact until Stripe is live. CTA on Division: "Request a
  pilot" → /contact. Footer line below cards: "All prices in CAD. Division
  pricing is by annual invoice. Teacher Premium and School tiers are
  self-serve via credit card (coming soon — contact us to purchase in the
  meantime)."

- **Use Cases page** — one-line pricing callout on each card: Provincial
  Assessment card: no pricing mention, focus on credibility. Small School
  card: "Free tier covers it — no infrastructure required." Division
  Rollout card: "Division tier — IT deploys once, every school has it."

- **About page** — short paragraph explaining the pricing philosophy:
  AudioProctor is priced by the scope of the purchase. A teacher can sign
  up free. A school can buy a plan from their minibudget. A division can
  sign one contract that covers every school, every teacher, and every
  Chromebook. The price scales with how much of the organization is
  covered, not with how many features are unlocked.

- **Contact / Demo Request form** — add a Division Enrolment dropdown so
  leads self-segment on arrival: Individual teacher / Under 2,000 students
  / 2,000–8,000 / 8,000–25,000 / 25,000+. Every demo request arrives
  pre-qualified for the correct pricing band before you reply.

- **Privacy Policy and Terms of Service** — no pricing mention needed.
