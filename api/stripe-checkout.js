// POST /api/stripe-checkout
// Creates a Stripe Checkout Session for Teacher Premium, School Plan, or Division Plan.
// Pass { action: 'teacher' | 'school' | 'division', schoolId?, divisionId? } in body.
// Returns { url } — front-end redirects the browser there.

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

  const { data: { user }, error: authErr } = await supabase.auth.getUser(token);
  if (authErr || !user) return res.status(401).json({ error: 'Invalid token' });

  const { action = 'teacher', schoolId, divisionId, priceId, enrolmentBand } = req.body || {};

  // ─── Teacher Premium ────────────────────────────────────────────────
  if (action === 'teacher') {
    const stripe = Stripe(process.env.STRIPE_SECRET_KEY);

    const { data: profile } = await supabase
      .from('profiles')
      .select('stripe_customer_id')
      .eq('id', user.id)
      .maybeSingle();

    let customerId = profile?.stripe_customer_id;
    if (!customerId) {
      const customer = await stripe.customers.create({
        email: user.email,
        metadata: { supabase_user_id: user.id }
      });
      customerId = customer.id;
      await supabase.from('profiles').update({ stripe_customer_id: customerId }).eq('id', user.id);
    }

    const session = await stripe.checkout.sessions.create({
      customer: customerId,
      mode: 'subscription',
      line_items: [{ price: process.env.STRIPE_PRICE_ID, quantity: 1 }],
      success_url: 'https://app.audioproctor.com/dashboard.html?upgraded=1',
      cancel_url:  'https://app.audioproctor.com/dashboard.html',
      metadata: { supabase_user_id: user.id }
    });

    return res.status(200).json({ url: session.url });
  }

  // ─── School Plan ────────────────────────────────────────────────────
  if (action === 'school') {
    if (!schoolId) return res.status(400).json({ error: 'schoolId is required' });

    const { data: profile } = await supabase
      .from('profiles')
      .select('role, school_id')
      .eq('id', user.id)
      .maybeSingle();

    if (!profile) return res.status(403).json({ error: 'Profile not found' });

    const isPlatformAdmin = profile.role === 'platform_admin';
    const isSchoolAdmin   = profile.role === 'school_admin' && profile.school_id === schoolId;
    if (!isPlatformAdmin && !isSchoolAdmin) {
      return res.status(403).json({ error: 'Only school admins or platform admins can purchase school plans' });
    }

    const { data: school } = await supabase
      .from('schools')
      .select('id, name, tier, stripe_customer_id')
      .eq('id', schoolId)
      .maybeSingle();

    if (!school) return res.status(404).json({ error: 'School not found' });
    if (school.tier !== 'free' && school.tier !== 'premium') {
      return res.status(400).json({ error: 'This school already has an active plan' });
    }

    const stripe = Stripe(process.env.STRIPE_SECRET_KEY);
    const effectivePriceId = priceId || process.env.STRIPE_SCHOOL_PRICE_ID;

    let customerId = school.stripe_customer_id;
    if (!customerId) {
      const customer = await stripe.customers.create({
        email: user.email,
        metadata: { supabase_user_id: user.id, school_id: schoolId, entity_type: 'school' }
      });
      customerId = customer.id;
      await supabase.from('schools').update({ stripe_customer_id: customerId }).eq('id', schoolId);
    }

    const session = await stripe.checkout.sessions.create({
      customer: customerId,
      mode: 'subscription',
      line_items: [{ price: effectivePriceId, quantity: 1 }],
      success_url: 'https://app.audioproctor.com/school-admin.html?upgraded=school',
      cancel_url:  'https://app.audioproctor.com/school-admin.html',
      metadata: { entity_type: 'school', school_id: schoolId, supabase_user_id: user.id },
      subscription_data: { metadata: { entity_type: 'school', school_id: schoolId } }
    });

    return res.status(200).json({ url: session.url });
  }

  // ─── Division Plan ──────────────────────────────────────────────────
  if (action === 'division') {
    if (!divisionId) return res.status(400).json({ error: 'divisionId is required' });

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

    const { data: division } = await supabase
      .from('divisions')
      .select('id, name, tier, enrolment_band, stripe_customer_id')
      .eq('id', divisionId)
      .maybeSingle();

    if (!division) return res.status(404).json({ error: 'Division not found' });
    if (division.tier !== 'free' && division.tier !== 'premium') {
      return res.status(400).json({ error: 'This division already has an active plan' });
    }

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
      success_url: 'https://app.audioproctor.com/division-admin.html?upgraded=division',
      cancel_url:  'https://app.audioproctor.com/division-admin.html',
      metadata: { entity_type: 'division', division_id: divisionId, supabase_user_id: user.id },
      subscription_data: { metadata: { entity_type: 'division', division_id: divisionId } }
    });

    return res.status(200).json({ url: session.url });
  }

  return res.status(400).json({ error: `Unknown action: ${action}` });
};
