# Shipment — Account Lifecycle State Matrix Document

> **Status:** IMPLEMENTED  
> **Priority:** Medium (deferred from Shipment 3)  
> **Estimated effort:** 2–3 hours  
> **Type:** Documentation + minor code alignment  
> **Commits:** (to be filled on commit)  

**Goal:** Write `docs/account-lifecycle-states.md` — a single authoritative reference for every possible state a teacher account can be in, what it means for data access, who can trigger transitions, and what happens to uploads, sessions, and billing at each step. Update README to cross-link it.

**Why now:** The state machine is distributed across five migrations, four API files, and three frontend files. No single document exists. This causes ambiguity when answering support questions ("What happens if a teacher's trial expires but they had 5 active uploads?") and when onboarding future developers.

---

## Current State (the problem)

The rules exist but are scattered:

| Rule | Location |
|---|---|
| `is_deactivated` blocks session lookups | `api/session.js:78-86` |
| `get_effective_tier()` handles expired trials | `supabase/migrations/005_account_hierarchy.sql:62-95` |
| Detached teacher reverts to free tier | `planning/roadmap.md:393-400` |
| Deactivation is reversible, deletion is not | `planning/roadmap.md:416-431` |
| Self-delete blocked for school_admin | `api/account.js:65-76` |
| Admin-initiated deletion not yet built | `planning/roadmap.md:429-431` |
| `profiles.expires_at` added for trials | `supabase/migrations/016_auto_trial_and_requests.sql` |

There is no single place a developer or support person can read to understand the complete lifecycle. Questions that are currently hard to answer:

1. Can a deactivated teacher still upload new assessments?
2. What happens to a teacher's uploads when their school is detached from a division?
3. Does an expired trial block existing uploads or only new ones?
4. What's the exact difference between "detached" and "deactivated"?
5. Who can trigger each transition?

---

## Deliverables

1. **`docs/account-lifecycle-states.md`** — the canonical state matrix
2. **`README.md`** cross-link in the "Account Hierarchy" section
3. **Minor code alignment** if gaps are discovered during documentation (see Gap Analysis below)

---

## Document Structure (specification for `docs/account-lifecycle-states.md`)

### 1. State Definitions

Five states. Each gets a section with:
- **Definition** — one sentence
- **Data access** — what the teacher can and cannot do
- **Upload behavior** — existing uploads, new uploads
- **Session behavior** — can students still resolve codes?
- **Tier** — what `get_effective_tier()` returns
- **Visual indicator** — how the state appears in admin dashboards

The five states:

| State | DB Condition | Description |
|---|---|---|
| **Active** | `is_deactivated = false` AND effective tier is not 'free' by lapse | Normal operation. Teacher can upload, customize, and have sessions resolved. |
| **Detached** | `school_id IS NULL` AND `division_id IS NULL` | Teacher was removed from all orgs. Reverts to free tier. Uploads preserved. |
| **Deactivated** | `is_deactivated = true` | Explicit suspension by platform admin. All data preserved. Session access blocked. Upload access blocked. |
| **Lapsed** | `expires_at IS NOT NULL AND expires_at < now()` | Trial or subscription expired. `get_effective_tier()` returns 'free'. Existing uploads work; new uploads blocked by quota. |
| **Deleted** | Row does not exist | All data permanently removed. Irreversible. |

### 2. State Transition Diagram

ASCII diagram showing all valid transitions and who triggers them:

```
Active ──detach──→ Detached ──reassign──→ Active
   │                    │
   │ deactivate         │ (same transitions)
   ↓                    ↓
Deactivated ──reactivate──→ Active
   │
   │ (platform admin only)
   ↓
Deleted ←─────── self-delete (teacher)
Deleted ←─────── admin-delete (platform admin — not yet built)

Active ──trial expires──→ Lapsed ──renew/extend──→ Active
```

### 3. Transition Matrix Table

| From | To | Trigger | Who | Data Preserved? | Uploads Preserved? | Sessions Blocked? | Email Sent? |
|---|---|---|---|---|---|---|---|
| Active | Detached | School/division admin removes teacher | School admin, Division admin, Platform admin | Yes | Yes | No (codes still work) | No |
| Detached | Active | Platform admin reassigns teacher | Platform admin | Yes | Yes | No | Yes (reassignment email) |
| Active | Deactivated | Platform admin toggles `is_deactivated` | Platform admin | Yes | Yes | Yes | No (but should — see Gaps) |
| Deactivated | Active | Platform admin toggles `is_deactivated` | Platform admin | Yes | Yes | No | No (but should — see Gaps) |
| Active | Lapsed | `expires_at` passes | System (`get_effective_tier()`) | Yes | Yes | No | No (but should — see Gaps) |
| Lapsed | Active | Admin approves request, subscription renews, trial extended | Platform admin, Stripe webhook | Yes | Yes | No | No |
| Active | Deleted | Teacher self-deletes | Teacher (self) | No | No | Yes | No |
| Active | Deleted | Admin deletes account | Platform admin (not yet built) | No | No | Yes | No |

### 4. Tier Resolution at Each State

