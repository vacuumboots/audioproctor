# Shipment — Teacher Deactivate / Reactivate Toggle

> **Status:** IMPLEMENTED  
> **Priority:** High (highest deferred item from Shipment 3)  
> **Estimated effort:** 1 hour  
> **Commit:** `66895f8` — "feat: admin deactivate/reactivate toggle for teachers"

**Goal:** Platform admin can immediately suspend a teacher's access codes without deleting their data, and reactivate them later. School admin can detach teachers from their school; platform admin can deactivate any teacher account.

**Why now:** The `profiles.is_deactivated` column exists since migration 009, and `api/session.js` already returns 403 for deactivated teachers. The only missing piece is the admin UI and API toggle. This is a single-task build with immediate operational value.

---

## Current State

- `profiles.is_deactivated` exists (boolean, default false)
- `api/session.js` checks `is_deactivated` before generating signed URLs
- No `deactivate` action in `api/admin.js`
- No toggle in `app/js/admin.js`
- No visual distinction for deactivated teachers in the admin table

---

## Deliverables

1. `api/admin.js` — add `deactivate` POST action
2. `app/js/admin.js` — add deactivate/reactivate toggle button + visual state
3. `app/admin.html` — no changes needed (rendered by JS)

---

## Definition of Done

- [x] Platform admin clicks "Deactivate" → teacher's access codes immediately return 403
- [x] Platform admin clicks "Reactivate" → codes work again
- [x] Deactivated teachers are visually distinct (muted row, strikethrough, or badge)
- [x] Platform admin cannot deactivate themselves
- [x] Platform admin cannot deactivate another platform admin
- [x] Audit log entry written on every toggle
- [x] No changes needed for school/division admin dashboards (they use `detach`, not `deactivate`)

**Implementation note:** The toggle action was named `toggle-deactivation` (not `deactivate`) so a single endpoint handles both directions. The UI swaps the button label based on `is_deactivated`.

---

## Implementation

### Step 1: API action

Add to `api/admin.js` before the `seed-demo` action:

```js
if (action === 'deactivate') {
  const { userId, deactivated } = body;
  if (!userId || typeof deactivated !== 'boolean') {
    return res.status(400).json({ error: 'userId and deactivated boolean required' });
  }

  if (userId === user.id) {
    return res.status(403).json({ error: 'You cannot deactivate your own account' });
  }

  const { data: targetProfile } = await supabase
    .from('profiles')
    .select('is_deactivated, role')
    .eq('id', userId)
    .single();

  if (!targetProfile) return res.status(404).json({ error: 'User not found' });
  if (targetProfile.role === 'platform_admin') {
    return res.status(403).json({ error: 'Cannot deactivate a platform admin' });
  }

  const { error } = await supabase
    .from('profiles')
    .update({ is_deactivated: deactivated })
    .eq('id', userId);

  if (error) {
    console.error('deactivate failed:', error.message);
    return res.status(500).json({ error: 'Could not update activation state' });
  }

  audit(supabase, user.id, deactivated ? 'deactivate' : 'reactivate', 'teacher', userId,
    { is_deactivated: targetProfile.is_deactivated },
    { is_deactivated: deactivated });

  return res.status(200).json({ ok: true });
}
```

Also add `is_deactivated` to the `teachers` GET query `.select(...)`.

### Step 2: Admin UI

In `app/js/admin.js` `renderTeachers()`:

1. Add a deactivate/reactivate button in the Actions column
2. If `t.is_deactivated`, apply muted style to the email cell and append a `(deactivated)` label

```js
const deactBtn = t.is_deactivated
  ? `<button class="btn btn--ghost btn--small" onclick="toggleDeactivation('${t.id}', true)">Reactivate</button>`
  : `<button class="btn btn--small" style="border:1px solid var(--accent); color:var(--accent); background:transparent; cursor:pointer; font-family:'DM Sans',sans-serif; font-size:0.75rem; padding:0.3rem 0.75rem;" onclick="toggleDeactivation('${t.id}', false)">Deactivate</button>`;
```

Add function:

```js
async function toggleDeactivation(userId, currentlyDeactivated) {
  const action = currentlyDeactivated ? 'Reactivate' : 'Deactivate';
  if (!confirm(`${action} this teacher?`)) return;
  try {
    await adminApi('deactivate', 'POST', { userId, deactivated: !currentlyDeactivated });
    await loadTeachers();
  } catch (err) {
    alert(`Could not ${action.toLowerCase()}: ` + err.message);
  }
}
```

### Step 3: Commit and push

```bash
git add api/admin.js app/js/admin.js
git commit -m "feat: add teacher deactivate/reactivate toggle in platform admin"
git push origin main
```

---

## Verification

1. Deactivate a teacher → try their access code in the extension → should get 403
2. Reactivate the same teacher → code works again
3. Try to deactivate yourself → should get error
4. Try to deactivate a platform admin → should get error
5. Check `admin_audit_log` for `deactivate` / `reactivate` entries

---

## Risks

- **None.** This is entirely additive. The DB column exists, the session API already checks it, and the action is gated by platform_admin role.
