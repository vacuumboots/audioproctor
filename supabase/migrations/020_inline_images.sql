-- Migration 020: Inline Image Support
-- Run in Supabase SQL editor AFTER migration 019.
--
-- Adds image_count to uploads so the session API knows how many
-- signed URLs to generate for inline images in text assessments.

ALTER TABLE uploads
  ADD COLUMN IF NOT EXISTS image_count integer NOT NULL DEFAULT 0;

-- Text assessments with images must have image_count >= 0
ALTER TABLE uploads
  DROP CONSTRAINT IF EXISTS uploads_image_count_check,
  ADD CONSTRAINT uploads_image_count_check
  CHECK (
    assessment_type <> 'text'
    OR image_count >= 0
  );
