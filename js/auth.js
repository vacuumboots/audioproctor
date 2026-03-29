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
  window.location.href = '/index.html';
}

// Alias used in dashboard.html onclick
async function handleSignOut() {
  await signOut();
}

async function getSession() {
  const { data } = await supabaseClient.auth.getSession();
  return data.session;
}

// Call at the top of any protected page.
// Returns the current user, or redirects to index.html if not signed in.
async function requireAuth() {
  const session = await getSession();
  if (!session) {
    window.location.href = '/index.html';
    return null;
  }
  return session.user;
}
