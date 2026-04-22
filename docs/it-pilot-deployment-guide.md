# AudioProctor IT Pilot Deployment Guide

## Audience
This guide is for Google Workspace / Chromebook administrators rolling out AudioProctor to managed Chromebooks.

## Scope of this guide
This guide covers the current Chrome Web Store deployment path, pilot prerequisites, managed-device validation, smoke testing, rollback, and what an IT admin should verify during a rollout.

## Current deployment path
AudioProctor is published on the Chrome Web Store and should be deployed to managed Chromebooks through Google Admin Console by force-installing the extension by Store ID.

- Chrome Web Store listing: `https://chromewebstore.google.com/detail/audioproctor/fcphbkffopenkinliokmlopfnglbcfdj`
- Extension ID / Store ID: `fcphbkffopenkinliokmlopfnglbcfdj`

Use the Chrome Web Store listing as the standard deployment path for managed Chromebook rollout.
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
For the current rollout, IT should collect these items before deployment:

1. Chrome Web Store details
   - Extension ID / Store ID: `fcphbkffopenkinliokmlopfnglbcfdj`
   - Listing URL: `https://chromewebstore.google.com/detail/audioproctor/fcphbkffopenkinliokmlopfnglbcfdj`
2. Rollout scope notes
   - Intended student OU or pilot group
   - Any managed extension policy values used for the rollout
3. Smoke-test credentials/materials
   - One valid test access code
   - The corresponding exit word
4. Support contact
   - `hello@audioproctor.com`

## Install steps
1. Sign in to Google Admin Console.
2. Go to the Chrome management area for the users or devices included in the rollout (for example, Devices -> Chrome -> Apps & extensions -> Users & browsers, or the equivalent ChromeOS apps/extensions page used by your admin setup).
3. Select the pilot OU or pilot group only. Do not start with broad district-wide scope.
4. Add AudioProctor by Chrome Web Store ID: `fcphbkffopenkinliokmlopfnglbcfdj`.
5. Apply the extension policy to force-install for the selected rollout scope.
6. Save the policy.
7. On a managed Chromebook in scope, sign in with a managed account and allow policy sync to complete.
8. Confirm the AudioProctor extension appears without the student or teacher manually installing it.
Recommended rollout practice:
- Start with a small OU or test group first.
- Validate on one Chromebook before expanding the assignment.
- Record the extension ID and rollout date used in the pilot.

## How to verify install succeeded
Installation is successful when all of the following are true on a managed Chromebook in scope:

- The force-installed extension matches Chrome Web Store ID `fcphbkffopenkinliokmlopfnglbcfdj`
- The AudioProctor extension appears automatically after policy sync
- The user does not need to open `chrome://extensions` or load anything manually
- Clicking the extension opens the code-entry popup
- Entering a valid test code launches the fullscreen player

If the extension does not appear:
- Confirm the Chromebook is in the correct OU or group
- Confirm the policy is set to force-install, not allow-install
- Force a policy refresh and sign out/sign back in if needed
- Re-check that the extension is assigned by the correct Chrome Web Store ID (`fcphbkffopenkinliokmlopfnglbcfdj`)

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
To remove AudioProctor from rollout:

1. Return to Google Admin Console.
2. Open the same OU or pilot group where the extension was assigned.
3. Remove the AudioProctor extension assignment or change the policy so it is no longer force-installed.
4. Save the policy.
5. Sync policy on pilot Chromebooks or have users sign out and back in.
6. Confirm the extension is no longer installed or available to launch after policy sync completes.

Policy removal may not be immediate on every device. If the extension remains present temporarily, force a policy refresh or have the user sign out and back in before treating uninstall as failed.

If you are replacing the extension with a newer version, update the Store ID assignment policy and then revalidate on one managed Chromebook before broad rollout.

## Known limitations
- Chrome Web Store deployment is the current deployment method; local unpacked testing still uses `chrome://extensions` with the `extension/` folder.
- If you change the extension version, revalidate on one managed Chromebook before broad rollout.
- Lockdown behavior should be validated on the actual Chromebook model and ChromeOS version used in the pilot.

## Support contact
For rollout deployment help or smoke-test troubleshooting, contact:

- `hello@audioproctor.com`

When contacting support, include:
- school or division name
- pilot OU or group name
- Chromebook model and ChromeOS version
- the Chrome Web Store listing URL or Store ID
- exact failure step and any screenshots
