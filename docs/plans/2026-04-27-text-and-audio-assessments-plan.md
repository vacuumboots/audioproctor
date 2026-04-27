# Text + Audio Assessments Implementation Plan

> For Hermes: Use subagent-driven-development skill to implement this plan task-by-task.

Goal: Add a first-class assessment type so teachers can create either audio assessments (current behavior) or pasted plain-text assessments, and so the web app + Chrome extension can load either the audio player or an accessibility-focused read-aloud text mode.

Architecture: Keep the existing access-code, expiry, exit-word, and analytics model centered on the `uploads` table, but generalize each row into an assessment record with an `assessment_type` discriminator. Audio assessments continue using Supabase Storage + signed URLs. Text assessments store sanitized plain text in the database and return it from `/api/session`; the extension then chooses either the current audio player flow or a new fullscreen text-reader flow.

Tech Stack: Vanilla HTML/CSS/JS, Supabase Postgres + Storage + RLS, Vercel serverless functions, Chrome Extension Manifest V3, ChromeOS native accessibility tools (ChromeVox / Select-to-Speak).

---

## Product decisions locked in for v1

1. Support two assessment types:
   - `audio`
   - `text`
2. Text input method for v1:
   - pasted plain text only
   - no DOCX, PDF, or rich text parsing
3. Student experience for text assessments:
   - fullscreen extension reader view
   - visible text on screen
   - rely on Chromebook-native accessibility / TTS tools
4. Existing audio behavior stays intact.
5. Access code, exit word, expiry, duplication, rename, and delete remain shared concepts across both types.
6. Do not add server-side TTS generation in this phase.

## Non-goals for v1

- DOCX upload/import
- PDF import
- automatic MP3 generation from text
- in-extension speech synthesis engine
- precise text-to-speech playback telemetry equivalent to audio progress events
- per-word highlighting synced to speech

## Key design choices

### Data model
Continue using `uploads` as the source-of-truth table so existing analytics, admin pages, and access-code lookups remain anchored to the same IDs. Add nullable text-specific fields rather than inventing a second table.

Recommended new columns on `uploads`:
- `assessment_type text not null default 'audio' check (assessment_type in ('audio','text'))`
- `text_content text null`
- `text_char_count integer not null default 0`

Keep existing audio columns for backwards compatibility:
- `storage_path`
- `filename`
- `file_size_mb`

Behavior by type:
- audio:
  - `assessment_type='audio'`
  - `storage_path` required
  - `filename` required
  - `file_size_mb > 0`
  - `text_content null`
- text:
  - `assessment_type='text'`
  - `text_content` required
  - `text_char_count > 0`
  - `storage_path null`
  - `file_size_mb = 0`
  - `filename` can still be populated with a synthetic value for compatibility, but better is to keep it nullable long-term if current schema allows it

Important compatibility note:
The current app assumes `filename` always exists and uses `COALESCE(label, filename)` in analytics. Before implementation, verify whether `uploads.filename` is nullable in production. If it is NOT nullable, use a generated placeholder filename for text rows in v1, e.g. `text-assessment.txt`. If it IS nullable, prefer allowing null and updating UI/queries accordingly.

### Session API
`api/session.js` currently always returns:
- `signedUrl`
- `filename`
- `exitWordHash`

Change it to return a typed session payload:
- shared:
  - `assessmentType`
  - `title`
  - `exitWordHash`
- audio only:
  - `signedUrl`
  - `filename`
- text only:
  - `textContent`
  - optionally `textCharCount`

### Extension architecture
Do not fork the extension into two separate products. Keep one popup and one session bootstrap flow.

Recommended approach:
- popup fetches `/api/session`
- popup stores typed `sessionData` in `chrome.storage.session`
- popup opens a single fullscreen shell page, e.g. keep using `player.html`
- `extension/player.js` branches on `sessionData.assessmentType`

For v1, use a single fullscreen page with two states:
- audio player state (existing)
- text reader state (new)