Document that `get_effective_tier()` is the single source of truth and show what it returns:

- **Active + attached to school with division plan** → `division`
- **Active + attached to school with school plan** → `school`
- **Active + Teacher Premium paid** → `premium`
- **Active + free trial not expired** → `premium` (or whatever tier is set)
- **Detached** → `free` (no org to inherit from)
- **Deactivated** → whatever tier the profile/org says, but sessions are blocked before tier is checked
- **Lapsed** → `free` (regardless of what `profiles.tier` says)
- **Deleted** → N/A (no row)

### 5. Edge Cases and Decisions

Document these explicitly:

- **Detached + deactivated**: A teacher can be both detached AND deactivated. Deactivation takes precedence (sessions blocked).
- **Lapsed + deactivated**: Same precedence — deactivation blocks everything.
- **Detached with >3 active uploads**: Existing uploads remain playable until expiry. New uploads blocked by free quota.
- **School admin self-detach**: Not possible — school admins can detach other teachers, not themselves. They must be demoted first.
- **Org deletion cascade**: Deleting a school or division does NOT delete teachers. FK constraints use `ON DELETE SET NULL`, so teachers become detached automatically.

### 6. Gaps Discovered

These are code-level findings to document alongside the state matrix. They may become follow-up tasks.

**Gap 1: Deactivation does not block uploads**
- `is_deactivated` is checked in `api/session.js` only.
- `handleUpload()` in `app/js/dashboard.js` does not check `is_deactivated`.
- A deactivated teacher can still create new uploads (though students can't play them).
- **Recommended fix:** Add `is_deactivated` check to `handleUpload()` and/or the upload RLS policy.

**Gap 2: No email on deactivate/reactivate**
- Teachers are not notified when their account is suspended or restored.
- This is acceptable for pilot scale but should be documented as a known limitation.

**Gap 3: No email on trial expiry**
- Teachers discover their trial expired when they see the banner on next dashboard load.
- No proactive email is sent.
- Also acceptable for pilot but worth noting.

**Gap 4: Admin-initiated deletion not built**
- `planning/roadmap.md` lists this as a Stage 6 deferred item.
- Document it as "not yet implemented; platform admin must contact developer for manual deletion."

---

## Code Alignment Tasks

These are minor fixes discovered during the documentation pass. They do not need a separate shipment.

### Task A: Block uploads for deactivated teachers

In `app/js/dashboard.js`, add a check at the start of `handleUpload()`:

```js
// Before uploading, verify the teacher account is not deactivated
const { data: me } = await supabaseClient
  .from('profiles')
  .select('is_deactivated')
  .eq('id', currentUser.id)
  .single();
if (me?.is_deactivated) {
  alert('Your account has been suspended. Contact your administrator.');
  return;
}
```

Or, preferably, add an RLS policy on `uploads` INSERT that checks `profiles.is_deactivated = false` for the teacher. This is more robust because it blocks API callers too.

**Recommended approach:** RLS policy. One-line addition to existing `enforce_upload_quota` policy or a new standalone policy.

```sql
CREATE POLICY block_deactivated_uploads ON uploads
  FOR INSERT TO authenticated
  WITH CHECK (
    teacher_id = auth.uid()
    AND EXISTS (
      SELECT 1 FROM profiles
      WHERE id = auth.uid() AND is_deactivated = false
    )
  );
```

### Task B: Add `is_deactivated` to admin teachers list

In `api/admin.js` `teachers` GET query, `is_deactivated` is likely already selected (verify during implementation). If not, add it.

In `app/js/admin.js` `renderTeachers()`, show a "Deactivated" badge in the tier column or email column when `t.is_deactivated` is true.

---

## Verification

- [x] `docs/account-lifecycle-states.md` exists and covers all 5 states
- [x] All 7 transitions are documented with trigger, actor, and data rules
- [x] Tier resolution is explained with reference to `get_effective_tier()`
- [x] All 4 edge cases are documented
- [x] All 4 gaps are documented (even if not fixed)
- [x] `README.md` has a cross-link under "Account Hierarchy" section
- [x] Code alignment tasks A and B are either completed or moved to `.hermes/plans/` as follow-ups
- [ ] A second developer can read the doc and correctly answer: "What happens to a teacher's uploads when they are deactivated?"

---

## Risks

- **Low risk.** This is primarily documentation. The only code changes are minor defensive checks.
- **Gap 1 (uploads while deactivated)** is a real bug but low-severity — a deactivated teacher uploading unplayable assessments is harmless.
- **No deployment risk** — no schema changes, no API route changes.

---

## Out of Scope

These are NOT part of this shipment:

- Building admin-initiated deletion UI
- Adding email notifications for deactivate/reactivate/lapse
- Fixing the Stripe webhook expansion (separate plan exists)
- Any schema migrations

---

## Next Recommended Work After This

1. **Deactivate/reactivate toggle** — still the highest operational-value build. The state matrix doc makes the toggle's behavior obvious to anyone reading the code.
2. **Stripe webhook expansion** — handle `past_due` and `unpaid` states so the "Lapsed" transition is triggered correctly.
