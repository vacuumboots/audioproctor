# AudioProctor Prioritized Shipping Order

> For Hermes: planning only. Do not implement from this file without a separate execution pass.

**Goal:** Turn `roadmap.md` into the actual shipping order that gets AudioProctor from current product state to pilot-ready, then division-ready, then self-serve revenue.

**Recommended planning horizon:** Next 90–120 days.

**Principle:** Ship only the work that removes the next real blocker to adoption, trust, deployment, or payment. Do not treat every roadmap item as equally urgent.

---

## Current context

Based on `roadmap.md`, `improvements.md`, and `README.md`, the product already has:
- core teacher upload flow
- Chrome extension player flow
- free tier quota enforcement
- teacher customization features
- session analytics schema + dashboards
- org hierarchy (school/division)
- admin dashboards
- teacher request flow
- invitation acceptance flow
- Teacher Premium Stripe checkout/webhook

The main gaps are not core product capability. The main gaps are:
1. deployment readiness on real managed Chromebooks
2. trust/reliability/compliance readiness for schools/divisions
3. email delivery and invite completion
4. org lifecycle/admin hardening
5. distribution workflow for IT admins
6. pricing/billing hardening for non-teacher tiers

---

## What not to ship yet

These should explicitly wait until later:
- custom subdomains
- Google Workspace Marketplace listing
- timeline visualization over waveform
- public Chrome Web Store listing
- onboarding drip sequences beyond the minimum required ones
- audio normalization before pilot deployment and admin workflow blockers are solved
- school/division billing automation before org entitlement rules are fully defined

---

## The actual shipping order

## Shipment 0 — Clean up the roadmap and define the source of truth

**Why first:** Planning drift is already visible. A roadmap that disagrees with the repo causes bad prioritization.

**Outcome:** One trustworthy status document before more work ships.

**Ship items:**
1. Reconcile `roadmap.md` against shipped code and `README.md`
2. Mark each item as one of:
   - shipped
   - in progress
   - next
   - later
   - parked
3. Split roadmap lines into 4 buckets:
   - product/platform
   - deployment/distribution
   - compliance/operations
   - billing/revenue
4. Add stage exit criteria for:
   - pilot-ready
   - first paid school
   - first paid division

**Acceptance criteria:**
- No item marked future if already shipped
- No duplicated feature entries with conflicting scope
- “Pilot-ready” is defined in writing
- “Division-ready” is defined in writing

**Likely files to change:**
- `roadmap.md`
- `improvements.md`
- `README.md`

---

## Shipment 1 — Managed Chromebook pilot readiness

**Why now:** Before more platform work, prove the real deployment path works in the target environment.

**Outcome:** AudioProctor runs end-to-end on an actual managed Chromebook under real school policy.

**Ship items:**
1. Run and document a full managed Chromebook test
2. Validate:
   - extension force-install path
   - code entry flow
   - fullscreen enforcement
   - audio playback duration stability
   - exit-word flow
   - session expiration behavior
   - behavior after sleep/wake/network interruption
3. Capture every policy/config needed for IT deployment
4. Fix any blocker bugs discovered in the extension or session flow

**Acceptance criteria:**
- One successful end-to-end run on a managed Chromebook
- One documented reproducible install path for IT admins
- No blocker bugs in fullscreen/audio/exit-word flow
- Any Chromebook-specific issue is either fixed or explicitly documented with workaround

**Likely files to change:**
- `extension/manifest.json`
- `extension/popup.js`
- `extension/player.js`
- `extension/background.js`
- `api/session.js`
- `README.md`
- new deployment doc under `docs/` or `site/`

**Notes:**
This is more important than audio normalization. If the deployment path itself is shaky, nothing else matters.

---

## Shipment 2 — Invite delivery and minimum onboarding completion

**Why now:** The data model and acceptance flow exist, but email delivery is still the missing connective tissue.

**Outcome:** Platform admin and org admins can send a real invite that lands in a user inbox and completes successfully.

