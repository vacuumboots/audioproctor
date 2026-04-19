// POST /api/stripe-webhook
// Handles Stripe webhook events to sync subscription state into Supabase.
//
// Required env vars: STRIPE_SECRET_KEY, STRIPE_WEBHOOK_SECRET
// Vercel: set bodyParser = false so we get the raw body for signature verification.

const Stripe = require('stripe');
const { createClient } = require('@supabase/supabase-js');

module.exports.config = { api: { bodyParser: false } };

async function getRawBody(req) {
  return new Promise((resolve, reject) => {
    const chunks = [];
    req.on('data', chunk => chunks.push(chunk));
    req.on('end', () => resolve(Buffer.concat(chunks)));
    req.on('error', reject);
  });
}

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

  if (event.type === 'checkout.session.completed') {
    const session = event.data.object;
    const userId = session.metadata?.supabase_user_id;
    if (!userId) return res.status(200).json({ received: true });

    await supabase.from('profiles').update({
      tier_override:           'premium',
      stripe_subscription_id:  session.subscription
    }).eq('id', userId);
  }

  if (event.type === 'customer.subscription.deleted') {
    const sub = event.data.object;
    const { data: profile } = await supabase
      .from('profiles')
      .select('id')
      .eq('stripe_subscription_id', sub.id)
      .maybeSingle();

    if (profile) {
      await supabase.from('profiles').update({
        tier_override:          null,
        stripe_subscription_id: null
      }).eq('id', profile.id);
    }
  }

  return res.status(200).json({ received: true });
};
