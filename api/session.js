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

  const supabase = createClient(
    process.env.SUPABASE_URL,
    process.env.SUPABASE_SERVICE_ROLE_KEY
  );

  // Look up upload by access code
  const { data: upload, error } = await supabase
    .from('uploads')
    .select('id, filename, storage_path, exit_word_hash, expires_at')
    .eq('access_code', code.toUpperCase().trim())
    .single();

  if (error || !upload) {
    return res.status(404).json({ error: 'Access code not found' });
  }

  // Check expiry
  if (new Date(upload.expires_at) < new Date()) {
    return res.status(410).json({ error: 'This assessment has expired' });
  }

  // Generate a signed URL valid for 1 hour
  const { data: signed, error: signError } = await supabase
    .storage
    .from('audio-files')
    .createSignedUrl(upload.storage_path, 3600);

  if (signError || !signed) {
    return res.status(500).json({ error: 'Could not generate audio link' });
  }

  // Return only what the client needs.
  // storage_path and exit_word (plain) are intentionally omitted.
  return res.status(200).json({
    signedUrl:    signed.signedUrl,
    filename:     upload.filename,
    exitWordHash: upload.exit_word_hash,
  });
};
