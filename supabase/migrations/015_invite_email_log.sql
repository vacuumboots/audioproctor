-- ─── Migration 015: Invite Email Log ───────────────────────────────────────
-- Run in Supabase SQL editor.
--
-- Records every invitation email send attempt and every expired/accepted
-- lookup at the accept-invite endpoint. Operational visibility for the
-- platform admin without pulling Resend logs.
--
-- Design:
--   - invitation_id: references invitations (no FK to allow cleanup)
--   - action: 'approve_request', 'invite', 'resend', 'accept_expired', 'accept_already_accepted'
--   - email_ok: null for lookups, true/false for sends
--   - No RLS UPDATE or DELETE — append-only
--   - Only platform admins read via service role in API

CREATE TABLE IF NOT EXISTS invite_email_log (
  id             uuid        DEFAULT gen_random_uuid() PRIMARY KEY,
  invitation_id  uuid,                       -- invitations.id (nullable for lookups without known invite)
  action         text        NOT NULL,
  email_ok       boolean,
  error_message  text,
  created_at     timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS invite_email_log_invitation_idx ON invite_email_log (invitation_id, created_at DESC);
CREATE INDEX IF NOT EXISTS invite_email_log_action_idx      ON invite_email_log (action, created_at DESC);

-- RLS: no client access. All reads and writes go through service role in API.
ALTER TABLE invite_email_log ENABLE ROW LEVEL SECURITY;
