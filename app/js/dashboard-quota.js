// ─── Stripe upgrade ──────────────────────────────────────────────

async function startUpgrade() {
  const btn = document.getElementById('btn-upgrade');
  if (btn) btn.textContent = 'Redirecting…';
  const session = await getSession();
  if (!session) { window.location = '/login.html'; return; }

  const res = await fetch('/api/stripe-checkout', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${session.access_token}` }
  });
  const { url, error } = await res.json();
  if (error) { alert('Could not start checkout: ' + error); if (btn) btn.textContent = 'Upgrade to Premium →'; return; }
  window.location = url;
}

// Check for successful return from Stripe
if (new URLSearchParams(window.location.search).get('upgraded') === '1') {
  history.replaceState(null, '', window.location.pathname);
  const banner = document.createElement('div');
  banner.style.cssText = 'position:fixed;top:0;left:0;right:0;background:var(--ink);color:var(--paper);text-align:center;padding:0.6rem;font-size:0.85rem;z-index:999;';
  banner.textContent = 'Welcome to Teacher Premium! Higher quality audio and unlimited uploads are now active.';
  document.body.prepend(banner);
  setTimeout(() => banner.remove(), 6000);
}

// ─── Quota ───────────────────────────────────────────────────────

async function loadQuota() {
  const session = await getSession();
  if (!session) return;
  const userId = session.user.id;

  // Resolve tier via the cascade function (division → school → teacher → free)
  currentTier = await getEffectiveTier(userId);

  // Fetch profile for role and org affiliation
  const { data: profile } = await supabaseClient
    .from('profiles')
    .select('role, school_id, division_id, tier, tier_override, expires_at, exit_word_mode')
    .eq('id', userId)
    .maybeSingle();

  // Pre-select the exit word mode dropdown to the saved preference
  if (profile?.exit_word_mode) {
    const modeEl = document.getElementById('exit-word-mode');
    if (modeEl) modeEl.value = profile.exit_word_mode;
  }

  currentRole = profile?.role || 'teacher';

  // Show role-appropriate nav links
  if (currentRole === 'platform_admin') {
    document.getElementById('admin-nav-link')?.classList.remove('hidden');
  } else if (currentRole === 'school_admin') {
    document.getElementById('school-admin-nav-link')?.classList.remove('hidden');
  } else if (currentRole === 'division_admin') {
    document.getElementById('div-admin-nav-link')?.classList.remove('hidden');
  }

  // Tier badge
  const badgeEl = document.getElementById('tier-badge');
  if (badgeEl) {
    const badgeLabels = { free: 'Free', premium: 'Teacher Premium', school: 'School Plan', division: 'Division Plan' };
    badgeEl.textContent  = badgeLabels[currentTier] || currentTier;
    badgeEl.classList.remove('hidden', 'tier-badge--paid');
    if (currentTier !== 'free') badgeEl.classList.add('tier-badge--paid');
  }

  // Show/hide premium advanced options section
  const advancedSection = document.getElementById('advanced-options');
  if (advancedSection) {
    advancedSection.classList.toggle('hidden', currentTier === 'free');
  }

  // Upgrade CTA / trial status
  const ctaEl = document.getElementById('upgrade-cta');
  const trialBanner = document.getElementById('trial-banner');
  const trialBannerText = document.getElementById('trial-banner-text');
  const trialBannerBtn = document.getElementById('trial-banner-btn');

  if (ctaEl) {
    const expiresAt = profile?.expires_at ? new Date(profile.expires_at) : null;
    const isTrial   = expiresAt && profile?.tier === 'premium' && !profile?.tier_override && !profile?.school_id && !profile?.division_id;
    const trialExpired = isTrial && expiresAt < new Date();
    const daysSinceExpiry = trialExpired ? Math.floor((Date.now() - expiresAt) / (1000 * 60 * 60 * 24)) : null;
    const daysLeft = expiresAt ? Math.ceil((expiresAt - Date.now()) / (1000 * 60 * 60 * 24)) : null;

    // ——— Visible trial banner ———
    if (isTrial && daysLeft !== null && daysLeft > 0) {
      trialBanner?.classList.remove('hidden');
      if (daysLeft <= 7) {
        trialBanner.style.background = 'var(--light-accent)';
        trialBanner.style.borderColor = 'var(--accent)';
        trialBannerText.innerHTML = `<strong style="color:var(--accent);">Trial ends in ${daysLeft} day${daysLeft === 1 ? '' : 's'}</strong> — Upgrade to keep unlimited uploads and higher quality audio.`;
      } else {
        trialBanner.style.background = '#f0f8f0';
        trialBanner.style.borderColor = '#4a7c59';
        trialBannerText.innerHTML = `<strong style="color:#4a7c59;">Trial ends in ${daysLeft} day${daysLeft === 1 ? '' : 's'}</strong> — Upgrade to keep unlimited uploads and higher quality audio.`;
      }
      trialBannerBtn.textContent = 'Upgrade Now';
      trialBannerBtn.onclick = startUpgrade;
    } else if (trialExpired && daysSinceExpiry !== null && daysSinceExpiry <= 15) {
      trialBanner?.classList.remove('hidden');
      trialBanner.style.background = 'var(--light-accent)';
      trialBanner.style.borderColor = 'var(--accent)';
      trialBannerText.innerHTML = `<strong style="color:var(--accent);">Your trial has expired</strong> — You're back on the Free plan.`;
      trialBannerBtn.textContent = 'Request Extension';
      trialBannerBtn.onclick = () => openRequestModal('premium_trial');
    } else {
      trialBanner?.classList.add('hidden');
    }

    if (currentTier === 'free') {
      if (trialExpired && daysSinceExpiry !== null && daysSinceExpiry <= 15) {
        ctaEl.innerHTML = `
          <span>Your 30-day premium trial has expired.</span>
          <button id="btn-request-premium" style="margin-left:1rem; padding:0.3rem 0.9rem; border:1px solid var(--ink); background:var(--paper); color:var(--ink); font-family:inherit; font-size:0.8rem; letter-spacing:0.08em; text-transform:uppercase; cursor:pointer;">Request Premium Access</button>
        `;
        ctaEl.classList.remove('hidden');
        document.getElementById('btn-request-premium')?.addEventListener('click', () => openRequestModal('premium_trial'));
      } else {
        ctaEl.innerHTML = `
          <span>You're on the Free plan — 3 uploads/month, 50 MB storage, 32kbps audio.</span>
          <button id="btn-upgrade" style="margin-left:1rem; padding:0.3rem 0.9rem; border:1px solid var(--ink); background:var(--ink); color:var(--paper); font-family:inherit; font-size:0.8rem; letter-spacing:0.08em; text-transform:uppercase; cursor:pointer;">Upgrade to Premium →</button>
        `;
        ctaEl.classList.remove('hidden');
        document.getElementById('btn-upgrade')?.addEventListener('click', startUpgrade);
      }
    } else if (isTrial && daysLeft !== null && daysLeft <= 7 && daysLeft > 0) {
      ctaEl.innerHTML = `
        <span>Premium trial expires in ${daysLeft} day${daysLeft === 1 ? '' : 's'}.</span>
        <button id="btn-extend-trial" style="margin-left:1rem; padding:0.3rem 0.9rem; border:1px solid var(--ink); background:var(--paper); color:var(--ink); font-family:inherit; font-size:0.8rem; letter-spacing:0.08em; text-transform:uppercase; cursor:pointer;">Request Extension</button>
      `;
      ctaEl.classList.remove('hidden');
      document.getElementById('btn-extend-trial')?.addEventListener('click', () => openRequestModal('premium_trial'));
    } else if (profile?.school_id) {
      ctaEl.innerHTML = `Your school is on a plan. <a href="/settings.html" style="color:var(--ink);">View subscription details</a>`;
      ctaEl.classList.remove('hidden');
    } else if (profile?.division_id) {
      ctaEl.innerHTML = `Your division is on a plan. <a href="/settings.html" style="color:var(--ink);">View subscription details</a>`;
      ctaEl.classList.remove('hidden');
    } else {
      ctaEl.classList.add('hidden');
    }
  }

  const el = document.getElementById('quota-indicator');
  if (!el) return;

  if (currentTier !== 'free') {
    el.classList.add('hidden');
    return;
  }

  const now        = new Date();
  const monthStart = new Date(now.getFullYear(), now.getMonth(), 1).toISOString();
  const { count }  = await supabaseClient
    .from('uploads')
    .select('id', { count: 'exact', head: true })
    .eq('teacher_id', userId)
    .gte('created_at', monthStart);

  const used     = count || 0;
  const limit    = 3;
  const reset    = new Date(now.getFullYear(), now.getMonth() + 1, 1);
  const resetFmt = reset.toLocaleDateString('en-CA', { month: 'long', day: 'numeric' });

  el.classList.remove('hidden', 'quota-bar--full');

  if (used >= limit) {
    el.classList.add('quota-bar--full');
    el.innerHTML = `You've used all ${limit} uploads for this month. Quota resets on ${resetFmt}.`;
    document.getElementById('btn-upload').disabled = true;
  } else {
    el.textContent = `${used} of ${limit} uploads used this month · Resets ${resetFmt}`;
  }
}

