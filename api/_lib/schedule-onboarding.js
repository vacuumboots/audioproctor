// ─── /api/_lib/schedule-onboarding.js ───────────────────────────────────────
// Inserts pending rows into the onboarding_emails table when a division's tier
// transitions to 'division' (first paid activation).
//
//   - api/admin.js           (POST ?action=set-tier for entityType=division)
//
// Inserts two rows per activation:
//   day0_welcome   — scheduled ASAP (immediate display; cron picks it up on its
//                    next run, typically within the hour)
//   day3_followup  — scheduled for 3 days after activation

/**
 * Schedule the two onboarding emails for a newly activated division.
 *
 * @param {object} supabase — Service-role Supabase client (already created)
 * @param {string} divisionId   — UUID of the division
 * @param {string} recipientEmail — Who receives the emails (division admin)
 * @returns {Promise<void>}  — Fire-and-forget; errors are logged not thrown.
 */
async function scheduleDivisionOnboarding(supabase, divisionId, recipientEmail) {
  if (!divisionId || !recipientEmail) {
    console.error('scheduleDivisionOnboarding: missing divisionId or recipientEmail');
    return;
  }

  const now = new Date();

  // Day 3 = now + 72 hours
  const day3 = new Date(now.getTime() + 3 * 24 * 60 * 60 * 1000);

  const rows = [
    {
      division_id:     divisionId,
      email_type:      'day0_welcome',
      recipient_email: recipientEmail,
      status:          'pending',
      scheduled_at:    now.toISOString(),
    },
    {
      division_id:     divisionId,
      email_type:      'day3_followup',
      recipient_email: recipientEmail,
      status:          'pending',
      scheduled_at:    day3.toISOString(),
    },
  ];

  // Upsert each row — the unique index on (division_id, email_type) WHERE
  // status='pending' ensures we don't double-schedule if the webhook fires
  // more than once (Stripe idempotency) or if both admin and webhook trigger.
  for (const row of rows) {
    const { error } = await supabase
      .from('onboarding_emails')
      .upsert(row, {
        onConflict: 'division_id, email_type',
        ignoreDuplicates: true,
      });

    if (error) {
      console.error(`scheduleDivisionOnboarding: upsert failed for ${row.email_type} (division ${divisionId}):`, error.message);
    }
  }
}

module.exports = { scheduleDivisionOnboarding };
