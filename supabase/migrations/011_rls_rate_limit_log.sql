-- ─── Migration 011: RLS on rate_limit_log ────────────────────────────────
-- Run in Supabase SQL editor.
--
-- Without RLS, any request using the public anon key can DELETE rows from
-- rate_limit_log, clearing their own failed-attempt count and bypassing the
-- brute-force protection on access codes entirely.
--
-- All reads and writes go through api/session.js using the service role key.
-- No client-side policies are needed or granted.

ALTER TABLE rate_limit_log ENABLE ROW LEVEL SECURITY;
