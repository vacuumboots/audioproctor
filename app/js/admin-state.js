// ─── Platform Admin Dashboard ─────────────────────────────────────
// Requires role = 'platform_admin' on the profiles row.
// All data operations go through /api/admin (service role key server-side).

const ADMIN_API = '/api/admin';

let adminJwt      = null;   // Bearer token from current session
let allTeachers   = [];     // cached for client-side filtering
let allSchoolsList    = []; // cached for reassignment modal
let allDivisionsList  = []; // cached for reassignment modal

// ─── Init ─────────────────────────────────────────────────────────

async function initAdmin(user) {
  // Get the session JWT to pass to the admin API
  const session = await getSession();
  if (!session) { window.location.href = '/login.html'; return; }
  adminJwt = session.access_token;

  // Verify this user is a platform admin before loading any data.
  const { data: profile } = await supabaseClient
    .from('profiles')
    .select('role')
    .eq('id', user.id)
    .maybeSingle();

  if (!profile || profile.role !== 'platform_admin') {
    document.body.innerHTML = `
      <div style="display:flex; align-items:center; justify-content:center; min-height:100vh; padding:2rem; text-align:center;">
        <div>
          <p class="label" style="margin-bottom:1rem; color:var(--accent);">${t('admin.accessDenied')}</p>
          <p style="color:var(--muted); margin-bottom:1.5rem;">${t('admin.accessDeniedPlatform')}</p>
          <a href="/dashboard.html" class="btn btn--ghost">${t('admin.goToDashboard')}</a>
        </div>
      </div>`;
    return;
  }

  await Promise.all([loadOverview(), loadDivisions(), loadSchools(), loadTeachers(), loadRequests(), loadInvitations(), loadAnalytics()]);
  loadDemoPanel();
}

// ─── API helper ───────────────────────────────────────────────────

async function adminApi(action, method = 'GET', body = null, extraParams = '') {
  const opts = {
    method,
    headers: {
      'Authorization': `Bearer ${adminJwt}`,
      'Content-Type':  'application/json',
    },
  };
  if (body) opts.body = JSON.stringify(body);

  const res  = await fetch(`${ADMIN_API}?action=${action}${extraParams}`, opts);
  const data = await res.json();
  if (!res.ok) throw new Error(data.error || `API error ${res.status}`);
  return data;
}
