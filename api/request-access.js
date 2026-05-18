// ─── /api/request-access ─────────────────────────────────────────────────────
// POST: stores a teacher access request and notifies the platform admin.

const { createClient } = require('@supabase/supabase-js');
const { Resend }       = require('resend');
const { getRequestLanguage, apiMessage } = require('./_lib/i18n.js');

module.exports = async (req, res) => {
  res.setHeader('Access-Control-Allow-Origin',  '*');
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') return res.status(200).end();

  const lang = getRequestLanguage(req);

  if (req.method !== 'POST')   return res.status(405).json({ error: apiMessage('method_not_allowed', lang) });

  const { name, email, school, division, message, website, teacherId, requestType } = req.body || {};

  if (website) return res.status(200).json({ ok: true }); // honeypot

  if (!name || !email) {
    return res.status(400).json({ error: apiMessage('name_email_required', lang) });
  }

  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if (!emailRegex.test(email)) {
    return res.status(400).json({ error: apiMessage('valid_email_required', lang) });
  }

  if (name.length > 200 || email.length > 254 ||
      (school   && school.length   > 200) ||
      (division && division.length > 200) ||
      (message  && message.length  > 2000)) {
    return res.status(400).json({ error: apiMessage('field_too_long', lang) });
  }

  const supabase = createClient(
    process.env.SUPABASE_URL,
    process.env.SUPABASE_SERVICE_ROLE_KEY
  );

  const insertData = {
    name:     name.trim(),
    email:    email.trim().toLowerCase(),
    school:   school?.trim()   || null,
    division: division?.trim() || null,
    message:  message?.trim()  || null,
  };

  // In-app request from an existing teacher
  if (teacherId) {
    insertData.teacher_id  = teacherId;
    insertData.request_type = requestType || 'premium_trial';
  }

  const { error: dbErr } = await supabase.from('teacher_requests').insert(insertData);

  if (dbErr) {
    console.error('teacher_requests insert failed:', dbErr.message);
    return res.status(500).json({ error: apiMessage('request_save_failed', lang) });
  }

  // Notify platform admin — non-fatal if this fails
  try {
    const resend = new Resend(process.env.RESEND_API_KEY);

    if (lang === 'fr') {
      await resend.emails.send({
        from:    'AudioProctor <hello@audioproctor.com>',
        to:      process.env.CONTACT_EMAIL,
        replyTo: email.trim(),
        subject: `Demande d'accès : ${name.trim()}${division ? ' — ' + division.trim() : ''}`,
        text: [
          'Nouvelle demande d\'accès d\'un enseignant :',
          '',
          `Nom :      ${name.trim()}`,
          `Courriel : ${email.trim()}`,
          `École :    ${school?.trim()   || '(non fourni)'}`,
          `Division : ${division?.trim() || '(non fourni)'}`,
          '',
          'Message :',
          message?.trim() || '(aucun)',
          '',
          'Révision : https://app.audioproctor.com/admin.html',
        ].join('\n'),
      });
    } else {
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
    }
  } catch (emailErr) {
    console.error('admin notification email failed:', emailErr.message);
  }

  return res.status(200).json({ ok: true });
};
