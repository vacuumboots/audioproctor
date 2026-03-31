// ─── /api/account ────────────────────────────────────────────────────────────
// Vercel serverless function for account self-management.
//
// Routes (via ?action= query param):
//
//   POST ?action=update-profile  — body: { displayName }
//   POST ?action=delete-account  — permanently deletes caller's account and all data

const { createClient } = require('@supabase/supabase-js');

module.exports = async (req, res) => {
  res.setHeader('Access-Control-Allow-Origin',  'https://app.audioproctor.com');
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  if (req.method === 'OPTIONS') return res.status(200).end();
  if (req.method !== 'POST')    return res.status(405).json({ error: 'Method not allowed' });

  // ─── Auth ───────────────────────────────────────────────────────────────
  const authHeader = req.headers['authorization'] || '';
  const jwt = authHeader.startsWith('Bearer ') ? authHeader.slice(7) : null;
  if (!jwt) return res.status(401).json({ error: 'Missing authorization' });

  const anonClient = createClient(
    process.env.SUPABASE_URL,
    process.env.SUPABASE_ANON_KEY,
    { global: { headers: { Authorization: `Bearer ${jwt}` } } }
  );

  const { data: { user }, error: authErr } = await anonClient.auth.getUser();
  if (authErr || !user) return res.status(401).json({ error: 'Invalid token' });

  const supabase = createClient(
    process.env.SUPABASE_URL,
    process.env.SUPABASE_SERVICE_ROLE_KEY
  );

  const action = req.query.action;
  const body   = req.body || {};

  // ─── update-profile ────────────────────────────────────────────────────
  if (action === 'update-profile') {
    const { displayName } = body;
    if (typeof displayName !== 'string') {
      return res.status(400).json({ error: 'displayName must be a string' });
    }

    const { error } = await supabase
      .from('profiles')
      .update({ display_name: displayName.trim() || null })
      .eq('id', user.id);

    if (error) return res.status(500).json({ error: error.message });
    return res.status(200).json({ ok: true });
  }

  // ─── delete-account ────────────────────────────────────────────────────
  if (action === 'delete-account') {
    // Block if school_admin — must relinquish role first
    const { data: profile } = await supabase
      .from('profiles')
      .select('role')
      .eq('id', user.id)
      .single();

    if (profile?.role === 'school_admin') {
      return res.status(400).json({
        error: 'You must relinquish your School Admin role before deleting your account. Contact your division admin or platform support.',
      });
    }

    // Collect unique storage paths (de-duplicate shared paths from duplicated uploads)
    const { data: uploads } = await supabase
      .from('uploads')
      .select('storage_path')
      .eq('teacher_id', user.id);

    const uniquePaths = [...new Set((uploads || []).map(u => u.storage_path))];

    // Delete storage files — don't abort the whole operation if some are missing
    if (uniquePaths.length > 0) {
      await supabase.storage.from('audio-files').remove(uniquePaths);
    }

    // Delete upload rows (session_events cascade via ON DELETE CASCADE)
    await supabase.from('uploads').delete().eq('teacher_id', user.id);

    // Delete profile row
    await supabase.from('profiles').delete().eq('id', user.id);

    // Delete auth.users record
    const { error: deleteErr } = await supabase.auth.admin.deleteUser(user.id);
    if (deleteErr) {
      return res.status(500).json({ error: 'Failed to delete auth account: ' + deleteErr.message });
    }

    return res.status(200).json({ ok: true });
  }

  return res.status(400).json({ error: 'Unknown action' });
};
