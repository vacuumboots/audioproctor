# Shipment 3 — Admin Hardening for Real Account Lifecycle Implementation Plan

> For Hermes: Use subagent-driven-development skill to implement this plan task-by-task.

**Goal:** Platform admin can safely manage teacher accounts and org relationships without manual DB intervention. Deactivated teachers are blocked from sessions, reassignment preserves upload history, and tier fallback behavior is predictable and documented.

**Architecture:** This shipment is backend-policy and admin-UI work, not a feature build. The key data model already exists: `profiles.is_deactivated` (migration 009), `profiles.school_id` / `division_id`, `get_effective_tier()`, and `api/session.js` already blocks deactivated teachers. What is missing is the admin API surface and UI to toggle deactivation, reassign teachers between schools, reassign schools between divisions, and document the exact state matrix so future admins do not have to guess at fallback behavior. The existing `api/org.js` `detach-teacher` and `detach-school` actions already handle tier-change emails; this plan extends that pattern to reassignment and adds the missing deactivate/reactivate flow.

**Tech Stack:** Vercel serverless (`api/admin.js`, `api/org.js`), Supabase (`profiles`, `schools`, `divisions`), vanilla JS admin UI (`js/admin.js`, `js/school-admin.js`, `js/division-admin.js`), markdown docs.

---

## Current context and assumptions

Known current state from repo inspection:
- `profiles.is_deactivated` exists (migration 009) and `api/session.js` already returns 403 for deactivated teachers.
- `api/admin.js` has `teachers` GET, `set-tier`, `set-notes`, `set-role`, and `attach-teacher` actions.
- `api/org.js` has `detach-teacher` and `detach-school` POST actions that clear `school_id` / `division_id` and send tier-change emails via Resend.
- `js/school-admin.js` has a working `detachTeacher()` UI button.
- `js/division-admin.js` has working `detachSchool()` and `removeSchoolAdmin()` UI buttons.
- There is NO `deactivate` or `reactivate` action in `api/admin.js`.
- There is NO deactivation toggle in the platform admin UI (`js/admin.js`).
- There is NO teacher reassignment action (moving a teacher from School A to School B without detaching first).
- There is NO school reassignment action (moving a school from Division A to Division B).
- The `attach-teacher` action in `api/admin.js` can set `school_id` and `division_id`, but it does not validate the new org exists, does not notify the teacher, and does not handle the case where a teacher is moved (as opposed to newly attached).
- No written state matrix exists for account lifecycle states.

This plan assumes Shipment 3 should deliver four things:
1. deactivation/reactivation toggle in platform admin UI with API enforcement
2. teacher reassignment between schools (platform admin)
3. school reassignment between divisions (platform admin)
4. a documented state matrix for account lifecycle

This plan does NOT include admin-initiated account deletion. Per the prioritized shipping order, deletion should be a separate shipment only after the deactivate flow is operationally stable.

---

## Deliverables

1. `deactivate` POST action in `api/admin.js` with audit logging
2. Deactivation/reactivation toggle in platform admin teacher table (`js/admin.js`)
3. `reassign-teacher` POST action in `api/admin.js` with tier-change email
4. Teacher reassignment UI in platform admin (`js/admin.js`)
5. `reassign-school` POST action in `api/admin.js`
6. School reassignment UI in platform admin (`js/admin.js`)
7. Documented state matrix under `docs/account-lifecycle-states.md`
8. Cross-link state matrix in `README.md`

---

## Definition of done

Shipment 3 is done only when all of these are true:
- Platform admin can click a button to deactivate a teacher; the teacher's access codes immediately stop working
- Platform admin can reactivate a deactivated teacher; their codes work again
- Deactivated teachers are visually distinct in the admin teacher table
- Platform admin can reassign a teacher to a different school (or division) in one action; upload history is preserved
- Platform admin can reassign a school to a different division in one action; the school's teachers inherit the new division tier correctly
- Reassignment triggers a notification email to the affected teacher(s) when tier changes
- `get_effective_tier()` produces predictable results after any attach/detach/reassign/deactivate/reactivate sequence
- A written state matrix document exists and is accurate against the current code

