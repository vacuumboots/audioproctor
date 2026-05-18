// ─── Auth Helpers ────────────────────────────────────────────────
// Used by index.html and dashboard.html.
// Depends on supabaseClient from supabase-client.js.

async function signInWithGoogle() {
  const btn = document.getElementById('btn-signin');
  if (btn) {
    btn.disabled = true;
    btn.textContent = 'Redirecting…';
  }

  const { error } = await supabaseClient.auth.signInWithOAuth({
    provider: 'google',
    options: {
      redirectTo: window.location.origin + '/login.html',
    },
  });

  if (error) {
    if (btn) {
      btn.disabled = false;
      btn.textContent = 'Sign in with Google';
    }
    const notice = document.getElementById('notice');
    if (notice) {
      notice.textContent = 'Could not start sign-in. Please try again.';
      notice.classList.remove('hidden');
    }
  }
}

async function signOut() {
  await supabaseClient.auth.signOut();
  window.location.href = '/login.html';
}

// Alias used in dashboard.html onclick
async function handleSignOut() {
  await signOut();
}

async function getSession() {
  const { data } = await supabaseClient.auth.getSession();
  return data.session;
}

// Ensures a profiles row exists for this teacher.
// Called silently on every authenticated page load.
// First checks /api/check-access to verify email is allowlisted.
async function ensureProfile(userId, accessToken) {
  // Check email allowlist before creating profile
  try {
    const checkRes = await fetch('/api/check-access', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${accessToken}` },
    });
    const { allowed, reason } = await checkRes.json();
    if (!allowed) {
      return { allowed: false, reason };
    }
  } catch (_) {
    // Network error — let through (fail open)
  }

  const { data } = await supabaseClient
    .from('profiles')
    .select('id, lang')
    .eq('id', userId)
    .maybeSingle();
  let profileLang = data?.lang || 'en';
  if (!data) {
    const browserLang  = (navigator.languages?.[0] || navigator.language || '');
    const countryCode  = browserLang.includes('-') ? browserLang.split('-').pop().toUpperCase() : null;
    const detectedLang = browserLang.startsWith('fr') ? 'fr' : 'en';
    const expiresAt    = new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toISOString();
    await supabaseClient.from('profiles').insert({
      id: userId,
      country_code: countryCode,
      lang: detectedLang,
      tier: 'premium',
      expires_at: expiresAt
    });
    profileLang = detectedLang;
  }
  // Activate the correct locale (i18n.js must be loaded first)
  if (window.setLocale) {
    await window.setLocale(profileLang);
  }
  return { allowed: true, lang: profileLang };
}

// Returns the teacher's effective tier, resolving division → school → teacher → free.
// Calls the get_effective_tier() Postgres function via RPC so the cascade is
// computed server-side and always reflects the latest org structure.
async function getEffectiveTier(userId) {
  const { data, error } = await supabaseClient.rpc('get_effective_tier', { p_user_id: userId });
  if (error) {
    console.warn('get_effective_tier RPC failed, defaulting to free:', error.message);
    // SAFETY NET: check raw profile before forcing free
    const { data: profile } = await supabaseClient
      .from('profiles')
      .select('tier, expires_at')
      .eq('id', userId)
      .maybeSingle();
    if (profile?.tier === 'premium' && (!profile.expires_at || new Date(profile.expires_at) > new Date())) {
      return 'premium';
    }
    return 'free';
  }
  return data || 'free';
}

// Call at the top of any protected page.
// Returns the current user, or redirects to login.html if not signed in.
// If email is not allowlisted, shows error and signs out.
async function requireAuth() {
  const session = await getSession();
  if (!session) {
    window.location.href = '/login.html';
    return null;
  }
  const result = await ensureProfile(session.user.id, session.access_token);
  if (result && result.allowed === false) {
    // Email not allowlisted — show error and sign out
    document.body.innerHTML = `<div style="display:flex;align-items:center;justify-content:center;height:100vh;font-family:system-ui,sans-serif;">
      <div style="max-width:420px;text-align:center;padding:2rem;">
        <h1 style="font-size:1.4rem;margin-bottom:1rem;">Access Restricted</h1>
        <p style="color:#666;line-height:1.6;">${result.reason || 'Your email is not authorized for this instance.'}</p>
        <p style="color:#999;font-size:0.85rem;margin-top:1.5rem;">Signed out. Close this page to return to the login screen.</p>
      </div>
    </div>`;
    await supabaseClient.auth.signOut();
    return null;
  }
  return session.user;
}
