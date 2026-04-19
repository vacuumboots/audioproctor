-- Stripe billing + exit word mode preference columns on profiles.
-- Stripe columns are only written by the webhook (service role key, bypasses RLS).
-- exit_word_mode is written by the teacher client and covered by existing RLS policies.
ALTER TABLE profiles
  ADD COLUMN IF NOT EXISTS stripe_customer_id      TEXT,
  ADD COLUMN IF NOT EXISTS stripe_subscription_id  TEXT,
  ADD COLUMN IF NOT EXISTS exit_word_mode          TEXT NOT NULL DEFAULT 'random_short';
