# Shipment — Stripe Webhook Expansion

> **Status:** NOT STARTED  
> **Priority:** High (prevents entitlement drift for paid users)  
> **Estimated effort:** 2–3 hours  
> **Depends on:** Stripe dashboard access to add webhook event types

**Goal:** Handle all Stripe subscription lifecycle events so teacher tiers stay in sync with actual payment status. Currently only `checkout.session.completed` and `customer.subscription.deleted` are handled, which leaves gaps for past-due, unpaid, and canceled-but-not-yet-deleted subscriptions.

---

## Current State

- `api/stripe-webhook.js` handles:
  - `checkout.session.completed` → sets `profiles.tier_override = 'premium'`
  - `customer.subscription.deleted` → sets `profiles.tier_override = null`
- Does NOT handle: `invoice.payment_failed`, `customer.subscription.updated` (past_due/unpaid), `invoice.payment_succeeded`
- Result: a teacher whose card fails may still show as premium for days or weeks until the subscription is fully deleted

---

## Deliverables

1. Expand `api/stripe-webhook.js` to handle:
   - `invoice.payment_failed` → downgrade to free immediately
   - `customer.subscription.updated` with `status = 'past_due'` or `'unpaid'` → downgrade
   - `customer.subscription.updated` with `status = 'active'` → ensure tier is premium
   - `invoice.payment_succeeded` → ensure tier is premium (recovery after failure)
2. Update Stripe dashboard webhook endpoint to listen for all four event types
3. Add `stripe_subscription_status` column to `profiles` for debugging
4. Test with Stripe CLI or test mode events

---

## Definition of Done

- [ ] Teacher with failed payment is downgraded to free within seconds of Stripe event
- [ ] Teacher who updates their payment method and succeeds is re-upgraded automatically
- [ ] `profiles.stripe_subscription_status` accurately reflects Stripe state
- [ ] Webhook handler is idempotent — same event received twice does not cause errors
- [ ] All event types are registered in Stripe dashboard webhook settings

---

## Implementation

### Step 1: Add subscription status column

Migration:
```sql
ALTER TABLE profiles
  ADD COLUMN IF NOT EXISTS stripe_subscription_status text;
```

### Step 2: Expand webhook handler

Replace the existing `api/stripe-webhook.js` subscription logic with:

```js
const event = req.body;
const sig = req.headers['stripe-signature'];

let stripeEvent;
try {
  stripeEvent = stripe.webhooks.constructEvent(req.body, sig, process.env.STRIPE_WEBHOOK_SECRET);
} catch (err) {
  return res.status(400).json({ error: 'Invalid signature' });
}

const supabase = createClient(process.env.SUPABASE_URL, process.env.SUPABASE_SERVICE_ROLE_KEY);

switch (stripeEvent.type) {
  case 'checkout.session.completed': {
    const session = stripeEvent.data.object;
    const customerId = session.customer;
    await supabase.from('profiles')
      .update({ tier_override: 'premium', stripe_customer_id: customerId, stripe_subscription_status: 'active' })
      .eq('stripe_customer_id', customerId);
    break;
  }

  case 'invoice.payment_failed': {
    const invoice = stripeEvent.data.object;
    const customerId = invoice.customer;
    await supabase.from('profiles')
      .update({ tier_override: null, stripe_subscription_status: 'past_due' })
      .eq('stripe_customer_id', customerId);
    break;
  }

  case 'invoice.payment_succeeded': {
    const invoice = stripeEvent.data.object;
    const customerId = invoice.customer;
    // Only re-upgrade if this is a subscription invoice (not a one-off)
    if (invoice.subscription) {
      await supabase.from('profiles')
        .update({ tier_override: 'premium', stripe_subscription_status: 'active' })
        .eq('stripe_customer_id', customerId);
    }
    break;
  }

  case 'customer.subscription.updated': {
    const subscription = stripeEvent.data.object;
    const customerId = subscription.customer;
    const status = subscription.status; // 'active', 'past_due', 'unpaid', 'canceled', 'incomplete'

    if (['active', 'trialing'].includes(status)) {
      await supabase.from('profiles')
        .update({ tier_override: 'premium', stripe_subscription_status: status })
        .eq('stripe_customer_id', customerId);
    } else if (['past_due', 'unpaid', 'canceled', 'incomplete_expired'].includes(status)) {
      await supabase.from('profiles')
        .update({ tier_override: null, stripe_subscription_status: status })
        .eq('stripe_customer_id', customerId);
    } else {
      await supabase.from('profiles')
        .update({ stripe_subscription_status: status })
        .eq('stripe_customer_id', customerId);
    }
    break;
  }

  case 'customer.subscription.deleted': {
    const subscription = stripeEvent.data.object;
    const customerId = subscription.customer;
    await supabase.from('profiles')
      .update({ tier_override: null, stripe_subscription_status: 'canceled' })
      .eq('stripe_customer_id', customerId);
    break;
  }
}

return res.status(200).json({ received: true });
```

### Step 3: Update Stripe dashboard

In Stripe Dashboard → Developers → Webhooks → your endpoint:
- Add events: `invoice.payment_failed`, `invoice.payment_succeeded`, `customer.subscription.updated`
- Ensure `checkout.session.completed` and `customer.subscription.deleted` are still checked

### Step 4: Commit and push

```bash
git add api/stripe-webhook.js supabase/migrations/017_stripe_status.sql
git commit -m "feat: expand Stripe webhook to handle payment failure and recovery"
git push origin main
```

---

## Verification

1. Stripe CLI: `stripe listen --forward-to localhost:3000/api/stripe-webhook`
2. Trigger test events: `stripe trigger invoice.payment_failed`
3. Check `profiles` row — `tier_override` should become null, `stripe_subscription_status` = 'past_due'
4. Trigger `stripe trigger invoice.payment_succeeded` → `tier_override` should become 'premium'

---

## Risks

- **Idempotency**: If Stripe retries an event, the handler should not error. The `customer.subscription.updated` handler writes the same value each time, so this is safe.
- **Race condition**: If a teacher pays via checkout and the webhook fires before the profile row has `stripe_customer_id`, the lookup by customer ID will miss. The `checkout.session.completed` handler sets the customer ID, so this is only a concern if events arrive out of order. Mitigation: also store `stripe_subscription_id` and look up by that if customer_id is null.
- **Test mode vs live mode**: Ensure webhook endpoint is configured for the correct environment.