async function recalculateStorage(userId) {
  const { data } = await supabaseClient
    .from('uploads')
    .select('storage_path, file_size_mb')
    .eq('teacher_id', userId);

  // De-duplicate by storage_path so duplicated uploads don't double-count
  const seen  = new Set();
  const total = (data || []).reduce((sum, row) => {
    if (seen.has(row.storage_path)) return sum;
    seen.add(row.storage_path);
    return sum + (row.file_size_mb || 0);
  }, 0);

  await supabaseClient
    .from('profiles')
    .update({ storage_used_mb: total })
    .eq('id', userId);
}

// ─── First Login ─────────────────────────────────────────────────

/** Map of lowercase division name → { id, name } for matching */
let _divisionsMap = null;

async function checkFirstLogin() {
  const session = await getSession();
  if (!session) return;

  const { data: profile } = await supabaseClient
    .from('profiles')
    .select('division_name')
    .eq('id', session.user.id)
    .maybeSingle();

  if (!profile || !profile.division_name) {
    document.getElementById('first-login-modal').classList.remove('hidden');
    await loadDivisions();
    setupAutocomplete();
  }
}

async function loadDivisions() {
  if (_divisionsMap) return;
  try {
    const { data: divisions } = await supabaseClient
      .from('divisions')
      .select('id, name')
      .order('name');
    if (divisions) {
      _divisionsMap = new Map();
      for (const d of divisions) {
        _divisionsMap.set(d.name.toLowerCase(), d);
      }
    }
  } catch {
    _divisionsMap = new Map(); // empty map = no suggestions
  }
}

