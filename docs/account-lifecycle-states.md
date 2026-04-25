# Teacher Account Lifecycle States

A single reference for every state a teacher account can be in, what it means for data access, and who can trigger each transition.

> **Last updated:** 2026-04-25
> **Authoritative for:** `api/`, `app/js/`, Supabase migrations 005–017
> **If this doc conflicts with code, the code wins — update this doc.**

---

## State Definitions

A teacher account is a row in `profiles`. Its effective state is determined by the combination of `is_deactivated`, `school_id`, `division_id`, `expires_at`, and the `get_effective_tier()` function.

| State | DB Condition | What it means |
|---|---|---|
| **Active** | `is_deactivated = false` AND (`expires_at IS NULL OR expires_at > now()`) | Normal operation. Teacher can upload, customize, and have sessions resolved. |
| **Trial** | `tier = 'premium'` AND `expires_at IS NOT NULL AND expires_at > now()` | New signups get 30 days of premium by default. `get_effective_tier()` returns `'premium'`. All premium features active. |
| **Detached** | `school_id IS NULL` AND `division_id IS NULL` | Teacher was removed from all orgs. Reverts to free tier (unless they have Teacher Premium or a trial). Uploads and session history are preserved. |
| **Deactivated** | `is_deactivated = true` | Explicit suspension by platform admin. All data preserved. Session access blocked. Uploads blocked (enforced by RLS). |
| **Lapsed** | `expires_at IS NOT NULL AND expires_at < now()` | Trial or subscription expired. `get_effective_tier()` returns `'free'`. Existing uploads work; new uploads blocked by quota. |
| **Deleted** | Row does not exist | All data permanently removed. Irreversible. |

---

## State Transition Diagram

```
┌─────────┐   detach    ┌──────────┐   reassign    ┌─────────┐
│ Active  │ ──────────→ │ Detached │ ────────────→ │ Active  │
└────┬────┘             └────┬─────┘               └────┬────┘
     │                       │                          │
     │ deactivate            │ (same transitions)       │
     ↓                       ↓                          │
┌─────────────┐  reactivate ┌─────────┐                │
│ Deactivated │ ←────────── │ Active  │                │
└──────┬──────┘             └─────────┘                │
       │                                                │
       │ (platform admin only)                          │ trial expires
       ↓                                                ↓
┌───────────┐          ┌────────┐   renew / extend   ┌─────────┐
│  Deleted  │ ←────────│ Lapsed │ ←───────────────── │ Active  │
└───────────┘          └────────┘                    └─────────┘
   ↑                        ↑
   │                        │
 self-delete            system
 (teacher)           (get_effective_tier)
```

---

## Transition Matrix

| From | To | Trigger | Who | Data Preserved? | Uploads Preserved? | Sessions Blocked? | Email Sent? |
|---|---|---|---|---|---|---|---|
| Active | Detached | School/division admin removes teacher | School admin, Division admin, Platform admin | Yes | Yes | No (codes still work) | No |
| Detached | Active | Platform admin reassigns teacher | Platform admin | Yes | Yes | No | Yes (reassignment email) |
| Active | Deactivated | Platform admin toggles `is_deactivated` | Platform admin | Yes | Yes | Yes | No |
| Deactivated | Active | Platform admin toggles `is_deactivated` | Platform admin | Yes | Yes | No | No |
| Active | Lapsed | `expires_at` passes | System (`get_effective_tier()`) | Yes | Yes | No | No |
| Trial | Lapsed | 30 days elapse since signup | System (`get_effective_tier()`) | Yes | Yes | No | No |
| Lapsed | Active | Admin approves request, subscription renews, trial extended | Platform admin, Stripe webhook | Yes | Yes | No | No |
| Active | Deleted | Teacher self-deletes | Teacher (self) | No | No | Yes | No |
| Active | Deleted | Admin deletes account | Platform admin | No | No | Yes | No |
| Deactivated | Deleted | Admin deletes deactivated account | Platform admin | No | No | Yes | No |

### Key rules

- **Deactivation takes precedence over everything.** A deactivated teacher cannot upload or have sessions resolved, regardless of tier.
- **Detachment takes precedence over tier.** A detached teacher always falls back to free tier because `school_id` and `division_id` are null.
- **Lapse is computed, not stored.** `get_effective_tier()` returns `'free'` when `expires_at < now()`. The `profiles.tier` column is not changed.

---

## Tier Resolution at Each State

`get_effective_tier(user_id)` is the single source of truth. It runs server-side and is called via RPC from the dashboard.

