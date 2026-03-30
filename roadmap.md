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

- [x] **Rate limiting on the session API** — prevent brute-force guessing of access codes
- [ ] **Domain restriction on Google login** — optionally limit sign-in to a specific school email domain (e.g. `@yourschool.ca`)
- [x] **Signed URL refresh** — if a student's session expires mid-test (>1 hour), show a graceful error rather than silent failure
- [ ] Supabase backups enabled and confirmed
- [x] **Enforce free tier upload limits server-side** — limit free tier
  teachers to 3 uploads per calendar month. This must be enforced in the
  API, not just the UI, so it cannot be bypassed by calling the upload
  endpoint directly.

  Implementation:
  - Before accepting any upload, the API route checks how many rows exist
    in the `uploads` table WHERE `teacher_id = auth.uid()` AND
    `created_at >= date_trunc('month', now())`. If count >= 3 and the
    teacher has no active paid tier, return HTTP 403 with a clear error
    message.
  - Add a Supabase database function `check_upload_quota()` that performs
    this count and returns a boolean — call it from the upload API route
    before writing anything to storage.
  - The UI should also check quota before showing the upload button and
    display a friendly gate ("You've used 3 of 3 uploads this month"),
    but the server-side check is the real enforcement.

  Abuse prevention:
  - Add a `profiles` table (or extend existing teacher record) with
    `country_code` populated from the Accept-Language header or a
    lightweight IP geolocation lookup on first login. Flag non-Canadian
    accounts for review — AudioProctor is an Alberta product and
    international signups are anomalous. US signups are also welcome.
  - Add a honeypot field to the sign-up flow. Consider requiring a school
    division name on first login — a required text field costs a legitimate
    user nothing but raises friction for automated signups.
  - Rate limit the upload API endpoint per `teacher_id` — max 10 requests
    per hour regardless of tier, to prevent automated abuse.
  - Add a `storage_used_mb` running total to the teacher profile, updated
    on each upload and delete. Free tier cap: 50MB total storage. This
    catches someone who deletes and re-uploads to reset their monthly
    count while still accumulating storage. **Note:** `storage_used_mb`
    is now tracked (Stage 2), but the 50MB hard cap is not yet enforced
    — a free tier teacher can currently upload 3 large files per month
    and accumulate real storage. Enforce the cap as a follow-up: check
    `storage_used_mb + file.size / 1024 / 1024 <= 50` in `handleUpload()`
    before uploading, and block in the RLS policy via a second condition
    in `check_upload_quota()`. Audio normalization (Stage 1 deferred)
    will reduce the practical risk once it ships.
  - Monitor the `uploads` table weekly for anomalous patterns — many
    uploads from a single account, large file sizes, non-.mp3 extensions
    that slipped through.
  - [x] **Free tier quota indicator in the dashboard UI** — show a persistent
  "X of 3 uploads used this month" indicator on the dashboard for free
  tier teachers. Resets visually on the first of each month. When the
  limit is reached, replace the upload button with a friendly gate:
  "You've used all 3 uploads for this month. Upgrade for unlimited
  uploads, or your quota resets on [date]." Include a link to the
  pricing section of the marketing site.
  - [x] **Update marketing site copy to reflect correct free tier limits** —
  the free tier was changed from "5 active uploads at a time" to "3
  uploads per calendar month." Find and update every reference across the
  site:

  Known locations:
  - Homepage pricing card — "5 active uploads at a time" → "3 uploads per
    month"
  - Any tooltip, help text, or onboarding copy that references upload
    limits

  Audit instructions for Claude Code:
  - Search the entire codebase for "5 active", "5 uploads", "active
    uploads", and "at a time" — replace any free tier references found
  - Search for "7-day" to confirm expiry copy is consistent across
    homepage, use cases, FAQ, and dashboard
  - Search for "FOIP" — replace with "ATIA" everywhere except where both
    are referenced together for context. The privacy page is the known
    location but check all pages
  - Search for "free for one year" and "first division" — remove or revise
    the pilot program offer from the contact page (pilot program remains
    available but should not be advertised publicly at this stage)
  - After changes, do a final pass reading every page as a first-time
    visitor and flag any copy that contradicts the pricing tiers section
    of the roadmap

---

## Stage 3 — Teacher Customization
*Give teachers control without adding complexity.*