**Ship items:**
1. Trigger invitation email on invite creation
2. Add invite email template
3. Add resend-invite action in admin UI
4. Add expired-invite handling in UI and API
5. Add minimum operational logging for invite creation, send success/failure, resend
6. Add one Day-0 welcome email only after first successful account activation

**Acceptance criteria:**
- Admin creates invite -> email sends
- Recipient opens link -> signs in -> lands attached to correct org
- Expired invite produces a clear recovery path
- Failed email send is visible to admin
- Welcome email is sent only once

**Likely files to change:**
- `api/admin.js`
- `api/accept-invite.js`
- possibly new helper: `api/_lib/email.js` or similar
- `js/admin.js`
- `accept-invite.html`
- `site/request-access.html` if flow language changes

**Notes:**
This is the smallest high-leverage distribution unlock in the whole roadmap.

---

## Shipment 3 — Admin hardening for real account lifecycle

**Why now:** Once invites start working, org management becomes operationally real. You need correct suspend/delete/reassign behavior before pilots widen.

**Outcome:** Platform admin can safely manage teacher accounts and org relationships without manual DB intervention.

**Ship items:**
1. Teacher deactivate/reactivate in admin UI
2. Teacher reassignment between schools
3. School reassignment between divisions
4. Clear detach fallback behavior in UI and backend
5. Document the state matrix for:
   - active
   - detached
   - deactivated
   - deleted
   - lapsed billing
6. If deletion is exposed to admin UI, make it a separate shipment only after deactivate flow is stable

**Acceptance criteria:**
- Admin can deactivate and reactivate a teacher without direct DB edits
- Deactivated teacher’s sessions are blocked consistently
- Reassignment preserves upload history
- Tier fallback behavior matches written policy
- No silent privilege/tier drift after attach/detach/reassign

**Likely files to change:**
- `api/admin.js`
- `api/org.js`
- `api/session.js`
- `js/admin.js`
- `js/school-admin.js`
- `js/division-admin.js`
- `settings.html`
- relevant Supabase migration(s)

**Notes:**
Do not broaden to division-level deletion yet unless teacher-level lifecycle is solid.

---

## Shipment 4 — Compliance and operational trust pack

**Why now:** This is what makes a school/division comfortable saying yes. It is a sales blocker, not back-office polish.

**Outcome:** You can answer a principal, division admin, or IT/privacy reviewer with confidence.

**Ship items:**
1. Enable Supabase PITR / backups
2. Perform one restore test and document the result
3. Finalize analytics retention/deletion implementation, not just policy wording
4. Define account/data deletion triggers:
   - teacher self-delete
   - org detachment
   - deactivation
   - billing lapse
   - contract end
5. Add anomaly review operating procedure
6. Create a short buyer-facing security/privacy summary
7. Update Privacy Policy and internal docs to match actual implementation

**Acceptance criteria:**
- Backups are enabled
- Restore path is tested at least once
- Retention policy is both documented and implemented
- Deletion/downgrade rules are internally consistent
- Buyer-facing security/privacy one-pager exists

**Likely files to change:**
- `roadmap.md`
- `README.md`
- `site/privacy.html`
- possible cron/script docs under `docs/`
- possible new cleanup scripts / scheduled job docs
- Supabase migrations and/or scheduled functions

**Notes:**
This shipment should be complete before serious division procurement conversations.

---

## Shipment 5 — Chrome Web Store and IT deployment path

**Why now:** This removes the biggest deployment friction for actual school IT teams.

**Outcome:** IT admins can deploy by Store ID using the normal Admin Console workflow.

**Ship items:**
1. Publish extension to Chrome Web Store as unlisted
2. Create store assets and listing copy aimed at IT admins
3. Write the one-page IT deployment guide
4. Update all deployment docs to reference Store ID, not manual package upload
5. Identify the minimum managed-policy surface actually needed
6. Only add managed extension config after a real pilot proves the need

**Acceptance criteria:**
- Extension is installable by Chrome Web Store ID
- IT guide is complete enough for a first-time Workspace admin
- No doc still tells admins to use an obsolete deployment path
- At least one test deployment is performed using the documented Store ID path