This is lower-risk than creating two separate windows/pages, because the background-service-worker lock/reopen logic already assumes `player.html`.

### Analytics
Current event model is audio-centric:
- `playback_started`
- `playback_paused`
- `playback_resumed`
- `playback_completed`
- `replay_triggered`
- `exit_word_used`
- `session_expired`
- `audio_error`

For text v1, add text-compatible events instead of pretending text is audio. Recommended additions:
- `text_viewed`
- `text_scrolled`
- `text_reader_opened_accessibility_help`
- `text_completed`

If you want to stay minimal, add only:
- `text_viewed`
- `text_completed`

Then update analytics summaries to avoid treating text rows as if completion depends on playback events.

Recommended completion interpretation in v1:
- audio completion = existing `playback_completed`
- text completion = explicit student/teacher action like clicking a `Done` button before exit OR simply rely on `exit_word_used` as the completion proxy for text rows

Simplest v1 recommendation:
Use `exit_word_used` as the completion proxy for text assessments and do not add a separate text completion button yet.

---

## Task 1: Verify current production schema assumptions before writing the migration

Objective: Confirm whether `uploads.filename`, `uploads.storage_path`, and `uploads.file_size_mb` are nullable in the live schema and whether any constraints would block text rows.

Files:
- Inspect: `supabase/migrations/`
- Create: `docs/plans/schema-notes-text-assessments.md` (optional working note, do not commit unless useful)

Step 1: Inspect schema definition sources
- Read existing migrations for `uploads` creation or alteration.
- If migrations are incomplete in-repo, inspect the live table definition using Supabase SQL editor before applying changes.

Step 2: Record answers to these questions
- Is `uploads.filename` nullable?
- Is `uploads.storage_path` nullable?
- Is `uploads.file_size_mb` nullable?
- Are there CHECK constraints assuming audio storage always exists?
- Do any views or RPCs select `filename` directly with non-null assumptions?

Step 3: Choose one compatibility path
- Path A: `filename` remains required → generate a synthetic filename for text assessments.
- Path B: `filename` becomes nullable → patch all UI/API consumers accordingly.

Step 4: Verification
- Verify you can describe the exact migration needed without guessing.

Step 5: Commit
```bash
git add docs/plans/2026-04-27-text-and-audio-assessments-plan.md
git commit -m "docs: add mixed text/audio assessments plan"
```

---

## Task 2: Add schema support for typed assessments

Objective: Extend `uploads` so one row can represent either audio or text safely.

Files:
- Create: `supabase/migrations/018_text_assessments.sql`
- Modify: `RELEASE_SOURCE_OF_TRUTH.md` only later if this ships

Step 1: Write the migration
Include:
- new `assessment_type` column with default `'audio'`
- new `text_content` column
- new `text_char_count` column with default `0`
- backfill existing rows to `assessment_type='audio'`
- add CHECK constraint(s) enforcing valid shape by type

Recommended migration shape:
```sql
ALTER TABLE uploads
  ADD COLUMN IF NOT EXISTS assessment_type text NOT NULL DEFAULT 'audio',
  ADD COLUMN IF NOT EXISTS text_content text,
  ADD COLUMN IF NOT EXISTS text_char_count integer NOT NULL DEFAULT 0;

UPDATE uploads
SET assessment_type = 'audio'
WHERE assessment_type IS NULL;

ALTER TABLE uploads
  ADD CONSTRAINT uploads_assessment_type_check
  CHECK (assessment_type IN ('audio', 'text'));

ALTER TABLE uploads
  ADD CONSTRAINT uploads_text_shape_check
  CHECK (
    (assessment_type = 'audio' AND storage_path IS NOT NULL)
    OR
    (assessment_type = 'text' AND text_content IS NOT NULL AND length(trim(text_content)) > 0)
  );
```

Adjust for actual nullability discovered in Task 1.

