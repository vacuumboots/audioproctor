-- ─── Migration 005: Account Hierarchy ───────────────────────────────
-- Run in Supabase SQL editor AFTER migration 004.
-- Adds divisions, schools, invitations tables; extends profiles;
-- adds get_effective_tier() function; updates quota RLS policy.

-- ─── divisions ───────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS divisions (
  id             uuid        DEFAULT gen_random_uuid() PRIMARY KEY,
  name           text        NOT NULL,
  enrolment_band text        CHECK (enrolment_band IN ('small','medium','large','metro')),
  tier           text        NOT NULL DEFAULT 'free'
                             CHECK (tier IN ('free','premium','school','division')),
  admin_email    text,
  notes          text,                          -- platform admin freeform notes / flags
  expires_at     timestamptz,
  created_at     timestamptz NOT NULL DEFAULT now()
);

-- ─── schools ─────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS schools (
  id           uuid        DEFAULT gen_random_uuid() PRIMARY KEY,
  name         text        NOT NULL,
  division_id  uuid        REFERENCES divisions(id) ON DELETE SET NULL,
  tier         text        NOT NULL DEFAULT 'free'
                           CHECK (tier IN ('free','premium','school','division')),
  admin_email  text,
  notes        text,
  expires_at   timestamptz,
  created_at   timestamptz NOT NULL DEFAULT now()
);

-- ─── profiles — new columns ───────────────────────────────────────────
-- school_id / division_id: set by platform admin to attach teacher to org
-- tier_override: platform admin can force a specific tier (e.g. for pilots)
-- role: access control for admin dashboards

ALTER TABLE profiles
  ADD COLUMN IF NOT EXISTS school_id     uuid REFERENCES schools(id)   ON DELETE SET NULL,
  ADD COLUMN IF NOT EXISTS division_id   uuid REFERENCES divisions(id)  ON DELETE SET NULL,
  ADD COLUMN IF NOT EXISTS tier_override text CHECK (tier_override IN ('free','premium','school','division')),
  ADD COLUMN IF NOT EXISTS role          text NOT NULL DEFAULT 'teacher'
                                         CHECK (role IN ('teacher','school_admin','division_admin','platform_admin')),
  ADD COLUMN IF NOT EXISTS notes         text;   -- platform admin notes / flags

-- ─── invitations ─────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS invitations (
  id           uuid        DEFAULT gen_random_uuid() PRIMARY KEY,
  email        text        NOT NULL,
  role         text        NOT NULL CHECK (role IN ('teacher','school_admin','division_admin')),
  school_id    uuid        REFERENCES schools(id)    ON DELETE CASCADE,
  division_id  uuid        REFERENCES divisions(id)  ON DELETE CASCADE,
  token        text        NOT NULL UNIQUE DEFAULT encode(gen_random_bytes(32), 'hex'),
  expires_at   timestamptz NOT NULL DEFAULT now() + interval '7 days',
  accepted_at  timestamptz,
  created_at   timestamptz NOT NULL DEFAULT now()
);

-- ─── get_effective_tier(user_id) ─────────────────────────────────────
-- Resolves a teacher's tier using the cascade:
--   tier_override → division.tier → school.tier → profiles.tier → 'free'
--
-- This function is SECURITY DEFINER so it can join across tables that
-- the calling user might not have SELECT access to (e.g. divisions, schools
-- owned by other teachers). The result is a single text tier value —
-- no sensitive data is exposed.

CREATE OR REPLACE FUNCTION get_effective_tier(p_user_id uuid)
RETURNS text
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT COALESCE(
    -- 1. Platform admin override (highest priority)
    p.tier_override,
    -- 2. Division tier (teacher is directly linked to a division)
    CASE WHEN p.division_id IS NOT NULL THEN d.tier ELSE NULL END,
    -- 3. Division tier via school (teacher → school → division)
    CASE WHEN p.school_id IS NOT NULL AND s.division_id IS NOT NULL THEN sd.tier ELSE NULL END,
    -- 4. School tier (teacher linked to a school with its own purchased tier)
    CASE WHEN p.school_id IS NOT NULL THEN s.tier ELSE NULL END,
    -- 5. Teacher's own purchased tier (e.g. Teacher Premium self-serve)
    CASE WHEN p.tier <> 'free' THEN p.tier ELSE NULL END,
    -- 6. Default
    'free'
  )
  FROM profiles p
  LEFT JOIN divisions  d  ON d.id  = p.division_id
  LEFT JOIN schools    s  ON s.id  = p.school_id
  LEFT JOIN divisions  sd ON sd.id = s.division_id
  WHERE p.id = p_user_id
  LIMIT 1;
$$;

-- Grant execute to authenticated users (so dashboard JS can call it via RPC)
GRANT EXECUTE ON FUNCTION get_effective_tier(uuid) TO authenticated;

-- ─── Update check_upload_quota() RLS policy ──────────────────────────
-- The existing policy reads profiles.tier directly. Replace it with one
-- that calls get_effective_tier() so inherited tiers are respected.
--
-- Drop and recreate the INSERT policy on uploads.
-- Adjust the policy name below if yours differs — check with:
--   SELECT policyname FROM pg_policies WHERE tablename = 'uploads';

DROP POLICY IF EXISTS "check_upload_quota" ON uploads;
DROP POLICY IF EXISTS "Enforce upload quota" ON uploads;
DROP POLICY IF EXISTS "enforce_upload_quota" ON uploads;

CREATE POLICY "enforce_upload_quota"
  ON uploads
  FOR INSERT
  WITH CHECK (
    -- Must be inserting as yourself
    teacher_id = auth.uid()
    AND (
      -- Premium/school/division tier: unlimited uploads
      get_effective_tier(auth.uid()) <> 'free'
      OR (
        -- Free tier: max 3 uploads per calendar month
        (
          SELECT COUNT(*) FROM uploads
          WHERE teacher_id = auth.uid()
            AND created_at >= date_trunc('month', now())
        ) < 3
        -- Free tier: max 50 MB total storage
        AND (
          SELECT COALESCE(storage_used_mb, 0) FROM profiles WHERE id = auth.uid()
        ) + file_size_mb <= 50
        -- Rate limit: max 10 uploads per hour (abuse prevention)
        AND (
          SELECT COUNT(*) FROM uploads
          WHERE teacher_id = auth.uid()
            AND created_at >= now() - interval '1 hour'
        ) < 10
      )
    )
  );

-- ─── Bootstrap: set yourself as platform_admin ────────────────────────
-- After running this migration, run the following to grant yourself
-- platform admin access. Replace the email with your own.
--
--   UPDATE profiles
--   SET role = 'platform_admin'
--   WHERE id = (
--     SELECT id FROM auth.users WHERE email = 'your@email.com'
--   );
--
-- You only need to do this once. Subsequent logins will read the role
-- from the profiles table automatically.
