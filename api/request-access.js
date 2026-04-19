// ─── /api/request-access ─────────────────────────────────────────────────────
// POST: stores a teacher access request and notifies the platform admin.

const { createClient } = require('@supabase/supabase-js');
const { Resend }       = require('resend');

module.exports = async (req, res) => {
  res.setHeader('Access-Control-Allow-Origin',  '*');
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') return res.status(200).end();
  if (req.method !== 'POST')   return res.status(405).json({ error: 'Method not allowed' });

  const { name, email, school, division, message, website } = req.body || {};

  if (website) return res.status(200).json({ ok: true }); // honeypot

  if (!name || !email) {
    return res.status(400).json({ error: 'Name and email are required.' });
  }

  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if (!emailRegex.test(email)) {
    return res.status(400).json({ error: 'Please enter a valid email address.' });
  }

  if (name.length > 200 || email.length > 254 ||
      (school   && school.length   > 200) ||
      (division && division.length > 200) ||
      (message  && message.length  > 2000)) {
    return res.status(400).json({ error: 'One or more fields are too long.' });
  }

  const supabase = createClient(
    process.env.SUPABASE_URL,
    process.env.SUPABASE_SERVICE_ROLE_KEY
  );

  const { error: dbErr } = await supabase.from('teacher_requests').insert({
    name:     name.trim(),
    email:    email.trim().toLowerCase(),
    school:   school?.trim()   || null,
    division: division?.trim() || null,
    message:  message?.trim()  || null,
  });

  if (dbErr) {
    console.error('teacher_requests insert failed:', dbErr.message);
    return res.status(500).json({ error: 'Could not save your request. Please email hello@audioproctor.com directly.' });
  }

  // Notify platform admin — non-fatal if this fails
  try {
    const resend = new Resend(process.env.RESEND_API_KEY);
    await resend.emails.send({
      from:    'AudioProctor <hello@audioproctor.com>',
      to:      process.env.CONTACT_EMAIL,
      replyTo: email.trim(),
      subject: `Access request: ${name.trim()}${division ? ' — ' + division.trim() : ''}`,
      text: [
        'New teacher access request:',
        '',
        `Name:     ${name.trim()}`,
        `Email:    ${email.trim()}`,
        `School:   ${school?.trim()   || '(not provided)'}`,
        `Division: ${division?.trim() || '(not provided)'}`,
        '',
        'Message:',
        message?.trim() || '(none)',
        '',
        'Review at: https://app.audioproctor.com/admin.html',
      ].join('\n'),
    });
  } catch (emailErr) {
    console.error('admin notification email failed:', emailErr.message);
  }

  return res.status(200).json({ ok: true });
};