Step 2: Keep free-tier quota compatibility
The existing RLS policy in `supabase/migrations/005_account_hierarchy.sql` checks:
- monthly upload count
- cumulative `storage_used_mb + file_size_mb <= 50`
- hourly upload rate

For text rows, set `file_size_mb = 0` and keep them within the same upload-count quota system for v1.

Step 3: Consider char-length guardrail
Add a DB-side CHECK or app-side validation for maximum text length. Recommended v1 max:
- 25,000 characters
This is enough for an assessment passage without opening abuse/storage issues.

Step 4: Verification
In Supabase SQL editor or local throwaway DB, verify:
- existing audio rows still valid
- inserting a valid text row succeeds
- inserting a text row with null content fails
- inserting an audio row with null storage_path fails

Step 5: Commit
```bash
git add supabase/migrations/018_text_assessments.sql
git commit -m "feat(db): add text assessment support to uploads"
```

---

## Task 3: Update teacher dashboard form to choose assessment type

Objective: Let teachers explicitly choose Audio or Text before entering the assessment content.

Files:
- Modify: `app/dashboard.html`
- Modify: `app/js/dashboard.js`
- Modify: `app/css/styles.css` only if shared styles are needed

Step 1: Add an assessment type selector to the form
In `app/dashboard.html`, insert above the file/text inputs:
```html
<div class="form-group">
  <label class="label" for="assessment-type">Assessment Type</label>
  <select id="assessment-type" class="input-field" onchange="toggleAssessmentType()">
    <option value="audio" selected>Audio file</option>
    <option value="text">Plain text</option>
  </select>
</div>
```

Step 2: Split the input UI into two sections
Audio section:
- existing file input
- existing hint text

Text section:
```html
<div id="text-input-group" class="form-group hidden">
  <label class="label" for="text-content-input">Assessment Text</label>
  <textarea
    id="text-content-input"
    class="input-field"
    rows="12"
    maxlength="25000"
    placeholder="Paste the passage or assessment text here..."
    oninput="handleTextInput()"
  ></textarea>
  <span id="text-hint" class="label text-muted">Plain text only · Max 25,000 characters</span>
</div>
```

Step 3: Add toggle logic in `app/js/dashboard.js`
Implement:
- `toggleAssessmentType()`
- show/hide audio vs text inputs
- update button label if helpful (`Upload Assessment` can remain unchanged)
- disable upload button until valid input exists for the selected type

Step 4: Add text validation helpers
Implement functions like:
- `getSelectedAssessmentType()`
- `normalizeTextContent(raw)`
- `isValidTextAssessment(text)`
- `handleTextInput()`

Normalization rules for v1:
- convert CRLF to LF
- trim leading/trailing blank space
- collapse runs of 3+ blank lines to 2
- preserve paragraph breaks
- do not support HTML markup

Step 5: Update copy in empty state and hints
Current dashboard copy says “Upload Audio” and “Select an MP3 or WAV file”.
Change it so the teacher understands both modes exist.

Recommended empty-state wording:
- Step 2 becomes “Choose Audio File or Paste Text”
- CTA button becomes “Create Assessment” instead of “Upload Audio”

Step 6: Verification
Manual browser test:
- audio mode still behaves exactly as before
- text mode enables button only after valid text pasted
- switching modes resets irrelevant inputs cleanly

Step 7: Commit
```bash
git add app/dashboard.html app/js/dashboard.js app/css/styles.css
git commit -m "feat(dashboard): add assessment type selector"
```

---

## Task 4: Refactor upload/create flow in dashboard.js for dual-mode creation

Objective: Generalize `handleUpload()` so it can create either an audio assessment or a text assessment.

Files:
- Modify: `app/js/dashboard.js`

Step 1: Split the current giant `handleUpload()` into helpers
Recommended helpers:
- `buildSharedAssessmentFields()`
- `createAudioAssessment(session, selectedFile, sharedFields)`
- `createTextAssessment(session, textContent, sharedFields)`
- `resetAssessmentForm()`

