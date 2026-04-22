# AudioProctor IT Pilot Deployment Guide

## Audience
This guide is for Google Workspace / Chromebook administrators running a pre-Chrome-Web-Store AudioProctor pilot on managed Chromebooks.

## Scope of this guide
This guide is a founder-assisted pilot rollout checklist. It covers prerequisites, managed-device validation, smoke testing, rollback, and what an IT admin should verify during a pilot. It does not attempt to standardize the exact extension artifact or every Google Admin Console field, because those rollout-specific install details are currently supplied separately for each pilot.

## Current deployment path
Current pilot deployment path: AudioProctor uses a founder-assisted pilot deployment process. For each pilot rollout, AudioProctor supplies the exact extension package and the specific Google Admin Console inputs needed for that deployment. Chrome Web Store publication is planned, but it is not yet the standard deployment path.

Use this guide only for the current pilot path. Do not look for a Chrome Web Store ID as part of the live pilot rollout. Use only the package file and handoff notes supplied for the specific pilot rollout; do not substitute older packages or unofficial download links. This guide is intentionally high-level: it covers pilot prerequisites, validation, and rollback, while the exact artifact/package format remains rollout-specific until the longer-term deployment standard is finalized.
## Prerequisites
Before starting, make sure you have:

- Google Admin Console access with permission to manage Chrome apps and extensions
- A pilot OU or pilot user/device group selected for rollout
- At least one managed Chromebook enrolled in that pilot scope
- The current AudioProctor pilot extension package provided by AudioProctor
- A teacher test account with at least one active upload
- One valid student access code for that upload
- The matching exit word for the same upload
- Headphones or speakers available on the Chromebook for audio confirmation
- Network access from the Chromebook to:
  - `https://app.audioproctor.com`
  - `https://audioproctor.com`
  - `https://*.supabase.co/*` for signed audio playback URLs

## Files IT needs
For the current pilot rollout, IT should collect these items before deployment:

1. AudioProctor pilot extension package
   - This is the extension package provided directly by AudioProctor for pilot deployment.
   - Record the package date/version supplied with the pilot email or handoff notes.
   - Confirm with AudioProctor which exact package file should be uploaded in Google Admin Console for this pilot.
2. Pilot deployment notes
   - Version/date of the package
   - Intended pilot OU or pilot group
3. Smoke-test credentials/materials
   - One valid test access code
   - The corresponding exit word
4. Support contact
   - `hello@audioproctor.com`

## Install steps
1. Sign in to Google Admin Console.
2. Go to the Chrome management area for the users or devices included in the pilot (for example, Devices -> Chrome -> Apps & extensions -> Users & browsers, or the equivalent ChromeOS apps/extensions page used by your admin setup).
3. Select the pilot OU or pilot group only. Do not start with broad district-wide scope.
4. Use the package file and deployment notes supplied by AudioProctor for this rollout, including the exact Admin Console values required for that pilot.
5. Apply the extension policy to force-install for the selected pilot scope.
6. Save the policy.
7. On a pilot Chromebook, sign in with a managed account in the targeted scope and allow policy sync to complete.
8. Confirm the AudioProctor extension appears without the student or teacher manually installing it.
Recommended pilot practice:
- Start with a small OU or test group first.
- Validate on one Chromebook before expanding the assignment.
- Record the package version/date used in the pilot.

## How to verify install succeeded
Installation is successful when all of the following are true on a managed Chromebook in scope:

- The uploaded pilot package matches the current rollout package and its recorded package date/version
- The AudioProctor extension appears automatically after policy sync
- The user does not need to open `chrome://extensions` or load anything manually
- Clicking the extension opens the code-entry popup
- Entering a valid test code launches the fullscreen player

If the extension does not appear:
- Confirm the Chromebook is in the correct OU or group
- Confirm the policy is set to force-install, not allow-install
- Force a policy refresh and sign out/sign back in if needed
- Re-check that the package uploaded to Admin Console is the latest pilot package from AudioProctor

## How to run a smoke test
### 5-minute smoke test
Use one managed Chromebook in the pilot scope.

1. Install extension
   - Confirm the extension is present automatically from policy.
2. Enter test code
   - Open the extension and enter a known valid access code.
3. Confirm fullscreen opens
   - Verify the AudioProctor player opens as the active fullscreen assessment window.
4. Press play and hear audio
   - Press Play if needed and confirm audio is actually audible through headphones or speakers.
5. Verify exit word closes player
   - Enter the correct exit word and confirm the player closes and the Chromebook returns to normal use.

If any step fails, stop the broader rollout and keep the pilot limited until the issue is resolved.

Before expanding the pilot, run the full managed-device validation flow in [`docs/managed-chromebook-pilot-checklist.md`](managed-chromebook-pilot-checklist.md), especially the lock-down, focus-switch, close-button, sleep/wake, and Wi‑Fi interruption scenarios.

## Rollback / uninstall
To remove AudioProctor from the pilot:

1. Return to Google Admin Console.
2. Open the same OU or pilot group where the extension was assigned.
3. Remove the AudioProctor pilot package assignment or change the policy so it is no longer force-installed.
4. Save the policy.
5. Sync policy on pilot Chromebooks or have users sign out and back in.
6. Confirm the extension is no longer installed or available to launch after policy sync completes.

Policy removal may not be immediate on every device. If the extension remains present temporarily, force a policy refresh or have the user sign out and back in before treating uninstall as failed.

If the package is being replaced with a newer pilot build, remove or supersede the previous package assignment before validating the new build.

## Known limitations
- Chrome Web Store publication is planned but is not the current deployment method.
- Pilot updates are not yet distributed by Chrome Web Store ID, so IT should expect to replace or update the pilot package when AudioProctor provides a newer build.
- This guide is for managed Chromebook pilot deployment. Local developer testing still uses `chrome://extensions` with the unpacked `extension/` folder.
- Lockdown behavior should be validated on the actual Chromebook model and ChromeOS version used in the pilot.

## Support contact
For pilot deployment help, package replacement, or smoke-test troubleshooting, contact:

- `hello@audioproctor.com`

When contacting support, include:
- school or division name
- pilot OU or group name
- Chromebook model and ChromeOS version
- package version/date if known
- exact failure step and any screenshots
