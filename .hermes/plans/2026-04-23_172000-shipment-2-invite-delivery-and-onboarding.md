# Shipment 2 — Invite Delivery and Minimum Onboarding Completion Implementation Plan

> For Hermes: Use subagent-driven-development skill to implement this plan task-by-task.

**Goal:** Platform admin and org admins can send a real invite that lands in a user inbox, completes successfully, and triggers a single Day-0 welcome email on first activation.

**Architecture:** This shipment is not a feature build; it is connective-tissue work around the existing invitation data model and acceptance flow. The `invitations` table, `/api/accept-invite`, and `accept-invite.html` already exist. What is missing is the email delivery layer, operational visibility, and edge-case handling (expired invites, resends, send failure visibility). This plan adds the minimum email and UI wiring to make the invite loop actually usable by non-technical admins.

**Tech Stack:** Vercel serverless (`api/admin.js`, `api/accept-invite.js`), Resend (`resend` npm package), Supabase (`invitations` table), vanilla JS admin UI (`js/admin.js`), HTML landing page (`accept-invite.html`).

---

## Current context and assumptions

Known current state from repo inspection:
- `invitations` table has `email`, `role`, `school_id`, `division_id`, `token`, `expires_at`, `accepted_at`, `created_at`.
- `api/admin.js` `approve-request` action creates an invitation row and returns `{ inviteUrl, token }` to the admin UI, but **no email is sent**. The admin must manually copy and share the link.
- `api/accept-invite.js` validates tokens and accepts invitations, with basic expiry checking (410 if expired or already accepted).
- `accept-invite.html` shows invitation details and supports Google OAuth sign-in before acceptance.
- Resend is already configured and used in `api/contact.js`, `api/request-access.js`, and `api/org.js`.
- There is no operational logging table for invite lifecycle events (create, send, resend, accept).
- There is no Day-0 welcome email.
- There is no resend capability.
- Expired invites return a 410 error but no clear recovery path in the UI.

This plan assumes Shipment 2 should deliver five things:
1. automatic invite email delivery on invite creation
2. a resend action visible to admins
3. expired-invite recovery handling in UI and API
4. minimal operational logging for invite lifecycle
5. one Day-0 welcome email after first successful account activation

This plan does NOT include:
- a full onboarding drip sequence (that is Shipment 10)
- org-level domain restriction enforcement (that is Shipment 6)
- school/division self-serve billing (that is Shipment 8)

---

## Deliverables

1. A shared email helper module for server-side email composition and sending
2. Invite email template (plain text + minimal HTML) sent automatically on invite creation
3. Day-0 welcome email template sent once after first successful invite acceptance
4. Resend-invite endpoint and admin UI button
5. Expired-invite recovery path in `accept-invite.html`
6. Minimal invite operational logging (creation, send, resend, accept, failure)
7. Failed-send visibility in the admin UI

---

## Definition of done

Shipment 2 is done only when all of these are true:
- Admin creates an invite (via approve-request or a direct invite action) and an email is automatically sent to the recipient
- Recipient can open the email link, sign in with Google, and land attached to the correct org with the correct role
- Admin can click a resend button and a fresh email is delivered with the same or a new token
- Expired invite shows a clear recovery message in `accept-invite.html` with a way to contact the admin or request access
- Failed email sends are logged and visible to the admin (console or UI, not silent)
- Welcome email is sent exactly once after first successful acceptance
- No invite-related errors are silently swallowed

---

## Files likely to change

Backend:
- Create: `api/_lib/email.js` — shared Resend wrapper + template helpers
- Modify: `api/admin.js` — send invite email in `approve-request`; add `resend-invite` action; add direct `invite` action if needed
- Modify: `api/accept-invite.js` — trigger welcome email on first acceptance; improve expired-invite error payload
- Modify: `api/request-access.js` — optionally send confirmation email (out of scope unless trivial)
- Possibly modify: `api/org.js` — if school/division admins will also send invites

Frontend:
- Modify: `js/admin.js` — add resend button; show send status/failure inline
- Modify: `accept-invite.html` — handle expired-invite state with recovery messaging
- Possibly modify: `site/request-access.html` — if flow language changes

Database:
- Possibly migrate: add `email_sent_at`, `email_failed_at`, `welcome_sent_at` to `invitations` or create `invite_log` table
- Decide: whether to log in `invitations` columns or a separate small table

Documentation:
- Modify: `README.md` — document email env vars and invite flow
- Possibly create: `docs/invite-lifecycle.md` — short operational note for future maintainers

---

## Task 1: Create a shared server-side email helper

**Objective:** Centralize email sending so invite, welcome, and future transactional emails share one reliable path.

**Files:**
- Create: `api/_lib/email.js`

**Step 1: Write the helper**

