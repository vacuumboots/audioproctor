# AudioProctor — Top 5 Improvements

*Written April 19, 2026. Based on current codebase, recent commits, and the Stage 6 goal:
remove every manual step between "heard about it" and "deployed across all Chromebooks."*

---

## Assessment of recent commits

The last few months of work are well-targeted. The Chrome OS lockdown milestone
(`4a5d42e`) validated the core product. The security hardening pass was appropriate
pre-pilot. Stripe billing (`d908f7b`) unblocks self-serve Teacher Premium sales. Exit
word persistence is a small but real quality-of-life win for teachers.

The gap: all of that work is on the product side. The distribution side — how a
division goes from "heard about it" to "every Chromebook has it" — is almost entirely
unbuilt.

---

## 1. Wire up email delivery

**What's missing:** The `invitations` table, token generation, and Resend configuration
all exist. No email is actually sent. Teacher invitations, onboarding sequences, and
renewal reminders are all blocked on this.

**Why it matters most:** Email is the connective tissue between every other Stage 6
goal. Without it, there's no self-serve onboarding, no drip sequence to convert free
teachers into division conversations, and no renewal reminders to justify the next
contract. The infrastructure is already paid for (Resend). This is a wiring problem.

**What to build:**
- `api/accept-invite.js` — validates token, attaches teacher to org, redirects to dashboard
- Trigger email on invitation creation (platform admin creates invite → email fires)
- Day-0 welcome email for new teachers (triggered on first `ensureProfile()`)
- One onboarding nudge at Day 7 if no upload yet

Start with invitations; onboarding sequences can follow once the delivery path is proven.

---

## 2. Publish the extension to Chrome Web Store

**What's missing:** The extension is deployed by uploading a `.crx` file to Google Admin
Console. Publishing to Chrome Web Store (unlisted) lets IT admins reference a Store ID
instead — standard practice, much lower friction, no manual `.crx` management.

**Why it matters:** IT admins in Alberta school divisions deal with hundreds of extension
deployments. An unlisted Store ID slots into their existing workflow. A `.crx` upload
is a one-off exception that requires extra steps, extra trust, and someone to remember
to re-upload on every update. This is the single highest-leverage reduction in IT
friction before any pilot.

**What to build:**
- Submit extension to Chrome Web Store (unlisted)
- Update all deployment documentation to reference Store ID
- Set up auto-publish workflow so extension updates don't require manual re-upload

---

## ~~3. Add a sign-in link to the marketing site~~ ✓ Done April 19, 2026

"Sign in" link added to `site/nav.js` — appears in desktop and mobile nav on all
marketing pages, pointing to `https://app.audioproctor.com/login.html`.

---

## 4. Build the teacher request / self-serve signup flow

**What's missing:** There is no path for a teacher to self-serve into the product.
Every new teacher currently requires manual platform admin action to create an account
and attach them to an org.

**Why it matters:** The model requires teachers to champion the product upward to their
principal and division. That only works if they can actually use it independently
first — free tier, no friction. Right now a teacher who wants to try it can't without
asking for access. That kills grassroots adoption.

**What to build:**
- Teacher request form: name, email, school, division (pre-qualification, not a wall)
- Request lands in platform admin dashboard with a notification email
- One-click approval sends an invitation email and creates the account
- Prevents arbitrary signups (not open registration) while removing the manual bottleneck

---

## 5. Audio normalization on upload

**What's missing:** Teachers upload whatever MP3 they have. File sizes and bitrates vary
widely. A 45-minute 320kbps stereo file is 100MB+ and provides no quality benefit over
a 32kbps mono file for a spoken-word assessment track.

**Why it matters:** The free tier storage cap (50MB) will hit teachers with normal-sized
recordings sooner than expected. More importantly, inconsistent audio quality is a
credibility problem in a pilot. A division evaluating the product for IEP accommodations
will notice if audio cuts out, loads slowly, or fails on a slow school network. The
normalization plan is fully designed in the roadmap; it's just not built.

**What to build:**
- Supabase Edge Function triggered on storage upload
- `ffmpeg` transcode to 32kbps mono MP3, write to final path, delete staging file
- Show "Processing…" state in dashboard while transcode runs
- Block code generation until transcode completes (codes issued for final path only)

This also makes the storage accounting more predictable: a 45-minute track reliably
costs ~10MB, not 10–150MB depending on source.

---

## Priority order

| # | Improvement | Effort | Impact |
|---|-------------|--------|--------|
| 1 | Wire email delivery | Medium | Unblocks invitations, onboarding, renewals |
| 2 | Chrome Web Store publication | Low | Removes biggest IT friction |
| ~~3~~ | ~~Marketing site sign-in link~~ | ~~Low~~ | ✓ Done |
| 4 | Teacher request/signup flow | Medium | Enables grassroots teacher adoption |
| 5 | Audio normalization | High | Product reliability + storage predictability |

Items 2 and 3 are quick wins that should ship before the first pilot conversation.
Items 1 and 4 together define the self-serve distribution model. Item 5 is higher
effort but becomes more urgent once free-tier teachers start hitting the storage cap.

---

## Bonus quick wins (April 19, 2026)

- [x] Contact form enrolment dropdown — leads now self-segment by division size on arrival
- [x] About page pricing philosophy paragraph — added before "Built by someone in the room"
- [x] Use Cases pricing callouts updated — Provincial Assessment note removed (credibility focus); Small School updated to "Free tier covers it — no infrastructure required."
- [x] roadmap.md — Sign In link in top nav marked done
