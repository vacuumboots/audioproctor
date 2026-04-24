# Shipment 2 Completion Checklist

**Ship:** Invite Delivery and Minimum Onboarding Completion  
**Status:** IMPLEMENTED  
**Date:** 2026-04-23  
**Commits:** 8 ahead of origin/main  

---

## Task 1 — Shared Server-Side Email Helper

- [x] `api/_lib/email.js` created
- [x] Imports `resend`, instantiates with `RESEND_API_KEY`
- [x] Exports `sendEmail({ to, subject, text, html })` returning `{ ok, error }`
- [x] Returns `{ ok: false, error }` when `RESEND_API_KEY` is missing
- [x] Returns `{ ok: false, error }` when Resend API returns `result.error`
- [x] Returns `{ ok: true, id }` on success
- [x] All callers use `emailResult.ok` to check success

## Task 2 — Send Invitation Email Automatically on Invite Creation

- [x] `api/admin.js` `approve-request` action sends email after creating invitation
- [x] `api/admin.js` `invite` action sends email after creating invitation
- [x] Both actions return `{ ok, inviteUrl, token, emailOk, emailError }`
- [x] `js/admin.js` `approveRequest()` shows email failure inline
- [x] `js/admin.js` renders invite link in requests table

## Task 3 — Add Resend-Invite Capability

- [x] `api/admin.js` `resend-invite` POST action added
- [x] Validates `invitationId`, returns 404 if not found, 400 if already accepted
- [x] Updates `expires_at` to now + 7 days
- [x] Resends invite email via `buildInviteEmail` + `sendEmail`
- [x] Returns `{ ok, inviteUrl, emailOk, emailError }`
- [x] Logs to `admin_audit_log`
- [x] `admin.html` has new "Invitations" tab
- [x] `js/admin.js` `loadInvitations()` fetches pending invites, splits active/expired
- [x] `js/admin.js` `resendInvite()` calls API and shows inline status

## Task 4 — Harden Expired-Invite Handling with Recovery Path

- [x] `api/accept-invite.js` GET returns `reason: 'expired'` with `expiredAt` for expired invites
- [x] `api/accept-invite.js` GET returns `reason: 'accepted'` for already-accepted invites
- [x] `api/accept-invite.js` POST returns same `reason` fields
- [x] `accept-invite.html` has `state-expired` DOM section
- [x] `accept-invite.html` `loadInvite()` branches on `data.reason === 'expired'`
- [x] Expired state shows friendly message + link to `/site/request-access.html`
- [x] **Bugfix:** POST handler now checks and returns 500 if `accepted_at` update fails (previously discarded)

## Task 5 — Add Minimal Operational Logging for Invite Lifecycle

- [x] Migration `015_invite_email_log.sql` created and reviewed
- [x] Table `invite_email_log` with `id, invitation_id, action, email_ok, error_message, created_at`
- [x] Indexes on `(invitation_id, created_at DESC)` and `(action, created_at DESC)`
- [x] RLS enabled, no client access
- [x] `api/admin.js` logs every `approve_request`, `invite`, `resend` action
- [x] `api/accept-invite.js` logs every `accept_expired` and `accept_already_accepted` lookup
- [x] Fire-and-forget pattern — never blocks the main response

## Task 6 — Add Day-0 Welcome Email on First Acceptance

- [x] `api/accept-invite.js` POST sends welcome email after successful acceptance
- [x] Fire-and-forget — `.catch(() => {})` so it never blocks response
- [x] Welcome text and HTML are inline, simple, and actionable

## Task 7 — Surface Failed Email Sends in Admin UI

- [x] `api/admin.js` `list-invitations` merges `lastEmailOk` from `invite_email_log`
- [x] `js/admin.js` `loadInvitations()` shows red dot indicator when `lastEmailOk === false`
- [x] Indicator has tooltip title "Last email send failed"

---

## Integration Verification

- [x] No broken `token=***` placeholders in any API file
- [x] All JS files pass `node -c` syntax check
- [x] `sendEmail` imported in all API files that use it
- [x] `logInviteEmail` available in both `api/admin.js` and `api/accept-invite.js`
- [x] Working tree clean — all changes committed
- [x] 8 commits ready to push

## Deployment Notes

1. Run migration `015_invite_email_log.sql` in Supabase SQL Editor.
2. Ensure `RESEND_API_KEY` is set in Vercel environment variables.
3. Deploy via `git push origin main`.
4. Verify by creating a test invitation in the admin panel and checking the Invitations tab.

---

**Sign-off:** All Shipment 2 tasks implemented, reviewed, and committed.
