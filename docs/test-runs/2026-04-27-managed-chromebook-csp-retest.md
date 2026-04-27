# Managed Chromebook Retest — 2026-04-27

Status: COMPLETED
Owner: vacuumboots

## Scope
Targeted retest of the extension popup/session flow after the Manifest V3 CSP hardening change blocked the production redirect target `https://www.audioproctor.com`.

This was a scoped validation run for the 1.0.1 patch release, not a fresh full MC-01..MC-20 execution.

## Test metadata
- Date: 2026-04-27
- Tester: vacuumboots
- Deployment target: managed Chromebook
- Validation target: extension popup/session fetch flow
- Extension manifest version under test: 1.0.1
- Extension manifest version_name under test: v1.0.1
- Private branch under test: `dev`
- Key fix under test: allow `https://www.audioproctor.com` in manifest host permissions and CSP `connect-src`

## Defect being retested
- Prior behavior: popup fetch to `https://audioproctor.com/api/session?...` redirected to `https://www.audioproctor.com/api/session?...` and was blocked by CSP.
- Expected fixed behavior: popup can complete the session request successfully on the managed Chromebook.

## Retest steps
1. Install/load the updated extension build containing version 1.0.1.
2. Open the AudioProctor extension popup on the Chromebook.
3. Enter a valid access code.
4. Start the session.
5. Confirm the popup no longer throws the CSP connection error for `www.audioproctor.com`.

## Result
- Retest result: PASS
- Observed outcome: fix works on Chromebook; popup/session flow succeeds after adding `www.audioproctor.com` to the manifest allowlist.
- Blockers introduced: none reported
- Recommended next action: promote `dev` to `main`, verify public mirror sync, then publish 1.0.1 to the Chrome Web Store.