---

## Files likely to change

Backend:
- Modify: `api/admin.js` — add `deactivate`, `reassign-teacher`, `reassign-school` actions
- Modify: `api/org.js` — possibly extend `detach-teacher` to share logic with reassignment
- Verify: `api/session.js` — already blocks deactivated teachers; confirm no changes needed

Frontend:
- Modify: `js/admin.js` — add deactivate toggle, reassign dropdowns, visual states
- Modify: `admin.html` — possibly add new column headers or toolbar elements
- Possibly modify: `js/school-admin.js` — if school admin needs reassignment UI (out of scope for platform admin task, but note if needed)
- Possibly modify: `js/division-admin.js` — if division admin needs reassignment UI

Database:
- No new migrations required if `is_deactivated` already exists
- Verify `profiles.school_id`, `profiles.division_id`, `schools.division_id` are correct

Documentation:
- Create: `docs/account-lifecycle-states.md`
- Modify: `README.md` — cross-link state matrix and describe admin lifecycle capabilities

---

## Task 1: Add deactivate/reactivate action and platform admin UI

**Objective:** Close the gap between the `is_deactivated` column and an actual admin button.

**Files:**
- Modify: `api/admin.js`
- Modify: `js/admin.js`
- Modify: `admin.html`

**Step 1: Add `deactivate` POST action to `api/admin.js`**

Insert a new action block before `seed-demo`:

