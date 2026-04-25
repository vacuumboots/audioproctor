# Shipment 3 — Admin Hardening for Real Account Lifecycle Implementation Plan

> **Status:** PARTIALLY IMPLEMENTED (2026-04-23)  
> **Commits:** 2556ef9 pushed to origin/main  
> **Migration:** 016 applied in Supabase

**Goal:** Platform admin can safely manage teacher accounts and org relationships without manual DB intervention. Tier fallback behavior is predictable and documented in code.

**Architecture:** Backend-policy and admin-UI work. Key data model: `profiles.school_id` / `division_id`, `get_effective_tier()`, `profiles.expires_at`, `teacher_requests`.

---

## Decisions Made During Implementation

1. **Detach-teacher behavior** — clearing `division_id` on detach: **YES**. Both `school_id` and `division_id` are cleared. If a platform admin wants a teacher in a division with no school, they use `reassign-teacher` with `schoolId=null` and `divisionId` set.

2. **Reassignment UI** — inline selects vs modal: **Modal with two dropdowns** (school + division). Keeps the table clean. Opened via "Reassign" button per row.

3. **Reassignment email content** — generic vs specific: **Specific**. Names the new school and division: "You have been assigned to Silverwood Junior High, Aspen Peaks School Division." Takes one extra query, much less confusing.

4. **Self-service detach** — school/division admin capabilities: Division admins can detach teachers. School admins can only detach teachers from their school. No school-to-division reassignment — that is an edge case handled by platform admin via direct DB edit if ever needed.

6. **Teacher Premium** — keep Stripe button or hide behind request form: **Keep the Stripe button**. The request flow is an alternative path, not a replacement.

7. **Trial expiry** — auto-downgrade after 30 days: **YES**. `get_effective_tier()` returns 'free' when `expires_at` has passed. Data is preserved indefinitely; only new uploads are blocked by free-tier limits.

8. **Request flow** — simple contact form vs in-app admin approval: **In-app request with approve/reject in `/admin.html`**. Platform admin sees request type (premium_trial, school_plan, division_plan) and an "Existing Teacher" tag.

---

## Deliverables — Completed

### Trial & Tier Enforcement
- [x] `supabase/migrations/016_auto_trial_and_requests.sql` — adds `profiles.expires_at`, `teacher_requests.teacher_id`, `teacher_requests.request_type`
- [x] `app/js/auth.js` `ensureProfile()` — new signups get `tier: 'premium'` + 30-day `expires_at`
- [x] `get_effective_tier()` updated — respects `expires_at`; expired trials fall back to 'free'
- [x] `app/js/dashboard.js` `loadQuota()` — shows trial status:
  - Expiring in ≤7 days: warning banner + "Request Extension" button
  - Expired: "Your 30-day premium trial has expired" + "Request Premium Access" button
  - Free (never trialed): existing Stripe "Upgrade to Premium" button

### In-App Request Flow
- [x] `app/dashboard.html` — new request modal with type selector + message field
- [x] `app/js/dashboard.js` — `openRequestModal()`, `submitRequest()` functions
- [x] `api/request-access.js` — accepts `teacherId` and `requestType` from authenticated teachers
- [x] `api/admin.js` `approve-request` — handles existing teachers (direct profile update, no invitation token)
- [x] `api/admin.js` `list-requests` — returns `teacher_id` and `request_type`
- [x] `app/js/admin.js` — requests table shows:
  - Type column: New Account / Premium Trial / School Plan / Division Plan
  - "Existing Teacher" tag on in-app requests
  - Approve button directly updates profile (no invite link for existing teachers)

### Reassignment
- [x] `api/admin.js` `reassign-teacher` — validates school/division exist, updates profile, logs audit, sends specific notification email naming the new org
- [x] `app/js/admin.js` — modal UI with cached school/division dropdowns
- [x] `api/org.js` `detach-teacher` — clears BOTH `school_id` and `division_id`
- [x] Reassignment email names specific school and division

### Bug Fixes
- [x] Fixed 3 broken `inviteUrl` lines in `api/admin.js` (`token=***` → `${invite.token}`)

---

## Deliverables — Deferred / Not Implemented

- [x] **Deactivate/reactivate toggle** (Task 1 from original plan) — Implemented 2026-04-25. `profiles.is_deactivated` exists, `api/admin.js` has `toggle-deactivation` action with self-targeting protection and audit logging, and `app/js/admin.js` shows Deactivate/Reactivate buttons per teacher row.
- [x] **Account lifecycle state matrix document** (Task 5 from original plan) — `docs/account-lifecycle-states.md` written and updated 2026-04-25. Captures the Trial → Lapsed → Free fallback flow, deactivation, and admin deletion paths.
- [ ] **README.md cross-link** for state matrix — deferred until the document stabilizes.

---

## Files Changed

- `supabase/migrations/016_auto_trial_and_requests.sql` (new)
- `app/js/auth.js`
- `app/js/dashboard.js`
- `app/dashboard.html`
- `app/js/admin.js`
- `api/request-access.js`
- `api/admin.js`
- `planning/roadmap.md`

---

## Tests and Verification (Manual)

- [ ] New signup gets premium badge and advanced options (30-day trial)
- [ ] After 30 days, trial teacher sees "expired" banner and "Request Premium Access"
- [ ] Request submission creates row in `teacher_requests` with `teacher_id` and `request_type`
- [ ] Admin sees request in `/admin.html` with correct type label and "Existing Teacher" tag
- [ ] Admin approves premium trial request → teacher's `profiles.tier` becomes 'premium', `expires_at` set to +30 days
- [ ] Admin approves school plan request → teacher's `profiles.school_id` updated
- [ ] Reassign teacher via modal → profile updated, teacher receives email naming new org
- [ ] Detach teacher → both `school_id` and `division_id` become null
- [ ] Access code still works after reassignment (session API not affected)
- [ ] Expired trial teacher's existing uploads still accessible, but new uploads blocked at 3/month

---

## Regression Hotspots

Retest the full lifecycle if any of these change:
- `api/admin.js` teacher-related actions (`reassign-teacher`, `approve-request`)
- `api/org.js` detach actions
- `get_effective_tier()` SQL function
- `profiles.expires_at` column behavior

---

## Risks and Tradeoffs

- **Trial backfill**: Existing teachers in the DB before migration 016 do NOT get a retroactive trial. This is intentional — there are currently no production teachers.
- **Request approval for school/division plans**: The admin must manually select the target school/division when approving a `school_plan` or `division_plan` request. The UI does not yet pre-populate or validate this selection beyond basic existence checks.
- **Email delivery**: Reassignment and approval emails are fire-and-forget. Failures are logged to console only. No retry queue.

---

## Next Recommended Work

If continuing on this track:
1. **Deactivate/reactivate toggle** — highest operational value. Blocks bad actors immediately.
2. **Account lifecycle state matrix document** — useful for onboarding future developers or support staff.

If switching to monetization:
4. **Stripe webhook expansion** — handle `past_due`, `unpaid`, `canceled` states beyond `checkout.session.completed` and `customer.subscription.deleted`.
5. **Renewal reminders** — automated 60/30-day emails before `expires_at`.
