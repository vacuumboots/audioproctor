// ─── Settings Page ────────────────────────────────────────────────────────
// Handles profile editing, subscription display, and account deletion.

const ACCOUNT_API = '/api/account';

let settingsJwt    = null;
let settingsUserId = null;

async function initSettings(user) {
  const session = await getSession();
  if (!session) { window.location.href = '/login.html'; return; }
  settingsJwt    = session.access_token;
  settingsUserId = user.id;

  document.getElementById('profile-email').textContent = user.email || '—';

  // Load profile data
  const { data: profile } = await supabaseClient
    .from('profiles')
    .select('display_name, role, school_id, division_id, tier, tier_override')
    .eq('id', user.id)
    .maybeSingle();

  if (profile?.display_name) {
    document.getElementById('display-name-input').value = profile.display_name;
  }

  // Org affiliation — resolve school name and, if the school is part of a
  // division, the division name too (even though profile.division_id is null).
  let orgText = t('settings.noOrg');
  let schoolDivisionId = null; // division that the teacher's school belongs to
  if (profile?.school_id || profile?.division_id) {
    const parts = [];
    if (profile.school_id) {
      const { data: school } = await supabaseClient
        .from('schools').select('name, division_id').eq('id', profile.school_id).maybeSingle();
      if (school) {
        parts.push(school.name);
        schoolDivisionId = school.division_id || null;
      }
    }
    // Show division name whether the teacher is linked directly or via school.
    const divisionId = profile.division_id || schoolDivisionId;
    if (divisionId) {
      const { data: division } = await supabaseClient
        .from('divisions').select('name').eq('id', divisionId).maybeSingle();
      if (division) parts.push(division.name);
    }
    if (parts.length) orgText = parts.join(' · ');
  }
  document.getElementById('profile-org').textContent = orgText;

  // Subscription block
  const tier = await getEffectiveTier(user.id);
  await renderSubscription(tier, profile, schoolDivisionId);
}

async function renderSubscription(tier, profile, schoolDivisionId = null) {
  const block = document.getElementById('subscription-block');
  if (!block) return;

  if (tier === 'free') {
    block.innerHTML = `
      <p><strong>${t('settings.freeTierTitle')}</strong></p>
      <p style="margin-top:0.5rem; color:var(--muted);">${t('settings.freeTierDesc')}</p>
      <p style="margin-top:0.75rem;"><a href="/site/pricing.html" style="color:var(--ink); font-weight:500;">${t('settings.seePricing')}</a></p>
    `;
  } else if (profile?.tier_override) {
    const tierLabels = { premium: t('dashboard.tierBadge.premium'), school: t('dashboard.tierBadge.school'), division: t('dashboard.tierBadge.division') };
    block.innerHTML = `
      <p><strong>${t('settings.tierOverrideTitle', { tier: tierLabels[tier] || tier })}</strong></p>
      <p style="margin-top:0.5rem; color:var(--muted);">${t('settings.tierOverride')}</p>
    `;
  } else if (profile?.division_id) {
    // Load division Stripe subscription status
    const { data: division } = await supabaseClient
      .from('divisions')
      .select('name, stripe_subscription_status, tier, enrolment_band')
      .eq('id', profile.division_id)
      .maybeSingle();

    const statusHtml = getStripeStatusHtml(division?.stripe_subscription_status);
    const bandLabel = division?.enrolment_band ? capitalize(division.enrolment_band) : '';
    const planLabel = division?.tier === 'division'
      ? (bandLabel ? t('settings.divisionPlanLabel', { band: capitalize(division.enrolment_band) }) : t('settings.divisionPlanLabel', { band: '' }).trim())
      : t('dashboard.tierBadge.division');

    block.innerHTML = `
      <p><strong>${t('settings.divisionOnPlan', { name: division?.name || '—', plan: planLabel })}</strong> ${statusHtml}</p>
      <p style="margin-top:0.5rem; color:var(--muted);">${t('settings.planFeatures')}</p>
      <p style="margin-top:0.75rem; font-size:0.8rem; color:var(--muted);">
        <a href="/division-admin.html" style="color:var(--ink);">${t('settings.manageDivisionPlan')}</a>
      </p>
    `;
  } else if (profile?.school_id) {
    // Teacher linked via school — check school's Stripe status
    const { data: school } = await supabaseClient
      .from('schools')
      .select('name, stripe_subscription_status, tier, division_id')
      .eq('id', profile.school_id)
      .maybeSingle();

    const onDivisionPlan = tier === 'division' || !!schoolDivisionId;
    const label = onDivisionPlan ? t('dashboard.tierBadge.division') : t('dashboard.tierBadge.school');
    const via   = onDivisionPlan ? t('settings.schoolDivisionVia') : '';
    const statusHtml = school ? getStripeStatusHtml(school.stripe_subscription_status) : '';

    block.innerHTML = `
      <p><strong>${t('settings.schoolOnPlan', { school: school?.name || t('settings.yourSchool'), plan: label })}</strong> ${statusHtml}</p>
      <p style="margin-top:0.5rem; color:var(--muted);">${t('settings.planFeaturesVia', { via: via })}</p>
      <p style="margin-top:0.75rem; font-size:0.8rem; color:var(--muted);">
        <a href="/school-admin.html" style="color:var(--ink);">${t('settings.manageSchoolPlan')}</a>
      </p>
    `;
  } else if (tier === 'premium') {
    block.innerHTML = `
      <p><strong>${t('settings.premiumTitle')}</strong></p>
      <p style="margin-top:0.5rem; color:var(--muted);">${t('settings.planFeatures')}</p>
      <p style="margin-top:0.75rem; font-size:0.8rem; color:var(--muted);">${t('settings.billingComing')}</p>
    `;
  } else {
    block.innerHTML = `<p>${t('settings.loadingDetails')}</p>`;
  }
}

