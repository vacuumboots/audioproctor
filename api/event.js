// ─── /api/event ───────────────────────────────────────────────────
// Vercel serverless function.
// POST /api/event
// Body: { code, eventType, metadata? }
//
// Called by extension/player.js to log playback events.
// Uses the service role key to bypass RLS — the caller is identified
// only by the access code (no student identity is recorded).
//
// Accepted event types: playback_started, playback_paused,
// playback_resumed, playback_completed, replay_triggered,
// exit_word_used, session_expired.
// (code_entered is logged by api/session.js, not here.)

const { createClient } = require('@supabase/supabase-js');

const ALLOWED_EVENTS = new Set([
  'playback_started',
  'playback_paused',
  'playback_resumed',
  'playback_completed',
  'replay_triggered',
  'exit_word_used',
  'session_expired',
]);

module.exports = async (req, res) => {
  // CORS — Chrome extension origin is chrome-extension://...
  res.setHeader('Access-Control-Allow-Origin',  '*');
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') return res.status(200).end();
  if (req.method !== 'POST')   return res.status(405).json({ error: 'Method not allowed' });

  const { code, eventType, metadata } = req.body || {};

  if (!code || typeof code !== 'string') {
    return res.status(400).json({ error: 'Missing code' });
  }
  if (!eventType || !ALLOWED_EVENTS.has(eventType)) {
    return res.status(400).json({ error: 'Invalid or missing eventType' });
  }
  // metadata is optional; if present must be a plain object
  if (metadata !== undefined && (typeof metadata !== 'object' || Array.isArray(metadata))) {
    return res.status(400).json({ error: 'metadata must be a plain object' });
  }

  const supabase = createClient(
    process.env.SUPABASE_URL,
    process.env.SUPABASE_SERVICE_ROLE_KEY
  );

  // Look up the upload by access code — must still be valid (not expired).
  // We don't rate-limit this endpoint because it's only reachable by a
  // student who already successfully entered a code (signed URL in hand).
  const { data: upload, error: uploadErr } = await supabase
    .from('uploads')
    .select('id, expires_at')
    .eq('access_code', code.toUpperCase().trim())
    .single();

  if (uploadErr || !upload) {
    return res.status(404).json({ error: 'Code not found' });
  }

  // Accept events up to 2 hours after expiry to catch end-of-session events
  // that arrive just after the 1-hour signed URL expires.
  const grace = new Date(upload.expires_at).getTime() + 2 * 60 * 60 * 1000;
  if (Date.now() > grace) {
    return res.status(410).json({ error: 'Assessment expired' });
  }

  const { error: insertErr } = await supabase
    .from('session_events')
    .insert({
      upload_id:  upload.id,
      event_type: eventType,
      metadata:   metadata ?? null,
    });

  if (insertErr) {
    // Don't surface DB errors to the client — log and swallow
    console.error('session_events insert failed:', insertErr.message);
    return res.status(500).json({ error: 'Could not record event' });
  }

  return res.status(200).json({ ok: true });
};
