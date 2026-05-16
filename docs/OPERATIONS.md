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

**Checklist moved to [`docs/DEFINITION-OF-DONE.md`](DEFINITION-OF-DONE.md).**  
Run through that file before every release.

Quick syntax check (still useful for fast local validation):

```bash
node --check app/js/*.js
node --check extension/popup.js
node --check extension/player.js
```

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

**Moved to [`docs/DEFINITION-OF-DONE.md`](DEFINITION-OF-DONE.md).**  
See the "Extension only" rows in each section of that file.

## 8) Supabase key rotation

The `SUPABASE_SERVICE_ROLE_KEY` lives in three places. Rotating it in Supabase
breaks the other two until they're manually updated.

**Procedure:**

1. Rotate the key in Supabase: Project Settings → API → `service_role` key → Rotate
2. Copy the new key immediately — it won't be shown again
3. Update Vercel (must be done per-environment — combining environments fails):
   ```bash
   vercel env rm SUPABASE_SERVICE_ROLE_KEY production
   vercel env add SUPABASE_SERVICE_ROLE_KEY   # select Production, Preview
   vercel env add SUPABASE_SERVICE_ROLE_KEY   # select Development
   ```
4. Update `.env.local` with the new key
5. Force redeploy: `vercel redeploy <latest-deployment-url>` (env var changes do
   not always trigger an automatic redeploy)
6. Verify: open the admin dashboard, confirm divisions/schools/teachers load

**What breaks when the key is rotated without these steps:**
- Admin API (`/api/admin`) — all actions return 403
- Stripe webhook — subscription events silently fail
- Session API — access code lookups fail
- Any endpoint using the service role client

See `docs/security/2026-05-09-credential-leak.md` for the full incident record.