function getStripeStatusHtml(status) {
  if (!status || status === 'active') return '';
  const statusLabels = {
    past_due: t('settings.stripeStatusPastDue'),
    canceled: t('settings.stripeStatusCanceled'),
    incomplete: t('settings.stripeStatusIncomplete'),
    unpaid: t('settings.stripeStatusUnpaid'),
    paused: t('settings.stripeStatusPaused'),
  };
  const label = statusLabels[status] || status;
  return `<span style="display:inline-block; padding:0.1rem 0.45rem; font-size:0.65rem; letter-spacing:0.1em; text-transform:uppercase; font-weight:500; background:var(--light-accent); color:var(--accent); border:1px solid var(--accent); vertical-align:middle;">${label}</span>`;
}

// ─── Profile ─────────────────────────────────────────────────────────────

async function saveDisplayName() {
  const displayName = document.getElementById('display-name-input').value.trim();
  const noticeEl    = document.getElementById('profile-notice');

  try {
    const res  = await fetch(`${ACCOUNT_API}?action=update-profile`, {
      method:  'POST',
      headers: { 'Authorization': `Bearer ${settingsJwt}`, 'Content-Type': 'application/json' },
      body:    JSON.stringify({ displayName }),
    });
    const data = await res.json();
    if (!res.ok) throw new Error(data.error || `Error ${res.status}`);

    noticeEl.textContent = t('settings.profileSaved');
    noticeEl.className   = 'notice notice--success';
    noticeEl.classList.remove('hidden');
    setTimeout(() => noticeEl.classList.add('hidden'), 3000);
  } catch (err) {
    noticeEl.textContent = t('settings.couldNotSave', { error: err.message });
    noticeEl.className   = 'notice notice--error';
    noticeEl.classList.remove('hidden');
  }
}

// ─── Delete Account ───────────────────────────────────────────────────────

function startDeleteFlow() {
  document.getElementById('delete-step-1').classList.add('hidden');
  document.getElementById('delete-step-2').classList.remove('hidden');
  document.getElementById('delete-confirm-input').focus();
}

function cancelDeleteFlow() {
  document.getElementById('delete-step-2').classList.add('hidden');
  document.getElementById('delete-step-1').classList.remove('hidden');
  document.getElementById('delete-confirm-input').value = '';
  document.getElementById('btn-confirm-delete').disabled = true;
}

function checkDeleteConfirm() {
  const val = document.getElementById('delete-confirm-input').value;
  document.getElementById('btn-confirm-delete').disabled = (val !== 'DELETE');
}

async function confirmDelete() {
  const val = document.getElementById('delete-confirm-input').value;
  if (val !== 'DELETE') return;

  const btn = document.getElementById('btn-confirm-delete');
  btn.disabled    = true;
  btn.textContent = t('settings.deleting');

  const noticeEl = document.getElementById('delete-notice');

  try {
    const res  = await fetch(`${ACCOUNT_API}?action=delete-account`, {
      method:  'POST',
      headers: { 'Authorization': `Bearer ${settingsJwt}`, 'Content-Type': 'application/json' },
    });
    const data = await res.json();
    if (!res.ok) throw new Error(data.error || `Error ${res.status}`);

    // Sign out and redirect to marketing site
    await supabaseClient.auth.signOut();
    window.location.href = 'https://audioproctor.com';
  } catch (err) {
    noticeEl.textContent = t('settings.deleteError', { error: err.message });
    noticeEl.className   = 'notice notice--error';
    noticeEl.classList.remove('hidden');
    btn.disabled    = false;
    btn.textContent = t('settings.permanentlyDelete');
  }
}

// ─── Util ─────────────────────────────────────────────────────────────────

function capitalize(str) {
  if (!str) return '';
  return str.charAt(0).toUpperCase() + str.slice(1);
}
