// ─── /api/stripe-checkout-school ───────────────────────────────────────────
// POST — Creates a Stripe Checkout Session for a School Plan annual subscription.
// School admin (school_admin role or platform_admin) triggers this.
// Requires Bearer token + school_id in body.
// Returns { url } — front-end redirects the browser to Stripe Checkout.
//
// Env: STRIPE_SECRET_KEY, STRIPE_SCHOOL_PRICE_ID

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

  const { schoolId, priceId } = req.body || {};
  if (!schoolId) return res.status(400).json({ error: 'schoolId is required' });

  // Verify the user is a school_admin for this school, or a platform_admin
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

  // Load school info
  const { data: school } = await supabase
    .from('schools')
    .select('id, name, tier, stripe_customer_id, division_id')
    .eq('id', schoolId)
    .maybeSingle();

  if (!school) return res.status(404).json({ error: 'School not found' });
  if (school.tier !== 'free' && school.tier !== 'premium') {
    return res.status(400).json({ error: 'This school already has an active plan' });
  }

  const stripe = Stripe(process.env.STRIPE_SECRET_KEY);
  const effectivePriceId = priceId || process.env.STRIPE_SCHOOL_PRICE_ID;
  const successUrl = 'https://app.audioproctor.com/school-admin.html?upgraded=school';
  const cancelUrl  = 'https://app.audioproctor.com/school-admin.html';

  // Create or reuse customer
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
    success_url: successUrl,
    cancel_url:  cancelUrl,
    metadata: {
      entity_type:    'school',
      school_id:      schoolId,
      supabase_user_id: user.id
    },
    subscription_data: {
      metadata: {
        entity_type: 'school',
        school_id:   schoolId
      }
    }
  });

  return res.status(200).json({ url: session.url });
};
