-- ─── Migration 012: Security hardening ───────────────────────────────────
-- Run in Supabase SQL editor.

-- ── 1. Fix mutable search_path on check_upload_quota ─────────────────────
-- If this function exists from an earlier migration, lock down its
-- search_path to prevent schema-injection privilege escalation.
-- (In migration 005 the quota logic was moved into an RLS policy; this
-- function may be a leftover. Dropping it is safe if it exists.)

DROP FUNCTION IF EXISTS public.check_upload_quota();

-- ── 2. Revoke direct access to upload_summaries materialized view ─────────
-- Any authenticated user could SELECT * FROM upload_summaries and see
-- every teacher's analytics. All legitimate access goes through the
-- get_my_upload_summaries() SECURITY DEFINER function, which scopes
-- results to the calling user's own uploads.

REVOKE SELECT ON public.upload_summaries FROM anon;
REVOKE SELECT ON public.upload_summaries FROM authenticated;