Step 2: Keep shared logic shared
These steps remain common to both types:
- auth/session lookup
- duplicate display-name check strategy
- free-tier monthly quota check
- exit-word generation + hashing
- access-code generation
- expires_at generation
- preferred exit word mode persistence

Step 3: Implement audio branch
Retain current behavior:
- validate MP3/WAV
- convert WAV→MP3 if needed
- upload to Supabase Storage
- insert DB row with:
  - `assessment_type: 'audio'`
  - `storage_path`
  - `filename`
  - `file_size_mb`
  - `text_content: null`
  - `text_char_count: 0`

Step 4: Implement text branch
For text assessments:
- normalize text
- validate non-empty and under character limit
- insert DB row with:
  - `assessment_type: 'text'`
  - `text_content`
  - `text_char_count`
  - `storage_path: null`
  - `file_size_mb: 0`
  - `filename`: placeholder or null based on Task 1

Step 5: Keep progress UX sensible
For text rows there is no storage upload, so use short stages like:
- Preparing…
- Saving…
- Done

Do not show fake upload percentages for text.

Step 6: Fix delete logic for text rows
Current `deleteUpload(id, storagePath, btn)` assumes every row has a storage file.
Change it so:
- if `storage_path` is null, skip Storage delete and just delete DB row
- if `storage_path` exists, keep current duplicate-path safety logic

Step 7: Verification
Manual tests:
- create audio assessment successfully
- create text assessment successfully
- delete audio assessment successfully
- delete text assessment successfully
- quota bar and storage recalculation remain sane

Step 8: Commit
```bash
git add app/js/dashboard.js
git commit -m "feat(dashboard): support creating text assessments"
```

---

## Task 5: Update dashboard list rendering for mixed assessment types

Objective: Make the teacher’s “Your Uploads” table understandable for both audio and text rows.

Files:
- Modify: `app/js/dashboard.js`
- Modify: `app/css/styles.css` if needed

Step 1: Expand the query in `loadUploads()`
Current select:
```js
.select('id, filename, label, access_code, exit_word, expires_at, storage_path, file_size_mb')
```
Add:
- `assessment_type`
- `text_char_count`

Step 2: Add a type indicator in the Assessment column
Render a small badge:
- Audio
- Text

Example rendering:
```js
const typeBadge = u.assessment_type === 'text'
  ? '<span class="tier-badge">Text</span>'
  : '<span class="tier-badge">Audio</span>';
```

Step 3: Change secondary metadata line
For audio:
- keep filename line
For text:
- show something like `842 chars` or `Text assessment`

Step 4: Ensure Rename / Duplicate / Edit Expiry / Delete actions still work for both
Duplication logic must copy text rows correctly too; inspect and patch `duplicateUpload()` accordingly.

Step 5: Verification
- mixed list renders correctly
- text rows do not show broken filenames or delete behavior
- duplicate text assessment produces a new access code and same content

Step 6: Commit
```bash
git add app/js/dashboard.js app/css/styles.css
git commit -m "feat(dashboard): render text and audio assessments in uploads table"
```

---

## Task 6: Generalize the session API for typed responses

Objective: Make `/api/session` return either audio session data or text session data from the same access-code flow.

Files:
- Modify: `api/session.js`

Step 1: Expand the upload query
Current select:
```js
.select('id, filename, storage_path, exit_word_hash, expires_at, teacher_id')
```
Add:
- `assessment_type`
- `label`
- `text_content`
- `text_char_count`

Step 2: Keep existing access checks unchanged
Preserve:
- rate limiting
- code format validation
- expiry check
- deactivated teacher check
- code_entered analytics insert

Step 3: Return typed payload
Recommended response shape:
```js
if (upload.assessment_type === 'text') {
  return res.status(200).json({
    assessmentType: 'text',
    title: upload.label || upload.filename || 'Text Assessment',
    filename: upload.filename || null,
    textContent: upload.text_content,
    textCharCount: upload.text_char_count,
    exitWordHash: upload.exit_word_hash,
  });
}

return res.status(200).json({
  assessmentType: 'audio',
  title: upload.label || upload.filename,
  filename: upload.filename,
  signedUrl: signed.signedUrl,
  exitWordHash: upload.exit_word_hash,
});
```

