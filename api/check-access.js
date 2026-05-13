// ─── /api/check-access ─────────────────────────────────────────────
// Vercel serverless function.
// POST /api/check-access
//
// Called by the client after Google OAuth sign-in, BEFORE profile creation.
// Verifies the user's email matches the configured allowlist pattern.
// Existing users (already in profiles) are grandfathered through.
//
// Requires SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY, and
// ALLOWED_EMAIL_PATTERN env vars.

const { createClient } = require('@supabase/supabase-js');

module.exports = async (req, res) => {
  res.setHeader('Access-Control-Allow-Origin',  'https://app.audioproctor.com');
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  if (req.method === 'OPTIONS') return res.status(200).end();
  if (req.method !== 'POST')    return res.status(405).json({ error: 'Method not allowed' });

  const pattern = process.env.ALLOWED_EMAIL_PATTERN;
  if (!pattern) {
    // No pattern configured → allow everyone (same as current behaviour)
    return res.status(200).json({ allowed: true });
  }

  const authHeader = req.headers.authorization || '';
  const token = authHeader.replace('Bearer ', '');
  if (!token) return res.status(401).json({ error: 'Missing auth token' });

  const supabase = createClient(
    process.env.SUPABASE_URL,
    process.env.SUPABASE_SERVICE_ROLE_KEY
  );

  const { data: { user }, error: authErr } = await supabase.auth.getUser(token);
  if (authErr || !user) {
    return res.status(401).json({ error: 'Invalid token' });
  }

  const email = user.email || '';

  // Grandfather: existing users always allowed through
  const { data: existingProfile } = await supabase
    .from('profiles')
    .select('id')
    .eq('id', user.id)
    .maybeSingle();

  if (existingProfile) {
    return res.status(200).json({ allowed: true });
  }

  // Check email against allowlist pattern
  try {
    const regex = new RegExp(pattern, 'i');
    if (regex.test(email)) {
      return res.status(200).json({ allowed: true });
    }
  } catch (_) {
    console.error('Invalid ALLOWED_EMAIL_PATTERN regex:', pattern);
    return res.status(200).json({ allowed: true }); // fail open on bad regex
  }

  return res.status(200).json({
    allowed: false,
    reason: 'Your email is not authorized for this instance. Contact your division administrator.'
  });
};