- [ ] **Custom exit word** — teacher can type their own exit word instead of the randomly assigned one
- [ ] **Exit word complexity options** — choose between: short word (default), long word, two-word phrase, numeric PIN
- [ ] **Access code complexity options** — choose between: standard (`ABC-123`), short 4-char (`AB12`), or a custom code the teacher sets themselves
- [ ] **Rename uploads** — edit the display label after uploading
- [ ] **Extend expiry** — reset the 7-day clock on an upload without re-uploading the file
- [ ] **Manual expiry override** — set a specific expiry date/time instead of always 7 days
- [ ] Duplicate an upload (generates a new code for the same audio file)

---

## Stage 4 — Analytics & Playback Tracking
*Useful data for teachers; a compelling feature for division admins.*

The analytics layer serves two audiences with different needs: teachers want to know
if students completed the audio; division admins want to demonstrate that accommodation
obligations are being met at scale. Both needs are served by the same event log —
just presented at different levels of aggregation.

No student identity is ever recorded. All events are anonymous by design.

---

### Database Changes

- [ ] **`session_events` table** — access_code_id, event_type, occurred_at, metadata (JSONB)
  - Event types: `code_entered`, `playback_started`, `playback_paused`, `playback_resumed`,
  `playback_completed`, `replay_triggered`, `exit_word_used`, `session_expired`
  - Metadata captures position_seconds on pause/resume/replay events — no student identity,
  no device fingerprint, no IP address
- [ ] **`upload_summaries` materialized view** — aggregates session_events per upload:
  total sessions, completions, early exits, average listen time, replay count.
  Refreshed on a schedule rather than computed on every dashboard load.

---

### Teacher-Level Analytics

- [ ] **Per-upload summary card** — visible on each upload in the dashboard:
  "Used 24 times · 18 completed · 6 exited early · Average listen time 14:32"
- [ ] **Completion rate indicator** — simple visual (green/yellow/red) showing what
  percentage of sessions reached the end of the audio
- [ ] **Replay signal** — "Audio was replayed from the beginning 9 times" — useful
  for identifying passages students found difficult
- [ ] **Timeline view** — when during the audio did most pauses and replays occur,
  shown as a simple bar graph over the waveform. Helps teachers identify whether
  a specific question or passage caused difficulty.
- [ ] **Teacher dashboard "Insights" tab** — aggregated view across all of a teacher's
  uploads: total sessions delivered, total completions, most-used assessments
- [ ] **Export session data as CSV** — one row per session event, suitable for teacher
  records or inclusion in an IEP review

---

### Division Admin Analytics

- [ ] **Division-wide summary** — total assessments delivered across all schools,
  total sessions, overall completion rate, storage consumed
- [ ] **Per-school breakdown** — same metrics grouped by school, sortable by usage.
  Lets a division admin see which schools are actively using the tool and which
  haven't started yet.
- [ ] **Active teachers report** — how many teachers have uploaded at least one
  assessment in the current school year
- [ ] **Assessment window report** — usage over time shown as a simple line chart.
  Naturally shows spikes during provincial assessment periods — a compelling visual
  for demonstrating adoption to a superintendent or board.
- [ ] **Export division report as CSV** — suitable for board reporting or budget
  justification documents

---

### Privacy Boundaries

- [ ] All analytics are aggregate only at the division admin level — no drill-down
  to individual session events from the division view
- [ ] Session events contain no student identity, device fingerprint, or IP address
  at any level
- [ ] Teachers can only see analytics for their own uploads
- [ ] Analytics data is retained for the duration of the division's active contract,
  then deleted on account closure
- [ ] Privacy Policy updated to document session event collection and retention policy

---

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

---

### Platform Admin Dashboard (`/admin` — Adam only)

- List all divisions, schools, and unattached teachers
- See tier, enrolment band, expiry date, and usage for each
- Manually set or override tier for any account (for pilots, trials, invoiced deals)
- Invite a division admin or school admin by email
- Flag an account for follow-up (e.g. "demo requested", "invoice sent")
- No Stripe required for early pilots — Adam flips tiers manually until billing is built

---

### Division Admin Dashboard (Division tier only)

- List all schools in the division and their usage
- Invite or remove school admins by email
- Division-wide usage report — total uploads, storage used, active teachers
- View billing status and renewal date

---

### School Admin Dashboard (School tier and above)

- List all teachers at the school
- Invite or remove teachers by email
- School-wide usage report
- View and manage billing if school purchased independently

---

### Teacher Dashboard Additions

- Tier badge visible in the dashboard — "Free", "Premium", "School Plan", "Division Plan"
- Soft gates when approaching free tier limits — friendly prompt, not a hard block
- Upgrade CTA for free tier teachers — self-serve Teacher Premium via Stripe (Stage 6)
- If on School or Division plan, show "Your school/division is on a plan" instead of an upgrade prompt

