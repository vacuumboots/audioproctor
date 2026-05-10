# Security Incident — 2026-05-09

## Summary

A Supabase database connection string containing credentials was committed and
pushed to the private GitHub repository. The file was removed within minutes,
the commit was force-pushed over, and all exposed credentials were rotated. No
evidence of compromise.

## Timeline

| Time | Event |
|------|-------|
| ~20:11 | Three temporary files (`check_db.js`, `check_db2.js`, `supabase/migrations/run-025.mjs`) were present in the working tree, likely from a prior debugging session or automated worker run. `run-025.mjs` contained a full Supabase PgBouncer connection string including host, database name, username, and password. |
| 20:12 | `git add -A` in commit 1c430a7 picked up the files alongside legitimate changes. |
| 20:12 | Commit pushed to `main` on GitHub. |
| ~20:13 | Files discovered during review. Commit amended (2031bf2) to remove them. Force-pushed to overwrite remote history. |
| ~20:15 | Supabase database password rotated via Supabase Dashboard. `SUPABASE_SERVICE_ROLE_KEY` rotated as a precaution. |
| ~20:15 | Admin API and all service-role-dependent functions broke (expected — Vercel env var still pointed to old key, and Supabase rejected queries using it). |
| ~20:30 | `SUPABASE_SERVICE_ROLE_KEY` updated in Vercel for Production, Preview, and Development environments via `vercel env rm` / `vercel env add`. |
| ~20:32 | `.env.local` updated with new key for local development. |
| ~20:35 | Vercel redeployed (`vercel redeploy`) to pick up the new env var. Env var changes alone did not trigger an automatic redeploy — manual redeploy was required. |
| ~20:36 | Admin dashboard verified working. |

## Files involved

- `check_db.js` — empty file (0 bytes). Presumed debugging artifact.
- `check_db2.js` — empty file (0 bytes). Presumed debugging artifact.
- `supabase/migrations/run-025.mjs` — Node.js script that connected to Supabase via PgBouncer (pooler) and ran migration 025_platform_admin_rls.sql. Contained hardcoded credentials. **Credentials have been rotated; the file's contents are no longer valid.**

All three files have been removed from the repository and history. Patterns added to `.gitignore` to prevent recurrence.

## Credentials rotated

- Supabase database password
- Supabase `service_role` key (`SUPABASE_SERVICE_ROLE_KEY`)

## Lesson learned

**Rotating a Supabase key requires updating every place it's stored.** The
`SUPABASE_SERVICE_ROLE_KEY` lives in three places:

1. Vercel environment variables (Production, Preview, Development)
2. `.env.local` (local development)
3. Supabase itself (where the key is generated)

Rotating in Supabase immediately breaks #1 and #2 until they're manually
updated. Vercel env var changes do **not** always trigger an automatic
redeploy — a manual `vercel redeploy` may be required.

See `docs/OPERATIONS.md` for the documented key rotation procedure.
