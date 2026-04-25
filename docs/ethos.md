# The AudioProctor Ethos

*How a tool for locked-down audio accommodation should think about itself.*

---

## 1. The problem is not theoretical

In Alberta, students with IEPs and designated accommodations are entitled to audio support during provincial assessments. The delivery platform provides the assessment in a browser. It does not provide the audio. Teachers are left to improvise: another adult reading aloud, a screen reader mispronouncing content, or hardware that may or may not still work. The gap is not a missing feature. It is a missing layer.

AudioProctor exists because that gap is encountered in real rooms, with real students, under real time pressure. It was not conceived in a pitch competition. It was built by an IT administrator inside an Alberta school division who needed it to exist.

---

## 2. Privacy is structural, not promotional

Most ed-tech products collect student data and then promise to protect it. AudioProctor removes the opportunity entirely.

- No student accounts.
- No student names, IDs, ASN numbers, or device fingerprints.
- No IP addresses logged during sessions.
- No third-party analytics on student activity.

Session events are anonymous by design — not anonymized after collection, but never tied to an identity in the first place. Teachers see aggregate completion rates. Division admins see school-level summaries. No one sees which student did what, because that information was never written down.

This is not a marketing stance. It is a schema decision.

---

## 3. Simplicity is a deliberate constraint

AudioProctor is built with vanilla HTML, CSS, and JavaScript. No React. No Next.js. No build step. The stack is chosen not out of nostalgia but out of clarity: the codebase should remain understandable by a single person, and it should stay that way as it grows.

Complexity is not a sign of sophistication. In infrastructure that supports students with accommodations, complexity is a liability. A locked audio player that fails during an assessment because of a framework upgrade is worse than no player at all.

The same principle applies to the user experience:
- Teachers upload an MP3 and get a six-character code.
- Students enter the code and listen.
- The teacher says an exit word; the student types it; the lock releases.

Three steps. No training required. No manual to misplace.

---

## 4. Trust through transparency

AudioProctor does not claim to do more than it does. It does not replace assessment platforms. It does not grade students. It does not generate reports for administrators. It plays audio in a locked window and then gets out of the way.

This honesty extends to pricing:
- Cost scales with the scope of the purchase, not the number of features.
- A single teacher can use it free.
- A school can buy from its minibudget.
- A division can sign one contract covering every Chromebook.

Every tier receives the same product. A metro division pays more than a rural division because the contract covers more teachers and more schools — not because they unlock a better dashboard.

---

## 5. Built from the inside

The most important credential AudioProctor has is not technical. It is institutional memory. The tool was designed around what actually happens in Alberta schools:
- IT departments deploy software via Google Admin Console, not by asking teachers to install things.
- Accommodations are governed by IEPs that teachers cannot alter on short notice.
- Assessment windows are fixed. A tool that requires setup on the day of the test is a tool that fails.
- Privacy law (FOIP in Alberta) is not a checkbox. It shapes what you are allowed to build.

This means the product speaks the language of its users. The IT deployment guide is written for Google Workspace admins. The privacy policy references FOIP specifically. The pricing model assumes school minibudgets and division-level procurement cycles. These are not generic ed-tech conventions adapted after the fact. They are the foundation.

---

## 6. The design is the argument

AudioProctor looks like a well-typeset government report, not a startup landing page. The design system is editorial: Playfair Display headlines, DM Sans body text, a warm paper background, and a single red accent. No border-radius. No box-shadow. No icons except an em-dash for list bullets. Structure comes from borders and grid, not from color blocks or gradients.

This is not aesthetic preference alone. It signals something to the user: this is infrastructure, not entertainment. It should feel as serious as the assessment it supports. The visual calm is part of the accessibility promise — a frantic interface has no place in a room where a student is already managing a reading disability under test conditions.

---

## 7. How it can be done

The path from "tool that works" to "product a division would pay for" is staged, not rushed. Each stage builds the foundation for the next.

### Stage 1 — Make it feel finished
Polish the details that make an MVP feel like a product: branded extension icons, a real upload progress bar, duplicate filename handling, and human-readable labels. Test end-to-end on a managed Chromebook. If it fails there, it fails everywhere that matters.

### Stage 2 — Earn trust
Add rate limiting, signed URL refresh, quota enforcement at the database layer, and abuse prevention (honeypots, profile enrichment, upload rate limits). These are invisible to legitimate users and fatal to bad actors. A division IT director will ask about them. Have answers before they ask.

### Stage 3 — Give teachers control, not complexity
Custom exit words, access code formats, rename, extend, duplicate. Every feature must pass the test: does this help a teacher under time pressure, or does it add another decision to make? If it adds decisions, it does not ship.

### Stage 4 — Build the data layer
Analytics without student identity. An account hierarchy (divisions, schools, teachers) with inherited tiers. An audit log. An invitation system. A platform admin dashboard. All of this is scaffolding for the organization to operate at scale without manual intervention.

### Stage 5 — Surface the right data to the right person
Teachers see per-upload completion rates. School admins see school-wide usage. Division admins see twelve-week activity charts. Platform admins see anomaly queues. No one sees data outside their scope. Privacy boundaries are enforced at the API and schema level, not by convention.

### Stage 6 — Remove every manual step
The goal is that a division can move from "heard about it" to "deployed on every Chromebook" without a meeting at each step. Chrome Web Store publication, Google Admin deployment, self-serve billing, onboarding email sequences, and renewal reminders. Early customers are onboarded manually — that is expected and valuable. Stage 6 systematizes what was learned from those conversations.

---

## 8. What will not change

Some decisions are not up for negotiation, regardless of growth stage:

- **Student anonymity is non-negotiable.** No feature will ever require a student to identify themselves.
- **No framework lock-in.** The codebase stays vanilla and readable.
- **No feature bloat.** AudioProctor plays audio in a locked window. It does not become a learning management system, a proctoring service, or an analytics platform for student behaviour.
- **No dark patterns.** Free tier limits are enforced server-side and communicated clearly. Upgrade prompts are honest about what changes and what does not.
- **Alberta-first, not Alberta-only.** The architecture works anywhere, but the product decisions are grounded in Alberta's assessment structure, privacy law, and procurement reality. Expansion to other provinces or countries happens by understanding their equivalent structures, not by slapping a new logo on the same page.

---

## 9. The measure of success

AudioProctor is successful when a teacher who has never used it before can upload an audio file, hand a code to a student, and have the accommodation running in under two minutes — without calling IT, without filling out a form, and without worrying about whether student data is being collected.

It is successful when a division administrator can demonstrate that accommodation obligations were met across all schools, with data, without ever knowing which individual student used which code.

It is successful when the person who built it can step away for a month and the system keeps running — not because it is over-engineered, but because it is simple enough to be reliable.

---

*AudioProctor is infrastructure for a specific kind of fairness: the kind that happens in a quiet room, during an assessment, when a student who needs audio support finally has a tool that just works.*
