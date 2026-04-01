-- ─── Migration 007: RLS for divisions, schools, invitations ──────────────
-- Run in Supabase SQL editor AFTER migration 005.
--
-- Context: migrations 005 created these tables without enabling RLS.
-- In Supabase, tables without RLS are readable/writable by any
-- authenticated user. This migration locks them down.
--
-- Design decisions:
--   divisions  — authenticated users may read only their own division
--                (where profiles.division_id = divisions.id).
--                All writes go through api/admin.js (service role).
--   schools    — authenticated users may read only their own school
--                (where profiles.school_id = schools.id).
--                All writes go through api/admin.js (service role).
--   invitations — no client access at all. Created and read server-side
--                only via service role (api/admin.js, future api/invite.js).
--
-- Note: get_effective_tier(), get_my_upload_summaries(), and all API
-- functions use SECURITY DEFINER or service role, so they are unaffected
-- by these policies.

-- ─── divisions ────────────────────────────────────────────────────────────

ALTER TABLE divisions ENABLE ROW LEVEL SECURITY;

-- A teacher can read the division they are directly linked to.
-- This covers: settings page org display, division-admin page name lookup.
CREATE POLICY "read_own_division"
  ON divisions
  FOR SELECT
  USING (
    id IN (
      SELECT division_id FROM profiles
      WHERE id = auth.uid()
        AND division_id IS NOT NULL
    )
  );

-- A teacher can also read the division their school belongs to.
-- This covers: settings page "Your school is on a Division Plan" logic.
CREATE POLICY "read_school_division"
  ON divisions
  FOR SELECT
  USING (
    id IN (
      SELECT s.division_id FROM schools s
      JOIN profiles p ON p.school_id = s.id
      WHERE p.id = auth.uid()
        AND s.division_id IS NOT NULL
    )
  );

-- ─── schools ──────────────────────────────────────────────────────────────

ALTER TABLE schools ENABLE ROW LEVEL SECURITY;

-- A teacher can read the school they are directly linked to.
-- This covers: settings page org display, school-admin page name lookup.
CREATE POLICY "read_own_school"
  ON schools
  FOR SELECT
  USING (
    id IN (
      SELECT school_id FROM profiles
      WHERE id = auth.uid()
        AND school_id IS NOT NULL
    )
  );

-- ─── invitations ──────────────────────────────────────────────────────────

ALTER TABLE invitations ENABLE ROW LEVEL SECURITY;

-- No SELECT, INSERT, UPDATE, or DELETE policies for authenticated users.
-- All invitation operations are performed server-side via service role key.
-- A future api/accept-invite.js endpoint will use service role to validate
-- and accept tokens — the invitee never reads this table directly.
