const { Resend } = require('resend');

const FROM = 'AudioProctor <hello@audioproctor.com>';

async function sendEmail({ to, subject, text, html }) {
  if (!process.env.RESEND_API_KEY) {
    const err = 'RESEND_API_KEY is missing from environment';
    console.error('email send failed:', err);
    return { ok: false, error: err };
  }

  try {
    const resend = new Resend(process.env.RESEND_API_KEY);
    const result = await resend.emails.send({ from: FROM, to, subject, text, html });
    if (result.error) {
      console.error('email send failed:', result.error.message);
      return { ok: false, error: result.error.message };
    }
    return { ok: true, id: result.data?.id };
  } catch (err) {
    console.error('email send failed:', err.message);
    return { ok: false, error: err.message };
  }
}

module.exports = { sendEmail, FROM };
