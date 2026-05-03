-- Migration 021: Inline Image Storage RLS Policies
-- Run in Supabase SQL editor AFTER migration 020.
--
-- Policies for the assessment-images storage bucket.
-- The bucket itself must be created manually in Supabase Dashboard
-- (Storage -> New Bucket -> name: 'assessment-images', public: NO, file size limit: 2 MB).
-- These policies are applied to the existing storage.objects table.

-- Teachers can upload images to their own directory
DROP POLICY IF EXISTS "teachers_upload_own_images" ON storage.objects;
CREATE POLICY "teachers_upload_own_images"
  ON storage.objects
  FOR INSERT
  WITH CHECK (
    bucket_id = 'assessment-images'
    AND auth.role() = 'authenticated'
    AND (storage.foldername(name))[1] = auth.uid()::text
  );

-- Teachers can delete their own images
DROP POLICY IF EXISTS "teachers_delete_own_images" ON storage.objects;
CREATE POLICY "teachers_delete_own_images"
  ON storage.objects
  FOR DELETE
  USING (
    bucket_id = 'assessment-images'
    AND auth.role() = 'authenticated'
    AND (storage.foldername(name))[1] = auth.uid()::text
  );

-- Session API uses service role (bypasses RLS) — no SELECT policy needed
