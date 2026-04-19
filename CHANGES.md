# AudioProctor — Planned Changes (Steps 2, 5, 8, 9, 10)

Each section below describes one file change: **what** is being changed, **why**, and **exactly what the change looks like**. Steps 1, 3, 6, and 7 from the plan are manual/external tasks (Chromebook testing, Chrome Web Store publishing, Supabase Edge Functions, pilot agreement writing) — no code changes possible here.

---

## Step 2: Admin Deactivation Toggle + Admin-Initiated Deletion

### Why this step matters
The `is_deactivated` column already exists on `profiles` (migration 009). The `api/session.js` already blocks code lookups for deactivated teachers. But there's no button anywhere to flip the flag — the only way to deactivate a teacher today is to run raw SQL in the Supabase dashboard. Similarly, there's no way for the platform admin to delete someone else's account. Both of these are needed before onboarding any pilot users.

---

### Change 2A — `api/admin.js`: Add `deactivate` POST action

**File:** `api/admin.js`  
**Location:** Insert new `if (action === 'deactivate')` block before the existing `if (action === 'seed-demo')` block (currently line 310).  
**What it does:**
- Accepts `{ userId, deactivated }` where `deactivated` is a boolean (true = deactivate, false = reactivate)
- Validates userId exists, confirms the target is not a `platform_admin` (you shouldn't be able to lock yourself out)
- Runs `UPDATE profiles SET is_deactivated = $deactivated WHERE id = $userId`
- Logs to `admin_audit_log` with before/after values
- Returns `{ ok: true }`

**Why this approach:** Matches the existing pattern in the file — every POST action validates input, makes one Supabase call, logs to audit, returns `{ ok: true }`. No new dependencies.

---

### Change 2B — `api/admin.js`: Add `admin-delete` POST action

**File:** `api/admin.js`  
**Location:** Immediately after the `deactivate` block.  
**What it does:**
- Accepts `{ userId }`
- Loads target profile (blocks if `platform_admin`)
- Looks up target's email from `auth.admin.getUserById()` for the audit log
- Deletes storage files, upload rows, profile row, then auth record — same cascade sequence as the existing self-service delete in `api/account.js` (lines 78–122)
- Writes audit log entry *before* the auth deletion (so the record exists even if auth deletion fails)
- Returns `{ ok: true }`

**Why this approach:** Mirrors the existing self-service delete flow in `api/account.js` exactly, but performed by a platform admin against another user. Same cascade order, same error handling pattern.

---

### Change 2C — `api/admin.js`: Add `is_deactivated` to teachers query

**File:** `api/admin.js`  
**Location:** Line 123, the `.select(...)` inside the `teachers` GET action.  
**What changes:** Add `is_deactivated` to the comma-separated column list.

**Before:**
```
id, role, tier, tier_override, country_code, division_name, notes, school_id, division_id,
```

**After:**
```
id, role, tier, tier_override, country_code, division_name, notes, school_id, division_id, is_deactivated,
```

**Why:** The admin JS needs this field to render the deactivation toggle in the correct state.

---

### Change 2D — `js/admin.js`: Add deactivation toggle + delete button to teacher rows

**File:** `js/admin.js`  
**Location:** Inside `renderTeachers()` (line 255–288), add a new `<td>` column after the Notes column.  
**What changes:**

1. Add a new `<th>Actions</th>` header in the table.
2. For each teacher row, add a cell with two elements:
   - A toggle button: "Deactivate" (if active) or "Reactivate" (if deactivated). Calls `toggleDeactivation(userId, currentState)`.
   - A "Delete" button styled as `btn--danger btn--small`. Calls `adminDeleteTeacher(userId, email)`.
3. If the teacher is deactivated, the email cell gets a strikethrough style + `(deactivated)` label to make the state visually obvious.

---

### Change 2E — `js/admin.js`: Add `toggleDeactivation()` and `adminDeleteTeacher()` functions

**File:** `js/admin.js`  
**Location:** After the existing `setNotes()` function (around line 364).  
**What it does:**

`toggleDeactivation(userId, currentlyDeactivated)`:
- Calls `adminApi('deactivate', 'POST', { userId, deactivated: !currentlyDeactivated })`
- On success, reloads the teacher list
- On error, shows an alert

`adminDeleteTeacher(userId, email)`:
- Shows `confirm()` dialog: "Permanently delete {email}? This removes all uploads, session events, and the account itself. This cannot be undone."
- If confirmed, calls `adminApi('admin-delete', 'POST', { userId })`
- On success, reloads teacher list + overview stats
- On error, shows an alert

**Why `confirm()` instead of a custom modal:** Every existing destructive action in the admin panel (seed-demo) uses `confirm()`. Consistency over polish at this stage.

---

## Step 5: Invitation Email Delivery

### Why this step matters
The `invitations` table exists (migration 005) with auto-generated tokens and 7-day expiry. The RLS has zero policies (server-side only by design). But there's no endpoint to create invitations, no endpoint to accept them, no email sending, and the School Admin / Division Admin pages show placeholder text. Without this, onboarding a division's teachers means manually attaching each one from the platform admin dashboard.

---

### Change 5A — `api/admin.js`: Add `send-invitation` POST action

**File:** `api/admin.js`  
**Location:** After the `admin-delete` block, before `seed-demo`.  
**What it does:**
- Accepts `{ email, role, schoolId, divisionId }` — role must be one of `teacher`, `school_admin`, `division_admin`
- Inserts a row into `invitations` (the DB auto-generates the token and sets 7-day expiry)
- Resolves the school or division name for the email subject/body
- Sends an email via Resend with a link to `/api/accept-invite?token=xxx`
- If the email send fails, the invitation row still exists — the admin can share the link manually
- Logs to `admin_audit_log`
- Returns `{ ok: true, token, expiresAt }`

**Why Resend:** Already a dependency (`package.json` line 8). Already used in `api/org.js` for tier-change emails. Same pattern.

---

### Change 5B — New file: `api/accept-invite.js`

**File:** `api/accept-invite.js` (new)  
**What it does:**
- `GET ?token=xxx` — browser redirect flow. If the teacher is not signed in, redirects to `/login.html?invite=xxx`. If signed in (JWT in header), processes the invitation inline and redirects to `/dashboard.html?invite_accepted=1`.
- `POST ?token=xxx` — AJAX call from login page after auth. Validates token, checks email match, attaches teacher to school/division, sets role, marks `accepted_at`, returns `{ ok: true }`.

**Validation rules:**
- Token must exist in the `invitations` table
- `accepted_at` must be null (not already used)
- `expires_at` must be in the future
- The signed-in user's email must match the invitation's email (case-insensitive)

**On success:**
- Updates `profiles` with `school_id`, `division_id`, and `role` from the invitation
- Sets `accepted_at` to now
- Writes audit log entry

---

### Change 5C — `login.html`: Handle invite token in URL

**File:** `login.html`  
**Location:** Inside the `<script>` block, after the existing `onAuthStateChange` handler (lines 42–48).  
**What changes:**
- After sign-in, check `URLSearchParams` for `invite` param
- If present, POST to `/api/accept-invite?token=xxx` with the auth JWT
- On success, redirect to `/dashboard.html?invite_accepted=1` instead of the normal role-based redirect
- On error, redirect to the normal destination with a query param indicating the error

---

### Change 5D — `school-admin.html`: Replace invite placeholder with a form

**File:** `school-admin.html`  
**Location:** Replace the `<div class="invite-placeholder">` block (lines 112–115).  
**What changes:** Replace the placeholder text with:
- An email input + role dropdown (Teacher or School Admin) + "Send Invitation" button
- A pending invitations list below the form (invitations not yet accepted)
- The form calls `sendInvitation()` in the JS

---

### Change 5E — `js/school-admin.js`: Add invitation functions

**File:** `js/school-admin.js`  
**Location:** Add new functions after the existing code.  
**What it does:**
- `sendSchoolInvitation()` — reads email + role from the form, calls `adminApi` or `orgApi` to send invitation
- `loadPendingInvitations()` — fetches invitations for this school, renders a list

**Note:** The `send-invitation` action lives on `/api/admin.js` (platform admin only). For School Admins to send invitations, we need to also add a `send-invitation` action to `/api/org.js`. This follows the same pattern but is scoped to the caller's school.

---

### Change 5F — `api/org.js`: Add `send-invitation` POST action

**File:** `api/org.js`  
**Location:** After the existing `remove-school-admin` action.  
**What it does:**
- Same logic as the admin version but scoped: School Admins can only invite to their own school, Division Admins can invite to schools in their division
- Validates that the caller has permission to invite to the specified school/division
- Inserts invitation row, sends email via Resend

---

### Change 5G — `division-admin.html` + `js/division-admin.js`: Same invite form

**File:** `division-admin.html`  
**Location:** Replace the `<div class="invite-placeholder">` block (lines 131–134).  
**Same approach as 5D/5E** but scoped to division-level invitations.

---

## Step 8: Marketing Site Sign In Link + Pricing Callouts

### Why this step matters
The marketing site at `audioproctor.com` has no visible path to the app. A teacher who finds the site can't sign in. The pricing section already exists on the homepage, but the About page has no pricing philosophy paragraph and the Contact form doesn't have the enrolment dropdown described in the roadmap.

---

### Change 8A — `site/nav.js`: Add "Sign In" link

**File:** `site/nav.js`  
**Location:** Line 25 (the `site-nav__links` div), before the "Schedule a Demo" button.  
**What changes:** Add a new link:
```html
<a href="https://app.audioproctor.com/login.html" class="site-nav__link">Sign In</a>
```
Also add it to the mobile nav (line 30).

**Why `https://app.audioproctor.com`:** The app lives on the subdomain. The marketing site can't link to `/login.html` because that would serve the marketing site's own root, not the app.

---

### Change 8B — `site/about.html`: Add pricing philosophy paragraph

**File:** `site/about.html`  
**Location:** After the "Built by someone in the room" section (after line 37, before the closing `</div>`).  
**What changes:** Add a new `<h2>Pricing</h2>` section with the paragraph from the roadmap:

> AudioProctor is priced by the scope of the purchase. A teacher can sign up free. A school can buy a plan from their minibudget. A division can sign one contract that covers every school, every teacher, and every Chromebook. The price scales with how much of the organization is covered, not with how many features are unlocked.

With a link to the homepage pricing section.

---

### Change 8C — `site/contact.html`: Add Division Enrolment dropdown

**File:** `site/contact.html`  
**Location:** After the "School Division" text input (line 49), add a new `<div class="site-form-group">`.  
**What changes:** Add a dropdown:
```html
<label for="enrolment">Division Size</label>
<select id="enrolment" name="enrolment">
  <option value="">Select one…</option>
  <option value="Individual teacher">Individual teacher</option>
  <option value="Under 2,000 students">Under 2,000 students</option>
  <option value="2,000–8,000 students">2,000–8,000 students</option>
  <option value="8,000–25,000 students">8,000–25,000 students</option>
  <option value="25,000+ students">25,000+ students</option>
</select>
```
Also add `enrolment` to the form submission body object (around line 111).

**Also needed:** `api/contact.js` must accept the new `enrolment` field and include it in the email body. This is a one-line addition to the email template.

---

## Step 9: Domain Restriction on Google Login

### Why this step matters
When a division signs a pilot, they'll want only their staff creating accounts under their division. Currently anyone with any Google account can sign up. This needs to be optional (per-division, not global) and checked after login, not during OAuth (Supabase doesn't support per-division OAuth restrictions).