It should:
- import `Resend`
- expose `sendEmail({ to, subject, text, html })` that returns `{ ok, error }`
- read `RESEND_API_KEY` and `CONTACT_EMAIL` / a default from address
- catch and return errors without throwing (callers decide whether to fail the request)
- log errors to console for serverless function visibility

Example structure:

```js
const { Resend } = require('resend');

const FROM = 'AudioProctor <hello@audioproctor.com>';

async function sendEmail({ to, subject, text, html }) {
  try {
    const resend = new Resend(process.env.RESEND_API_KEY);
    const result = await resend.emails.send({ from: FROM, to, subject, text, html });
    if (result.error) return { ok: false, error: result.error.message };
    return { ok: true, id: result.data?.id };
  } catch (err) {
    console.error('email send failed:', err.message);
    return { ok: false, error: err.message };
  }
}

module.exports = { sendEmail, FROM };
```

**Step 2: Verify env var presence**

If `RESEND_API_KEY` is missing, return a clear error so the caller can degrade gracefully.

**Step 3: Commit**

```bash
git add api/_lib/email.js
git commit -m "feat: add shared server-side email helper"
```

---

## Task 2: Send invitation email automatically on invite creation

**Objective:** Close the gap between "admin clicks approve" and "recipient knows they were invited."

**Files:**
- Modify: `api/admin.js`
- Modify: `js/admin.js`

**Step 1: Add email send to `approve-request` in `api/admin.js`**

After the invitation row is inserted and the request is marked approved, call the email helper:

```js
const { sendEmail } = require('./_lib/email');
// ...
await sendEmail({
  to: req.email,
  subject: 'You\'ve been invited to join AudioProctor',
  text: buildInviteText({ inviteUrl, role, schoolName, divisionName }),
  html: buildInviteHtml({ inviteUrl, role, schoolName, divisionName }),
});
```

If the email fails, still return `200` to the admin (the invite is valid), but include `emailOk: false` and the error message so the UI can surface it.

**Step 2: Build minimal invite templates**

Plain text template:

```
You've been invited to join AudioProctor as a [role].

[Org context line, e.g. "as part of Silverwood High"]

Click the link below to accept your invitation:
[inviteUrl]

This invitation expires in 7 days.
If you did not expect this invitation, you can safely ignore it.
```

HTML template: same content, minimal markup, no external images. Keep it simple and deliverable.

**Step 3: Update admin UI to show send status**

In `js/admin.js` `approveRequest()`:
- If `data.emailOk === false`, show a warning inline: "Invite created, but email failed to send. Copy the link below to share manually."
- Keep the existing invite-link input for manual fallback.

**Step 4: Add a direct `invite` action to `api/admin.js` (optional but recommended)**

Currently invites are only created via `approve-request`. Add a standalone `invite` action so platform admins can invite people without a prior request:

```js
if (action === 'invite') {
  const { email, role, schoolId, divisionId } = body;
  // validate email, role
  // insert invitation row
  // send email
  // return { ok, emailOk, inviteUrl }
}
```

This keeps the admin UI from being forced through the request-approval flow for manually added teachers.

**Step 5: Commit**

```bash
git add api/admin.js js/admin.js
git commit -m "feat: send invitation email automatically on invite creation"
```

---

## Task 3: Add resend-invite capability

**Objective:** Let admins recover from failed sends or lost emails without creating duplicate invitation rows.

**Files:**
- Modify: `api/admin.js`
- Modify: `js/admin.js`

**Step 1: Add `resend-invite` action in `api/admin.js`**

Logic:
- Accept `{ invitationId }`
- Look up the invitation row
- If already accepted, return 400 with clear error
- Optionally generate a new token (safer) or keep the existing one
- Update `expires_at` to now + 7 days
- Send the invite email again
- Return `{ ok, inviteUrl, emailOk }`

If generating a new token:
- Update the `token` column and `expires_at`
- This invalidates the old link (security benefit)

**Step 2: Add resend UI in `js/admin.js`**

Wherever invitations are listed (or in the requests table after approval), add a "Resend" button that calls `adminApi('resend-invite', 'POST', { invitationId })`.

Show success/failure inline, similar to the approve flow.

**Step 3: Operational logging**

When a resend happens, log it. If using a separate table, insert a row. If using columns, increment a counter or store `resent_at`.

**Step 4: Commit**

```bash
git add api/admin.js js/admin.js
git commit -m "feat: add invite resend action and admin UI"
```

---

## Task 4: Harden expired-invite handling with a recovery path

**Objective:** A recipient with an expired link should know what happened and what to do next, not just see "410 Gone."

**Files:**
- Modify: `api/accept-invite.js`
- Modify: `accept-invite.html`

