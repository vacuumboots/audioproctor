// ─── /api/accept-invite ───────────────────────────────────────────────────────
// GET  ?token=...     — validate token, return invitation details
// POST { token }      — Bearer JWT; attach signed-in user to the invited org

const { createClient } = require('@supabase/supabase-js');
const { sendEmail } = require('./_lib/email');
const { getRequestLanguage, apiMessage } = require('./_lib/i18n');

module.exports = async (req, res) => {
  res.setHeader('Access-Control-Allow-Origin',  'https://app.audioproctor.com');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  if (req.method === 'OPTIONS') return res.status(200).end();

  const lang = getRequestLanguage(req);

  const supabase = createClient(
    process.env.SUPABASE_URL,
    process.env.SUPABASE_SERVICE_ROLE_KEY
  );

  // ─── GET: validate token ─────────────────────────────────────────
  if (req.method === 'GET') {
    const { token } = req.query;
    if (!token) return res.status(400).json({ error: apiMessage('missing_param', lang, { param: 'token' }) });

    const { data: invite, error } = await supabase
      .from('invitations')
      .select('id, email, role, school_id, division_id, expires_at, accepted_at, schools(name), divisions(name)')
      .eq('token', token)
      .maybeSingle();

    if (error || !invite) return res.status(404).json({ error: apiMessage('not_found', lang) });
    if (invite.accepted_at) {
      logInviteEmail(supabase, invite.id, 'accept_already_accepted');
      return res.status(410).json({ error: apiMessage('invitation_used', lang), reason: 'accepted' });
    }
    if (new Date(invite.expires_at) < new Date()) {
      logInviteEmail(supabase, invite.id, 'accept_expired');
      return res.status(410).json({ error: apiMessage('invitation_expired', lang), reason: 'expired', expiredAt: invite.expires_at });
    }

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
    if (!jwt) return res.status(401).json({ error: apiMessage('missing_auth', lang) });

    const anonClient = createClient(
      process.env.SUPABASE_URL,
      process.env.SUPABASE_ANON_KEY,
      { global: { headers: { Authorization: `Bearer ${jwt}` } } }
    );

    const { data: { user }, error: authErr } = await anonClient.auth.getUser();
    if (authErr || !user) return res.status(401).json({ error: apiMessage('invalid_token', lang) });

    const { token } = req.body || {};
    if (!token) return res.status(400).json({ error: apiMessage('missing_param', lang, { param: 'token' }) });

    const { data: invite, error: invErr } = await supabase
      .from('invitations')
      .select('id, email, role, school_id, division_id, expires_at, accepted_at')
      .eq('token', token)
      .maybeSingle();

    if (invErr || !invite) return res.status(404).json({ error: apiMessage('not_found', lang) });
    if (invite.accepted_at) {
      logInviteEmail(supabase, invite.id, 'accept_already_accepted');
      return res.status(410).json({ error: apiMessage('invitation_used', lang), reason: 'accepted' });
    }
    if (new Date(invite.expires_at) < new Date()) {
      logInviteEmail(supabase, invite.id, 'accept_expired');
      return res.status(410).json({ error: apiMessage('invitation_expired', lang), reason: 'expired', expiredAt: invite.expires_at });
    }

    if (invite.email.toLowerCase() !== user.email.toLowerCase()) {
      return res.status(403).json({
        error: apiMessage('invitation_email_mismatch', lang, { email: invite.email }),
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
      return res.status(500).json({ error: apiMessage('profile_update_failed', lang) });
    }

    const { error: acceptErr } = await supabase
      .from('invitations')
      .update({ accepted_at: new Date().toISOString() })
      .eq('id', invite.id);

    if (acceptErr) {
      console.error('accept-invite invitation update failed:', acceptErr.message);
      return res.status(500).json({ error: apiMessage('invitation_accept_failed', lang) });
    }

    // Fire-and-forget welcome email — don't block the response
    try {
      const isFr = lang === 'fr';
      const welcomeSubject = isFr ? 'Bienvenue sur AudioProctor' : 'Welcome to AudioProctor';
      const welcomeText = isFr
        ? `Bonjour,\n\nBienvenue sur AudioProctor ! Votre compte est maintenant actif et vous pouvez commencer à créer des évaluations pour vos élèves.\n\nSi vous avez des questions, répondez à ce courriel ou contactez-nous à hello@audioproctor.com.\n\n— L'équipe AudioProctor`
        : `Hi there,\n\nWelcome to AudioProctor! Your account is now active and you can start creating assessments for your students.\n\nIf you have any questions, reply to this email or contact us at hello@audioproctor.com.\n\n— The AudioProctor Team`;
      const welcomeHtml = isFr
        ? `<p>Bonjour,</p><p>Bienvenue sur AudioProctor ! Votre compte est maintenant actif et vous pouvez commencer à créer des évaluations pour vos élèves.</p><p>Si vous avez des questions, répondez à ce courriel ou contactez-nous à <a href="mailto:hello@audioproctor.com">hello@audioproctor.com</a>.</p><p>— L'équipe AudioProctor</p>`
        : `<p>Hi there,</p><p>Welcome to AudioProctor! Your account is now active and you can start creating assessments for your students.</p><p>If you have any questions, reply to this email or contact us at <a href="mailto:hello@audioproctor.com">hello@audioproctor.com</a>.</p><p>— The AudioProctor Team</p>`;
      sendEmail({ to: invite.email, subject: welcomeSubject, text: welcomeText, html: welcomeHtml }).catch(() => {});
    } catch {
      // ignore — welcome email is best-effort
    }

    return res.status(200).json({ ok: true, role: invite.role });
  }

  return res.status(405).json({ error: apiMessage('method_not_allowed', lang) });
};

function logInviteEmail(supabase, invitationId, action, emailOk, errorMessage) {
  supabase.from('invite_email_log').insert({
    invitation_id: invitationId ?? null,
    action,
    email_ok:      emailOk ?? null,
    error_message: errorMessage ?? null,
  }).then(({ error }) => {
    if (error) console.error('invite email log insert failed:', error.message);
  });
}