---

### Change 9A — New migration: `supabase/migrations/013_restricted_domain.sql`

**File:** `supabase/migrations/013_restricted_domain.sql` (new)  
**What it does:**
```sql
ALTER TABLE divisions ADD COLUMN IF NOT EXISTS restricted_domain text;
```

One column. No constraint — it's just a text field holding a domain like `fsd38.ab.ca`. Null means no restriction.

---

### Change 9B — `login.html`: Post-login domain check

**File:** `login.html`  
**Location:** Inside `redirectByRole()` (line 29), after fetching the profile.  
**What changes:**
- If the teacher has a `division_id`, fetch the division's `restricted_domain`
- If `restricted_domain` is set and the teacher's email doesn't end with `@{restricted_domain}`, sign them out and show an error: "Your email domain is not authorized for this division."
- This only blocks teachers who are *already attached* to a division with a restriction. Teachers who aren't attached to any division are unaffected.

**Why check at login, not in the auth callback:** Supabase OAuth doesn't support per-tenant domain filtering. The check has to happen after the user is authenticated and we know which division they belong to.

---

### Change 9C — `api/admin.js`: Add `restricted_domain` to divisions query + new action

**File:** `api/admin.js`  
**Location:** Inside the `divisions` GET action (line 95), add `restricted_domain` to the select.  
**Also:** Already described above — `set-restricted-domain` POST action and `restricted_domain` included in the divisions query.

