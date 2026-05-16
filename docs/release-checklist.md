# AudioProctor Release Checklist

> **Merged into [`docs/DEFINITION-OF-DONE.md`](DEFINITION-OF-DONE.md).**  
> This file is kept for historical reference. Use DEFINITION-OF-DONE.md for all releases.

## Historical content follows

## 1) Code and behavior validation
- [ ] Run syntax checks for touched JS files (`node --check <file>`).
- [ ] Verify upload flow end-to-end for MP3.
- [ ] Verify upload flow end-to-end for WAV -> MP3 conversion.
- [ ] Confirm dashboard shows expected filename and metadata after upload.
- [ ] Confirm extension playback works with newly created access code.
- [ ] Confirm exit-word flow closes player as expected.

## 2) Limits, quotas, and policy alignment
- [ ] Confirm max upload limit copy matches enforced logic (currently 50 MB).
- [ ] Confirm free-tier quota messaging matches actual enforcement.
- [ ] Confirm deactivated teacher behavior is still blocked where expected.

## 3) Extension mirror/public repo sync
- [ ] If this release touches `extension/**`, complete `docs/extension-release-checklist.md`.
- [ ] Confirm `.github/workflows/sync-extension.yml` exists on `main`.
- [ ] Confirm `PUBLIC_REPO_TOKEN` secret is set in private repo.
- [ ] If first sync, run workflow manually (`workflow_dispatch`) and verify success.
- [ ] Confirm public repo `main` reflects current `extension/` content.

## 4) Docs and operational hygiene
- [ ] Update `CHANGELOG.md` with notable user-facing changes.
- [ ] Update relevant docs/README sections when behavior changes.
- [ ] Sweep `.hermes` status notes for stale or contradictory status text.
- [ ] Ensure no placeholder secrets/tokens appear in committed files.

## 5) Deployment and post-deploy smoke test
- [ ] Push/merge to `main`.
- [ ] Verify Vercel deployment is healthy.
- [ ] Smoke test login -> upload -> extension playback on production domain.
- [ ] Validate admin page loads and critical actions render without console errors.