| State | What `get_effective_tier()` returns | Notes |
|---|---|---|
| Active + attached to school with division plan | `'division'` | Inherited from division |
| Active + attached to school with school plan | `'school'` | Inherited from school |
| Active + Teacher Premium paid | `'premium'` | Own purchased tier |
| Active + 30-day trial not expired | `'premium'` | Set by `ensureProfile()` on first login |
| Detached | `'free'` | No org to inherit from; own tier ignored unless it's premium via trial |
| Deactivated | Whatever profile/org says | But sessions are blocked before tier is checked |
| Lapsed | `'free'` | Regardless of what `profiles.tier` says |
| Deleted | N/A | No row exists |

---

## Edge Cases

### Detached + Deactivated

A teacher can be both detached AND deactivated. Deactivation takes precedence: sessions are blocked, uploads are blocked. If later reactivated, they remain detached and on free tier.

### Lapsed + Deactivated

Same precedence — deactivation blocks everything. Reactivating a lapsed teacher restores them to lapsed state (free tier) unless their expiry is also extended.

### Detached with >3 active uploads

Existing uploads remain playable until expiry. New uploads are blocked by the free-tier quota (3/month). The teacher sees the free-tier banner on their dashboard.

### School admin self-detach

Not possible through the UI. School admins can detach other teachers from their school, not themselves. They must be demoted to teacher first (by a division or platform admin).

### Org deletion cascade

Deleting a school or division does **not** delete teachers. Foreign key constraints use `ON DELETE SET NULL`, so teachers become detached automatically. Their uploads and session history remain intact.

---

## Data Preservation Rules

| Operation | Profile | Uploads | Sessions | Storage Files |
|---|---|---|---|---|
| Detach | Preserved | Preserved | Preserved | Preserved |
| Deactivate | Preserved | Preserved | Preserved | Preserved |
| Lapse | Preserved | Preserved | Preserved | Preserved |
| Self-delete | Removed | Removed | Removed | Removed |
| Admin-delete | Removed | Removed | Removed | Removed |

---

## Who Can Trigger What

| Action | School Admin | Division Admin | Platform Admin | Teacher (self) | System |
|---|---|---|---|---|---|
| Detach teacher from school | Yes | Yes | Yes | No | No |
| Detach teacher from division | No | Yes | Yes | No | No |
| Reassign teacher (school/division) | No | No | Yes | No | No |
| Deactivate / reactivate | No | No | Yes | No | No |
| Self-delete | No | No | No | Yes | No |
| Admin-delete | No | No | Yes | No | No |
| Trial / subscription lapse | No | No | No | No | Yes |

---

## Gaps and Known Limitations

These are documented for transparency. They may become implementation tasks.

### Gap 1: No email on deactivate/reactivate

Teachers are not notified when their account is suspended or restored. Acceptable for pilot scale.

### Gap 2: No email on trial expiry

Teachers discover expiry via the dashboard banner. No proactive email is sent.

### Gap 3: No renewal reminders

Automated 60/30/7-day emails before `expires_at` are not implemented.

---

## Resolved Items (no longer gaps)

### Deactivation upload blocking

`is_deactivated` is checked in `api/session.js` and enforced by RLS on `uploads` INSERT (migration 017). A deactivated teacher cannot create new uploads.

### Admin-initiated deletion

Platform admin can delete teacher accounts, schools, and divisions from `/admin.html`. Teacher deletion removes uploads, session events, storage files, the profile row, and the auth user. School/division deletion detaches teachers via `ON DELETE SET NULL` and removes invitations via `ON DELETE CASCADE`.

---

## Related Files

- `api/session.js` — checks `is_deactivated` before resolving access codes
- `api/account.js` — `delete-account` action for self-service deletion
- `api/org.js` — `detach-teacher` action
- `api/admin.js` — `reassign-teacher`, `toggle-deactivation`, `delete-teacher`, `delete-school`, `delete-division` actions
- `app/js/dashboard.js` — `handleUpload()`, quota display, trial banners
- `app/js/admin.js` — platform admin UI for teacher/division/school management
- `supabase/migrations/005_account_hierarchy.sql` — `get_effective_tier()`, org FKs
- `supabase/migrations/009_deactivation.sql` — `is_deactivated` column
- `supabase/migrations/016_auto_trial_and_requests.sql` — `expires_at` enhancements
- `supabase/migrations/017_block_deactivated_uploads.sql` — RLS policy blocking deactivated teachers from uploading
