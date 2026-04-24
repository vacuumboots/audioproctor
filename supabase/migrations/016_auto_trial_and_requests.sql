-- ─── Migration 016: Auto Premium Trial + In-App Requests ───────────────────
-- Run in Supabase SQL editor AFTER migration 015.
--
-- 1. Adds expires_at to profiles so new signups can get a time-bounded trial.
-- 2. Extends teacher_requests with teacher_id and request_type so existing
--    teachers can submit in-app requests for premium/org access.
-- 3. Updates get_effective_tier() to respect profiles.expires_at.

-- ─── profiles.expires_at ──────────────────────────────────────────────────

ALTER TABLE profiles
  ADD COLUMN IF NOT EXISTS expires_at timestamptz;

-- ─── teacher_requests extensions ──────────────────────────────────────────

ALTER TABLE teacher_requests
  ADD COLUMN IF NOT EXISTS teacher_id uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  ADD COLUMN IF NOT EXISTS request_type text NOT NULL DEFAULT 'access'
    CHECK (request_type IN ('access', 'premium_trial', 'school_plan', 'division_plan'));

-- ─── Update get_effective_tier() ──────────────────────────────────────────
-- When profiles.expires_at is set and has passed, the teacher's own tier
-- is ignored (falls back to free). This enables 30-day auto trials.

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
    -- 5. Teacher's own purchased/trial tier — ONLY if not expired
    CASE
      WHEN p.tier <> 'free'
           AND (p.expires_at IS NULL OR p.expires_at > now())
      THEN p.tier
      ELSE NULL
    END,
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

GRANT EXECUTE ON FUNCTION get_effective_tier(uuid) TO authenticated;
