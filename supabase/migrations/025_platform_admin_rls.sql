-- ─── Migration 025: Platform admin RLS for divisions and schools ─────────────────
-- Run in Supabase SQL editor AFTER migration 024 (onboarding emails).
--
-- Context: migration 007 already enables RLS on divisions and schools with
-- read policies for teachers, school_admins, and division_admins. But there
-- are no policies granting platform_admins access — they operate through the
-- admin API (service role key), but direct Supabase client queries from the
-- browser (anon key) are blocked.
--
-- This migration adds all-operations policies for platform_admins so they
-- have full CRUD access when using the anon-key client (e.g., from admin
-- dashboard JS, Supabase Studio dashboard, or pg client).
--
-- Design: platform_admins are identified by profiles.role = 'platform_admin'.
-- We check this via a subquery rather than assuming auth.role() = 'authenticated',
-- because role is stored in profiles, not auth.users.

-- ─── divisions ────────────────────────────────────────────────────────────

-- Platform admin: full access to all divisions
CREATE POLICY "platform_admin_divisions_all"
  ON divisions
  FOR ALL
  USING (
    (SELECT role FROM profiles WHERE id = auth.uid()) = 'platform_admin'
  )
  WITH CHECK (
    (SELECT role FROM profiles WHERE id = auth.uid()) = 'platform_admin'
  );

-- ─── schools ──────────────────────────────────────────────────────────────

-- Platform admin: full access to all schools
CREATE POLICY "platform_admin_schools_all"
  ON schools
  FOR ALL
  USING (
    (SELECT role FROM profiles WHERE id = auth.uid()) = 'platform_admin'
  )
  WITH CHECK (
    (SELECT role FROM profiles WHERE id = auth.uid()) = 'platform_admin'
  );

-- ─── division_pricing ─────────────────────────────────────────────────────
-- Migration 022 added this table with GRANT SELECT to authenticated but no
-- RLS. Add RLS + platform_admin policy for safety.

ALTER TABLE division_pricing ENABLE ROW LEVEL SECURITY;

-- Authenticated users can read pricing (needed by checkout pages)
-- Platform admins can read/write pricing

CREATE POLICY "read_pricing_authenticated"
  ON division_pricing
  FOR SELECT
  USING (auth.uid() IS NOT NULL);

CREATE POLICY "platform_admin_pricing_all"
  ON division_pricing
  FOR ALL
  USING (
    (SELECT role FROM profiles WHERE id = auth.uid()) = 'platform_admin'
  )
  WITH CHECK (
    (SELECT role FROM profiles WHERE id = auth.uid()) = 'platform_admin'
  );
