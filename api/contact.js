// ─── /api/contact ────────────────────────────────────────────────
// POST handler for the demo request / contact form.
// Sends an email to CONTACT_EMAIL via Resend.
//
// Required env vars:
//   RESEND_API_KEY  — from resend.com dashboard
//   CONTACT_EMAIL   — your receiving address (e.g. your personal email)

const { Resend } = require('resend');

module.exports = async (req, res) => {
  res.setHeader('Access-Control-Allow-Origin',  'https://audioproctor.com');
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') return res.status(200).end();
  if (req.method !== 'POST')   return res.status(405).json({ error: 'Method not allowed' });

  const { name, email, division, enrolment, role, message, website } = req.body;

  // Honeypot — bots fill in the hidden `website` field; humans don't
  if (website) return res.status(200).json({ ok: true });

  // Basic validation
  if (!name || !email || !message) {
    return res.status(400).json({ error: 'Name, email, and message are required.' });
  }

  // Length limits to prevent abuse
  if (name.length > 200 || email.length > 254 || message.length > 5000) {
    return res.status(400).json({ error: 'One or more fields are too long.' });
  }
  if ((division && division.length > 200) || (role && role.length > 100) || (enrolment && enrolment.length > 100)) {
    return res.status(400).json({ error: 'One or more fields are too long.' });
  }

  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if (!emailRegex.test(email)) {
    return res.status(400).json({ error: 'Please enter a valid email address.' });
  }

  const resend = new Resend(process.env.RESEND_API_KEY);

  const { error } = await resend.emails.send({
    from:    'AudioProctor <hello@audioproctor.com>',
    to:      process.env.CONTACT_EMAIL,
    replyTo: email,
    subject: `Demo request from ${name}${division ? ' — ' + division : ''}`,
    text: [
      `Name: ${name}`,
      `Email: ${email}`,
      `Division: ${division || '(not provided)'}`,
      `Enrolment: ${enrolment || '(not provided)'}`,
      `Role: ${role || '(not provided)'}`,
      ``,
      `Message:`,
      message,
    ].join('\n'),
  });

  if (error) {
    console.error('Resend error:', error);
    return res.status(500).json({ error: 'Could not send message. Please email hello@audioproctor.com directly.' });
  }

  return res.status(200).json({ ok: true });
};
