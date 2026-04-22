# Shipment 1 — Managed Chromebook Pilot Readiness Implementation Plan

> For Hermes: Use subagent-driven-development skill to implement this plan task-by-task.

**Goal:** Prove that AudioProctor works reliably on an actual managed Chromebook and leave behind a documented, repeatable deployment/test process for future pilots.

**Architecture:** This shipment is not primarily a feature build; it is an operational hardening pass around the existing Chrome extension + `/api/session` flow. The work should capture a real managed-Chromebook validation run, patch any blockers discovered in the extension/session path, and add a small amount of instrumentation and documentation so the deployment path is reproducible by IT admins and testable by future maintainers.

**Tech Stack:** Chrome Extension Manifest V3, Chrome OS managed-device policies, vanilla JS extension code (`extension/`), Vercel serverless (`api/session.js`), existing markdown docs.

---

## Current context and assumptions

Known current state from repo inspection:
- `extension/offscreen.js` is the audio playback workaround for Chrome OS audio restrictions.
- `extension/background.js` manages fullscreen enforcement, unauthorized close recovery, and offscreen lifecycle.
- `extension/popup.js` calls `https://audioproctor.com/api/session` and opens `player.html` in a fullscreen popup.
- `api/session.js` returns a signed Supabase URL and rejects expired/deactivated uploads.
- `AUDIO-DEBUG.md` shows a managed Chromebook test was already performed once, but that knowledge is trapped in a debug log rather than a reusable pilot checklist.
- The staged documentation now treats the current pilot path as founder-assisted Google Admin deployment, while the exact reusable artifact/package standard still needs to be nailed down for future pilots.

This plan assumes Shipment 1 should deliver three things:
1. one current, explicit test protocol
2. one current deployment guide for pilot use
3. any small code fixes needed to survive real managed-Chromebook testing

This plan does NOT include Chrome Web Store publication itself. That is Shipment 5.

---

## Deliverables

1. A reusable managed-Chromebook validation checklist
2. A pilot deployment guide for IT/admin testing
3. A structured test-results log template
4. Any code fixes needed for issues discovered in the test pass
5. One updated source of truth in docs for the current deployment path during pre–Chrome Web Store pilot testing

---

## Definition of done

Shipment 1 is done only when all of these are true:
- A tester can follow one written checklist and run the assessment flow on a managed Chromebook end-to-end
- The extension behavior is verified for: startup, fullscreen lock, playback, replay, pause, exit-word close, session-expiry handling, network interruption, and unauthorized window close
- Any blocker bugs found during test are either fixed or documented as known issues with workarounds
- A future IT admin or founder can reproduce the pilot setup without relying on memory
- Repo docs no longer contradict each other about the current pilot deployment approach

---

## Files likely to change

Documentation:
- Modify: `README.md`
- Modify: `AUDIO-DEBUG.md`
- Modify: `roadmap.md` (only if you want to mark the item complete after validation)
- Create: `docs/managed-chromebook-pilot-checklist.md`
- Create: `docs/it-pilot-deployment-guide.md`
- Create: `docs/managed-chromebook-test-log-template.md`

Potential code files if blockers are found during test:
- Modify: `extension/popup.js`
- Modify: `extension/player.js`
- Modify: `extension/background.js`
- Modify: `extension/offscreen.js`
- Modify: `extension/manifest.json`
- Modify: `api/session.js`

---

## Task 1: Create the managed Chromebook pilot checklist document

**Objective:** Write the exact manual test checklist that defines what “managed Chromebook end-to-end validated” means.

**Files:**
- Create: `docs/managed-chromebook-pilot-checklist.md`

**Step 1: Write the checklist structure**

Create sections for:
- Purpose
- Required equipment/accounts
- Pre-test setup
- Test matrix
- Pass/fail criteria
- Notes / defect capture

Use this starting structure:

```md
# Managed Chromebook Pilot Checklist

## Purpose
Validate that AudioProctor works on an actual managed Chromebook under school-style policy enforcement.

## Required setup
- 1 managed Chromebook
- 1 teacher account with at least one active upload
- 1 valid access code + exit word
- Google Admin access (or equivalent IT-managed deployment path)
- Stable Wi‑Fi connection

## Core scenarios
1. Extension is present on managed Chromebook
2. Student enters valid code
3. Player opens fullscreen
4. Audio loads and plays
5. Pause / resume / rewind / speed controls work
6. Student cannot escape assessment window without exit word
7. Authorized exit closes session cleanly
8. Expired/invalid code shows correct error
9. Network interruption behavior is understood
10. Unauthorized close reopens player
```

**Step 2: Add exact scenario checklist items**

Include explicit checks for:
- extension installed automatically
- popup opens successfully
- valid code path
- invalid code path
- expired code path
- teacher deactivated path if available
- offscreen audio actually audible
- progress bar/time updates
- rewind and speed controls
- exit word success and failure
- system close button behavior
- switching focus / alt-tab equivalent / other window attempt
- sleep/wake or lid close/open if feasible
- temporary Wi‑Fi disconnect and reconnect

**Step 3: Add pass/fail severity labels**

Use three severity levels:
- Blocker — cannot run a real student session
- Major — session works but pilot confidence is weakened
- Minor — polish or docs issue only

**Step 4: Save the file**

Expected outcome: `docs/managed-chromebook-pilot-checklist.md` exists and could be handed directly to a tester.

**Step 5: Commit**

```bash
git add docs/managed-chromebook-pilot-checklist.md
git commit -m "docs: add managed Chromebook pilot checklist"
```

---

## Task 2: Create the IT pilot deployment guide

**Objective:** Document the real pre-Chrome-Web-Store pilot deployment path so an IT admin can reproduce it.

**Files:**
- Create: `docs/it-pilot-deployment-guide.md`
- Modify: `README.md`

**Step 1: Decide and state the current pilot deployment truth**

Before writing, choose one current statement and use it consistently everywhere in docs.

If Chrome Web Store is NOT yet shipped, the guide should say something like:

```md
Current pilot deployment path: load or deploy the unpacked extension / package through Google Admin for pilot testing. Chrome Web Store publication is planned but not yet the standard path.
```

If pilot installs are being done another way, document that exact path instead. Do not leave both `.crx` and Chrome Web Store as simultaneous “current” answers.

**Step 2: Write the guide skeleton**

Create sections:
- Audience
- Current deployment path
- Prerequisites
- Files IT needs
- Install steps
- How to verify install succeeded
- How to run a smoke test
- Rollback / uninstall
- Known limitations
- Support contact

Use this starting structure:

```md
# IT Pilot Deployment Guide

## Audience
Google Workspace / Chromebook administrators piloting AudioProctor.

## Current deployment method
[one truthful paragraph only]

## What you need
- Managed Chromebook OU or test device
- Extension package or source folder
- Test teacher account and access code

## Verification
- Extension appears in Chrome
- Code entry popup opens
- Test assessment launches fullscreen
- Audio plays audibly
```

**Step 3: Update `README.md` so it matches the guide**

Specifically update:
- the “Chrome extension deployment” section
- any architecture/deployment lines that imply Chrome Web Store is already the live path if it is not

**Step 4: Add a short smoke-test subsection**

Include 5-minute smoke test steps:
- install extension
- enter test code
- confirm fullscreen opens
- press play and hear audio
- verify exit word closes player

**Step 5: Commit**

```bash
git add docs/it-pilot-deployment-guide.md README.md
git commit -m "docs: add IT pilot deployment guide"
```

---

## Task 3: Convert the ad hoc audio debug log into an evergreen operational reference

**Objective:** Preserve the key Chrome OS lessons without leaving them buried in a historical debug file.

**Files:**
- Modify: `AUDIO-DEBUG.md`
- Possibly modify: `README.md`

**Step 1: Keep the historical narrative, but add a top summary block**

At the top of `AUDIO-DEBUG.md`, add a concise “Current truth” section:

```md
## Current implementation summary
- Chrome OS blocks audio output from regular extension pages
- AudioProctor uses `chrome.offscreen` with `AUDIO_PLAYBACK`
- `popup.js` must await `prepare_session` before player launch
- Any change touching popup -> background -> offscreen startup must be retested on Chrome OS
```

**Step 2: Add a “Regression triggers” section**

