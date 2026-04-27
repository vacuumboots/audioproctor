# Managed Chromebook Pilot Checklist

For each formal run, record results in:
- `docs/test-runs/2026-04-26-managed-chromebook-pilot.md` (current prefilled run sheet)
- or a new dated file under `docs/test-runs/` using the same structure.

## Purpose
Validate that AudioProctor works on a real managed Chromebook under school-style policy enforcement and is ready for a live student pilot. "Managed Chromebook end-to-end validated" means a tester can launch a session from the force-installed extension, hear audio reliably, use the player controls, confirm lock-down behavior, recover from common interruptions, and end the session only with the correct exit word.

## Required equipment/accounts
- 1 managed Chromebook enrolled in the target Google Admin OU or pilot policy group
- Google Admin access, or an IT admin available to confirm force-install policy status
- 1 teacher account with at least one active upload
- 1 valid student access code for an active upload
- 1 known invalid code for negative-path testing
- 1 expired code for negative-path testing
- 1 deactivated-teacher code if available in the environment
- The correct exit word for the active test upload
- Stable Wi‑Fi, plus a way to temporarily disable and restore Wi‑Fi on the Chromebook
- Headphones or audible speakers so the tester can confirm real audio output
- A second person preferred for observing lock-down behavior and reading the exit word aloud

## Pre-test setup
1. Confirm the Chromebook is managed and signed into the correct student or test account.
2. Confirm the AudioProctor extension is assigned by policy to the device/user OU used for the pilot.
3. Confirm the active upload is not expired and has a known access code and exit word.
4. Prepare three negative-path codes before starting:
   - invalid code: does not exist
   - expired code: known expired upload
   - teacher deactivated code: only if a deactivated teacher/account exists in test data
5. Make sure Chromebook audio output is enabled and volume is audible.
6. Close unrelated apps/windows so focus-switch attempts during testing are deliberate and observable.
7. Record the Chromebook model and Chrome OS version in the test notes before starting. If either value cannot be retrieved, note that explicitly.
8. Decide who will record defects and severity during the run.

## Test matrix
Use one row per scenario. Mark Pass, Fail, or N/A and record severity only for failures. Minor issues are optional observations that do not fail a scenario but should still be logged in the notes/defect section.

