# Text Assessment — Marketing & Dashboard Refresh

> **Status:** IMPLEMENTED
> **Priority:** High
> **Estimated effort:** 2–3 hours
> **Dependencies:** Text assessment feature (shipped in 1.1.0)

**Goal:** Update the marketing site and teacher dashboard to reflect that AudioProctor now supports both audio and text assessments. Make the dashboard assessment type selector more prominent. Investigate and fix the assessment label display in the extension.

**Why now:** The text assessment feature is live but the marketing site still describes AudioProctor as audio-only. Teachers landing on the dashboard may not notice the assessment type dropdown buried below the label field. The product has changed; the surface hasn't caught up.

---

## Current State

### Marketing site (audioproctor.com)
- **Landing page:** Describes the product as "Audio accommodation for assessments." Hero, How It Works, and Why sections all reference audio only. Pricing is up to date.
- **Use Cases page:** All three use case cards (Provincial Assessment, Small School, Division Rollout) describe audio workflows exclusively.
- **About page:** "The Problem" and "The Solution" sections reference audio files and audio players only.

### Dashboard (app.audioproctor.com/dashboard.html)
- Assessment type selector is a `<select>` dropdown below the label field (line 148).
- Label field (optional) sits above the type selector (line 136).
- Current order: Label → Type → File/Text input → Advanced Options → Submit.
- The type selector is easy to miss — it looks like just another form field.

### Extension title display
- `api/session.js` sends `title: upload.label || upload.filename` (line 97/115).
- `extension/player.js` uses `sessionData.title || sessionData.filename || 'Assessment'` (line 95).
- `app/js/player.js` (web fallback) uses the same pattern (line 27).
- **The label IS being sent to the extension as `title`.** If the teacher set a label, it should display. However, the label field is optional and most teachers likely skip it, so the extension shows the filename by default. This is working as designed but may feel broken to teachers who don't realize the label propagates.

---

## Deliverables

### Task 1: Dashboard — Assessment type toggle redesign

**Goal:** Make the assessment type choice the first and most prominent field in the New Assessment card. Replace the `<select>` dropdown with a visible toggle that clearly presents both options.

**Files:**
- `app/dashboard.html` — reorder form fields, replace select with toggle markup
- `app/js/dashboard.js` — update `toggleAssessmentType()` to work with new toggle element
- `app/css/styles.css` — add toggle styling (if needed; may inline in dashboard.html)

**Design:**
- Move the assessment type selector to the top of the form (above the label field).
- Replace the `<select>` with a two-button toggle: `[ Audio ]  [ Text ]` — styled as a segmented control.
- Audio selected by default.
- Active button uses the accent color (`#c0392b`); inactive is muted.
- The toggle should feel like a deliberate choice, not a form field.
- Label field becomes the second field (optional, as before).
- File input / textarea appears below based on selection.

**Current order:**
```
Label (optional)
Assessment Type [dropdown]
Audio File / Text Area
Advanced Options
Create Assessment
```

**New order:**
```
Assessment Type [toggle: Audio | Text]
Label (optional)
Audio File / Text Area
Advanced Options
Create Assessment
```

---

### Task 2: Dashboard — Make assessment label more discoverable

**Goal:** Help teachers understand that the label they set here is what students see in the extension.

**Files:**
- `app/dashboard.html` — update label field hint text

**Changes:**
- Change the label hint from `(optional)` to: `(optional — shown to students in the extension)`
- This clarifies the purpose without making the field required.

---

### Task 3: Landing page — Rewrite for audio + text

**Goal:** Update the hero, How It Works, and Why sections to reflect the dual-mode product.

**Files:**
- `site/index.html`

**Changes:**

**Hero section:**
- Current: "Audio accommodation for assessments."
- Proposed: "Audio and text accommodation for assessments."
- Subhead: Update to mention both modes. Something like: "A Chrome extension and teacher dashboard that delivers audio and text support for assessed students on managed Chromebooks — without storing any student data."

**How It Works section:**
- Step 1 (Teacher uploads): Update to mention both options. "Sign in, upload an audio file or paste text, and get a short access code."
- Step 2 (Student enters code): "The extension opens a locked fullscreen player for audio, or a read-aloud text reader for text assessments."
- Step 3 (Teacher unlocks): Unchanged — exit word flow is the same for both types.

**Why AudioProctor section:**
- "Built for how assessments actually work" — update to mention that AudioProctor handles both audio and text-based accommodations, not just audio.

**Pricing section:** No changes needed — pricing is type-agnostic.

---

### Task 4: Use Cases page — Add text assessment context

**Goal:** Update use case cards to reflect that text assessments are now a first-class option.

**Files:**
- `site/use-cases.html`

**Changes:**

**Provincial Assessment card:**
- Current: "The teacher uploads the official audio track — or records their own read-aloud."
- Update to mention text: "The teacher uploads the official audio track, records their own read-aloud, or pastes the assessment text directly."

**Small School card:**
- Update to mention text option alongside audio.

**Division Rollout card:**
- Minor update: mention both assessment types are supported.

**FAQ section:**
- Add a new question: "What's the difference between audio and text assessments?" — brief answer explaining that audio plays a locked player, text shows a fullscreen reader with built-in read-aloud.
- Update "Who can see uploaded audio files?" to be type-agnostic: "Who can see my assessments?"

---

### Task 5: About page — Update problem/solution framing

**Goal:** The About page currently frames the problem as purely audio-related. Update to reflect the broader accommodation scope.

**Files:**
- `site/about.html`

**Changes:**

**The Problem section:**
- Current framing: "audio accommodation during an assessment."
- Broaden to: "audio or text accommodation during an assessment."
- Mention that some students need the text read aloud, not just played as audio.

**The Solution section:**
- Current: "A teacher uploads an audio file."
- Update: "A teacher uploads an audio file or pastes assessment text."
- Mention the text reader with built-in read-aloud alongside the audio player.

---

### Task 6: Verify extension title display with label

**Finding:** Verified — working as designed.

- `api/session.js` sends `title: upload.label || upload.filename` (lines 97, 115)
- `extension/popup.js` stores `session.title` in `chrome.storage.session` (line 59)
- `extension/player.js` displays `sessionData.title` first, falls back to `sessionData.filename` (line 95)

If a teacher sets a label, it shows in the extension's top bar. The perceived issue is that the label field is optional and easy to skip — addressed by Task 2's hint text update.

---

## Definition of Done

- [x] Dashboard assessment type toggle is visually prominent and above the label field
- [x] Label field hint tells teachers it's shown to students in the extension
- [x] Landing page hero mentions both audio and text
- [x] Landing page How It Works describes both modes
- [x] Use Cases page cards mention text assessments where relevant
- [x] Use Cases FAQ includes a text assessment question
- [x] About page problem/solution sections mention text alongside audio
- [x] Extension title display verified with a labeled assessment
- [x] No changes to `.hermes/plans/`
- [x] CHANGELOG.md updated