Document exactly what kinds of code changes require re-testing on managed Chromebook:
- changes to `extension/manifest.json`
- changes to `popup.js` player launch flow
- changes to `background.js` offscreen lifecycle
- changes to `offscreen.js` message handling
- changes to `player.js` startup/loading/error flow

**Step 3: Cross-link the new checklist and deployment guide**

Add links at the top or bottom:
- `docs/managed-chromebook-pilot-checklist.md`
- `docs/it-pilot-deployment-guide.md`
- `docs/managed-chromebook-test-log-template.md`

**Step 4: Commit**

```bash
git add AUDIO-DEBUG.md
git commit -m "docs: turn Chrome OS audio debug notes into operational reference"
```

---

## Task 4: Create a structured managed Chromebook test log template

**Objective:** Make the actual pilot test repeatable and comparable across devices or Chrome OS versions.

**Files:**
- Create: `docs/managed-chromebook-test-log-template.md`

**Step 1: Write the template**

Use this structure:

```md
# Managed Chromebook Test Log

## Test metadata
- Date:
- Tester:
- Device model:
- Chrome OS version:
- Chrome version:
- Extension version:
- Deployment method:
- Network environment:

## Scenario results
| Scenario | Expected | Actual | Pass/Fail | Severity | Notes |
|----------|----------|--------|-----------|----------|-------|

## Issues found
- Issue:
- Repro steps:
- Impact:
- Suggested fix:

## Final verdict
- Pilot ready / Not pilot ready
```

**Step 2: Include the minimum scenarios**

Pre-fill rows for:
- install success
- popup opens
- valid code lookup
- invalid code error
- expired code error
- fullscreen lock
- audio playback audible
- progress updates
- rewind works
- speed control works
- unauthorized close reopens
- exit word rejects wrong input
- exit word accepts correct input
- reconnect behavior after network interruption

**Step 3: Commit**

```bash
git add docs/managed-chromebook-test-log-template.md
git commit -m "docs: add managed Chromebook test log template"
```

---

## Task 5: Add lightweight startup instrumentation for pilot debugging

**Objective:** Make future Chromebook failures diagnosable without guesswork.

**Files:**
- Modify: `extension/popup.js`
- Modify: `extension/player.js`
- Modify: `extension/background.js`
- Modify: `extension/offscreen.js`

**Step 1: Add a shared debug flag**

Implement a small constant in each file:

```js
const DEBUG = false;
function debugLog(...args) {
  if (DEBUG) console.log('[AudioProctor]', ...args);
}
```

**Step 2: Add logs at the critical boundaries only**

Add logs for:
- popup: session fetch start/success/failure, `prepare_session` start/success, window create success
- background: offscreen create, player open, unauthorized close reopen, max reopen reached
- offscreen: `load`, `play`, `error`, `loadedmetadata`
- player: session loaded, invalid session state, signed URL rejected, metadata received, retry triggered

Do NOT flood logs with `timeupdate` spam.

**Step 3: Keep all logs gated by `DEBUG`**

Expected outcome: enabling one boolean gives enough signal to diagnose startup problems during pilot testing.

**Step 4: Verify no behavior change when `DEBUG = false`**

Manual verification:
- extension still loads
- player still opens
- no user-facing UI changes

**Step 5: Commit**

```bash
git add extension/popup.js extension/player.js extension/background.js extension/offscreen.js
git commit -m "chore: add gated extension debug logging for pilot testing"
```

---

## Task 6: Harden load-error behavior in the extension player

**Objective:** Improve resilience for the real-world failure modes most likely on school devices and networks.

**Files:**
- Modify: `extension/player.js`
- Modify: `extension/offscreen.js`
- Possibly modify: `api/session.js`

**Step 1: Define the exact desired behavior**

Desired behavior:
- If session data is missing, show a clear recovery message
- If signed URL origin is invalid, fail safely
- If metadata never arrives within timeout, show retry state
- If playback errors, student sees a human-readable message
- Retrying should reload the same signed URL cleanly

**Step 2: Review current player states against that behavior**

Current code already includes:
- `state-loading`
- `state-error`
- retry button
- load timeout

Check whether each message is understandable for a student/teacher in pilot conditions.

**Step 3: Adjust wording and retry flow if needed**

