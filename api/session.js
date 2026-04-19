// ─── /api/session ────────────────────────────────────────────────
// Vercel serverless function.
// GET /api/session?code=ABC-123
//
// Validates the access code, checks expiry, and returns a 1-hour
// signed URL for the private audio file plus the exit word hash.
//
// Uses the service role key, which bypasses RLS. This key must
// NEVER be sent to the browser — it lives only in this function.

const { createClient } = require('@supabase/supabase-js');

const RATE_LIMIT_MAX    = 10;   // max failed attempts per IP per window
const RATE_LIMIT_WINDOW = 60;   // minutes

module.exports = async (req, res) => {
  // CORS — required so the Chrome extension can call this endpoint.
  // The extension origin is chrome-extension://... not audioproctor.com.
  res.setHeader('Access-Control-Allow-Origin',  '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') return res.status(200).end();
  if (req.method !== 'GET')    return res.status(405).json({ error: 'Method not allowed' });

  const { code } = req.query;
  if (!code) return res.status(400).json({ error: 'Missing code parameter' });

  // Validate code format — reject obviously invalid input before hitting the DB
  if (typeof code !== 'string' || code.length > 20 || !/^[A-Za-z0-9 -]{2,20}$/.test(code)) {
    return res.status(400).json({ error: 'Invalid code format' });
  }

  const supabase = createClient(
    process.env.SUPABASE_URL,
    process.env.SUPABASE_SERVICE_ROLE_KEY
  );

  // ─── Rate limiting ────────────────────────────────────────────
  // Track failed lookups per IP. Blocks brute-force code guessing.
  const clientIp = (req.headers['x-forwarded-for'] || '').split(',')[0].trim() || 'unknown';
  const windowStart = new Date(Date.now() - RATE_LIMIT_WINDOW * 60 * 1000).toISOString();

  // Purge stale entries (older than 2× window) to keep the table small
  await supabase
    .from('rate_limit_log')
    .delete()
    .lt('attempted_at', new Date(Date.now() - RATE_LIMIT_WINDOW * 2 * 60 * 1000).toISOString());

  const { count } = await supabase
    .from('rate_limit_log')
    .select('id', { count: 'exact', head: true })
    .eq('ip', clientIp)
    .gte('attempted_at', windowStart);

  if (count >= RATE_LIMIT_MAX) {
    return res.status(429).json({ error: 'Too many attempts. Try again later.' });
  }

  // ─── Access code lookup ───────────────────────────────────────
  const { data: upload, error } = await supabase
    .from('uploads')
    .select('id, filename, storage_path, exit_word_hash, expires_at, teacher_id')
    .eq('access_code', code.toUpperCase().trim())
    .single();

  if (error || !upload) {
    await supabase.from('rate_limit_log').insert({ ip: clientIp });
    return res.status(404).json({ error: 'Access code not found' });
  }

  // Check expiry
  if (new Date(upload.expires_at) < new Date()) {
    await supabase.from('rate_limit_log').insert({ ip: clientIp });
    return res.status(410).json({ error: 'This assessment has expired' });
  }

  // Check that the teacher account is not deactivated
  const { data: teacher } = await supabase
    .from('profiles')
    .select('is_deactivated')
    .eq('id', upload.teacher_id)
    .maybeSingle();

  if (teacher?.is_deactivated) {
    return res.status(403).json({ error: 'This assessment is no longer available' });
  }

  // Generate a signed URL valid for 1 hour
  const { data: signed, error: signError } = await supabase
    .storage
    .from('audio-files')
    .createSignedUrl(upload.storage_path, 3600);

  if (signError || !signed) {
    return res.status(500).json({ error: 'Could not generate audio link' });
  }

  // Log the successful code entry — fire-and-forget, never blocks the response.
  supabase.from('session_events').insert({
    upload_id:  upload.id,
    event_type: 'code_entered',
  }).then(({ error }) => {
    if (error) console.error('session_events insert failed:', error.message);
  });

  // Return only what the client needs.
  // storage_path and exit_word (plain) are intentionally omitted.
  return res.status(200).json({
    signedUrl:    signed.signedUrl,
    filename:     upload.filename,
    exitWordHash: upload.exit_word_hash,
  });
};