---

### Change 9D — `js/admin.js`: Add restricted domain input to division rows

**File:** `js/admin.js`  
**Location:** Inside `loadDivisions()` → the `rows` template (around line 100–116).  
**What changes:** Add a new `<td>` with an input field:
```html
<td>
  <input class="notes-input" type="text" value="${d.restricted_domain || ''}"
    placeholder="e.g. fsd38.ab.ca"
    onblur="setRestrictedDomain('${d.id}', this.value)"
    onkeydown="if(event.key==='Enter')this.blur()">
</td>
```
And add a `<th>Domain Lock</th>` header.

Also add a `setRestrictedDomain()` function that calls `adminApi('set-restricted-domain', 'POST', ...)`.

---

## Step 10: Stripe Integration

### Why this step matters
Once a pilot converts, you need a way to take payment. Teacher Premium ($75/yr) and School ($200/yr) are self-serve credit card. Division stays manual invoice. This is the most complex change.

---

### Change 10A — `package.json`: Add Stripe dependency

**File:** `package.json`  
**What changes:** Add `"stripe": "^17.0.0"` to `dependencies`.

---

### Change 10B — New file: `api/stripe.js`

**File:** `api/stripe.js` (new)  
**What it does:**

Three actions via `?action=` query param:

1. `POST ?action=create-checkout` — Authenticated teacher creates a Stripe Checkout Session for Teacher Premium or School tier. Returns a checkout URL. Requires `STRIPE_SECRET_KEY` and `STRIPE_PRICE_PREMIUM` / `STRIPE_PRICE_SCHOOL` env vars.