```js
if (action === 'deactivate') {
  const { userId, deactivated } = body;
  if (!userId || typeof deactivated !== 'boolean') {
    return res.status(400).json({ error: 'userId and deactivated boolean required' });
  }

  // Prevent self-deactivation
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

**Step 2: Add `is_deactivated` to the `teachers` GET query**

In the `teachers` action `.select(...)`, add `is_deactivated` to the column list if it is not already present.

**Step 3: Add deactivate/reactivate UI in `js/admin.js`**

In `renderTeachers()`, add an "Actions" column after "Notes / Flags":

1. Add `<th>Actions</th>` to the header.
2. For each teacher row, render:
   - A toggle button: "Deactivate" if `!t.is_deactivated`, "Reactivate" if `t.is_deactivated`
   - If deactivated, apply a strikethrough or muted style to the email cell and append a `(deactivated)` label.
3. The button calls `toggleDeactivation(t.id, t.is_deactivated)`.

**Step 4: Add `toggleDeactivation()` function**

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

**Step 5: Verify no behavior change for non-admins**

- School admin and division admin dashboards should not show deactivation toggles.
- The `api/admin.js` action already requires `platform_admin`.

**Step 6: Commit**

```bash
git add api/admin.js js/admin.js admin.html
git commit -m "feat: add teacher deactivate/reactivate toggle in platform admin"
```

---

## Task 2: Add teacher reassignment between schools

**Objective:** Let platform admins move a teacher from one school to another (or to a division directly) without a manual detach-then-attach dance.

**Files:**
- Modify: `api/admin.js`
- Modify: `js/admin.js`

**Step 1: Add `reassign-teacher` POST action to `api/admin.js`**

```js
if (action === 'reassign-teacher') {
  const { userId, schoolId, divisionId } = body;
  if (!userId) return res.status(400).json({ error: 'userId required' });

  const { data: prevProfile } = await supabase
    .from('profiles')
    .select('school_id, division_id, role, is_deactivated')
    .eq('id', userId)
    .single();

  if (!prevProfile) return res.status(404).json({ error: 'User not found' });
  if (prevProfile.role === 'platform_admin') {
    return res.status(403).json({ error: 'Cannot reassign a platform admin' });
  }

  // Validate that the new school exists if provided
  if (schoolId) {
    const { data: school } = await supabase.from('schools').select('id').eq('id', schoolId).single();
    if (!school) return res.status(404).json({ error: 'School not found' });
  }

  // Validate that the new division exists if provided
  if (divisionId) {
    const { data: division } = await supabase.from('divisions').select('id').eq('id', divisionId).single();
    if (!division) return res.status(404).json({ error: 'Division not found' });
  }

  const { error } = await supabase
    .from('profiles')
    .update({ school_id: schoolId || null, division_id: divisionId || null })
    .eq('id', userId);

  if (error) {
    console.error('reassign-teacher failed:', error.message);
    return res.status(500).json({ error: 'Could not reassign teacher' });
  }

  audit(supabase, user.id, 'reassign_teacher', 'teacher', userId,
    { school_id: prevProfile.school_id, division_id: prevProfile.division_id },
    { school_id: schoolId || null, division_id: divisionId || null });

  // Notify teacher if they have an email and the org changed
  const { data: authUser } = await supabase.auth.admin.getUserById(userId);
  const teacherEmail = authUser?.user?.email;
  if (teacherEmail && (prevProfile.school_id !== schoolId || prevProfile.division_id !== divisionId)) {
    // Fire-and-forget email
    sendReassignmentEmail(teacherEmail, { schoolId, divisionId }).catch(err => {
      console.error('reassignment email failed:', err.message);
    });
  }

  return res.status(200).json({ ok: true });
}
```

**Step 2: Add `sendReassignmentEmail()` helper**

Add a small helper near the bottom of `api/admin.js` (or in a shared email helper if Shipment 2 created one):

```js
async function sendReassignmentEmail(teacherEmail, { schoolId, divisionId }) {
  const { Resend } = require('resend');
  const resend = new Resend(process.env.RESEND_API_KEY);
  await resend.emails.send({
    from: 'AudioProctor <hello@audioproctor.com>',
    to: teacherEmail,
    subject: 'Your AudioProctor organization has changed',
    text: [
      `Hi,`,
      ``,
      `Your account has been reassigned to a new organization on AudioProctor.`,
      `Your uploads and access codes remain intact.`,
      `Your plan tier may have changed based on the new organization's subscription.`,
      ``,
      `If you believe this was done in error, please contact your administrator.`,
      ``,
      `— AudioProctor`,
    ].join('\n'),
  });
}
```

**Step 3: Add reassignment UI in `js/admin.js`**

In `renderTeachers()`, add a "Reassign" button in the Actions column that opens a small inline form or a `prompt()` for the target school/division ID.

Simpler approach for MVP:
- Add a small dropdown in each teacher row: a `<select>` populated with all schools and divisions, plus a "Move" button.
- Or: a single reassignment flow triggered by a button that calls `prompt("Enter new school ID (or leave blank):")` and `prompt("Enter new division ID (or leave blank):")`.

Given the admin UI already uses inline controls, the cleanest approach is:

1. Add a `<select>` for school and a `<select>` for division in the Actions column.
2. Pre-populate the selects with the current values.
3. Add a "Save" button that calls `reassignTeacher(t.id, schoolSelect.value, divisionSelect.value)`.

Since the admin page does not currently load a full school/division list into JS memory for the teachers tab, you may need to cache `allSchools` and `allDivisions` from the existing `loadSchools()` / `loadDivisions()` calls, or fetch them on demand.

**Recommended minimal approach:**
- Cache `allSchools` and `allDivisions` in `js/admin.js` when the respective tabs load.
- In `renderTeachers()`, render two small selects and a Save button in the Actions cell.

**Step 4: Add `reassignTeacher()` function**

```js
async function reassignTeacher(userId, schoolId, divisionId) {
  if (!confirm('Reassign this teacher?')) return;
  try {
    await adminApi('reassign-teacher', 'POST', { userId, schoolId: schoolId || null, divisionId: divisionId || null });
    await loadTeachers();
  } catch (err) {
    alert('Could not reassign: ' + err.message);
  }
}
```

**Step 5: Commit**

```bash
git add api/admin.js js/admin.js
git commit -m "feat: add teacher reassignment between schools and divisions"
```

---

## Task 3: Add school reassignment between divisions

**Objective:** Let platform admins move a school from one division to another without detaching all teachers first.

**Files:**
- Modify: `api/admin.js`
- Modify: `js/admin.js`

**Step 1: Add `reassign-school` POST action to `api/admin.js`**

```js
if (action === 'reassign-school') {
  const { schoolId, divisionId } = body;
  if (!schoolId) return res.status(400).json({ error: 'schoolId required' });

  const { data: prevSchool } = await supabase
    .from('schools')
    .select('division_id, name')
    .eq('id', schoolId)
    .single();

  if (!prevSchool) return res.status(404).json({ error: 'School not found' });

  if (divisionId) {
    const { data: division } = await supabase.from('divisions').select('id').eq('id', divisionId).single();
    if (!division) return res.status(404).json({ error: 'Division not found' });
  }

  const { error } = await supabase
    .from('schools')
    .update({ division_id: divisionId || null })
    .eq('id', schoolId);

  if (error) {
    console.error('reassign-school failed:', error.message);
    return res.status(500).json({ error: 'Could not reassign school' });
  }

  audit(supabase, user.id, 'reassign_school', 'school', schoolId,
    { division_id: prevSchool.division_id },
    { division_id: divisionId || null });

  // Notify affected teachers fire-and-forget
  notifySchoolTeachersOfReassignment(supabase, schoolId).catch(err => {
    console.error('school reassignment notification failed:', err.message);
  });

  return res.status(200).json({ ok: true });
}
```

**Step 2: Add notification helper**

```js
async function notifySchoolTeachersOfReassignment(supabase, schoolId) {
  const { data: teachers } = await supabase
    .from('profiles')
    .select('id')
    .eq('school_id', schoolId);

  for (const t of (teachers || [])) {
    const { data: authUser } = await supabase.auth.admin.getUserById(t.id);
    if (authUser?.user?.email) {
      await sendReassignmentEmail(authUser.user.email, { schoolId, divisionId: null });
    }
  }
}
```

**Step 3: Add reassignment UI in Schools tab**

In `js/admin.js` `renderSchools()` or the schools table rendering, add a "Move to Division" select + button in each school row.

- Cache `allDivisions` when `loadDivisions()` runs.
- In the schools table Actions column, render a `<select>` of divisions plus a "Move" button.
- Call `reassignSchool(schoolId, divisionSelect.value)`.

**Step 4: Add `reassignSchool()` function**

```js
async function reassignSchool(schoolId, divisionId) {
  if (!confirm('Move this school to a different division?')) return;
  try {
    await adminApi('reassign-school', 'POST', { schoolId, divisionId: divisionId || null });
    await Promise.all([loadSchools(), loadDivisions(), loadTeachers(), loadOverview()]);
  } catch (err) {
    alert('Could not reassign school: ' + err.message);
  }
}
```

**Step 5: Commit**

```bash
git add api/admin.js js/admin.js
git commit -m "feat: add school reassignment between divisions"
```

---

## Task 4: Harden detach fallback behavior and verify tier consistency

**Objective:** Ensure that after any attach, detach, reassign, deactivate, or reactivate, the teacher's effective tier is predictable and consistent.

**Files:**
- Verify: `api/org.js` `detach-teacher` and `detach-school`
- Verify: `api/session.js`
- Modify: `api/admin.js` if gaps are found

**Step 1: Verify `detach-teacher` clears the right fields**

In `api/org.js`, `detach-teacher` should set `school_id = null` but preserve `division_id` if the teacher is directly attached to a division. If the teacher is attached via school, detaching from school should also clear `division_id` unless they have a direct division attachment.

Current code in `api/org.js`:
```js
.from('profiles')
.update({ school_id: null })
.eq('id', userId);
```

This only clears `school_id`. If the teacher also has `division_id` set (inherited from the school or directly), the `division_id` remains, which may cause incorrect tier inheritance.

**Decision:** When detaching a teacher from a school, also clear `division_id` unless the teacher was directly assigned to that division (not via the school). Since the current schema does not distinguish "direct division attachment" from "inherited division attachment", the safest rule is:
- `detach-teacher` clears both `school_id` and `division_id`.
- If a platform admin wants a teacher in a division without a school, they use `reassign-teacher` with `divisionId` set and `schoolId` null.

Update `api/org.js` `detach-teacher` to:
```js
.update({ school_id: null, division_id: null })
```

**Step 2: Verify `get_effective_tier()` cascade after detach/reassign**

Run manual SQL checks:
```sql
SELECT id, display_name, school_id, division_id, tier, tier_override,
       get_effective_tier(id) as effective_tier
