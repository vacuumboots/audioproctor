-- Migration 017: Block uploads for deactivated teachers
-- Run in Supabase SQL editor.
--
-- Adds an RLS policy on uploads INSERT that prevents deactivated teachers
-- from creating new uploads. The is_deactivated flag is checked in
-- api/session.js for code resolution; this policy closes the gap where
-- a deactivated teacher could still upload unplayable assessments.
--
-- No index changes needed — profiles_deactivated_idx already exists (migration 009).

DROP POLICY IF EXISTS "block_deactivated_uploads" ON uploads;

CREATE POLICY "block_deactivated_uploads"
  ON uploads
  FOR INSERT
  WITH CHECK (
    teacher_id = auth.uid()
    AND EXISTS (
      SELECT 1 FROM profiles
      WHERE id = auth.uid() AND is_deactivated = false
    )
  );
