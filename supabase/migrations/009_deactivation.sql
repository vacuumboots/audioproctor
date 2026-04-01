-- ─── Migration 009: Account deactivation flag ────────────────────────────
-- Run in Supabase SQL editor.
--
-- Adds is_deactivated to profiles so platform admins can suspend access
-- without permanently deleting data. A deactivated teacher:
--   - Cannot have their access codes resolved by api/session.js
--   - Retains all uploads, session events, and profile data
--   - Can be reactivated by a platform admin (flip the flag back)
--
-- The admin UI toggle is deferred to Stage 6. This migration establishes
-- the schema foundation so the flag can be set directly in Supabase SQL
-- during the pilot period without a later breaking migration.
--
-- Distinction from deletion:
--   Deactivation: access suspended, data preserved, reversible.
--   Deletion:     account and all data permanently removed, irreversible.
--   The teacher self-service delete (api/account?action=delete-account)
--   performs permanent deletion — not deactivation.

ALTER TABLE profiles ADD COLUMN IF NOT EXISTS is_deactivated boolean NOT NULL DEFAULT false;

CREATE INDEX IF NOT EXISTS profiles_deactivated_idx
  ON profiles (is_deactivated)
  WHERE is_deactivated = true;