FROM profiles
WHERE id = 'test-teacher-uuid';
```

Test sequences:
1. Teacher in School A (division tier = school) → effective = school/division
2. Detach → effective = free (or their own tier if purchased)
3. Reassign to School B (division tier = premium) → effective = premium
4. Deactivate → session blocked regardless of tier
5. Reactivate → effective returns to reassigned value

**Step 3: Verify `api/session.js` blocks consistently**

Confirm `api/session.js` checks `is_deactivated` and that the check happens **before** generating the signed URL. Current code already does this; verify no reordering is needed.

**Step 4: Commit any fixes**

```bash
git add api/org.js
git commit -m "fix: clear division_id on teacher detach to prevent stale tier inheritance"
```

---

## Task 5: Document the account lifecycle state matrix

**Objective:** Produce one source of truth that explains what happens in every account state and transition.

**Files:**
- Create: `docs/account-lifecycle-states.md`
- Modify: `README.md`

**Step 1: Write the state matrix document**

Create `docs/account-lifecycle-states.md` with these sections:

```md
# Account Lifecycle State Matrix

## States

### Active
- Teacher can sign in, upload, and generate access codes.
- `profiles.is_deactivated = false`
- Effective tier is determined by `get_effective_tier()`.

### Deactivated
- Teacher cannot sign in to dashboards (optional: block at UI layer) OR can sign in but cannot generate new sessions.
- `profiles.is_deactivated = true`
- Existing access codes are blocked by `api/session.js`.
- Uploads and data are preserved.
- Can be reactivated by platform admin.

