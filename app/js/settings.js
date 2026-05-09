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
  let orgText = 'No school or division assigned';
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
      <p><strong>You're on the Free tier.</strong></p>
      <p style="margin-top:0.5rem; color:var(--muted);">3 uploads per calendar month · 50 MB storage · No analytics</p>
      <p style="margin-top:0.75rem;"><a href="/site/pricing.html" style="color:var(--ink); font-weight:500;">See pricing →</a></p>
    `;
  } else if (profile?.tier_override) {
    const tierLabels = { premium: 'Teacher Premium', school: 'School Plan', division: 'Division Plan' };
    block.innerHTML = `
      <p><strong>You're on ${tierLabels[tier] || tier}.</strong></p>
      <p style="margin-top:0.5rem; color:var(--muted);">Your tier has been set manually by the platform administrator.</p>
    `;
  } else if (profile?.division_id) {
    // Load division Stripe subscription status
    const { data: division } = await supabaseClient
      .from('divisions')
      .select('name, stripe_subscription_status, tier, enrolment_band')
      .eq('id', profile.division_id)
      .maybeSingle();

    const statusHtml = getStripeStatusHtml(division?.stripe_subscription_status);
    const bandLabel = division?.enrolment_band ? capitalize(division.enrolment_band) + ' Division' : 'Division';
    const tierLabel = division?.tier === 'division' ? `${bandLabel} Plan` : 'Division';

    block.innerHTML = `
      <p><strong>Your division (${division?.name || '—'}) is on a ${tierLabel}.</strong> ${statusHtml}</p>
      <p style="margin-top:0.5rem; color:var(--muted);">Unlimited uploads · Full analytics · All features included.</p>
      <p style="margin-top:0.75rem; font-size:0.8rem; color:var(--muted);">
        <a href="/division-admin.html" style="color:var(--ink);">Manage Division Plan →</a>
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
    const label = onDivisionPlan ? 'Division Plan' : 'School Plan';
    const via   = onDivisionPlan ? ' (through your school\'s division)' : '';
    const statusHtml = school ? getStripeStatusHtml(school.stripe_subscription_status) : '';

    block.innerHTML = `
      <p><strong>${school?.name || 'Your school'} is on a ${label}.</strong> ${statusHtml}</p>
      <p style="margin-top:0.5rem; color:var(--muted);">Unlimited uploads · Full analytics · All features included${via}.</p>
      <p style="margin-top:0.75rem; font-size:0.8rem; color:var(--muted);">
        <a href="/school-admin.html" style="color:var(--ink);">Manage School Plan →</a>
      </p>
    `;
  } else if (tier === 'premium') {
    block.innerHTML = `
      <p><strong>You're on Teacher Premium.</strong></p>
      <p style="margin-top:0.5rem; color:var(--muted);">Unlimited uploads · Full analytics · All features included.</p>
      <p style="margin-top:0.75rem; font-size:0.8rem; color:var(--muted);">Billing management is coming in a future update.</p>
    `;
  } else {
    block.innerHTML = `<p>Loading subscription details…</p>`;
  }
}

function getStripeStatusHtml(status) {
  if (!status || status === 'active') return '';
  const statusLabels = {
    past_due: 'Past Due',
    canceled: 'Canceled',
    incomplete: 'Incomplete',
    unpaid: 'Unpaid',
    paused: 'Paused',
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

    noticeEl.textContent = 'Profile saved.';
    noticeEl.className   = 'notice notice--success';
    noticeEl.classList.remove('hidden');
    setTimeout(() => noticeEl.classList.add('hidden'), 3000);
  } catch (err) {
    noticeEl.textContent = 'Could not save: ' + err.message;
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
  btn.textContent = 'Deleting…';

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
    noticeEl.textContent = err.message;
    noticeEl.className   = 'notice notice--error';
    noticeEl.classList.remove('hidden');
    btn.disabled    = false;
    btn.textContent = 'Permanently Delete';
  }
}

// ─── Util ─────────────────────────────────────────────────────────────────

function capitalize(str) {
  if (!str) return '';
  return str.charAt(0).toUpperCase() + str.slice(1);
}
