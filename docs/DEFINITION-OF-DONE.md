# Definition of Done

One checklist. Two release types. No hunting across files.

Read top to bottom. Every step has a trigger so you know whether it happens automatically or you need to do it.

---

## 1. Code

- [ ] **Syntax**: All JS files pass `node --check` _(gate: pre-push + CI)_
- [ ] **Tests**: 93 tests pass `npm test` _(gate: CI on PR)_
- [ ] **Doc gate**: `scripts/pre-push` passes — no stale refs, no CHANGELOG gaps, no orphaned `require()` calls _(gate: pre-push + CI)_
- [ ] **Secrets**: No hardcoded keys, tokens, or connection strings in the diff _(manual review)_

## 2. Test

- [ ] **Local smoke**: Upload an MP3. Paste text with images. Create a code. Play it back. Verify the exit word. _(manual — 3 min)_
- [ ] **Admin pages**: Load admin, school-admin, division-admin. No console errors. _(manual — 1 min)_
- [ ] **Extension — unpacked**: Load unpacked from `extension/`. Test popup → player flow for both audio and text assessments. _(manual — 2 min)_

### Extension only

- [ ] **Managed Chromebook**: Run MC-01 through MC-20 from `docs/managed-chromebook-pilot-checklist.md`. Record results in `docs/test-runs/`. This is the formal acceptance gate — do not skip. _(manual — 15 min)_

## 3. Merge

- [ ] **CI green**: All checks passed on the PR _(gate: GitHub Actions)_
- [ ] **PR `dev` → `main`**: Merge only after validation is complete _(manual)_

## 4. Deploy

- [ ] **Vercel**: Automatic on push to `main`. Verify the deployment is healthy. _(auto + manual verify)_
- [ ] **Smoke on production**: One real session on `app.audioproctor.com` — login, upload, play. _(manual — 2 min)_

### Extension only

- [ ] **Public mirror synced**: `.github/workflows/sync-extension.yml` ran successfully on `main` push. Public repo `main` matches private `extension/` subtree. _(auto, verify in Actions tab)_
- [ ] **Attested artifact built**: Run the attestation commands from `docs/OPERATIONS.md` §2. Record VERSION, SPLIT_SHA, and SHA256 in `RELEASE_SOURCE_OF_TRUTH.md`. _(manual — 2 min)_
- [ ] **Published to Chrome Web Store**: Automatic when `extension/manifest.json` changes on `main`. Verify in the Actions tab that `publish-extension.yml` completed. Manual fallback: `workflow_dispatch` with optional version bump.
- [ ] **Store listing verified**: Confirm the Web Store shows the new version. Confirm managed test devices receive the update after policy refresh. _(manual — 3 min)_

## 5. Document

Do these last, after everything is deployed and verified:

- [ ] **CHANGELOG.md**: User-facing changes under the release version heading _(manual)_
- [ ] **ROADMAP.md**: Check off any shipped items. Update "Last reviewed" date. _(manual — 1 min)_
- [ ] **README.md**: If file structure, features, or tier model changed, update the README. _(manual — if applicable)_
- [ ] **AGENTS.md**: If new API endpoints, migrations, or pitfalls discovered, update AGENTS.md. _(manual — if applicable)_
- [ ] **USERSTEPS.md**: If the release requires operator action (Supabase SQL Editor, Stripe dashboard, Google Admin), add a checklist item. _(manual — if applicable)_
- [ ] **`.hermes/plans/`**: Archive or delete the plan file for this feature. _(manual)_

---

## Quick reference: what changed

| Before | After |
|---|---|
| `docs/release-checklist.md` (35 lines) | **Deleted.** Content merged here. |
| `docs/extension-release-checklist.md` (182 lines) | **Deleted.** Content merged here. |
| `docs/OPERATIONS.md` §4, §7 | **Trimmed.** Checklists removed; §1-3, §5-6, §8 kept as procedural reference (commands, not checklists). |
| `AGENTS.md` pitfalls #10 | **Kept** — it explains the gate, not the release process. |
| `docs/ROADMAP.md` | **Kept** — it's the plan, not the release process. |

This file is the single checklist. Run it top to bottom before every release.

---

## Extension-only: fast path

If you only changed `extension/` and nothing else:

1. Code → Test → Merge (sections 1-3 above)
2. Sync mirror verified _(auto)_
3. Build artifact + update RELEASE_SOURCE_OF_TRUTH
4. Publish to CWS
5. Document (CHANGELOG at minimum)

Skip Vercel smoke and admin checks if the web app was untouched.