function setupAutocomplete() {
  const input = document.getElementById('division-name-input');
  const dropdown = document.getElementById('division-autocomplete-dropdown');
  const hiddenId = document.getElementById('division-id-input');
  const fallbackNote = document.getElementById('division-fallback-note');
  let highlightedIdx = -1;
  let lastResults = [];

  function closeDropdown() {
    dropdown.classList.remove('open');
    dropdown.innerHTML = '';
    highlightedIdx = -1;
    lastResults = [];
  }

  function selectDivision(divId, divName) {
    hiddenId.value = divId;
    input.value = divName;
    input.classList.add('autocomplete-selected');
    fallbackNote.classList.add('hidden');
    closeDropdown();
  }

  function renderDropdown(filter) {
    if (!_divisionsMap) return;
    const q = filter.toLowerCase().trim();
    const results = [];
    for (const [key, d] of _divisionsMap) {
      if (!q || key.includes(q)) {
        results.push(d);
      }
    }
    lastResults = results;
    highlightedIdx = -1;

    if (!q) {
      results.length = Math.min(results.length, 50);
    }

    if (results.length === 0) {
      dropdown.innerHTML =
        '<div class="ac-no-match">No matching divisions found \u2014 you can still type your division name below.</div>';
      dropdown.classList.add('open');
      fallbackNote.classList.remove('hidden');
      return;
    }

    dropdown.innerHTML = results
      .map(
        (d, i) =>
          `<div class="ac-option" data-index="${i}" data-id="${escapeHtml(d.id)}">${escapeHtml(d.name)}</div>`
      )
      .join('');
    dropdown.classList.add('open');
    fallbackNote.classList.add('hidden');
  }

  // Debounced input handler
  let debounceTimer;
  input.addEventListener('input', function () {
    clearTimeout(debounceTimer);
    hiddenId.value = '';
    input.classList.remove('autocomplete-selected');
    debounceTimer = setTimeout(() => renderDropdown(this.value), 80);
  });

  input.addEventListener('focus', function () {
    if (!dropdown.classList.contains('open')) {
      renderDropdown(this.value);
    }
  });

  // Keyboard navigation
  input.addEventListener('keydown', function (e) {
    const options = dropdown.querySelectorAll('.ac-option');
    if (!options.length) return;

    if (e.key === 'ArrowDown') {
      e.preventDefault();
      highlightedIdx = Math.min(highlightedIdx + 1, options.length - 1);
    } else if (e.key === 'ArrowUp') {
      e.preventDefault();
      highlightedIdx = Math.max(highlightedIdx - 1, 0);
    } else if (e.key === 'Enter' && highlightedIdx >= 0) {
      e.preventDefault();
      const selected = options[highlightedIdx];
      if (selected) {
        selectDivision(selected.dataset.id, selected.textContent);
      }
      return;
    } else if (e.key === 'Escape') {
      closeDropdown();
      return;
    } else {
      return;
    }

    options.forEach((el, i) => el.classList.toggle('highlighted', i === highlightedIdx));
    if (options[highlightedIdx]) {
      options[highlightedIdx].scrollIntoView({ block: 'nearest' });
    }
  });

  dropdown.addEventListener('click', function (e) {
    const option = e.target.closest('.ac-option');
    if (option && option.dataset.id) {
      selectDivision(option.dataset.id, option.textContent);
    }
  });

  document.addEventListener('click', function (e) {
    if (!e.target.closest('.autocomplete-wrap')) {
      closeDropdown();
    }
  });
}

