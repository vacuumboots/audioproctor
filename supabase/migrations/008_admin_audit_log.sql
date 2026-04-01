-- ─── Migration 008: Admin Audit Log ──────────────────────────────────────
-- Run in Supabase SQL editor.
--
-- Records every administrative action taken via api/admin.js and api/org.js.
-- Provides an answer to "who changed this, and when?" for tier changes,
-- role changes, and org membership changes.
--
-- Design:
--   - actor_id: the platform/school/division admin who performed the action
--   - action: short verb, e.g. 'set_tier', 'set_role', 'detach_teacher'
--   - target_type: 'teacher' | 'school' | 'division'
--   - target_id: UUID of the affected row
--   - before_value / after_value: JSONB snapshots of what changed
--   - No RLS UPDATE or DELETE — this table is append-only
--   - Only platform admins can read it (via api/admin.js service role)

CREATE TABLE IF NOT EXISTS admin_audit_log (
  id           uuid        DEFAULT gen_random_uuid() PRIMARY KEY,
  actor_id     uuid        NOT NULL,                 -- profiles.id of the admin
  action       text        NOT NULL,                 -- 'set_tier', 'set_role', etc.
  target_type  text        NOT NULL CHECK (target_type IN ('teacher', 'school', 'division')),
  target_id    uuid        NOT NULL,
  before_value jsonb,
  after_value  jsonb,
  occurred_at  timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS audit_log_actor_idx  ON admin_audit_log (actor_id, occurred_at DESC);
CREATE INDEX IF NOT EXISTS audit_log_target_idx ON admin_audit_log (target_id, occurred_at DESC);

-- RLS: no client access. All reads and writes go through service role in API.
ALTER TABLE admin_audit_log ENABLE ROW LEVEL SECURITY;
