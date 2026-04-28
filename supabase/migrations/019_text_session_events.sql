-- ─── Migration 019: Text Session Event Types ─────────────────────
-- Run in Supabase SQL editor AFTER migration 018.
--
-- Adds text-compatible event types to the session_events CHECK constraint.
-- Existing constraint only allows audio-centric events (migration 004).

ALTER TABLE session_events
  DROP CONSTRAINT IF EXISTS session_events_event_type_check;

ALTER TABLE session_events
  ADD CONSTRAINT session_events_event_type_check
  CHECK (event_type IN (
    -- Audio events (existing)
    'code_entered',
    'playback_started',
    'playback_paused',
    'playback_resumed',
    'playback_completed',
    'replay_triggered',
    'exit_word_used',
    'session_expired',
    'audio_error',
    -- Text events (new)
    'text_viewed',
    'text_completed'
  ));