Step 4: Only create signed URLs for audio
Do not touch Supabase Storage for text assessments.

Step 5: Verification
Use curl or browser fetch against known audio and text access codes.
Expected:
- audio row returns `assessmentType: "audio"` plus `signedUrl`
- text row returns `assessmentType: "text"` plus `textContent`

Step 6: Commit
```bash
git add api/session.js
git commit -m "feat(api): return typed audio or text sessions"
```

---

## Task 7: Expand event logging to support text sessions

Objective: Allow the extension to log meaningful non-audio events for text assessments without breaking existing analytics.

Files:
- Modify: `api/event.js`
- Modify: `supabase/migrations/004_session_events.sql` only by new migration, not by editing applied history
- Create: `supabase/migrations/019_text_session_events.sql`

Step 1: Choose text event vocabulary
Recommended minimal set:
- `text_viewed`
- `text_scrolled`

Optional:
- `text_accessibility_hint_viewed`

Step 2: Add DB support via new migration
If `session_events.event_type` has a CHECK constraint, add a new migration that drops/recreates or alters it to include the new values.

Step 3: Add API allowlist support
In `api/event.js`, add the new values to `ALLOWED_EVENTS`.

Step 4: Define what counts as “completion” in v1
Recommendation:
- do NOT add a new required completion signal yet
- rely on `exit_word_used` as the strongest shared completion-ish event across both types
- keep dashboard completion analytics labeled carefully later if needed

Step 5: Verification
- posting `text_viewed` succeeds
- old audio events still succeed
- invalid event names still fail with 400

Step 6: Commit
```bash
git add api/event.js supabase/migrations/019_text_session_events.sql
git commit -m "feat(analytics): add text assessment event types"
```

---

## Task 8: Update extension popup to store typed session data

Objective: Make the popup bootstrap agnostic to whether the assessment is audio or text.

Files:
- Modify: `extension/popup.js`

Step 1: Preserve access-code validation flow
Keep:
- code entry UX
- fetch to `/api/session`
- same error handling for 404/410/network

Step 2: Store new typed session payload
Update `chrome.storage.session.set()` so it stores:
- `assessmentType`
- `title`
- `filename`
- `exitWordHash`
- `code`
- `apiBase`
- audio-only `signedUrl` if present
- text-only `textContent` and `textCharCount` if present

Step 3: Prepare offscreen document only for audio sessions
Current popup always sends `prepare_session` before opening the player window.
Change to:
- if audio → call `prepare_session`
- if text → skip it

Step 4: Verification
- audio code still opens fullscreen window normally
- text code also opens fullscreen window without offscreen/audio preparation

Step 5: Commit
```bash
git add extension/popup.js
git commit -m "feat(extension): store typed session data in popup"
```

---

## Task 9: Refactor extension background worker for mixed session types

Objective: Make the background worker reopen/manage the fullscreen player for both audio and text sessions.

Files:
- Modify: `extension/background.js`

Step 1: Keep existing player window tracking
Do not change the fullscreen lock model.

Step 2: Gate offscreen logic by assessment type
Today unauthorized reopen does this:
- reads `sessionData`
- if `sessionData.signedUrl`, ensures offscreen and reopens `player.html`

Change it to:
- if session exists and `assessmentType === 'audio'`, ensure offscreen then reopen
- if session exists and `assessmentType === 'text'`, reopen `player.html` without offscreen

Step 3: Safe cleanup
When legitimate close occurs:
- remove `playerWindowId`
- for audio, close offscreen document
- for text, skip offscreen close errors harmlessly

Step 4: Verification
- unauthorized close reopens both audio and text sessions
- audio still recreates offscreen document correctly
- text does not depend on offscreen document

