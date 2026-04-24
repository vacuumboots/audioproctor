// ─── School Admin Dashboard ───────────────────────────────────────────────
// Requires role = 'school_admin' on the profiles row.

const ORG_API = '/api/org';

let orgJwt = null;

async function initSchoolAdmin(user) {
  const session = await getSession();
  if (!session) { window.location.href = '/login.html'; return; }
  orgJwt = session.access_token;

  // Verify school_admin role
  const { data: profile } = await supabaseClient
    .from('profiles')
    .select('role, school_id')
    .eq('id', user.id)
    .maybeSingle();

  if (!profile || !['school_admin', 'platform_admin'].includes(profile.role)) {
    document.body.innerHTML = `
      <div style="display:flex; align-items:center; justify-content:center; min-height:100vh; padding:2rem; text-align:center;">
        <div>
          <p class="label" style="margin-bottom:1rem; color:var(--accent);">Access denied</p>
          <p style="color:var(--muted); margin-bottom:1.5rem;">This page requires the School Admin role.</p>
          <a href="/dashboard.html" class="btn btn--ghost">Go to Dashboard</a>
        </div>
      </div>`;
    return;
  }

  // Load school name
  if (profile.school_id) {
    const { data: school } = await supabaseClient
      .from('schools')
      .select('name')
      .eq('id', profile.school_id)
      .maybeSingle();
    if (school) document.getElementById('school-name-title').textContent = school.name;
  }

  await Promise.all([loadSchoolReport(), loadTeachers()]);
}

// ─── API helper ───────────────────────────────────────────────────────────

async function orgApi(action, method = 'GET', body = null, params = '') {
  const opts = {
    method,
    headers: {
      'Authorization': `Bearer ${orgJwt}`,
      'Content-Type':  'application/json',
    },
  };
  if (body) opts.body = JSON.stringify(body);
  const res  = await fetch(`${ORG_API}?action=${action}${params}`, opts);
  const data = await res.json();
  if (!res.ok) throw new Error(data.error || `API error ${res.status}`);
  return data;
}

// ─── Stats ────────────────────────────────────────────────────────────────

async function loadSchoolReport() {
  try {
    const report = await orgApi('school-report');
    document.getElementById('stat-teachers').textContent  = report.teacherCount;
    document.getElementById('stat-uploads').textContent   = report.uploadCount;
    document.getElementById('stat-sessions').textContent  = report.totalSessions;
    const rate = report.completionRate;
    const rateEl = document.getElementById('stat-completion');
    if (rate != null) {
      rateEl.textContent  = rate + '%';
      rateEl.style.color  = rate >= 80 ? '#27ae60' : rate >= 60 ? '#e67e22' : 'var(--accent)';
    } else {
      rateEl.textContent = '—';
    }
  } catch (err) {
    console.error('school-report failed:', err.message);
  }
}

// ─── Teachers ─────────────────────────────────────────────────────────────

async function loadTeachers() {
  const container = document.getElementById('teachers-container');
  try {
    const teachers = await orgApi('school-teachers');

    if (!teachers.length) {
      container.innerHTML = `<div class="empty-state"><p class="label">No teachers attached to this school yet.</p></div>`;
      return;
    }

    const rows = teachers.map(t => {
      const lastActive = t.last_active
        ? new Date(t.last_active).toLocaleDateString('en-CA', { year: 'numeric', month: 'short', day: 'numeric' })
        : '—';
      const roleTag = t.role === 'school_admin'
        ? `<span class="role-badge">Admin</span> `
        : '';

      return `
        <tr>
          <td>${roleTag}<span style="font-size:0.85rem;">${escapeHtml(t.email || '—')}</span></td>
          <td style="text-align:center;">${t.upload_count}</td>
          <td style="text-align:center;">${t.session_count}</td>
          <td style="color:var(--muted); font-size:0.82rem;">${lastActive}</td>
          <td>
            <button class="btn btn--ghost btn--small" onclick="detachTeacher('${t.id}', '${escapeHtml(t.email || t.id)}', this)">Remove</button>
          </td>
        </tr>`;
    }).join('');

    container.innerHTML = `
      <table class="admin-table">
        <thead>
          <tr>
            <th>Email</th>
            <th style="text-align:center;">Uploads</th>
            <th style="text-align:center;">Sessions</th>
            <th>Last Active</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>${rows}</tbody>
      </table>`;
  } catch (err) {
    container.innerHTML = `<p class="label text-accent">Could not load teachers: ${escapeHtml(err.message)}</p>`;
  }
}

async function detachTeacher(userId, email, btn) {
  if (!confirm(`Remove ${email} from this school? Their account and uploads will be preserved — they revert to the free tier.`)) return;
  btn.disabled    = true;
  btn.textContent = 'Removing…';
  try {
    await orgApi('detach-teacher', 'POST', { userId });
    await Promise.all([loadTeachers(), loadSchoolReport()]);
  } catch (err) {
    alert('Could not remove teacher: ' + err.message);
    btn.disabled    = false;
    btn.textContent = 'Remove';
  }
}

// ─── Util ─────────────────────────────────────────────────────────────────

function escapeHtml(str) {
  if (!str) return '';
  return String(str)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#39;');
}