2. `POST ?action=webhook` — Stripe webhook handler (no auth — verified by Stripe signature). Handles:
   - `checkout.session.completed` → update teacher's `tier_override` (or school's `tier`) to the purchased tier
   - `customer.subscription.deleted` → downgrade tier back to `free`
   - `invoice.payment_failed` → optional: set a flag or send a notification

3. `POST ?action=portal` — Authenticated teacher gets a Stripe Customer Portal URL for managing their subscription (cancel, update payment method).

**Environment variables needed:**
- `STRIPE_SECRET_KEY`
- `STRIPE_WEBHOOK_SECRET`
- `STRIPE_PRICE_PREMIUM` (Stripe Price ID for Teacher Premium)
- `STRIPE_PRICE_SCHOOL` (Stripe Price ID for School tier)

---

### Change 10C — `vercel.json`: Add raw body config for Stripe webhook

**File:** `vercel.json`  
**What changes:** Stripe webhooks require the raw request body for signature verification. Vercel parses JSON by default. Add:
```json
{
  "functions": {
    "api/stripe.js": {
      "includeFiles": ""
    }
  }
}
```
And in the stripe.js handler, use `req.headers['stripe-signature']` with the raw body.

**Note:** Vercel serverless functions receive the raw body as `req.body` when Content-Type is not application/json. For Stripe, the webhook sends `application/json` but we need to read `req.rawBody` or buffer it manually.

---

### Change 10D — `js/settings.js`: Add upgrade buttons

**File:** `js/settings.js`  
**Location:** Inside `renderSubscription()` (line 58), modify the `tier === 'free'` branch.  
**What changes:**
- Instead of just showing "See pricing →", add two buttons:
  - "Upgrade to Teacher Premium — $75 CAD/year" → calls `startCheckout('premium')`
  - For school_admin role only: "Upgrade School — $200 CAD/year" → calls `startCheckout('school')`
- Add a `startCheckout(tier)` function that POSTs to `/api/stripe?action=create-checkout`, then redirects to the Stripe Checkout URL
- For already-subscribed users (tier === 'premium' and paid via Stripe), show a "Manage Subscription" link that opens the Stripe Customer Portal

---

### Change 10E — `settings.html`: Add success/cancel messaging

**File:** `settings.html`  
**Location:** Inside the subscription section.  
**What changes:** Check URL params for `?checkout=success` or `?checkout=cancel` and show appropriate notices. Stripe redirects back to these URLs after checkout.

---

## Files NOT changed

These files are not modified by any of the above:

- `css/styles.css` — no new styles needed; all new UI uses existing classes
- `extension/*` — no extension changes
- `dashboard.html`, `js/dashboard.js` — no teacher dashboard changes
- `player.html` — no player changes
- `api/session.js` — already respects `is_deactivated`; no changes needed
- `api/event.js` — no changes
- `site/site.css` — no new marketing styles needed
- `site/privacy.html`, `site/terms.html` — no changes needed for these steps

---

## New environment variables required

| Variable | Where | Step | Purpose |
|---|---|---|---|
| `STRIPE_SECRET_KEY` | Vercel env | 10 | Stripe API access |
| `STRIPE_WEBHOOK_SECRET` | Vercel env | 10 | Webhook signature verification |
| `STRIPE_PRICE_PREMIUM` | Vercel env | 10 | Stripe Price ID for Teacher Premium |
| `STRIPE_PRICE_SCHOOL` | Vercel env | 10 | Stripe Price ID for School tier |

All existing env vars (`SUPABASE_URL`, `SUPABASE_ANON_KEY`, `SUPABASE_SERVICE_ROLE_KEY`, `RESEND_API_KEY`, `CONTACT_EMAIL`) remain unchanged.

---

## New database migration required

**`supabase/migrations/013_restricted_domain.sql`** — one line:
```sql
ALTER TABLE divisions ADD COLUMN IF NOT EXISTS restricted_domain text;
```

Run in Supabase SQL editor before deploying the code changes from Step 9.