Step 5: Commit
```bash
git add extension/background.js
git commit -m "feat(extension): support mixed audio and text session reopening"
```

---

## Task 10: Add text-reader mode to the extension player shell

Objective: Extend `extension/player.html` to support an accessibility-focused text reader state alongside the existing audio player state.

Files:
- Modify: `extension/player.html`
- Modify: `extension/player.js`

Step 1: Keep the existing audio markup intact
Do not rip out the proven audio player.

Step 2: Add a new text reader state in `extension/player.html`
Insert a hidden block alongside `#state-player`, e.g.:
```html
<div id="state-text" class="player-card hidden">
  <div class="text-reader-header">
    <p class="state-label">Text Assessment</p>
    <p class="exit-hint">Use your Chromebook's built-in read-aloud tools if needed.</p>
  </div>

  <div class="text-reader-help">
    <p><strong>Select-to-Speak:</strong> If enabled by your school, highlight text and use the Chromebook read-aloud shortcut.</p>
    <p><strong>ChromeVox:</strong> If already enabled, navigate the passage with keyboard controls.</p>
  </div>

  <div id="text-content" class="text-content" tabindex="0"></div>
</div>
```

Step 3: Add text-reader styles
Goals:
- high contrast
- large readable text
- constrained measure (comfortable line length)
- scrollable content area
- visible focus outline
- preserve paragraph breaks with `white-space: pre-wrap`

Step 4: Branch player bootstrap on `assessmentType`
In `extension/player.js`:
- if `assessmentType === 'audio'`, run current audio flow
- if `assessmentType === 'text'`, skip audio URL validation and offscreen messaging
- render `textContent` into `#text-content` safely with `textContent`, not `innerHTML`
- show `#state-text`

Step 5: Add minimal text telemetry
For text sessions:
- log `text_viewed` when the text state is shown
- optionally debounce a `text_scrolled` event on first scroll only

Step 6: Preserve exit-word flow exactly
The exit section should remain shared and always visible.

Step 7: Verification
Manual extension tests:
- audio session still loads and plays
- text session shows readable content
- text session never tries to load signed audio URL
- exit word works in both modes

Step 8: Commit
```bash
git add extension/player.html extension/player.js
git commit -m "feat(extension): add accessibility-focused text reader mode"
```

---

## Task 11: Update web fallback player for typed sessions

Objective: Make `app/js/player.js` fail gracefully or support text mode when a text assessment is opened in the browser.

Files:
- Modify: `app/js/player.js`
- Modify: corresponding `app/player.html` if needed

Step 1: Decide fallback behavior
Recommended v1 behavior:
- support text mode in the web fallback too
This keeps the access-code experience coherent even outside the extension.

Step 2: Add typed-session handling
Like the extension player:
- audio → current behavior
- text → show text content in a simple reader block

Step 3: Keep scope smaller than extension
You do not need the full lockdown behavior here; just avoid a broken page for text sessions.

Step 4: Verification
- browser `?code=` URL works for audio
- browser `?code=` URL works for text

Step 5: Commit
```bash
git add app/js/player.js app/player.html
git commit -m "feat(web): support text sessions in fallback player"
```

---

## Task 12: Patch duplication, CSV export, and insights assumptions

Objective: Make teacher-side analytics and utilities tolerate text rows without broken labels or misleading assumptions.

Files:
- Modify: `app/js/dashboard.js`
- Modify: `supabase/migrations/006_analytics_views.sql` only via a new migration if needed
- Create: `supabase/migrations/020_text_analytics_compat.sql` if necessary

Step 1: Inspect `duplicateUpload()` logic and patch it
Ensure text duplication copies:
- `assessment_type`
- `text_content`
- `text_char_count`
And does not try to duplicate storage upload if there is no `storage_path`.

Step 2: Review dashboard stats wording
Current stats say:
- completion rate
- replays
- avg listen time
These are audio-native terms.