### Detached
- Teacher has `school_id = null` and `division_id = null`.
- Not a database state; it is the absence of org attachment.
- Effective tier falls back to personal tier (`profiles.tier`) or `free`.
- Teacher retains uploads and can continue using personal codes.

### Reassigned
- Teacher moves from Org A to Org B.
- Upload history is preserved.
- Effective tier updates immediately based on new org.
- A notification email is sent.

### Lapsed billing
- Org tier expires (`expires_at` in the past).
- `get_effective_tier()` falls back to the next available tier in the cascade.
- Teachers are NOT automatically deactivated; they revert to free or personal tier.
- This is a graceful degradation, not a hard block.

## Transition table

| From → To | Trigger | Data preserved? | Tier effect | Session effect |
|-----------|---------|-----------------|-------------|----------------|
| Active → Deactivated | Admin toggle | Yes | Unchanged | Blocked |
| Deactivated → Active | Admin toggle | Yes | Unchanged | Restored |
| Attached → Detached | `detach-teacher` | Yes | Falls back | Unchanged |
| Detached → Attached | `attach-teacher` / invite accept | Yes | Inherits org | Unchanged |
| School A → School B | `reassign-teacher` | Yes | New org tier | Unchanged |
| Division A → Division B | `reassign-school` | Yes | New division tier | Unchanged |
| Active → Lapsed | Org `expires_at` passes | Yes | Falls back | Unchanged |
```

**Step 2: Add to README**

In the README's architecture or admin section, add:

```md
## Account lifecycle

