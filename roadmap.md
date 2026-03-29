# AudioProctor — Product Roadmap

A rough sequence of improvements, from "working MVP" to "something a division would pay for."

---

## Stage 1 — Polish the MVP
*Make it feel finished before anyone else sees it.*

- [ ] Proper extension icons (branded, not placeholders)
- [ ] Friendly onboarding on first login ("Upload your first assessment to get started")
- [ ] Better upload progress — show a real progress bar for large files
- [ ] Handle duplicate filenames gracefully in the dashboard
- [ ] Add a label/title field to uploads so teachers can name them ("Grade 4 Reading Assessment - May")
- [ ] Responsive dashboard for teachers on phones/tablets
- [ ] Test on an actual managed Chromebook end-to-end

---

## Stage 2 — Security & Reliability
*Build the foundation of trust before pitching to anyone in a school.*

- [ ] **Rate limiting on the session API** — prevent brute-force guessing of access codes
- [ ] **Domain restriction on Google login** — optionally limit sign-in to a specific school email domain (e.g. `@yourschool.ca`)
- [ ] **Signed URL refresh** — if a student's session expires mid-test (>1 hour), show a graceful error rather than silent failure
- [ ] **FOIP/PIPEDA compliance note** — document that no student personally identifiable information is stored (no names, no student IDs, no login)
- [ ] **Audit log** — record when each access code was used (timestamp + rough geographic region, no student identity)
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