For v1, simplest path:
- show detailed stats block only for audio rows
- for text rows show a neutral message like `Session activity available in CSV export`

Step 3: Review CSV export RPC compatibility
`get_my_session_events()` already returns generic event rows joined to uploads.
This likely works unchanged, but verify text event names export cleanly.

Step 4: Review upload_summaries assumptions
If materialized views count only audio completion semantics, do not force text rows into misleading completion-rate widgets in v1.
A safe approach is to exclude text rows from completion/replay/avg-listen derived metrics until you intentionally redesign mixed-mode analytics.

Step 5: Verification
- text rows do not crash insights card
- CSV export includes text events if present
- duplication works for text rows

Step 6: Commit
```bash
git add app/js/dashboard.js supabase/migrations/020_text_analytics_compat.sql
git commit -m "feat(analytics): make dashboard utilities text-safe"
```

---

## Task 13: Update docs and public extension documentation

Objective: Reflect that AudioProctor now supports both audio and text assessments.

Files:
- Modify: `AGENTS.md`
- Modify: `extension/README.md`
- Modify: `docs/extension-release-checklist.md`
- Modify: `CHANGELOG.md`
- Create: `docs/test-runs/2026-04-27-text-assessment-pilot.md` after testing

Step 1: Update extension README
Change description from audio-only to mixed-mode.

Examples to update:
- “secure student audio assessment playback” → “secure student assessment delivery for audio and text accommodations”
- “fetch a short-lived signed audio URL” → “fetch a typed session payload for audio or text assessments”

Step 2: Update release checklist
Add explicit regression checks for both:
- audio assessment flow
- text assessment flow

Step 3: Update changelog
Add an unreleased or release entry for text assessment support.

Step 4: Verification
Read docs end-to-end and ensure they no longer claim the extension is audio-only.

Step 5: Commit
```bash
git add AGENTS.md extension/README.md docs/extension-release-checklist.md CHANGELOG.md
git commit -m "docs: describe mixed text and audio assessment support"
```

---

## Task 14: Run manual QA across both modes

Objective: Prove that mixed-mode support works on desktop Chrome and managed Chromebook before release.

Files:
- Create: `docs/test-runs/2026-04-27-text-assessment-pilot.md`
- Reference: `docs/test-runs/2026-04-26-managed-chromebook-pilot.md`
- Reference: `docs/test-runs/2026-04-27-managed-chromebook-csp-retest.md`

Step 1: Audio regression matrix
Verify:
- teacher can upload MP3
- teacher can upload WAV and get MP3 conversion
- student can open extension with access code
- audio plays
- rewind/speed/exit word still work
- events still log

Step 2: Text assessment matrix
Verify:
- teacher can create text assessment from pasted plain text
- teacher dashboard shows type badge and usable metadata
- student enters access code in extension
- fullscreen text reader opens
- text is visible and scrollable
- Chromebook native accessibility tools can read the text aloud in the intended managed environment
- exit word still works

Step 3: Web fallback matrix
Verify:
- browser player handles both audio and text sessions

Step 4: Edge cases
Verify:
- empty text rejected
- over-limit text rejected
- delete text row works
- duplicate text row works
- expired text assessment behaves correctly
- deactivated teacher text assessment blocked in `/api/session`

Step 5: Save test run notes
Document:
- device/browser/version
- managed Chromebook settings relevant to accessibility
- whether Select-to-Speak / ChromeVox was available by default or required admin enablement
- teacher usability feedback

Step 6: Commit
```bash
git add docs/test-runs/2026-04-27-text-assessment-pilot.md
git commit -m "docs(test): record mixed-mode audio/text assessment pilot"
```

---

## Task 15: Release strategy

Objective: Ship safely without breaking classrooms already using audio.

Files:
- Follow: `docs/extension-release-checklist.md`
- Follow: `docs/release-checklist.md`

