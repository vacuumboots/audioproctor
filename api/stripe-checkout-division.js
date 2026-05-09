// ─── /api/stripe-checkout-division ─────────────────────────────────────────
// POST — Creates a Stripe Checkout Session for a Division Plan annual subscription.
// Division admin (division_admin role or platform_admin) triggers this.
// Supports enrolment band pricing (small, medium, large, metro).
// Returns { url } — front-end redirects to Stripe Checkout.
//
// Env: STRIPE_SECRET_KEY

const Stripe = require('stripe');
const { createClient } = require('@supabase/supabase-js');

module.exports = async (req, res) => {
  res.setHeader('Access-Control-Allow-Origin', 'https://app.audioproctor.com');
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  if (req.method === 'OPTIONS') return res.status(200).end();
  if (req.method !== 'POST') return res.status(405).json({ error: 'Method not allowed' });

  const authHeader = req.headers.authorization || '';
  const token = authHeader.replace('Bearer ', '');
  if (!token) return res.status(401).json({ error: 'Missing auth token' });

  const supabase = createClient(
    process.env.SUPABASE_URL,
    process.env.SUPABASE_SERVICE_ROLE_KEY
  );

  // Verify token and get user
  const { data: { user }, error: authErr } = await supabase.auth.getUser(token);
  if (authErr || !user) return res.status(401).json({ error: 'Invalid token' });

  const { divisionId, priceId, enrolmentBand } = req.body || {};
  if (!divisionId) return res.status(400).json({ error: 'divisionId is required' });

  // Verify the user is a division_admin for this division, or a platform_admin
  const { data: profile } = await supabase
    .from('profiles')
    .select('role, division_id')
    .eq('id', user.id)
    .maybeSingle();

  if (!profile) return res.status(403).json({ error: 'Profile not found' });

  const isPlatformAdmin  = profile.role === 'platform_admin';
  const isDivisionAdmin  = profile.role === 'division_admin' && profile.division_id === divisionId;
  if (!isPlatformAdmin && !isDivisionAdmin) {
    return res.status(403).json({ error: 'Only division admins or platform admins can purchase division plans' });
  }

  // Load division info
  const { data: division } = await supabase
    .from('divisions')
    .select('id, name, tier, enrolment_band, stripe_customer_id')
    .eq('id', divisionId)
    .maybeSingle();

  if (!division) return res.status(404).json({ error: 'Division not found' });
  if (division.tier !== 'free' && division.tier !== 'premium') {
    return res.status(400).json({ error: 'This division already has an active plan' });
  }

  // Resolve price ID: either explicit priceId, or look up by enrolment band
  let effectivePriceId = priceId;
  if (!effectivePriceId) {
    const band = enrolmentBand || division.enrolment_band;
    if (!band) {
      return res.status(400).json({ error: 'Division must have an enrolment band set. Set it in the admin panel first.' });
    }
    const { data: pricing } = await supabase
      .from('division_pricing')
      .select('stripe_price_id')
      .eq('enrolment_band', band)
      .maybeSingle();
    if (!pricing) {
      return res.status(400).json({ error: `No pricing configured for enrolment band "${band}". Contact the platform admin.` });
    }
    effectivePriceId = pricing.stripe_price_id;
  }

  const stripe = Stripe(process.env.STRIPE_SECRET_KEY);
  const successUrl = 'https://app.audioproctor.com/division-admin.html?upgraded=division';
  const cancelUrl  = 'https://app.audioproctor.com/division-admin.html';

  // Create or reuse customer
  let customerId = division.stripe_customer_id;
  if (!customerId) {
    const customer = await stripe.customers.create({
      email: user.email,
      metadata: { supabase_user_id: user.id, division_id: divisionId, entity_type: 'division' }
    });
    customerId = customer.id;
    await supabase.from('divisions').update({ stripe_customer_id: customerId }).eq('id', divisionId);
  }

  const session = await stripe.checkout.sessions.create({
    customer: customerId,
    mode: 'subscription',
    line_items: [{ price: effectivePriceId, quantity: 1 }],
    success_url: successUrl,
    cancel_url:  cancelUrl,
    metadata: {
      entity_type:    'division',
      division_id:    divisionId,
      supabase_user_id: user.id
    },
    subscription_data: {
      metadata: {
        entity_type:  'division',
        division_id:  divisionId
      }
    }
  });

  return res.status(200).json({ url: session.url });
};
