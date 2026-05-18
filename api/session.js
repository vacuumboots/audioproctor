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
const { getRequestLanguage, apiMessage } = require('./_lib/i18n.js');

const RATE_LIMIT_MAX    = 10;   // max failed attempts per IP per window
const RATE_LIMIT_WINDOW = 60;   // minutes

function escapeHTMLAttr(str) {
  return str.replace(/&/g, '&amp;').replace(/"/g, '&quot;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
}

module.exports = async (req, res) => {
  // CORS — required so the Chrome extension can call this endpoint.
  // The extension origin is chrome-extension://... not audioproctor.com.
  res.setHeader('Access-Control-Allow-Origin',  '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') return res.status(200).end();

  const lang = getRequestLanguage(req);

  if (req.method !== 'GET')    return res.status(405).json({ error: apiMessage('method_not_allowed', lang) });

  const { code } = req.query;
  if (!code) return res.status(400).json({ error: apiMessage('missing_param', lang, { param: 'code' }) });

  // Validate code format — reject obviously invalid input before hitting the DB
  if (typeof code !== 'string' || code.length > 20 || !/^[A-Za-z0-9 -]{2,20}$/.test(code)) {
    return res.status(400).json({ error: apiMessage('invalid_param', lang, { param: 'code' }) });
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
    return res.status(429).json({ error: apiMessage('rate_limited', lang) });
  }

  // ─── Access code lookup ───────────────────────────────────────
  const { data: upload, error } = await supabase
    .from('uploads')
    .select('id, filename, storage_path, exit_word_hash, expires_at, teacher_id, assessment_type, label, text_content, text_char_count, image_count')
    .eq('access_code', code.toUpperCase().trim())
    .single();

  if (error || !upload) {
    await supabase.from('rate_limit_log').insert({ ip: clientIp });
    return res.status(404).json({ error: apiMessage('session_invalid', lang) });
  }

  // Check expiry
  if (new Date(upload.expires_at) < new Date()) {
    await supabase.from('rate_limit_log').insert({ ip: clientIp });
    return res.status(410).json({ error: apiMessage('session_expired', lang) });
  }

  // Check that the teacher account is not deactivated
  const { data: teacher } = await supabase
    .from('profiles')
    .select('is_deactivated')
    .eq('id', upload.teacher_id)
    .maybeSingle();

  if (teacher?.is_deactivated) {
    return res.status(403).json({ error: apiMessage('forbidden', lang) });
  }

  // ─── Build typed response ───────────────────────────────────────
  // Text assessments skip signed URL generation entirely.

  let responseBody;

  if (upload.assessment_type === 'text') {
    let resolvedHtml = upload.text_content;

    // Resolve inline images if present
    if (upload.image_count > 0) {
      const teacherId = upload.teacher_id;
      const accessCode = code.toUpperCase().trim();

      // Generate signed URLs for each image
      const signedUrls = [];
      for (let i = 0; i < upload.image_count; i++) {
        let found = false;
        for (const ext of ['png', 'jpg', 'webp']) {
          const imgPath = `${teacherId}/${accessCode}/img_${i}.${ext}`;
          const { data: signed, error: signError } = await supabase
            .storage
            .from('assessment-images')
            .createSignedUrl(imgPath, 3600);

          if (!signError && signed) {
            signedUrls[i] = signed.signedUrl;
            found = true;
            break;
          }
        }
        if (!found) {
          signedUrls[i] = '';
        }
      }

      // Replace <img data-apimg-idx="N"> placeholders with resolved <img> tags
      resolvedHtml = resolvedHtml.replace(
        /<img[^>]*data-apimg-idx="(\d+)"[^>]*>/g,
        (match, idx) => {
          const url = signedUrls[parseInt(idx)] || '';
          if (!url) return '';
          return `<img src="${escapeHTMLAttr(url)}" style="max-width:100%;height:auto;display:inline-block;vertical-align:middle;margin:0.25rem 0;border:1px solid #e8e0d0;">`;
        }
      );
    }

    responseBody = {
      assessmentType: 'text',
      title:          upload.label || upload.filename || 'Text Assessment',
      textContent:    resolvedHtml,
      textCharCount:  upload.text_char_count,
      exitWordHash:   upload.exit_word_hash,
      imageCount:     upload.image_count,
    };
  } else {
    // Audio: generate a signed URL valid for 1 hour
    const { data: signed, error: signError } = await supabase
      .storage
      .from('audio-files')
      .createSignedUrl(upload.storage_path, 3600);

    if (signError || !signed) {
      return res.status(500).json({ error: apiMessage('server_error', lang) });
    }

    responseBody = {
      assessmentType: 'audio',
      title:         upload.label || upload.filename,
      filename:      upload.filename,
      signedUrl:     signed.signedUrl,
      exitWordHash:  upload.exit_word_hash,
    };
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
  return res.status(200).json(responseBody);
};
