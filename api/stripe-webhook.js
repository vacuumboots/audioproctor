// ─── /api/stripe-webhook ───────────────────────────────────────────────────
// Handles Stripe webhook events to sync subscription state into Supabase.
// Supports Teacher Premium, School Plan, and Division Plan subscriptions.
//
// Required env vars: STRIPE_SECRET_KEY, STRIPE_WEBHOOK_SECRET
// Vercel: set bodyParser = false so we get the raw body for signature verification.

const Stripe = require('stripe');
const { createClient } = require('@supabase/supabase-js');
const { scheduleDivisionOnboarding } = require('./_lib/schedule-onboarding');

module.exports.config = { api: { bodyParser: false } };

async function getRawBody(req) {
  return new Promise((resolve, reject) => {
    const chunks = [];
    req.on('data', chunk => chunks.push(chunk));
    req.on('end', () => resolve(Buffer.concat(chunks)));
    req.on('error', reject);
  });
}

// ─── Helpers ───────────────────────────────────────────────────────────────

async function handleTeacherPremium(supabase, session) {
  const userId = session.metadata?.supabase_user_id;
  if (!userId) return;

  await supabase.from('profiles').update({
    tier_override:          'premium',
    stripe_subscription_id:  session.subscription
  }).eq('id', userId);
}

async function handleSchoolPlan(supabase, session) {
  const schoolId = session.metadata?.school_id;
  if (!schoolId) return;

  // Fetch subscription from Stripe to get the current status
  const stripe = Stripe(process.env.STRIPE_SECRET_KEY);
  let subStatus = 'active';
  let priceId = null;
  if (session.subscription) {
    try {
      const subscription = await stripe.subscriptions.retrieve(session.subscription);
      subStatus = subscription.status;
      priceId = subscription.items?.data?.[0]?.price?.id || null;
    } catch (err) {
      console.error('stripe-webhook: failed to retrieve subscription:', err.message);
    }
  }

  await supabase.from('schools').update({
    tier:                      'school',
    stripe_subscription_id:     session.subscription,
    stripe_subscription_status: subStatus,
    stripe_price_id:            priceId,
    expires_at:                 null  // clear any manual expiry; Stripe manages it
  }).eq('id', schoolId);
}

async function handleDivisionPlan(supabase, session) {
  const divisionId = session.metadata?.division_id;
  if (!divisionId) return;

  const stripe = Stripe(process.env.STRIPE_SECRET_KEY);
  let subStatus = 'active';
  let priceId = null;
  if (session.subscription) {
    try {
      const subscription = await stripe.subscriptions.retrieve(session.subscription);
      subStatus = subscription.status;
      priceId = subscription.items?.data?.[0]?.price?.id || null;

      // If division has an enrolment_band price, record the band
      if (priceId) {
        const { data: pricing } = await supabase
          .from('division_pricing')
          .select('enrolment_band')
          .eq('stripe_price_id', priceId)
          .maybeSingle();
        if (pricing && pricing.enrolment_band) {
          await supabase.from('divisions').update({ enrolment_band: pricing.enrolment_band }).eq('id', divisionId);
        }
      }
    } catch (err) {
      console.error('stripe-webhook: failed to retrieve subscription:', err.message);
    }
  }

  await supabase.from('divisions').update({
    tier:                      'division',
    stripe_subscription_id:     session.subscription,
    stripe_subscription_status: subStatus,
    stripe_price_id:            priceId,
    expires_at:                 null
  }).eq('id', divisionId);

  // Schedule onboarding emails for first-time division activation
  scheduleDivisionOnboardingForDivision(supabase, divisionId, session);
}

async function scheduleDivisionOnboardingForDivision(supabase, divisionId, session) {
  try {
    // Use the division's admin_email if set, otherwise fall back to the purchaser
    const { data: division } = await supabase
      .from('divisions')
      .select('name, admin_email')
      .eq('id', divisionId)
      .single();

    let recipientEmail = division?.admin_email;

    if (!recipientEmail && session.metadata?.supabase_user_id) {
      const { data: userData } = await supabase.auth.admin.getUserById(session.metadata.supabase_user_id);
      recipientEmail = userData?.user?.email;
    }

    if (recipientEmail) {
      await scheduleDivisionOnboarding(supabase, divisionId, recipientEmail);
    } else {
      console.error('handleDivisionPlan: no recipient email for onboarding (division %s)', divisionId);
    }
  } catch (err) {
    console.error('handleDivisionPlan: onboarding scheduling failed:', err.message);
  }
}

