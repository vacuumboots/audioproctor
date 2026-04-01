-- ─── Migration 010: Demo helpers ──────────────────────────────────────────
-- Run in Supabase SQL editor.
--
-- Creates a service-role-callable RPC to immediately refresh the
-- upload_summaries materialized view after seeding demo data.
-- Without this, analytics show zeroes for up to 15 minutes post-seed.

CREATE OR REPLACE FUNCTION refresh_upload_summaries()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  REFRESH MATERIALIZED VIEW CONCURRENTLY upload_summaries;
END;
$$;

-- Only service_role can call this (admin seed endpoint uses service role key)
REVOKE EXECUTE ON FUNCTION refresh_upload_summaries() FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION refresh_upload_summaries() FROM authenticated;
GRANT  EXECUTE ON FUNCTION refresh_upload_summaries() TO service_role;