See `docs/account-lifecycle-states.md` for the complete state matrix.
```

**Step 3: Commit**

```bash
git add docs/account-lifecycle-states.md README.md
git commit -m "docs: add account lifecycle state matrix"
```

---

## Suggested execution order

Implement in this order:
1. Task 1 — deactivate/reactivate toggle
2. Task 4 — verify and fix detach tier consistency
3. Task 2 — teacher reassignment
4. Task 3 — school reassignment
5. Task 5 — state matrix document

This puts the most operationally critical capability (deactivation) first, then fixes any tier-inheritance bugs, then adds reassignment, then documents the result.

---

## Tests and verification

### Manual verification commands / checks

Minimum verification after any code change:
- Platform admin deactivates a teacher → teacher's access code returns 403 from `api/session`
- Platform admin reactivates the same teacher → code works again
- Platform admin reassigns a teacher from School A to School B → teacher's effective tier updates in SQL
- Platform admin reassigns a school from Division A to Division B → teachers in that school get new effective tier
- Detach a teacher from a school → `division_id` is also null; effective tier falls back to free
- Reassign a deactivated teacher → they remain deactivated; reactivation restores them in new org

### SQL verification snippets

```sql
-- Check effective tier for a test teacher
SELECT get_effective_tier('teacher-uuid-here');

-- Check deactivated teachers
SELECT id, display_name, is_deactivated, school_id, division_id
FROM profiles WHERE is_deactivated = true;

-- Check tier cascade after reassignment
SELECT id, display_name, school_id, division_id, tier, tier_override,
       get_effective_tier(id) as effective_tier
FROM profiles WHERE id = 'teacher-uuid-here';
```

### Regression hotspots

Retest the full lifecycle if any of these change:
- `api/admin.js` teacher-related actions
- `api/org.js` detach actions
- `api/session.js` deactivation check
- `get_effective_tier()` SQL function
- `profiles` table columns

---

## Risks and tradeoffs

- Main risk: clearing `division_id` on `detach-teacher` may break teachers who were directly attached to a division without a school. Mitigation: the `reassign-teacher` action can restore direct division attachment if needed. If you have such users today, audit before deploying.
- Main technical risk: reassignment UI complexity. Populating division/school selects for every teacher row may slow rendering at 1000+ teachers. Mitigation: only render the selects for teachers currently visible after client-side filtering, or use a lightweight prompt-based flow for MVP.
- Tradeoff: notification emails on reassignment add latency. They are fire-and-forget to avoid blocking the HTTP response, but failures are only logged to console. For a pilot, this is acceptable; for production scale, add an email queue or retry.
- Tradeoff: school reassignment notifies every teacher in the school. For large schools this could be many emails. Consider rate-limiting or batching if a school has >50 teachers.

---

## Open questions

1. Do you want school admins or division admins to have reassignment privileges, or should this remain platform-admin-only for now?
2. Should deactivated teachers be blocked from signing in entirely (redirect to a "deactivated" page), or only blocked from uploading and generating codes?
3. Do you need a bulk-reassign feature (e.g. move all teachers from School A to School B during a school merger), or is one-at-a-time sufficient for the pilot?
4. Should the state matrix include deletion semantics now, or wait until the deletion shipment is designed?

---

## Recommended first implementation slice

If you want the smallest high-value start, do these first:
1. Task 1 — deactivate/reactivate toggle
2. Task 4 — fix `division_id` clearing on detach
3. Task 5 — state matrix document

That gives you working account suspension and correct tier fallback before adding reassignment UI complexity.

---

Plan complete and saved. Ready to execute using subagent-driven-development — dispatch a fresh subagent per task with two-stage review (spec compliance then code quality). Shall I proceed?