**Step 1: Distinguish expired vs. accepted vs. not found in the API**

Current API returns 410 for both expired and accepted. Keep 410, but add a `reason` field:

```json
{ "error": "This invitation has expired.", "reason": "expired", "expiredAt": "2026-04-20T..." }
{ "error": "This invitation has already been accepted.", "reason": "accepted" }
```

**Step 2: Add an expired-invite state to `accept-invite.html`**

Add a new DOM state `state-expired`:

```html
<div id="state-expired" style="display:none;">
  <p class="tagline">This invitation has expired.</p>
  <p style="color:var(--muted); font-size:0.9rem; margin-top:0.5rem;">
    Invitations are valid for 7 days. Contact your administrator to request a new one.
  </p>
  <a href="/site/request-access.html" class="btn btn--ghost" style="margin-top:1rem; display:block; text-align:center;">
    Request access
  </a>
</div>
```

In `loadInvite()`, branch on `data.reason`:
- `expired` → show `state-expired`
- `accepted` → show a friendly "already accepted" message with a link to login
- `not_found` → keep existing error state

**Step 3: Commit**

```bash
git add api/accept-invite.js accept-invite.html
git commit -m "feat: add expired-invite recovery path in accept UI"
```

---

## Task 5: Add minimal operational logging for invite lifecycle

**Objective:** Make invite delivery debuggable without adding a heavy analytics pipeline.

**Files:**
- Modify or migrate: `invitations` table or create `invite_events` table
- Modify: `api/admin.js`
- Modify: `api/accept-invite.js`

**Step 1: Decide on logging shape**

Option A (columns on `invitations`):
- `email_sent_at` timestamptz
- `email_failed_at` timestamptz
- `email_error` text
- `resent_at` timestamptz
- `welcome_sent_at` timestamptz

Option B (small events table):
```sql
CREATE TABLE invite_events (
  id             uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  invitation_id  uuid REFERENCES invitations(id) ON DELETE CASCADE,
  event_type     text NOT NULL CHECK (event_type IN ('created','email_sent','email_failed','resent','accepted','welcome_sent')),
  detail         jsonb,
  created_at     timestamptz DEFAULT now()
);
```

Recommendation: Option A for simplicity. Only move to Option B if you find you need multi-event history per invite.

**Step 2: Add migration if needed**

If adding columns:
```sql
ALTER TABLE invitations
  ADD COLUMN IF NOT EXISTS email_sent_at timestamptz,
  ADD COLUMN IF NOT EXISTS email_failed_at timestamptz,
  ADD COLUMN IF NOT EXISTS email_error text,
  ADD COLUMN IF NOT EXISTS resent_at timestamptz,
  ADD COLUMN IF NOT EXISTS welcome_sent_at timestamptz;
```

Save under `supabase/migrations/00X_invite_email_logging.sql`.

**Step 3: Update send paths to write columns**

In `api/admin.js`:
- On email success: `update invitations set email_sent_at = now()`
- On email failure: `update invitations set email_failed_at = now(), email_error = ?`
- On resend: `update invitations set resent_at = now(), email_sent_at = now(), expires_at = now() + interval '7 days'`

In `api/accept-invite.js`:
- On successful acceptance: trigger welcome email; if sent, `update invitations set welcome_sent_at = now()`

**Step 4: Expose send status in admin UI**

In `js/admin.js`, if you render invitations anywhere, show:
- sent ✓
- failed ⚠
- resent ↻
- accepted ✓

If invitations are not yet rendered in a dedicated table, add a lightweight view or at least surface the status in the requests table.

**Step 5: Commit**

```bash
git add supabase/migrations/ api/admin.js api/accept-invite.js js/admin.js
git commit -m "feat: add invite lifecycle logging and visibility"
```

---

## Task 6: Add Day-0 welcome email on first successful account activation

**Objective:** Send one warm, useful welcome email only after the user has actually joined, not before.

**Files:**
- Modify: `api/accept-invite.js`
- Modify: `api/admin.js` or new `api/_lib/email.js`

**Step 1: Define "first successful activation"**

This means:
- The user accepted an invitation (not just signed up organically)
- The `welcome_sent_at` column on the accepted invitation row is null
- The profile was successfully updated with role/school/division

**Step 2: Send welcome email after successful profile update**

In `api/accept-invite.js` POST handler, after updating the profile and marking `accepted_at`, check `invite.welcome_sent_at`:

```js
if (!invite.welcome_sent_at) {
  const welcomeResult = await sendEmail({
    to: user.email,
    subject: 'Welcome to AudioProctor',
    text: buildWelcomeText({ name: user.user_metadata?.full_name, role: invite.role }),
    html: buildWelcomeHtml({ name: user.user_metadata?.full_name, role: invite.role }),
  });
  if (welcomeResult.ok) {
    await supabase.from('invitations').update({ welcome_sent_at: new Date().toISOString() }).eq('id', invite.id);
  }
}
```

