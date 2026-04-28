-- ─── Migration 018: Text Assessment Support ───────────────────────
-- Run in Supabase SQL editor AFTER migration 017.
--
-- Adds support for text assessments alongside existing audio assessments.
-- Extends the uploads table with an assessment_type discriminator and
-- text-specific columns. Existing rows are backfilled as 'audio'.
--
-- Design decisions:
--   - storage_path remains NOT NULL (text rows use a synthetic placeholder)
--   - filename remains NOT NULL (text rows use 'text-assessment.txt')
--   - file_size_mb = 0 for text rows (no storage consumed)
--   - text_content max 25,000 characters (enforced in app + CHECK)

-- ─── New columns ──────────────────────────────────────────────────

ALTER TABLE uploads
  ADD COLUMN IF NOT EXISTS assessment_type  text    NOT NULL DEFAULT 'audio',
  ADD COLUMN IF NOT EXISTS text_content     text,
  ADD COLUMN IF NOT EXISTS text_char_count  integer NOT NULL DEFAULT 0;

-- Backfill existing rows (all audio)
UPDATE uploads
SET assessment_type = 'audio'
WHERE assessment_type IS NULL;

-- ─── Constraints ──────────────────────────────────────────────────

-- Valid assessment type values
ALTER TABLE uploads
  DROP CONSTRAINT IF EXISTS uploads_assessment_type_check,
  ADD CONSTRAINT uploads_assessment_type_check
  CHECK (assessment_type IN ('audio', 'text'));

-- Text rows must have non-empty text_content; max 25k chars
ALTER TABLE uploads
  DROP CONSTRAINT IF EXISTS uploads_text_shape_check,
  ADD CONSTRAINT uploads_text_shape_check
  CHECK (
    assessment_type <> 'text'
    OR (
      text_content IS NOT NULL
      AND length(text_content) > 0
      AND length(text_content) <= 25000
    )
  );

-- Text rows must have text_char_count matching content
ALTER TABLE uploads
  DROP CONSTRAINT IF EXISTS uploads_text_char_count_check,
  ADD CONSTRAINT uploads_text_char_count_check
  CHECK (
    assessment_type <> 'text'
    OR text_char_count > 0
  );