async function handleSubscriptionDeleted(supabase, subscription) {
  const entityType = subscription.metadata?.entity_type;

  if (entityType === 'school') {
    const schoolId = subscription.metadata?.school_id;
    if (schoolId) {
      await supabase.from('schools').update({
        tier:                      'free',
        stripe_subscription_id:     null,
        stripe_subscription_status: 'canceled',
        cancelled_at:               new Date().toISOString()
      }).eq('id', schoolId);
    }
  } else if (entityType === 'division') {
    const divisionId = subscription.metadata?.division_id;
    if (divisionId) {
      await supabase.from('divisions').update({
        tier:                      'free',
        stripe_subscription_id:     null,
        stripe_subscription_status: 'canceled',
        cancelled_at:               new Date().toISOString()
      }).eq('id', divisionId);
    }
  } else {
    // Fallback: teacher premium — match by subscription ID
    const { data: profile } = await supabase
      .from('profiles')
      .select('id')
      .eq('stripe_subscription_id', subscription.id)
      .maybeSingle();

    if (profile) {
      await supabase.from('profiles').update({
        tier_override:          null,
        stripe_subscription_id: null
      }).eq('id', profile.id);
    }
  }
}

async function handleSubscriptionUpdated(supabase, subscription) {
  const entityType = subscription.metadata?.entity_type;
  const status = subscription.status;

  if (entityType === 'school') {
    const schoolId = subscription.metadata?.school_id;
    if (schoolId) {
      await supabase.from('schools').update({
        stripe_subscription_status: status
      }).eq('id', schoolId);
    }
  } else if (entityType === 'division') {
    const divisionId = subscription.metadata?.division_id;
    if (divisionId) {
      await supabase.from('divisions').update({
        stripe_subscription_status: status
      }).eq('id', divisionId);
    }
  }
}

// ─── Main handler ──────────────────────────────────────────────────────────

module.exports = async (req, res) => {
  if (req.method !== 'POST') return res.status(405).end();

  const stripe = Stripe(process.env.STRIPE_SECRET_KEY);
  const rawBody = await getRawBody(req);
  const sig = req.headers['stripe-signature'];

  let event;
  try {
    event = stripe.webhooks.constructEvent(rawBody, sig, process.env.STRIPE_WEBHOOK_SECRET);
  } catch (err) {
    return res.status(400).json({ error: `Webhook signature invalid: ${err.message}` });
  }

  const supabase = createClient(
    process.env.SUPABASE_URL,
    process.env.SUPABASE_SERVICE_ROLE_KEY
  );

  // ─── checkout.session.completed ─────────────────────────────────
  // Used by: Teacher Premium (metadata.entity_type missing or 'teacher'),
  //          School Plan (entity_type = 'school'),
  //          Division Plan (entity_type = 'division')
  if (event.type === 'checkout.session.completed') {
    const session = event.data.object;
    const entityType = session.metadata?.entity_type;

    if (entityType === 'school') {
      await handleSchoolPlan(supabase, session);
    } else if (entityType === 'division') {
      await handleDivisionPlan(supabase, session);
    } else {
      // Default: Teacher Premium (existing behaviour)
      await handleTeacherPremium(supabase, session);
    }
  }

  // ─── customer.subscription.deleted ──────────────────────────────
  // Triggered when subscription is cancelled or expires.
  if (event.type === 'customer.subscription.deleted') {
    await handleSubscriptionDeleted(supabase, event.data.object);
  }

  // ─── customer.subscription.updated ──────────────────────────────
  // Track status changes (past_due, trialing, etc.)
  if (event.type === 'customer.subscription.updated') {
    await handleSubscriptionUpdated(supabase, event.data.object);
  }

  // ─── invoice.payment_succeeded ──────────────────────────────────
  // For school/division plans, ensure tier stays active on successful renewal payment.
  if (event.type === 'invoice.payment_succeeded') {
    const invoice = event.data.object;
    if (invoice.subscription && invoice.metadata?.entity_type === 'school') {
      const schoolId = invoice.metadata?.school_id;
      if (schoolId) {
        await supabase.from('schools').update({
          stripe_subscription_status: 'active'
        }).eq('id', schoolId);
      }
    }
    if (invoice.subscription && invoice.metadata?.entity_type === 'division') {
      const divisionId = invoice.metadata?.division_id;
      if (divisionId) {
        await supabase.from('divisions').update({
          stripe_subscription_status: 'active'
        }).eq('id', divisionId);
      }
    }
  }

  return res.status(200).json({ received: true });
};
