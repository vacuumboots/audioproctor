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

- [ ] **Rate limiting on the session API** — prevent brute-force guessing of access codes
- [ ] **Domain restriction on Google login** — optionally limit sign-in to a specific school email domain (e.g. `@yourschool.ca`)
- [ ] **Signed URL refresh** — if a student's session expires mid-test (>1 hour), show a graceful error rather than silent failure
- [ ] Supabase backups enabled and confirmed

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

- [ ] **Session events log** — record when a code is entered, when playback starts, when audio completes, when the exit word is used
- [ ] **Per-upload summary** — "This code was used 24 times. Audio completed 18 times. 6 sessions exited early."
- [ ] **Replay count** — how many times the audio was rewound or replayed from the beginning
- [ ] **Average listen time** — useful signal for test validity
- [ ] **Teacher dashboard "Insights" tab** — simple charts, no third-party analytics services (keeps data in Supabase)
- [ ] Export session data as CSV for teacher records

---

## Stage 5 — Division-Level Features
*What a purchasing decision-maker needs to see.*

- [ ] **Division admin role** — a super-user who can see all teachers and uploads across their division
- [ ] **Teacher management** — admin invites/removes teachers by email, no self-serve sign-up
- [ ] **School grouping** — organize teachers by school within a division
- [ ] **Division-wide usage report** — total assessments delivered, active teachers, storage used
- [ ] **Custom subdomain** — `yourschool.audioproctor.com` with their logo in the top bar
- [ ] **Bulk upload** — upload multiple MP3s at once and generate codes in batch
- [ ] **Google Classroom integration** — surface access codes directly in a Classroom post

---

## Stage 6 — Distribution & Monetization
*Turning it into a real product.*

- [ ] **Chrome Web Store listing** — makes deployment easier (admin still force-installs, but no manual sideloading)
- [ ] **Google Admin deployment guide** — a short PDF schools can follow to set up the extension policy
- [ ] **Self-serve sign-up with email invite** — teachers request access, division admin approves
- [ ] **Subscription billing** — per-division annual pricing via Stripe; free tier for single teachers
- [ ] **Onboarding email sequence** — welcome email with setup checklist for new divisions
- [ ] **Pilot program package** — one division, free for one school year, in exchange for feedback and a testimonial

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