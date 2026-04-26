# Dev vs Production Workflow

AudioProctor currently runs on a single stack: one Vercel deployment, one Supabase project, one domain. This document describes how to work safely within that constraint until a full staging environment is justified.

## The rule we can't enforce (but follow anyway)

GitHub branch protection rules require a Team organization account. We don't have one. This means **nothing technically prevents pushing straight to `main`**. The protection is discipline, not enforcement.

## Branch conventions

| Branch | Purpose | What goes here |
|---|---|---|
| `main` | Production | Only code that teachers see at `app.audioproctor.com`. |
| `stable` | Known good | Last commit that was verified working in production. A bookmark you can roll back to. |
| `dev` | Integration | Work-in-progress, experiments, features being tested. |
| `feature/*` | Short-lived | Individual changes branched from `dev`, merged back to `dev`. |

`stable` is not deployed anywhere. It exists purely as a safety net. After you merge to `main` and confirm production is healthy, fast-forward `stable` to `main`. If `main` breaks, you can instantly reset `main` back to `stable`.

## The workflow

### 1. Daily work happens on `dev`

```
git checkout dev
git pull origin dev
# ... edit ...
git add -A
git commit -m "feat: something"
git push origin dev
```

The `dev` branch deploys automatically to a Vercel preview URL. Use that URL to test changes in a real browser with real auth before they touch production.

### 2. Merging `dev` → `main`

Always open a pull request. Never push directly.

```
# On GitHub, open a PR: dev → main
# Review the diff yourself before clicking merge
```

The PR diff is your safety net. Read it like someone else wrote it. Ask:
- Does this change anything in `api/` that could break the extension?
- Does this migration touch the `profiles` or `uploads` tables?
- Did I leave a hardcoded test value or `console.log`?

### 3. Mark `stable` after verifying production

Once the PR merges to `main` and you've confirmed production is healthy (upload works, login works, extension plays audio):

```bash
git checkout stable
git merge --ff-only main   # fast-forward stable to main
git push origin stable
```

If `main` breaks and you need to roll back immediately:

```bash
git checkout main
git reset --hard stable    # main is now back to the last known good commit
git push origin main --force-with-lease
```

Then investigate the failure on `dev` and try again.

### 4. Hotfixes (rare)

If production is broken and needs an immediate fix:

```
git checkout main
git checkout -b hotfix/whatever
# ... fix ...
git commit -m "fix: ..."
git push origin hotfix/whatever
# Open PR hotfix → main, review, merge
# Then: merge main back into dev so they don't diverge
git checkout dev
git merge main
git push origin dev
```

Never let `main` and `dev` drift apart for more than a day or two.

## What is safe to push straight to `dev`

- CSS tweaks, copy changes, new marketing pages
- Adding a column to a SELECT query (read-only)
- New serverless functions that don't touch the database yet
- Dashboard UI changes that don't alter upload or auth logic

## What requires extra caution before merging to `main`

| Change | Risk | Mitigation |
|---|---|---|
| New Supabase migration | Can corrupt data or lock tables | Run the migration SQL manually in the Supabase SQL editor on a copy of production data first, or at least read the migration three times |
| RLS policy changes | Can expose private uploads or block legitimate access | Test with a second test account, not your admin account |
| Auth flow changes | Can lock teachers out | Test the full login → dashboard → upload flow in the preview deployment |
| Stripe webhook changes | Can miss payments or grant incorrect tiers | Use Stripe CLI to forward webhooks to your local machine first |
| Extension changes (player.js, popup.js) | Chrome Web Store review takes days; broken extension can't be rolled back instantly | Test locally with unpacked extension before any `main` merge |

## Database: one project, shared between dev and production

Until a second Supabase project is created, `dev` and `main` share the same database.

### Safe operations (no risk to production data)

- Adding new nullable columns
- Adding new tables
- Adding new indexes
- Creating new RLS policies that don't replace existing ones

### Dangerous operations (think three times)

- `ALTER TABLE ... DROP COLUMN` — deletes data permanently
- `UPDATE` without a `WHERE` clause — obvious but easy to do
- Changing `NOT NULL` constraints — fails if existing rows violate it
- Replacing an RLS policy with a stricter one — can silently break teacher uploads
- Any `DELETE` from `profiles`, `uploads`, or `auth.users`

### Before running a migration on the shared database

1. Run it against a fresh local database first (`supabase start` if using CLI, or a throwaway project).
2. If it's destructive, export a backup via Supabase Dashboard → Database → Backups.
3. Run the migration during low-traffic hours (evenings, weekends).
4. Verify immediately after: check that uploads still work, a teacher can still log in, the extension still plays audio.

## Preview deployments

Vercel generates a preview URL for every push to `dev` and for every pull request. The URL looks like:

```
https://audioproctor-git-dev-username.vercel.app
```

These previews point at the **same Supabase project** as production. This means:

- ✅ You can test auth, uploads, and the admin panel with real data
- ⚠️ Uploads made in preview are real uploads in the real database
- ⚠️ Stripe webhooks from test mode will hit production if you use live keys

Use preview URLs for UI and auth flow testing. Do not use them for destructive database testing.

## When to create a real staging environment

Set a calendar reminder for one week after the first real teacher signs up. At that point:

1. Create a second Supabase project (`audioproctor-staging`).
2. Apply all migrations to it.
3. Seed it with demo data.
4. Create a second Vercel project pointing `dev` branch at the staging Supabase.
5. Switch Stripe to test mode in the staging environment.

Until then, discipline + the PR diff review is enough.

## Pre-merge checklist (copy before merging to `main`)

```
- [ ] I have tested this change on the Vercel preview deployment
- [ ] If this touches api/, I tested the affected endpoint locally
- [ ] If this adds a migration, I ran it against a fresh database first
- [ ] If this touches auth, I tested login/logout and session persistence
- [ ] If this touches the extension, I tested with unpacked extension locally
- [ ] There are no hardcoded test values, debug logs, or commented-out code
- [ ] The diff on the PR page looks correct and minimal
```

## Emergency: something is broken in production

1. **Don't panic-push a fix.** Open a hotfix branch from `main`, fix it there, PR to `main`.
2. **If the break is in `api/`**, you can temporarily disable the broken endpoint by returning a 503 from the top of the function while you fix it.
3. **If the break is in auth**, check Supabase Auth dashboard first — outages there affect you even if your code is correct.
4. **If data looks wrong**, check the `admin_audit_log` table to see what changed and when.
5. After the fix merges to `main`, immediately merge `main` back into `dev`.

## Summary

| | Right now | After first real users |
|---|---|---|
| Branches | `main`, `stable`, `dev`, feature branches | Same |
| Enforced rules | None (discipline only) | Consider GitHub Team for enforcement |
| Database | One shared Supabase project | Separate staging Supabase project |
| Stripe | Live mode only | Live + test mode |
| Extension | Unpacked local testing | Same + staged rollout via Chrome Web Store |
| Safe fallback | `stable` bookmark + PR diff review | Full staging environment + PR reviews |

The goal is not perfect process. The goal is not breaking production on a Monday morning because you were experimenting on the weekend.