Improve any unclear copy, for example:
- “Audio failed: unknown error” -> “The audio could not be loaded. Ask your teacher to try again.”
- “Session expired or not found” -> mention re-entering code in the extension popup

**Step 4: Consider adding one specific session API error mapping**

If `api/session.js` returns 403 for deactivated teachers, ensure popup/player messaging is not misleading.

**Step 5: Manual verification**

Verify these cases:
- 404 code not found
- 410 expired
- 403 no longer available
- network failure on session fetch
- offscreen playback error
- load timeout then retry

**Step 6: Commit**

```bash
git add extension/player.js extension/offscreen.js api/session.js extension/popup.js
git commit -m "fix: harden extension load and playback error recovery"
```

---

## Task 7: Run the real managed Chromebook validation pass and record outcomes

**Objective:** Execute the plan on real hardware and capture a durable record.

**Files:**
- Create: `docs/test-runs/YYYY-MM-DD-managed-chromebook-pilot.md`
- Possibly modify: `roadmap.md`

**Step 1: Copy the template into a dated test run file**

Example path:

```text
docs/test-runs/2026-04-21-managed-chromebook-pilot.md
```

**Step 2: Execute the checklist on actual hardware**

Run every scenario from `docs/managed-chromebook-pilot-checklist.md`.

**Step 3: Classify every issue**

Use:
- Blocker
- Major
- Minor

**Step 4: Make a ship decision**

At the end of the log, explicitly state one of:
- Pilot ready
- Pilot ready with known limitations
- Not pilot ready

**Step 5: If all blocker issues are resolved, mark roadmap item complete**

Update `roadmap.md` only after the real validation run is documented.

**Step 6: Commit**

```bash
git add docs/test-runs/ roadmap.md
git commit -m "docs: record managed Chromebook pilot validation"
```

---

## Suggested execution order

Implement in this order:
1. Task 1 — pilot checklist
2. Task 2 — IT deployment guide + README consistency
3. Task 3 — operationalize `AUDIO-DEBUG.md`
4. Task 4 — test log template
5. Task 5 — gated debug logging
6. Task 6 — load-error hardening
7. Task 7 — real managed Chromebook validation run

This keeps documentation and observability ahead of the real-world test pass.

---

## Tests and verification

### Manual verification commands / checks

There is no automated test harness in this repo for the extension flow, so verification is manual.

Minimum verification after any code change:
- Load the extension unpacked in Chrome
- Open popup and enter a valid code
- Confirm `prepare_session` completes and player opens
- Confirm audio metadata loads
- Confirm play/pause/rewind/speed work
- Confirm close button reopens player when unauthorized
- Confirm correct exit word closes the session
- Confirm invalid/expired code handling in popup

### Regression hotspots

Retest the full Chromebook flow if any of these change:
- `extension/manifest.json`
- `extension/popup.js`
- `extension/background.js`
- `extension/offscreen.js`
- `extension/player.js`
- `api/session.js`

---

## Risks and tradeoffs

- Main risk: documentation gets written but the real Chromebook pass is postponed. Shipment 1 is not complete until the live test happens.
- Main technical risk: over-editing stable extension code before reproducing issues on real hardware. Keep code changes small and evidence-driven.
- Tradeoff: adding debug logs slightly increases maintenance surface, but pays for itself the first time startup/audio breaks on Chrome OS.
- Tradeoff: docs-first work can feel slow, but it dramatically lowers pilot friction and avoids rediscovering Chrome OS quirks.

---

## Open questions

1. What exact package artifact and handoff format will be used for the current founder-assisted pilot deployment path through Google Admin Console?
2. Do you want `docs/` as the permanent location for operational docs, or would you rather keep them at repo root?
3. Will Shipment 1 include only founder-run pilot validation, or should the docs be written for a third-party IT admin immediately?

---

## Recommended first implementation slice

If you want the smallest high-value start, do these first:
1. Task 1 — managed Chromebook pilot checklist
2. Task 2 — IT deployment guide + README consistency
3. Task 4 — test log template

That gives you a runnable, documented pilot process before touching code.

---

Plan complete and saved. Ready to execute using subagent-driven-development — I'll dispatch a fresh subagent per task with two-stage review (spec compliance then code quality). Shall I proceed?
