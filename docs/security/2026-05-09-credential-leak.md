# Security Incident — 2026-05-09

## Summary

A Supabase database connection string containing credentials was committed and
pushed to the private GitHub repository. The file was removed within minutes,
the commit was force-pushed over, and the database password was rotated. No
evidence of compromise.

## Timeline

| Time | Event |
|------|-------|
| ~20:11 | Three temporary files (`check_db.js`, `check_db2.js`, `supabase/migrations/run-025.mjs`) were present in the working tree, likely from a prior debugging session or automated worker run. `run-025.mjs` contained a full Supabase PgBouncer connection string including host, database name, username, and password. |
| 20:12 | `git add -A` in commit 1c430a7 picked up the files alongside legitimate changes. |
| 20:12 | Commit pushed to `main` on GitHub. |
| ~20:13 | Files discovered during review. Commit amended (2031bf2) to remove them. Force-pushed to overwrite remote history. |
| ~20:15 | Supabase database password rotated via Supabase Dashboard. `SUPABASE_SERVICE_ROLE_KEY` rotated as a precaution. |
| ~20:15 | Admin API and any service-role-dependent functions broke (expected — Vercel env var still pointed to old key). |
| Pending | Update `SUPABASE_SERVICE_ROLE_KEY` in Vercel environment variables to the new key. Redeploy. |

## Files involved

- `check_db.js` — empty file (0 bytes). Presumed debugging artifact.
- `check_db2.js` — empty file (0 bytes). Presumed debugging artifact.
- `supabase/migrations/run-025.mjs` — Node.js script that connected to Supabase via PgBouncer (pooler) and ran migration 025_platform_admin_rls.sql. Contained hardcoded credentials. **Credentials have been rotated; the file's contents are no longer valid.**

All three files have been removed from the repository and history.

## Credentials rotated

- Supabase database password
- Supabase `service_role` key

## Follow-up

- [ ] Update `SUPABASE_SERVICE_ROLE_KEY` in Vercel environment variables
- [ ] Redeploy Vercel (triggered automatically on env var change)
- [ ] Verify admin dashboard loads correctly
- [ ] Verify Stripe webhook endpoint functions
- [ ] Review `.gitignore` — add patterns for `check_db*.js`, `run-*.mjs`, and any credential-containing scripts
- [ ] Consider a pre-commit hook that scans for Supabase connection strings