---

### Database Changes Required

- `divisions` table — name, enrolment_band, tier, admin_email, expires_at
- `schools` table — name, division_id (nullable), tier, admin_email, expires_at
- `teacher_profiles` table — user_id, school_id (nullable), division_id (nullable), tier_override
- Effective tier resolution: division tier → school tier → teacher tier → free (first match wins)
- `invitations` table — email, role, school_id, division_id, token, accepted_at
- **Note on `ensureProfile()` (from Stage 2):** The current implementation writes a `profiles` row
  once on first login and reads `tier` directly from it. When inherited tier resolution is
  implemented here, `ensureProfile()` (in `js/auth.js`) must be replaced with a function that
  resolves effective tier at runtime — checking division → school → teacher tier in order — so a
  teacher whose school just upgraded gets the correct quota immediately, without waiting for a manual
  profile update. Consider a DB function `get_effective_tier(user_id)` that performs this resolution
  server-side, called from both the dashboard and any quota-checking RLS policy.

---

### Billing Notes (implement in Stage 6)

- Teacher Premium: Stripe self-serve, annual subscription
- School tier: Stripe checkout or manual invoice, annual
- Division tier: manual invoice for now — division procurement rarely works through self-serve checkout
- All prices in CAD
- Early pilot divisions: manually set to Division tier with no billing until renewal

## Stage 6 — Distribution & Monetization
*Turning it into a real product.*

The goal of Stage 6 is to remove every manual step from the sales and onboarding
process so that a division can go from "heard about it" to "deployed across all
Chromebooks" without requiring your direct involvement at each step. Early customers
will be onboarded manually — that's fine and expected. This stage systematizes what
you've already learned from those early conversations.

---

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

## Pricing Tiers
*Reference model for when billing is implemented in Stage 6.*

**Free — Individual Teacher**
- 1 teacher account
- 5 active uploads at a time
- 7-day expiry only (no override)
- Randomly assigned exit words and access codes (no customization)
- No analytics
- Purpose: gives teachers enough to champion the product internally before a division decision is made

**Division — Annual Contract, Priced by Enrolment**
- Unlimited teacher accounts across all schools in the division
- All features across all stages
- Division admin role, school grouping, usage reports
- Priority support and onboarding call
- Single annual invoice to the division office

| Division Size | Enrolled Students | Annual Price (CAD) | Example |
|---|---|---|---|
| Small | Under 2,000 | $800 | Most rural Alberta divisions |
| Medium | 2,000–8,000 | $1,500 | Foothills SD, Rocky View SD |
| Large | 8,000–25,000 | $3,000 | Red Deer Public, Lethbridge SD |
| Metro | 25,000+ | $6,000 | Edmonton Public, Calgary Board |

*Enrolment figures from Alberta Education's annual school authority report.*

**Pricing rationale:** Cost scales with the number of assessed students, not the number of features
used. A metro division gets identical functionality to a small rural division — the price difference
reflects load, support overhead, and the administrative value of a single division-wide contract
covering hundreds of teachers and thousands of Chromebooks. Individual school purchases are not
offered; the division tier is the only paid option.

**Pilot program:** First division signs free for one full school year in exchange for structured
feedback and a written testimonial. Converts to paid at renewal.

---

## Marketing Site — Pricing Communication
*How the pricing model should be framed consistently across the marketing site.*

- **Home page** — include a Pricing section after the "Why AudioProctor" columns. Two cards: Free tier and Division tier with the enrolment table. Headline: "One price. The whole division." Sets the expectation that AudioProctor sells to divisions, not individual teachers.

- **Use Cases page** — add a one-line pricing callout to each use case card: small school card gets "Free tier — one teacher, no commitment." Division rollout card gets "Division tier — IT deploys once, every school has it." Provincial assessment card omits pricing, focuses on credibility.

- **About page** — include a short paragraph explaining the pricing philosophy in plain language: AudioProctor is priced by division enrolment, not by feature tier. A small rural division pays less than a metro division not because they get less, but because the price reflects the scale of what's being covered.

- **Contact / Demo Request form** — add a Division Enrolment dropdown so leads self-segment on arrival: Under 2,000 students / 2,000–8,000 / 8,000–25,000 / 25,000+ / Just exploring or individual teacher. This means every demo request arrives pre-qualified for the correct pricing band.

- **Privacy Policy and Terms of Service** — no pricing mention needed.