async function submitDivisionSetup() {
  if (document.getElementById('division-honeypot').value) {
    document.getElementById('first-login-modal').classList.add('hidden');
    return;
  }

  const divisionName = document.getElementById('division-name-input').value.trim();
  if (!divisionName) {
    document.getElementById('division-name-input').focus();
    return;
  }

  const session = await getSession();
  if (!session) return;

  const divisionId = document.getElementById('division-id-input').value;

  const updatePayload = {
    division_name: divisionName,
    tos_accepted_at: new Date().toISOString()
  };
  if (divisionId) {
    updatePayload.division_id = divisionId;
  }

  await supabaseClient
    .from('profiles')
    .update(updatePayload)
    .eq('id', session.user.id);

  document.getElementById('first-login-modal').classList.add('hidden');
}

// ─── In-App Request Flow ─────────────────────────────────────────

function openRequestModal(defaultType) {
  const modal = document.getElementById('request-modal');
  const select = document.getElementById('request-type-select');
  if (select && defaultType) select.value = defaultType;
  updateRequestModalTitle();
  document.getElementById('request-message').value = '';
  modal.classList.remove('hidden');
}

function updateRequestModalTitle() {
  const type = document.getElementById('request-type-select')?.value;
  const titles = {
    premium_trial: 'Request Premium Access',
    school_plan:   'Request School Plan',
    division_plan: 'Request Division Plan',
  };
  document.getElementById('request-modal-title').textContent = titles[type] || 'Request Access';
}

async function submitRequest() {
  const type    = document.getElementById('request-type-select').value;
  const message = document.getElementById('request-message').value.trim();

  try {
    const session = await getSession();
    if (!session) { window.location.href = '/login.html'; return; }

    const user = session.user;

    const res = await fetch('/api/request-access', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        name:      user.user_metadata?.full_name || user.email,
        email:     user.email,
        teacherId: user.id,
        requestType: type,
        message:   message,
      }),
    });

    const data = await res.json();
    if (!res.ok) throw new Error(data.error || 'Request failed');

    document.getElementById('request-modal').classList.add('hidden');
    showUploadNotice('Request submitted. You\'ll be notified by email when it\'s reviewed.', 'success');
  } catch (err) {
    showUploadNotice(err.message, 'error');
  }
}