**Step 3: Write the welcome template**

Keep it short and actionable:

```
Welcome to AudioProctor, [name].

You now have access as a [role].
[If school/division: You are part of [school/division name].]

Get started:
1. Go to https://app.audioproctor.com/dashboard.html
2. Upload your first audio track
3. Share the access code with your students

Need help? Contact hello@audioproctor.com.
```

**Step 4: Guard against duplicate sends**

The `welcome_sent_at` column is the guard. Never send if it is already set.

**Step 5: Commit**

```bash
git add api/accept-invite.js api/_lib/email.js
git commit -m "feat: send Day-0 welcome email on first invite acceptance"
```

---

## Task 7: Surface failed email sends in the admin UI

**Objective:** Admins must know when an email failed so they can copy the link and share it manually.

**Files:**
- Modify: `js/admin.js`
- Possibly modify: `admin.html`

**Step 1: Update approve-request UI**

In `approveRequest()`, after the API call:

```js
if (!data.emailOk) {
  showNotice(`Invite created, but email failed: ${data.emailError || 'unknown error'}. Copy the link manually.`, 'warning');
}
```

**Step 2: Add a lightweight invite-status indicator in the requests table**

If the requests table now includes invitation status, show a small badge:
- `email sent` (green)
- `email failed` (red, with resend button)
- `accepted` (muted)

If the requests table does not yet query invitation status, either:
- add a JOIN in the `loadRequests` / `requests` API path, or
- keep it simple and only show status immediately after the approve action (optimistic inline update)

**Step 3: Commit**

```bash
git add js/admin.js admin.html
git commit -m "feat: surface invite email send status in admin UI"
```

---

## Suggested execution order

Implement in this order:
1. Task 1 — shared email helper
2. Task 2 — automatic invite email on creation
3. Task 4 — expired-invite recovery path
4. Task 3 — resend capability
5. Task 5 — operational logging
6. Task 6 — Day-0 welcome email
7. Task 7 — admin UI send-status visibility

This keeps the core email delivery working before adding UI polish and secondary flows.

---

## Tests and verification

### Manual verification commands / checks

There is no automated email test harness in this repo, so verification is manual.

Minimum verification after any code change:
- Platform admin approves a teacher request
- Confirm invitation email is received by the test address
- Confirm email contains a working `accept-invite.html?token=...` link
- Open link in incognito, sign in with Google, confirm acceptance succeeds
- Confirm welcome email is received after acceptance
- Confirm second acceptance of the same invite returns "already accepted"
- Confirm expired invite shows recovery UI (test by backdating `expires_at` in DB)
- Confirm resend action delivers a fresh email
- Confirm failed-send state is visible in admin UI (test by temporarily breaking `RESEND_API_KEY`)

### Regression hotspots

Retest the full invite flow if any of these change:
- `api/admin.js` invite or approve-request actions
- `api/accept-invite.js` GET or POST handlers
- `accept-invite.html` state logic
- `api/_lib/email.js` helper signature
- Database columns on `invitations`

---

## Risks and tradeoffs

- Main risk: Resend deliverability issues (spam folder, bounced emails). This plan does not include DKIM/SPF verification or bounce handling; that is acceptable for a pilot but should be monitored.
- Main technical risk: over-engineering the logging layer. Keep it columns on `invitations` until you have a real need for event history.
- Tradeoff: sending welcome email on acceptance means it fires inside a POST request. If Resend is slow, the request may timeout. Mitigation: do not `await` the welcome send if it risks blocking the HTTP response; instead fire-and-forget but still update `welcome_sent_at` on success.
- Tradeoff: generating a new token on resend invalidates the old link. This is safer but may confuse a recipient who has both emails. Document the behavior in admin UI copy.

---

## Open questions

1. Should school admins and division admins also be able to send invites directly, or is invite creation reserved for platform admin only?
2. Do you want a dedicated "Invitations" tab in the admin UI, or is inline status in the requests table sufficient for now?
3. Should the welcome email be suppressed for users who signed up organically (not via invite)? Currently this plan only sends it on invite acceptance.
4. Is there a preferred email template style beyond plain text + minimal HTML?

---

## Recommended first implementation slice

If you want the smallest high-value start, do these first:
1. Task 1 — shared email helper
2. Task 2 — automatic invite email on `approve-request`
3. Task 4 — expired-invite recovery path

That gives you a working email delivery loop and better error handling before adding logging and resend.

---

Plan complete and saved. Ready to execute using subagent-driven-development — dispatch a fresh subagent per task with two-stage review (spec compliance then code quality). Shall I proceed?