| ID | Scenario | Steps | Expected result | Severity if failed |
|---|---|---|---|---|
| MC-01 | Extension installed automatically | Sign into the managed Chromebook and wait for policy sync if needed. Open Chrome extension UI and confirm AudioProctor is present without manual install. | Extension appears automatically on the managed device; tester does not need to sideload or install it manually. | Blocker |
| MC-02 | Popup opens successfully | Click the AudioProctor extension icon. | Popup opens cleanly, shows code entry UI, and is usable without console-level intervention or refresh tricks. | Blocker |
| MC-03 | Invalid code path | Enter a known invalid code before starting any real session. | Session does not start; popup shows a clear "code not found" style error and remains usable for another attempt. | Major |
| MC-04 | Expired code path | Enter a known expired code before starting any real session. | Session does not start; popup shows an expired-assessment error and remains usable for another attempt. | Major |
| MC-05 | Teacher deactivated path if available | Enter a code belonging to a deactivated teacher/account, if such a test record exists, before starting the real session. | Session does not start; popup shows an unavailable/deactivated-style error. If no test record exists, mark N/A. | Major |
| MC-06 | Valid code path | Enter a valid active access code and start the session. | No error is shown; session is accepted and player window launches. | Blocker |
| MC-07 | Player opens fullscreen | From a valid code entry, observe the launched player window. | Player opens in a fullscreen assessment window with no normal browser navigation visible and becomes the active session window. | Blocker |
| MC-08 | Offscreen audio actually audible | In the player, press Play if audio does not auto-start. Listen on speakers/headphones. | Audio is audibly heard from the Chromebook, not merely "playing" visually. | Blocker |
| MC-09 | Progress bar and time updates | Let audio play for at least 15-30 seconds. Watch current time, total time, and progress bar. | Current time advances, total duration is shown, and progress bar moves in sync with playback. | Major |
| MC-10 | Rewind control | While audio is playing, use rewind once or twice. | Playback jumps backward by about 10 seconds and continues from the earlier point. | Major |
| MC-11 | Speed controls | Change speed to a faster setting and then back to normal. | Playback speed changes as selected and remains audible/usable. | Major |
| MC-12 | Pause and resume | Press pause, then play again. | Audio pauses immediately and resumes successfully from the same position. | Major |
| MC-13 | System close button behavior | During an active session, click the Chrome OS window close button/X if visible. | Player window is treated as unauthorized close and reopens automatically; session continues. | Blocker |
| MC-14 | Switching focus / other window attempt | During an active session, try this minimum set: click another window if present, use Search/Launcher, use task switcher/overview, and attempt to open another Chrome tab or window. | Focus returns to the player or alternate windowing is effectively prevented; tester cannot leave the active assessment flow in a usable way. Record exact behavior observed for each attempt. | Blocker |
| MC-15 | Keyboard escape attempts | During an active session, try this minimum set: Escape, Tab, one function key, Ctrl+L, Ctrl+N, Ctrl+T, Alt+Tab if available, and one Search/Meta-based shortcut if available on the device. | Escape attempts do not exit the session or expose normal browser controls in a way that breaks the assessment. Record exact behavior observed for each attempt. | Blocker |
| MC-16 | Sleep/wake or lid close/open if feasible | If allowed by the device and test setting, close the lid briefly or trigger sleep, then wake/reopen the Chromebook. | After wake, the session is still recoverable: player is present or restored, and audio/playback can continue without requiring a full restart. Record exact behavior. | Major |
| MC-17 | Temporary Wi‑Fi disconnect and reconnect | Start a valid session, then temporarily disconnect Wi‑Fi and reconnect after a short interval. | Session does not silently exit. One of the following acceptable outcomes occurs: (a) playback continues if enough audio is buffered, (b) playback pauses/stalls but the player remains open and usable, or (c) playback errors visibly and the tester has a clear recovery path such as retrying or restarting the session. Fail if the session disappears, becomes misleadingly stuck, or recovers only through unexplained behavior. | Major |
| MC-18 | Exit word failure path | In the player, type an incorrect exit word and submit. | Session remains open, close is denied, and a clear incorrect-exit-word error appears. | Major |
| MC-19 | Exit word success path | Have the teacher/tester provide the correct exit word and submit it. | Session closes cleanly, fullscreen player exits, and device returns to normal browsing state. | Blocker |
| MC-20 | End-to-end rerun after interruption tests | After close-button, focus, sleep/wake, and Wi‑Fi tests, start one fresh valid session and complete a normal successful exit. | A normal student session can still be completed successfully after stress testing. | Blocker |

## Pass/fail criteria
A managed Chromebook is considered pilot-ready only if all of the following are true:
- All Blocker scenarios pass.
- No Major issue remains without a documented workaround that the pilot owner accepts explicitly.
- Audio is confirmed to be actually audible on the Chromebook during a real session.
- The player can be started with a valid code and ended only with the correct exit word.
- Negative paths behave correctly for invalid and expired codes, and for teacher deactivated codes if that path is available to test.
- Lock-down behavior is acceptable on the real device for close-button and focus-switch attempts. Brief visual flashes are acceptable only if the player immediately reclaims control and the tester cannot actually escape into normal browsing. If the student can meaningfully leave the assessment flow, classify as Blocker.
- Results for sleep/wake and Wi‑Fi interruption are captured, even if marked as a known limitation.

Use these severity levels when logging failures:
- Blocker — cannot run a real student session
- Major — session works but pilot confidence is weakened
- Minor — polish or docs issue only

Suggested fail classification:
- Blocker examples: extension not force-installed, popup will not open, valid code cannot launch session, fullscreen/lockdown fails badly, audio is not audible, correct exit word cannot close cleanly, unauthorized close escapes the session.
- Major examples: progress bar wrong, rewind/speed broken, invalid/expired handling unclear, Wi‑Fi or sleep recovery unreliable but workaround exists.
- Minor examples: wording confusion, missing doc detail, cosmetic UI issue that does not affect a live session.

## Notes/defect capture
Record each defect or observation with this template:

- Scenario ID:
- Pass / Fail / N/A:
- Severity: Blocker / Major / Minor
- Device model:
- Chrome OS version:
- Managed OU or policy group:
- Access code used:
- Time observed:
- Exact steps performed:
- Actual result:
- Expected result:
- Screenshot/photo/video captured: Yes/No
- Workaround found: Yes/No
- Owner / next action:

Tester notes:
- Record exact wording shown for invalid, expired, and deactivated-teacher errors.
- For focus-switch testing, note which Chrome OS gesture or key combo was attempted and what happened.
- For Wi‑Fi and sleep/wake tests, note whether playback resumed automatically, required user action, or required full session restart.
- If any scenario is skipped as not feasible in the environment, mark it N/A and explain why.
