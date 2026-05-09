// ─── /api/send-onboarding-emails ────────────────────────────────────────────
// Vercel Cron Job — runs every hour.
// Processes due pending onboarding emails from the onboarding_emails table
// and sends them via Resend.
//
// Authentication: requires Authorization: Bearer <CRON_SECRET> header
// matching the CRON_SECRET env var.
//
// Environment: SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY, RESEND_API_KEY, CRON_SECRET

const { createClient } = require('@supabase/supabase-js');
const { sendEmail } = require('./_lib/email');
const { buildDay0Welcome, buildDay3Followup } = require('./_lib/onboarding-emails');

module.exports = async (req, res) => {
  // ─── Auth ───────────────────────────────────────────────────────────────
  const authHeader = req.headers['authorization'] || '';
  const cronSecret = process.env.CRON_SECRET;
  if (cronSecret) {
    const token = authHeader.replace('Bearer ', '');
    if (token !== cronSecret) {
      return res.status(401).json({ error: 'Unauthorized' });
    }
  }
  // If CRON_SECRET is not set in env, only allow if x-vercel-cron header present
  // (Vercel Cron Jobs send this automatically)
  else if (req.headers['x-vercel-cron'] !== '1') {
    return res.status(401).json({ error: 'Missing authentication' });
  }

  // ─── Process due emails ─────────────────────────────────────────────────
  const supabase = createClient(
    process.env.SUPABASE_URL,
    process.env.SUPABASE_SERVICE_ROLE_KEY
  );

  let processed = 0;
  let errors   = 0;

  try {
    // Fetch all pending emails that are due
    const { data: dueEmails, error: fetchErr } = await supabase
      .from('onboarding_emails')
      .select('id, division_id, email_type, recipient_email')
      .eq('status', 'pending')
      .lte('scheduled_at', new Date().toISOString())
      .limit(50);  // process at most 50 per run

    if (fetchErr) {
      console.error('send-onboarding-emails: fetch failed:', fetchErr.message);
      return res.status(500).json({ error: fetchErr.message });
    }

    if (!dueEmails || dueEmails.length === 0) {
      return res.status(200).json({ processed: 0, errors: 0, message: 'No due emails' });
    }

    // Load division names for email personalization
    const divisionIds = [...new Set(dueEmails.map(e => e.division_id))];
    const { data: divisions } = await supabase
      .from('divisions')
      .select('id, name')
      .in('id', divisionIds);

    const divisionMap = {};
    (divisions || []).forEach(d => { divisionMap[d.id] = d.name; });

    // Send each email
    for (const email of dueEmails) {
      const divisionName = divisionMap[email.division_id] || 'your division';

      let subject, text, html;

      if (email.email_type === 'day0_welcome') {
        const content = buildDay0Welcome(divisionName);
        subject = content.subject;
        text    = content.text;
        html    = content.html;
      } else if (email.email_type === 'day3_followup') {
        const content = buildDay3Followup(divisionName);
        subject = content.subject;
        text    = content.text;
        html    = content.html;
      } else {
        // Unknown type — mark as failed
        await supabase
          .from('onboarding_emails')
          .update({ status: 'failed', error_message: `Unknown email_type: ${email.email_type}` })
          .eq('id', email.id);
        errors++;
        continue;
      }

      const result = await sendEmail({
        to: email.recipient_email,
        subject,
        text,
        html,
      });

      if (result.ok) {
        await supabase
          .from('onboarding_emails')
          .update({ status: 'sent', sent_at: new Date().toISOString() })
          .eq('id', email.id);
        processed++;
      } else {
        await supabase
          .from('onboarding_emails')
          .update({ status: 'failed', error_message: result.error })
          .eq('id', email.id);
        errors++;
      }
    }

    return res.status(200).json({ processed, errors, total: dueEmails.length });
  } catch (err) {
    console.error('send-onboarding-emails: unhandled error:', err.message);
    return res.status(500).json({ error: err.message });
  }
};
