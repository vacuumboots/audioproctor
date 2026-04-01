-- ─── Migration 006: Analytics Functions & Profile Enhancements ───────────
-- Run in Supabase SQL editor AFTER migrations 004 and 005.

-- ─── display_name and tos_accepted_at on profiles ────────────────────────
-- display_name: allows teachers to set a name distinct from their Google account.
-- tos_accepted_at: records when the teacher accepted the Terms of Service.
--   Null = accepted before this column existed (existing accounts, pre-ToS gate).
--   Non-null = timestamp of explicit acceptance via the first-login modal.

ALTER TABLE profiles ADD COLUMN IF NOT EXISTS display_name    text;
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS tos_accepted_at timestamptz;

-- ─── get_my_upload_summaries() ────────────────────────────────────────────
-- Returns upload_summaries rows for the currently authenticated teacher only.
-- SECURITY DEFINER bypasses RLS on upload_summaries (a materialized view,
-- which cannot have RLS). auth.uid() filter limits results to the caller's
-- own uploads so no cross-teacher data leaks.

CREATE OR REPLACE FUNCTION get_my_upload_summaries()
RETURNS TABLE (
  upload_id           uuid,
  total_sessions      bigint,
  completions         bigint,
  exits_with_word     bigint,
  session_expirations bigint,
  replays             bigint,
  avg_listen_seconds  numeric,
  last_used_at        timestamptz
)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT us.*
  FROM upload_summaries us
  WHERE us.upload_id IN (
    SELECT id FROM uploads WHERE teacher_id = auth.uid()
  );
$$;

GRANT EXECUTE ON FUNCTION get_my_upload_summaries() TO authenticated;

-- ─── get_my_session_events() ──────────────────────────────────────────────
-- Returns session event rows suitable for CSV export.
-- Scoped to the caller's own uploads via auth.uid() filter.

CREATE OR REPLACE FUNCTION get_my_session_events()
RETURNS TABLE (
  upload_label     text,
  access_code      text,
  event_type       text,
  occurred_at      timestamptz,
  position_seconds numeric
)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT
    COALESCE(u.label, u.filename)               AS upload_label,
    u.access_code,
    se.event_type,
    se.occurred_at,
    (se.metadata->>'position_seconds')::numeric  AS position_seconds
  FROM session_events se
  JOIN uploads u ON u.id = se.upload_id
  WHERE u.teacher_id = auth.uid()
  ORDER BY se.occurred_at DESC;
$$;

GRANT EXECUTE ON FUNCTION get_my_session_events() TO authenticated;
