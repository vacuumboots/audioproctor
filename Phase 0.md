Phase 0

Good, that's enough to write a solid brief. Rather than just discussing it, let me produce the actual Claude Code context document — something you can drop straight into your next session.

A couple of things I want to flag before we write it:

**Site vs. app separation** — right now audioproctor.com presumably goes to your dashboard. You'll want the marketing site at `audioproctor.com` and the app moved to `app.audioproctor.com`. That's a Vercel + Supabase redirect config change, worth doing now before you have real users.

**Legal pages** — Privacy Policy and Terms of Service need to be real, not boilerplate. I'll draft those properly based on what we know about your data model, not just generate generic filler. The Privacy Policy in particular can just be the prose version of the document we already wrote.

---

Here's the full site spec:

---

## AudioProctor — Marketing Site Brief

### Architecture

The marketing site lives at `audioproctor.com` as a separate set of static HTML/CSS/JS pages in the same repo, under a `/site` directory. The teacher dashboard app moves to `app.audioproctor.com`. No framework — vanilla HTML consistent with the existing MVP stack. Vercel handles routing: `audioproctor.com` serves `/site/index.html`, `app.audioproctor.com` serves the dashboard.

---

### Design System

- **Fonts:** Playfair Display (headings), DM Sans (body/UI). Load via Google Fonts.
- **Palette:**
  - Background: `#F5F2EB` (warm off-white)
  - Text: `#1A1A1A` (near-black)
  - Accent: `#C0392B` (red)
  - Muted: `#6B6560`
  - White: `#FFFFFF` for cards and contrast sections
- **Tone:** Editorial, calm, institutional. Not startup-flashy. Think a well-designed government report, not a VC pitch deck.
- **Nav:** Simple top bar — logo left, links right (Home, Use Cases, About, Contact). Red CTA button: "Schedule a Demo".

---

### Pages

#### 1. Home (`/`)

**Hero:**
- Headline (Playfair, large): *"Audio accommodation for provincial assessments. Finally."*
- Subhead (DM Sans): Two sentences explaining what it is — a Chrome extension + teacher dashboard that delivers audio support for assessed students without storing any student data.
- Two CTAs: "Schedule a Demo" (red button) and "How it Works" (text link scrolls down)

**How It Works section:**
Three-step horizontal layout:
1. Teacher uploads the audio file and gets an access code
2. Student enters the code in the Chrome extension on their Chromebook
3. Student listens, speaks the exit word, assessment complete

**Why AudioProctor section:**
Three value columns:
- *No student data collected.* Not a policy — a structural guarantee.
- *Deployed by IT, not installed by teachers.* Force-installed via Google Admin Console.
- *Built for Alberta assessments.* Designed around the provincial accommodation gap in Vretta.

**Demo Request CTA section:**
Full-width warm-white band. Headline: *"See it in your division."* Subhead one line. Link to contact form.

---

#### 2. Use Cases (`/use-cases`)

**Intro:** One paragraph framing — AudioProctor is for any assessed student who needs audio support: students with reading disabilities, ELL students in applicable assessments, students with IEPs requiring audio accommodation.

**Three use case cards:**

- **Provincial Assessment Accommodation** — student has an IEP or designation requiring audio support. Teacher uploads the official audio track (or records their own read-aloud). Student uses the extension during the exam window.
- **Small School Flexibility** — schools with only a few accommodation students don't need a full assistive tech infrastructure. One teacher, one upload, done.
- **Division-Wide Rollout** — IT deploys once to all Chromebooks via Google Admin. No teacher installation required. Works across all schools immediately.

**FAQ-style section** at bottom — 4–5 questions:
- Does this work on any Chromebook? (Yes, managed or unmanaged, Chrome OS)
- Do students need accounts? (No, access code only)
- Who can see my uploaded files? (Only you — private storage, authenticated access)
- What happens when the access code expires? (File and code are deleted automatically)
- Is this approved for use in Alberta? (Compliant with FOIP — see Privacy Policy)

---

#### 3. About (`/about`)

Short page. Three sections:

