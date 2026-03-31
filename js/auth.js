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
      redirectTo: 'https://app.audioproctor.com/dashboard.html',
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
async function ensureProfile(userId) {
  const { data } = await supabaseClient
    .from('profiles')
    .select('id')
    .eq('id', userId)
    .maybeSingle();
  if (!data) {
    const lang        = (navigator.languages?.[0] || navigator.language || '');
    const countryCode = lang.includes('-') ? lang.split('-').pop().toUpperCase() : null;
    await supabaseClient.from('profiles').insert({ id: userId, country_code: countryCode });
  }
}

// Returns the teacher's effective tier, resolving division → school → teacher → free.
// Calls the get_effective_tier() Postgres function via RPC so the cascade is
// computed server-side and always reflects the latest org structure.
async function getEffectiveTier(userId) {
  const { data, error } = await supabaseClient.rpc('get_effective_tier', { p_user_id: userId });
  if (error) {
    console.warn('get_effective_tier RPC failed, defaulting to free:', error.message);
    return 'free';
  }
  return data || 'free';
}

// Call at the top of any protected page.
// Returns the current user, or redirects to login.html if not signed in.
async function requireAuth() {
  const session = await getSession();
  if (!session) {
    window.location.href = '/login.html';
    return null;
  }
  await ensureProfile(session.user.id);
  return session.user;
}