Step 1: Branching
- branch off `dev`
- implement and merge into `dev`
- validate on managed Chromebook
- promote `dev` to `main`
- verify public extension mirror sync
- manually publish Chrome Web Store update

Step 2: Rollout guidance
Because this is a cross-stack feature touching DB, app, API, and extension:
- deploy migration first
- deploy app/API changes next
- publish extension last only after API is live

Step 3: Backward compatibility checklist
Before main merge, verify:
- old audio rows still resolve through `/api/session`
- extension version in production can still play old audio rows
- new text rows do not break old analytics pages

Step 4: Post-release monitoring
Watch for:
- spike in `audio_error`
- 500s from `/api/session`
- malformed text rows
- teacher confusion about which type to choose

Step 5: Publish note
Prepare a short teacher-facing changelog/update note:
- Audio assessments still supported
- New: paste plain text and use Chromebook accessibility tools in the student reader

---

## Suggested implementation order if you want the safest path

1. Task 1 — verify schema assumptions
2. Task 2 — migration
3. Task 6 — `/api/session` typed response
4. Task 8 — popup typed session storage
5. Task 9 — background worker mixed-mode reopen
6. Task 10 — extension text reader
7. Task 3 — dashboard assessment type UI
8. Task 4 — dashboard create flow
9. Task 5 — dashboard list rendering
10. Task 7 — text event support
11. Task 11 — web fallback player
12. Task 12 — duplication/analytics compatibility
13. Task 13 — docs
14. Task 14 — QA
15. Task 15 — release

This order de-risks the student runtime first, then the teacher authoring flow.

---

## Exact verification commands to run during implementation

Basic syntax checks after JS edits:
```bash
node --check api/session.js
node --check api/event.js
node --check app/js/dashboard.js
node --check app/js/player.js
node --check extension/popup.js
node --check extension/player.js
node --check extension/background.js
```

Git whitespace check:
```bash
git diff --check
```

If using Vercel local dev:
```bash
vercel dev
```

Manual fetch test examples:
```bash
curl "http://localhost:3000/api/session?code=ABC-123"
curl "https://app.audioproctor.com/api/session?code=ABC-123"
```

---

## Recommended v1 UX copy for text mode

Teacher dashboard helper text:
- “Paste plain text for Chromebook read-aloud accommodations. Students will see the text in the extension and can use built-in accessibility tools.”

Student text-reader helper text:
- “If your teacher has enabled Chromebook accessibility tools, you can use them to read this passage aloud.”

Avoid claiming specific shortcuts will always work unless you verify the managed Chromebook configuration in your district.

---

## Main risks and mitigations

1. Risk: Native Chromebook accessibility tools may not be enabled consistently.
Mitigation:
- test on the real managed Chromebook environment before release
- keep audio mode untouched for classrooms that already use MP3
- document required admin settings if needed

2. Risk: Analytics become misleading when mixing audio and text.
Mitigation:
- treat text analytics as minimal in v1
- avoid showing replay/listen metrics for text rows

3. Risk: Existing code assumes every row has storage_path.
Mitigation:
- explicitly patch delete, duplicate, session API, and list rendering

4. Risk: Schema constraints in production differ from repo assumptions.
Mitigation:
- do Task 1 before writing final migration SQL

5. Risk: Feature creep into DOCX/TTS generation delays shipping.
Mitigation:
- hold v1 to pasted plaintext only

---

## Definition of done

The feature is done when all of the following are true:

- Teachers can create both audio and text assessments from the dashboard.
- Existing audio assessments still work unchanged.
- `/api/session` returns a valid typed payload for both modes.
- The extension opens a fullscreen audio player for audio rows.
- The extension opens a fullscreen text reader for text rows.
- Exit word protection works in both modes.
- Text rows can be duplicated, renamed, expired, and deleted.
- Managed Chromebook testing confirms text can be read with native accessibility/TTS tools in the real school environment.
- Docs and release checklist reflect mixed-mode support.
- Public extension mirror sync and Chrome Web Store release are completed after validation.
