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

  // Org affiliation
  let orgText = 'No school or division assigned';
  if (profile?.school_id || profile?.division_id) {
    const parts = [];
    if (profile.school_id) {
      const { data: school } = await supabaseClient
        .from('schools').select('name').eq('id', profile.school_id).maybeSingle();
      if (school) parts.push(school.name);
    }
    if (profile.division_id) {
      const { data: division } = await supabaseClient
        .from('divisions').select('name').eq('id', profile.division_id).maybeSingle();
      if (division) parts.push(division.name);
    }
    if (parts.length) orgText = parts.join(' · ');
  }
  document.getElementById('profile-org').textContent = orgText;

  // Subscription block
  const tier = await getEffectiveTier(user.id);
  renderSubscription(tier, profile);
}

function renderSubscription(tier, profile) {
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
    block.innerHTML = `
      <p><strong>Your division is on a Division Plan.</strong></p>
      <p style="margin-top:0.5rem; color:var(--muted);">Unlimited uploads · Full analytics · All features included.</p>
    `;
  } else if (profile?.school_id) {
    // Check if school is on division plan or school plan
    const label = tier === 'division' ? 'Division Plan (via your school)' : 'School Plan';
    block.innerHTML = `
      <p><strong>Your school is on a ${label}.</strong></p>
      <p style="margin-top:0.5rem; color:var(--muted);">Unlimited uploads · Full analytics · All features included.</p>
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
