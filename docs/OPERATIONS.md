# AudioProctor Operations Runbook

This runbook is written for repeatable execution by humans and Hermes.

## Scope
Covers:
- extension source attestation
- private->public extension mirror verification
- managed Chromebook pilot validation run
- release readiness sweep
- rollback references

## Constants (current)
- Private repo: https://github.com/vacuumboots/audioproctor
- Public extension repo: https://github.com/vacuumboots/audioproctor-extension
- Chrome Web Store extension ID: fcphbkffopenkinliokmlopfnglbcfdj
- Extension path in private repo: `extension/`

## 1) Extension mirror verification
Run from private repo root.

```bash
SPLIT_SHA=$(git subtree split --prefix=extension HEAD)
PUBLIC_SHA=$(git ls-remote https://github.com/vacuumboots/audioproctor-extension.git refs/heads/main | awk '{print $1}')
echo "SPLIT_SHA=$SPLIT_SHA"
echo "PUBLIC_SHA=$PUBLIC_SHA"
[ "$SPLIT_SHA" = "$PUBLIC_SHA" ] && echo "MIRROR_MATCH=yes" || echo "MIRROR_MATCH=no"
```

If `MIRROR_MATCH=no`, run sync workflow and re-check.

## 2) Attested extension artifact build
Run from private repo root.

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

Record values in `RELEASE_SOURCE_OF_TRUTH.md`.

## 3) Managed Chromebook pilot run
Primary checklist:
- `docs/managed-chromebook-pilot-checklist.md`

Current prefilled run sheet:
- `docs/test-runs/2026-04-26-managed-chromebook-pilot.md`

Procedure:
1. Execute MC-01..MC-20 in order.
2. Record Pass/Fail/N/A in run sheet.
3. Log defects with severity and repro.
4. Produce final verdict: Pilot ready Yes/No.

## 4) Release readiness sweep
Use this set before pushing demo-critical changes.

```bash
git status --short
node --check app/js/dashboard.js
node --check app/js/admin.js
node --check extension/popup.js
node --check extension/player.js
```

Then manually confirm:
- `CHANGELOG.md` updated for user-facing changes
- `docs/release-checklist.md` completed
- `RELEASE_SOURCE_OF_TRUTH.md` updated if extension changed
- `README.md` — verify file structure, feature list, and tier model match reality
- `docs/ROADMAP.md` — verify recently shipped items are checked off
- `.hermes/plans/` statuses updated if shipment scope changed

## 5) Extension sync workflow checks
Workflow file:
- `.github/workflows/sync-extension.yml`

Must be true:
- exists on `main`
- `PUBLIC_REPO_TOKEN` secret configured in private repo
- first sync completed successfully

Manual run (if needed):
- GitHub Actions -> "Sync extension to public repo" -> Run workflow

## 6) Rollback references
- Primary rollback branch: `stable`
- Production branch: `main`

Fast rollback pattern:
```bash
git checkout stable
git pull --ff-only origin stable
git checkout main
git reset --hard stable
git push --force origin main
```

Use only for urgent production recovery. Capture incident notes in changelog/docs afterward.

## 7) Definition of done for extension-impacting changes
A change that touches `extension/**` is not done until:
- [ ] code merged to `main`
- [ ] public mirror matches private extension subtree
- [ ] attestation row updated in `RELEASE_SOURCE_OF_TRUTH.md`
- [ ] managed Chromebook run sheet updated (for behavior-affecting changes)
- [ ] changelog entry added