**Likely files to change:**
- `extension/manifest.json`
- store listing assets outside repo or under `assets/`
- `README.md`
- marketing/deployment docs in `site/` or `docs/`

**Notes:**
This should happen before trying to scale beyond manual pilot support.

---

## Shipment 6 — Controlled teacher acquisition flow

**Why now:** Once invites and deployment work, you can safely widen the top of the funnel without opening the floodgates.

**Outcome:** Teachers can request access cleanly, admins can approve them quickly, and growth no longer depends on ad hoc manual steps.

**Ship items:**
1. Polish the existing request-access flow
2. Notify platform admin reliably on request submission
3. Add approval/rejection workflow in admin UI
4. Add domain restriction as org policy, not as a vague login-only feature
5. Enforce domain restriction where it matters:
   - invite acceptance
   - request approval
   - optional sign-in guardrails
6. Add request triage fields or notes if needed

**Acceptance criteria:**
- Teacher request -> admin notified -> approval -> invite email -> org attachment works end-to-end
- Domain policy cannot be bypassed by invite sharing or wrong-account login
- Admin workload is lower than today, not higher

**Likely files to change:**
- `site/request-access.html`
- `api/request-access.js`
- `api/admin.js`
- `api/accept-invite.js`
- `js/admin.js`
- Supabase migrations for allowed domains / policy configuration

**Notes:**
This is where “domain restriction” should really land. Treat it as org-membership control, not just OAuth filtering.

---

## Shipment 7 — School plan and division plan entitlement rules

**Why now:** Before charging schools/divisions, entitlement logic must match pricing promises.

**Outcome:** Org plans have enforceable rules instead of hand-wavy admin overrides.

**Ship items:**
1. Define seat-cap rules for School tier
2. Add seat usage visibility in admin surfaces
3. Define over-cap behavior
4. Define how inherited tiers interact with teacher premium
5. Define lapse behavior for school/division plans
6. Keep manual admin override intact for exceptions

**Acceptance criteria:**
- School “up to 15 teachers” is technically enforceable
- Org tier inheritance is predictable and documented
- Lapse behavior is consistent with detach/deactivate policies
- Admin can explain why a specific teacher has a given effective tier

**Likely files to change:**
- Supabase migrations
- `api/admin.js`
- `api/org.js`
- `js/admin.js`
- `js/school-admin.js`
- `js/division-admin.js`
- `js/auth.js`
- `README.md`

**Notes:**
Do not launch school/division self-serve billing before this shipment is done.

---

## Shipment 8 — Teacher Premium hardening, then org billing design

**Why now:** Teacher Premium exists already. Harden that first. Do not jump straight to school/division billing.

**Outcome:** Individual billing is reliable; org billing gets designed on top of stable entitlement rules.

**Ship items:**
1. Harden Teacher Premium lifecycle:
   - renewal state visibility
   - cancellation/lapse handling
   - settings page clarity
2. Add billing visibility where appropriate
3. Only then design School/Division billing model:
   - invoice owner
   - customer record ownership
   - renewal reminders
   - contract expiry semantics
4. Keep school/division billing manual until model is operationally correct

**Acceptance criteria:**
- Teacher Premium upgrade/downgrade lifecycle is understandable and stable
- No ambiguous tier state after Stripe events
- Org billing design is documented before implementation begins

**Likely files to change:**
- `api/stripe-checkout.js`
- `api/stripe-webhook.js`
- `api/account.js`
- `js/settings.js`
- `settings.html`
- `README.md`
- billing design doc under `docs/` or `.hermes/plans/`

**Notes:**
This avoids mixing pricing strategy work with unfinished entitlement logic.

---

## Shipment 9 — Audio normalization and storage pipeline

**Why later:** Valuable, but not the next blocker to pilot deployment, school trust, or payment. It is a substantial architecture change and should be treated that way.

**Outcome:** Uploads become consistent, cheaper, and safer for long-form spoken audio.

**Ship items:**
1. Add upload processing states to DB
2. Add staging path/bucket semantics
3. Add async transcode worker/function with idempotency
4. Add dashboard processing UI
5. Ensure sessions never expose unprocessed audio
6. Update storage accounting after normalization completes
7. Add failure and retry path

