// ─── /api/accept-invite ───────────────────────────────────────────────────────
// GET  ?token=...     — validate token, return invitation details
// POST { token }      — Bearer JWT; attach signed-in user to the invited org

const { createClient } = require('@supabase/supabase-js');

module.exports = async (req, res) => {
  res.setHeader('Access-Control-Allow-Origin',  'https://app.audioproctor.com');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  if (req.method === 'OPTIONS') return res.status(200).end();

  const supabase = createClient(
    process.env.SUPABASE_URL,
    process.env.SUPABASE_SERVICE_ROLE_KEY
  );

  // ─── GET: validate token ─────────────────────────────────────────
  if (req.method === 'GET') {
    const { token } = req.query;
    if (!token) return res.status(400).json({ error: 'token required' });

    const { data: invite, error } = await supabase
      .from('invitations')
      .select('id, email, role, school_id, division_id, expires_at, accepted_at, schools(name), divisions(name)')
      .eq('token', token)
      .maybeSingle();

    if (error || !invite) return res.status(404).json({ error: 'Invitation not found.' });
    if (invite.accepted_at) return res.status(410).json({ error: 'This invitation has already been accepted.', reason: 'accepted' });
    if (new Date(invite.expires_at) < new Date()) return res.status(410).json({ error: 'This invitation has expired.', reason: 'expired', expiredAt: invite.expires_at });

    return res.status(200).json({
      email:        invite.email,
      role:         invite.role,
      schoolName:   invite.schools?.name   || null,
      divisionName: invite.divisions?.name || null,
      expiresAt:    invite.expires_at,
    });
  }

  // ─── POST: accept invitation ─────────────────────────────────────
  if (req.method === 'POST') {
    const authHeader = req.headers['authorization'] || '';
    const jwt = authHeader.startsWith('Bearer ') ? authHeader.slice(7) : null;
    if (!jwt) return res.status(401).json({ error: 'Authentication required.' });

    const anonClient = createClient(
      process.env.SUPABASE_URL,
      process.env.SUPABASE_ANON_KEY,
      { global: { headers: { Authorization: `Bearer ${jwt}` } } }
    );

    const { data: { user }, error: authErr } = await anonClient.auth.getUser();
    if (authErr || !user) return res.status(401).json({ error: 'Invalid session.' });

    const { token } = req.body || {};
    if (!token) return res.status(400).json({ error: 'token required' });

    const { data: invite, error: invErr } = await supabase
      .from('invitations')
      .select('id, email, role, school_id, division_id, expires_at, accepted_at')
      .eq('token', token)
      .maybeSingle();

    if (invErr || !invite) return res.status(404).json({ error: 'Invitation not found.' });
    if (invite.accepted_at) return res.status(410).json({ error: 'This invitation has already been accepted.', reason: 'accepted' });
    if (new Date(invite.expires_at) < new Date()) return res.status(410).json({ error: 'This invitation has expired.', reason: 'expired', expiredAt: invite.expires_at });

    if (invite.email.toLowerCase() !== user.email.toLowerCase()) {
      return res.status(403).json({
        error: `This invitation is for ${invite.email}. Please sign in with that account.`,
      });
    }

    const { error: profileErr } = await supabase
      .from('profiles')
      .update({
        role:        invite.role,
        school_id:   invite.school_id   || null,
        division_id: invite.division_id || null,
      })
      .eq('id', user.id);

    if (profileErr) {
      console.error('accept-invite profile update failed:', profileErr.message);
      return res.status(500).json({ error: 'Could not update your profile. Please contact hello@audioproctor.com.' });
    }

    await supabase
      .from('invitations')
      .update({ accepted_at: new Date().toISOString() })
      .eq('id', invite.id);

    return res.status(200).json({ ok: true, role: invite.role });
  }

  return res.status(405).json({ error: 'Method not allowed' });
};
