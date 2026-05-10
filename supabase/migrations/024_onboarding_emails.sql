-- ─── Migration 024: Onboarding email sequence for new divisions ──────────────
-- Run in Supabase SQL editor AFTER migration 023.
--
-- Tracks scheduled onboarding emails for divisions that have activated a paid
-- plan. Deferred: the cron endpoint was pruned (commit 8148d63) to stay under
-- the Vercel Hobby 12-function limit. Onboarding emails will be re-implemented
-- when the function budget allows.
--
-- Flow:
--   1. Division tier changes to 'division' (Stripe webhook or admin set-tier)
--      → inserts two rows: day0_welcome (due immediately) and day3_followup (due
--        in 3 days).
--   2. Cron endpoint runs every hour, sends any emails where
--      scheduled_at ≤ now() AND status = 'pending'.
--   3. Rows are kept for audit trail; no automatic cleanup.

CREATE TABLE IF NOT EXISTS onboarding_emails (
  id              uuid        DEFAULT gen_random_uuid() PRIMARY KEY,
  division_id     uuid        NOT NULL REFERENCES divisions(id) ON DELETE CASCADE,
  email_type      text        NOT NULL CHECK (email_type IN ('day0_welcome', 'day3_followup')),
  recipient_email text        NOT NULL,
  status          text        NOT NULL DEFAULT 'pending'
                              CHECK (status IN ('pending', 'sent', 'failed')),
  scheduled_at    timestamptz NOT NULL,
  sent_at         timestamptz,
  error_message   text,
  created_at      timestamptz NOT NULL DEFAULT now()
);

-- Speed up the cron query: find pending emails that are due
CREATE INDEX IF NOT EXISTS idx_onboarding_emails_due
  ON onboarding_emails (status, scheduled_at)
  WHERE status = 'pending';

-- Prevent scheduling the same email type twice for the same division
CREATE UNIQUE INDEX IF NOT EXISTS idx_onboarding_emails_unique_pending
  ON onboarding_emails (division_id, email_type)
  WHERE status = 'pending';

-- RLS: only the service role (server-side API) writes/reads this table.
-- No public access needed; the cron endpoint uses the service role key.
ALTER TABLE onboarding_emails ENABLE ROW LEVEL SECURITY;

-- Allow service-role inserts from API endpoints
CREATE POLICY "service_role_all_access"
  ON onboarding_emails
  FOR ALL
  TO service_role
  USING (true)
  WITH CHECK (true);

GRANT ALL ON onboarding_emails TO service_role;