**Acceptance criteria:**
- Uploaded source file transitions through clear processing states
- Teachers never get a playable code for a failed or in-progress asset
- Transcode failure is visible and recoverable
- Final stored file size is predictable enough for quota planning

**Likely files to change:**
- `js/dashboard.js`
- `api/session.js`
- Supabase migrations
- Supabase edge function(s)
- storage path conventions in docs

**Notes:**
This should be implemented as a separate mini-project, not a checklist bullet.

---

## Shipment 10 — Nice-to-have analytics and marketing polish

**Why last:** These improve presentation but do not unblock deployment, trust, or payment.

**Includes:**
- teacher timeline view
- extra onboarding sequence emails
- public Chrome Web Store listing
- pilot PDF/report automation
- Google Workspace Marketplace listing
- advanced marketing polish

---

## 90-day execution order

If you want the shortest realistic shipping queue, do it in this order:

1. Shipment 0 — roadmap/status cleanup
2. Shipment 1 — managed Chromebook pilot readiness
3. Shipment 2 — invite delivery and minimum onboarding
4. Shipment 3 — admin hardening for account lifecycle
5. Shipment 4 — compliance and operational trust pack
6. Shipment 5 — Chrome Web Store + IT deployment guide
7. Shipment 6 — controlled teacher acquisition + domain policy
8. Shipment 7 — school/division entitlement rules
9. Shipment 8 — Teacher Premium hardening, then org billing design
10. Shipment 9 — audio normalization
11. Shipment 10 — later polish

---

## The next 3 things to ship, specifically

If the goal is “what do we build next, in order,” the answer is:

### Next ship 1
Managed Chromebook end-to-end validation
- because it proves the real deployment path
- because it may expose extension blockers before you optimize anything else

### Next ship 2
Invitation email delivery + resend + expired-invite recovery
- because the data model and accept flow already exist
- because it unlocks real org onboarding immediately

### Next ship 3
Teacher/account lifecycle hardening in admin UI
- because once people are invited, account state management becomes operationally critical

If you want a revenue-oriented version of the same answer, then swap ship 3 and ship 5 only after ship 2:
- managed Chromebook validation
- invite email delivery
- Chrome Web Store publication

---

## Suggested definitions of readiness

### Pilot-ready
- Managed Chromebook deployment tested successfully
- Invite flow works end-to-end
- Teacher deactivation works
- Backups enabled
- Privacy policy and deletion behavior match reality
- IT deployment guide exists

### First paid school-ready
- School seat rules defined and enforceable
- School admin invite/remove flow stable
- Billing can be handled manually without ambiguity
- Chrome Web Store deployment path documented

### First paid division-ready
- Division admin workflow stable
- Domain restriction / membership controls work
- Compliance/security summary exists
- Renewal and contract-end behavior is documented
- Restore and deletion workflows have been tested

---

## Risks if you do this in the wrong order

1. Shipping audio normalization too early
- large engineering cost
- does not solve deployment friction or procurement trust

2. Shipping org billing before entitlement rules
- pricing promises and actual access control diverge

3. Shipping broad self-serve signup before domain/org controls
- support and abuse burden rises

4. Shipping pilot conversations before Chromebook and deployment docs are proven
- avoidable credibility hit with IT admins

---

## Open questions to resolve before execution

1. Do you want teacher signup to remain approval-based, or eventually move to instant free-tier access?
2. Is the first target customer still Alberta divisions first, or individual teachers/schools first?
3. Do you want School tier enforced by hard seat cap, soft cap with warning, or manual exception workflow?
4. Do you want email sending owned entirely from Vercel functions, or from a job/scheduler layer?
5. Do you want compliance artifacts lightweight and founder-written, or packaged more formally for procurement?

---

## Recommended immediate action

Turn Shipments 1–3 into implementation plans first. They are the highest-leverage sequence:
- Shipment 1: managed Chromebook validation
- Shipment 2: invitation email delivery
- Shipment 3: admin lifecycle hardening

That sequence gets AudioProctor from “feature-rich product” to “actually deployable product.”
