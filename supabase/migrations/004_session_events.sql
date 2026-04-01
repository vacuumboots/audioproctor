-- ─── Migration 004: Session Analytics ───────────────────────────────
-- Run in Supabase SQL editor (Dashboard → SQL Editor → New query).
-- Requires pg_cron extension (enabled by default on all Supabase projects).

-- ─── session_events ──────────────────────────────────────────────────
-- One row per trackable event during a student session.
-- No student identity, device fingerprint, or IP address stored here.
-- upload_id references the uploads row the student accessed.

CREATE TABLE IF NOT EXISTS session_events (
  id          uuid        DEFAULT gen_random_uuid() PRIMARY KEY,
  upload_id   uuid        NOT NULL REFERENCES uploads(id) ON DELETE CASCADE,
  event_type  text        NOT NULL CHECK (event_type IN (
                'code_entered',
                'playback_started',
                'playback_paused',
                'playback_resumed',
                'playback_completed',
                'replay_triggered',
                'exit_word_used',
                'session_expired'
              )),
  occurred_at timestamptz NOT NULL DEFAULT now(),
  metadata    jsonb
);

-- Index for per-upload queries (dashboard summaries, CSV export)
CREATE INDEX IF NOT EXISTS session_events_upload_id_idx
  ON session_events (upload_id, occurred_at DESC);

-- ─── RLS ─────────────────────────────────────────────────────────────

ALTER TABLE session_events ENABLE ROW LEVEL SECURITY;

-- Teachers may read events for their own uploads only.
-- No INSERT policy — all writes go through api/event.js (service role).
CREATE POLICY "teachers_read_own_events"
  ON session_events
  FOR SELECT
  USING (
    upload_id IN (
      SELECT id FROM uploads WHERE teacher_id = auth.uid()
    )
  );

-- ─── upload_summaries (materialized view) ────────────────────────────
-- Aggregates per upload. Refreshed every 15 minutes via pg_cron.
-- Use CONCURRENTLY so reads are never blocked during refresh.

CREATE MATERIALIZED VIEW IF NOT EXISTS upload_summaries AS
SELECT
  upload_id,
  COUNT(*)           FILTER (WHERE event_type = 'code_entered')       AS total_sessions,
  COUNT(*)           FILTER (WHERE event_type = 'playback_completed') AS completions,
  COUNT(*)           FILTER (WHERE event_type = 'exit_word_used')     AS exits_with_word,
  COUNT(*)           FILTER (WHERE event_type = 'session_expired')    AS session_expirations,
  COUNT(*)           FILTER (WHERE event_type = 'replay_triggered')   AS replays,
  ROUND(
    AVG(
      CASE WHEN event_type = 'playback_completed'
        THEN (metadata->>'position_seconds')::numeric
      END
    )::numeric, 0
  )                                                                    AS avg_listen_seconds,
  MAX(occurred_at)                                                     AS last_used_at
FROM session_events
GROUP BY upload_id;

-- Unique index required for CONCURRENTLY refresh
CREATE UNIQUE INDEX IF NOT EXISTS upload_summaries_upload_id_idx
  ON upload_summaries (upload_id);

-- ─── pg_cron: refresh every 15 minutes ───────────────────────────────
-- If you get "extension pg_cron is not available", enable it first:
--   Dashboard → Database → Extensions → search "pg_cron" → Enable
-- The cron job runs in the postgres schema by default.

SELECT cron.schedule(
  'refresh-upload-summaries',          -- job name (idempotent if re-run)
  '*/15 * * * *',                      -- every 15 minutes
  $$REFRESH MATERIALIZED VIEW CONCURRENTLY upload_summaries$$
);

-- Seed the view immediately so data is available before the first cron run.
-- Without this, the Insights card shows zeroes for up to 15 minutes after
-- the migration is applied, even if session_events already has rows.
REFRESH MATERIALIZED VIEW upload_summaries;
