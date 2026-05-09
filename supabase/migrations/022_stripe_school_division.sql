-- ─── Migration 022: Stripe billing for School & Division Plans ─────────────
-- Run in Supabase SQL editor AFTER migration 021.
--
-- 1. Adds Stripe subscription/customer columns to schools and divisions.
-- 2. Adds stripe_subscription_status for lifecycle tracking.
-- 3. Adds enrolment_band_prices configuration table for division pricing.
-- 4. Adds school_division_id FK for tracking which division a school belongs to
--    (already exists via schools.division_id from migration 005).

-- ─── schools — Stripe columns ──────────────────────────────────────────────

ALTER TABLE schools
  ADD COLUMN IF NOT EXISTS stripe_customer_id      TEXT,
  ADD COLUMN IF NOT EXISTS stripe_subscription_id  TEXT,
  ADD COLUMN IF NOT EXISTS stripe_subscription_status TEXT
    CHECK (stripe_subscription_status IN ('active', 'past_due', 'canceled', 'incomplete', 'incomplete_expired', 'trialing', 'unpaid', 'paused')),
  ADD COLUMN IF NOT EXISTS stripe_price_id         TEXT;

-- ─── divisions — Stripe columns ────────────────────────────────────────────

ALTER TABLE divisions
  ADD COLUMN IF NOT EXISTS stripe_customer_id      TEXT,
  ADD COLUMN IF NOT EXISTS stripe_subscription_id  TEXT,
  ADD COLUMN IF NOT EXISTS stripe_subscription_status TEXT
    CHECK (stripe_subscription_status IN ('active', 'past_due', 'canceled', 'incomplete', 'incomplete_expired', 'trialing', 'unpaid', 'paused')),
  ADD COLUMN IF NOT EXISTS stripe_price_id         TEXT;

-- ─── division_pricing — enrolment band config ──────────────────────────────
-- Stores per-division enrolment band prices. The admin sets these in Stripe
-- and records the price IDs here. Each band maps to a Stripe Price object
-- (recurring annual subscription price).

CREATE TABLE IF NOT EXISTS division_pricing (
  id              uuid        DEFAULT gen_random_uuid() PRIMARY KEY,
  enrolment_band  text        NOT NULL UNIQUE
                  CHECK (enrolment_band IN ('small', 'medium', 'large', 'metro')),
  label           text        NOT NULL,
  description     text,
  stripe_price_id text        NOT NULL,
  annual_price_cents integer  NOT NULL,  -- price in cents for display
  max_schools     integer,               -- null = unlimited
  created_at      timestamptz NOT NULL DEFAULT now()
);

-- Seed default pricing (update stripe_price_id after creating prices in Stripe)
INSERT INTO division_pricing (enrolment_band, label, description, stripe_price_id, annual_price_cents, max_schools)
VALUES
  ('small',  'Small Division',  'Up to 5 schools',    'price_school_div_small',  25000,  5),
  ('medium', 'Medium Division', '6–15 schools',       'price_school_div_medium', 50000,  15),
  ('large',  'Large Division',  '16–40 schools',      'price_school_div_large',  100000, 40),
  ('metro',  'Metro Division',  '40+ schools',        'price_school_div_metro',  200000, null)
ON CONFLICT (enrolment_band) DO NOTHING;

-- ─── Add cancelled_at timestamps for tracking subscription end ─────────────

ALTER TABLE schools
  ADD COLUMN IF NOT EXISTS cancelled_at timestamptz;

ALTER TABLE divisions
  ADD COLUMN IF NOT EXISTS cancelled_at timestamptz;

-- ─── Grant access ──────────────────────────────────────────────────────────

GRANT SELECT ON division_pricing TO authenticated;

-- ─── Helper function: resolve school's Stripe customer ─────────────────────
-- Returns the school's stripe_customer_id, creating one if needed.
-- Called by the API, not directly from RLS.

CREATE OR REPLACE FUNCTION ensure_school_stripe_customer(p_school_id uuid)
RETURNS text
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_customer_id text;
BEGIN
  SELECT stripe_customer_id INTO v_customer_id
  FROM schools WHERE id = p_school_id;
  RETURN v_customer_id;
END;
$$;

-- ─── Helper function: resolve division's Stripe customer ───────────────────

CREATE OR REPLACE FUNCTION ensure_division_stripe_customer(p_division_id uuid)
RETURNS text
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_customer_id text;
BEGIN
  SELECT stripe_customer_id INTO v_customer_id
  FROM divisions WHERE id = p_division_id;
  RETURN v_customer_id;
END;
$$;