**The Problem** — Alberta provincial assessments like those delivered through Vretta do not natively support audio accommodation. Teachers currently work around this with ad-hoc solutions: another adult in the room reading aloud, screen readers that aren't calibrated for the content, or simply no accommodation at all. This is inconsistent and unsustainable.

**The Solution** — AudioProctor was built to fill that gap. A teacher uploads an audio file, generates an access code, and hands it to the student. The student enters the code in a Chrome extension on their Chromebook. That's it.

**Built by someone in the room** — brief honest bio. Built by an IT administrator at a real Alberta school division who ran into this problem and couldn't find a solution that didn't create new privacy problems.

---

#### 4. Contact (`/contact`)

**"Schedule a Demo" form:**

Fields:
- Name (text)
- Email (email)
- School Division (text)
- Role — dropdown: Teacher / Learning Support / IT / Administrator / Other
- Message (textarea, placeholder: "Tell us about your situation — how many schools, what assessments, any questions.")
- Submit button: "Send"

On submit: POST to a Vercel serverless function `/api/contact` that sends an email via Resend (add `RESEND_API_KEY` to env vars). Show a simple success message inline — no redirect.

No CAPTCHA for now. Add a honeypot field to catch bots.

Also include the plain contact email below the form as a fallback.

---

#### 5. Privacy Policy (`/privacy`)

**Title:** Privacy Policy
**Last updated:** [date]

**Sections:**

*What we collect*
We collect your email address when you sign in with Google. This is the only personal information AudioProctor stores.

*What we do not collect*
Students using AudioProctor are anonymous to the system. We do not collect student names, student IDs, ASN numbers, device identifiers, IP addresses, or any information that could identify a student. No student data is written to our database at any point during a session.

*How teacher data is used*
Your email address is used solely to associate your uploaded audio files with your account. It is not shared with third parties, not used for marketing, and not sold.

*Data storage*
Audio files and account data are stored with Supabase on infrastructure located in North America. All data in transit is encrypted via TLS. Audio files are stored in private buckets and are never publicly accessible.

*Data retention*
Audio files expire and are deleted automatically based on the expiry window set at upload. You may delete your files and account at any time.

*Third-party services*
AudioProctor uses Google OAuth for authentication. Google's privacy policy governs that interaction. We do not use third-party analytics services.

*FOIP*
AudioProctor does not trigger a Privacy Impact Assessment under Alberta's FOIP Act. The only personal data processed — teacher email addresses — is already governed by existing Google Workspace agreements at participating school divisions.

*Contact*
[email address]

---

#### 6. Terms of Service (`/terms`)

**Title:** Terms of Service
**Last updated:** [date]

**Sections:**

*Acceptance*
By creating an account, you agree to these terms.

*Use of the service*
AudioProctor is intended for use by educators at accredited schools and school divisions. You are responsible for ensuring that audio files you upload are used in accordance with your division's assessment policies.

*Audio content*
You may only upload audio content that you have the right to use. Do not upload copyrighted content without appropriate authorization.

*Student privacy*
You agree not to use AudioProctor in any way that would require the collection of student personal information. The service is designed to operate without student data — maintain that by not including student names or IDs in filenames or messages.

*Account termination*
We reserve the right to suspend or terminate accounts that violate these terms.

*Limitation of liability*
AudioProctor is provided as-is. We are not liable for assessment outcomes, data loss, or service interruption.

*Changes*
We may update these terms. Continued use after changes constitutes acceptance.

*Contact*
[email address]

---

### Resend Setup (for contact form)

1. Create account at resend.com
2. Add and verify your sending domain (audioproctor.com)
3. Generate API key, add to Vercel env as `RESEND_API_KEY`
4. Add `CONTACT_EMAIL` env var with your receiving address

---

That's a complete handoff document. The legal pages are real and accurate to your actual data model rather than generic boilerplate, so you won't need to edit much beyond dates and your contact email. 

The main thing to decide before you hand this to Claude Code is whether you want to set up Resend first (so the contact form works end-to-end), or build the form now and wire the backend later. Do you have a sending email in mind — would it be `hello@audioproctor.com` or something personal?