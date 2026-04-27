# AudioProctor Extension Release Checklist

Use this runbook for any change that touches `extension/**`.

## Purpose
This checklist separates three different release milestones so they do not get conflated:
- `main` in the private repo = source of truth for shipped code
- `vacuumboots/audioproctor-extension` = public auditable mirror of `extension/`
- Chrome Web Store listing = actual managed-Chromebook deployment artifact

A release is not fully done until all three are updated and verified.

## Branch and repo rules
- Track work in the private repo: `https://github.com/vacuumboots/audioproctor`
- Public repo is mirror-only: `https://github.com/vacuumboots/audioproctor-extension`
- Start from `dev`
- Create a feature branch off `dev`
- Merge feature branch into `dev`
- Promote `dev` to `main` after validation
- Public repo sync happens from private `main`, not from `dev`

## 1) Create and scope the work
- [ ] Create or confirm a GitHub issue in the private repo.
- [ ] Confirm the change really belongs in `extension/**`.
- [ ] Note whether the change is behavior-affecting. If yes, plan to update the managed Chromebook run sheet after testing.

## 2) Create the branch
- [ ] Update local `dev`.
- [ ] Create a feature branch from `dev`.
- [ ] Keep commits focused on the extension change.

Example:
```bash
git checkout dev
git pull --ff-only origin dev
git checkout -b feat/extension-<short-description>
```

## 3) Implement in the private repo
- [ ] Make the code changes in `extension/` inside the private repo.
- [ ] Update docs in the same branch if user-visible behavior changed.
- [ ] Update `CHANGELOG.md` for notable user-facing changes.
- [ ] Confirm no secrets or internal-only data were added to extension files.

## 4) Local developer validation
This is for fast sanity testing only. It is not the formal managed-Chromebook acceptance test.

- [ ] Run syntax checks for touched JS files.
- [ ] Load unpacked from the private repo `extension/` directory in a regular Chrome browser.
- [ ] Verify the changed behavior locally.
- [ ] If the extension depends on API/session behavior, test against the app flow too.

Example syntax checks:
```bash
node --check extension/popup.js
node --check extension/player.js
```

Load unpacked:
1. Open `chrome://extensions`
2. Enable Developer mode
3. Click Load unpacked
4. Select the private repo `extension/` directory

Important:
- Use load-unpacked only for development validation.
- Do not treat a sideloaded build as the managed Chromebook release test.

## 5) Merge to `dev`
- [ ] Open a PR from the feature branch into `dev`.
- [ ] Review the diff for extension-only scope and accidental leaks.
- [ ] Merge into `dev` once ready.

## 6) Managed Chromebook acceptance test
This is the formal acceptance path for extension changes.

Required deployment method:
- Managed Chromebook
- Force-installed from the Chrome Web Store through Google Admin Console

Do not use load-unpacked for this acceptance step.

- [ ] Confirm the managed Chromebook receives the extension through policy.
- [ ] Run the full checklist in `docs/managed-chromebook-pilot-checklist.md`.
- [ ] Record results in `docs/test-runs/2026-04-26-managed-chromebook-pilot.md` or a new dated file under `docs/test-runs/`.
- [ ] Capture defects with severity and exact repro.
- [ ] Confirm final verdict is Pilot ready = Yes before promoting behavior-affecting changes.

Minimum expectation:
- MC-01..MC-20 executed in order
- Invalid, expired, and deactivated-teacher paths handled correctly if test data is available
- Valid code launches player successfully
- Audio is actually audible
- Close/focus/keyboard interruption behavior is acceptable
- Correct exit word closes the session cleanly

## 7) Promote `dev` to `main`
- [ ] Open PR from `dev` to `main`.
- [ ] Merge to `main` only after validation is complete.

Important:
- The public mirror sync workflow triggers from pushes to `main` that touch `extension/**`.
- Merging only to `dev` does not update the public repo.

## 8) Verify public mirror sync
Expected automation:
- Workflow: `.github/workflows/sync-extension.yml`
- Trigger: push to `main` for `extension/**` changes, or manual `workflow_dispatch`

- [ ] Confirm the sync workflow completed successfully.
- [ ] Confirm the public repo `main` matches the private `extension/` subtree.
- [ ] If it does not match, run the sync workflow manually and re-check.

Verification commands:
```bash
SPLIT_SHA=$(git subtree split --prefix=extension HEAD)
PUBLIC_SHA=$(git ls-remote https://github.com/vacuumboots/audioproctor-extension.git refs/heads/main | awk '{print $1}')
echo "SPLIT_SHA=$SPLIT_SHA"
echo "PUBLIC_SHA=$PUBLIC_SHA"
[ "$SPLIT_SHA" = "$PUBLIC_SHA" ] && echo "MIRROR_MATCH=yes" || echo "MIRROR_MATCH=no"
```

## 9) Build attested release artifact
Run from the private repo root after `main` contains the released extension code.

- [ ] Build the extension artifact from the extension subtree commit.
- [ ] Compute SHA-256.
- [ ] Record the artifact metadata in `RELEASE_SOURCE_OF_TRUTH.md`.

Commands:
```bash
SPLIT_SHA=$(git subtree split --prefix=extension HEAD)
SHORT_SHA=${SPLIT_SHA:0:7}
VERSION=$(node -e "const m=require('./extension/manifest.json'); process.stdout.write(m.version)")
ARTIFACT="/tmp/extension-v${VERSION}+git.${SHORT_SHA}.zip"
rm -f "$ARTIFACT"
git archive --format=zip --output "$ARTIFACT" "$SPLIT_SHA"
SHA256=$(sha256sum "$ARTIFACT" | awk '{print $1}')
printf "VERSION=%s\nSPLIT_SHA=%s\nARTIFACT=%s\nSHA256=%s\n" "$VERSION" "$SPLIT_SHA" "$ARTIFACT" "$SHA256"
```

## 10) Publish to the Chrome Web Store
This step is manual.

- [ ] Upload the new extension package/version in the Chrome Web Store dashboard.
- [ ] Submit/publish the update.
- [ ] Record the published version and publish timestamp.
- [ ] Update `RELEASE_SOURCE_OF_TRUTH.md` with store metadata.

Important:
- The Chrome Web Store release is separate from GitHub merge/sync.
- `main` and the public mirror may be newer than the currently published Web Store version until this step is completed.

## 11) Post-publish verification
- [ ] Confirm the Web Store listing shows the expected version.
- [ ] Confirm the public mirror still matches the released subtree.
- [ ] Confirm managed test devices receive the updated store version after policy refresh.
- [ ] Smoke test one real session on the managed path if the release changed runtime behavior.

## Definition of done
An extension update is done only when all are true:
- [ ] Code is merged to private `main`
- [ ] Public mirror matches private `extension/` subtree
- [ ] `RELEASE_SOURCE_OF_TRUTH.md` is updated
- [ ] Managed Chromebook run sheet is updated for behavior-affecting changes
- [ ] `CHANGELOG.md` is updated
- [ ] New version is published to the Chrome Web Store
- [ ] Post-publish verification is complete

## Fast reference summary
Use this sequence:
1. Issue in private repo
2. Feature branch off `dev`
3. Implement in private `extension/`
4. Local load-unpacked sanity test
5. PR/merge to `dev`
6. Managed Chromebook validation using force-installed Web Store build
7. PR/merge `dev` -> `main`
8. Verify public mirror sync
9. Build attested artifact and update release records
10. Manually publish to Chrome Web Store
11. Verify store rollout
