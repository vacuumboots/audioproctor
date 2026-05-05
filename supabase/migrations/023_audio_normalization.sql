-- ─── Migration 023: Audio Normalization Pipeline ─────────────────────
-- Run in Supabase SQL editor AFTER migration 022.
--
-- Adds a processing_status column to track the audio normalization
-- pipeline state. Browser uploads go to a staging path first; a
-- Supabase Edge Function transcodes to 32kbps mono MP3 and moves
-- the file to the final location.
--
-- Pipeline states:
--   pending   — uploaded to staging, awaiting Edge Function processing
--   processing — Edge Function is actively transcoding
--   ready     — normalized file is in final location, staging cleaned up
--   failed    — transcoding failed; staging file may still exist
--
-- Audio assessments: pending → processing → ready (or → failed)
-- Text assessments: always 'ready' (no audio processing needed)
-- Legacy rows:     backfilled to 'ready'

-- ─── New column ──────────────────────────────────────────────────────

ALTER TABLE uploads
  ADD COLUMN IF NOT EXISTS processing_status text NOT NULL DEFAULT 'ready';

-- ─── Constraints ─────────────────────────────────────────────────────

ALTER TABLE uploads
  DROP CONSTRAINT IF EXISTS uploads_processing_status_check,
  ADD CONSTRAINT uploads_processing_status_check
  CHECK (processing_status IN ('pending', 'processing', 'ready', 'failed'));

-- ─── Backfill ────────────────────────────────────────────────────────
-- Existing audio rows are already in final location, mark as ready.
-- Text rows never go through audio processing.
UPDATE uploads
SET processing_status = 'ready'
WHERE processing_status IS NULL OR processing_status = 'pending';

-- ─── Staging path policy for audio-files bucket ─────────────────────
-- Teachers can upload to their own staging directory, and delete from it.
-- The service role (Edge Function) bypasses RLS entirely.

DROP POLICY IF EXISTS "teachers_upload_staging_audio" ON storage.objects;
CREATE POLICY "teachers_upload_staging_audio"
  ON storage.objects
  FOR INSERT
  WITH CHECK (
    bucket_id = 'audio-files'
    AND auth.role() = 'authenticated'
    AND (storage.foldername(name))[1] = 'staging'
    AND (storage.foldername(name))[2] = auth.uid()::text
  );

DROP POLICY IF EXISTS "teachers_delete_staging_audio" ON storage.objects;
CREATE POLICY "teachers_delete_staging_audio"
  ON storage.objects
  FOR DELETE
  USING (
    bucket_id = 'audio-files'
    AND auth.role() = 'authenticated'
    AND (storage.foldername(name))[1] = 'staging'
    AND (storage.foldername(name))[2] = auth.uid()::text
  );

DROP POLICY IF EXISTS "teachers_read_final_audio" ON storage.objects;
CREATE POLICY "teachers_read_final_audio"
  ON storage.objects
  FOR SELECT
  USING (
    bucket_id = 'audio-files'
    AND auth.role() = 'authenticated'
    AND (
      -- Teachers can see their own finalized files
      (storage.foldername(name))[1] = auth.uid()::text
      OR
      -- Or staging files they uploaded
      ((storage.foldername(name))[1] = 'staging' AND (storage.foldername(name))[2] = auth.uid()::text)
    )
  );

-- Existing rows with path `{userId}/{code}.mp3` are readable by
-- the storage.foldername[1] = auth.uid() rule since they have no staging prefix.

-- ─── Index for status polling ────────────────────────────────────────
-- The dashboard polls by id + processing_status for real-time feedback.
CREATE INDEX IF NOT EXISTS idx_uploads_processing_status
  ON uploads (id, processing_status);
