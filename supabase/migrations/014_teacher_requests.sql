-- ─── Migration 014: Teacher Access Requests ─────────────────────────────────
-- Run in Supabase SQL editor AFTER migration 013.
-- Stores teacher sign-up requests submitted via /request-access.
-- All access is via the service role key in api/ — no public RLS policies.

CREATE TABLE IF NOT EXISTS teacher_requests (
  id          uuid        DEFAULT gen_random_uuid() PRIMARY KEY,
  name        text        NOT NULL,
  email       text        NOT NULL,
  school      text,
  division    text,
  message     text,
  status      text        NOT NULL DEFAULT 'pending'
                          CHECK (status IN ('pending', 'approved', 'rejected')),
  notes       text,
  created_at  timestamptz NOT NULL DEFAULT now(),
  reviewed_at timestamptz,
  reviewed_by uuid        REFERENCES auth.users(id) ON DELETE SET NULL
);

ALTER TABLE teacher_requests ENABLE ROW LEVEL SECURITY;
-- No public policies — only accessible via service role key in api/
