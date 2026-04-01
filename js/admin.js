// ─── Platform Admin Dashboard ─────────────────────────────────────
// Requires role = 'platform_admin' on the profiles row.
// All data operations go through /api/admin (service role key server-side).

const ADMIN_API = '/api/admin';

let adminJwt      = null;   // Bearer token from current session
let allTeachers   = [];     // cached for client-side filtering

// ─── Init ─────────────────────────────────────────────────────────

async function initAdmin(user) {
  // Get the session JWT to pass to the admin API
  const session = await getSession();
  if (!session) { window.location.href = '/login.html'; return; }
  adminJwt = session.access_token;

  // Verify this user is a platform admin before loading any data.
  // The API will also enforce this, but we check here for a clean redirect.
  const { data: profile } = await supabaseClient
    .from('profiles')
    .select('role')
    .eq('id', user.id)
    .maybeSingle();

  if (!profile || profile.role !== 'platform_admin') {
    document.body.innerHTML = `
      <div style="display:flex; align-items:center; justify-content:center; min-height:100vh; padding:2rem; text-align:center;">
        <div>
          <p class="label" style="margin-bottom:1rem; color:var(--accent);">Access denied</p>
          <p style="color:var(--muted); margin-bottom:1.5rem;">This page is only accessible to platform administrators.</p>
          <a href="/dashboard.html" class="btn btn--ghost">Go to Dashboard</a>
        </div>
      </div>`;
    return;
  }

  await Promise.all([loadOverview(), loadDivisions(), loadSchools(), loadTeachers()]);
}

// ─── API helper ───────────────────────────────────────────────────

async function adminApi(action, method = 'GET', body = null) {
  const opts = {
    method,
    headers: {
      'Authorization': `Bearer ${adminJwt}`,
      'Content-Type':  'application/json',
    },
  };
  if (body) opts.body = JSON.stringify(body);

  const res  = await fetch(`${ADMIN_API}?action=${action}`, opts);
  const data = await res.json();
  if (!res.ok) throw new Error(data.error || `API error ${res.status}`);
  return data;
}

// ─── Overview stats ───────────────────────────────────────────────

async function loadOverview() {
  try {
    const overview = await adminApi('overview');
    document.getElementById('stat-divisions').textContent = overview.divisionCount;
    document.getElementById('stat-schools').textContent   = overview.schoolCount;
    document.getElementById('stat-teachers').textContent  = overview.teacherCount;

    // Badge anomaly tab if there are flagged accounts
    if (overview.anomalies?.length > 0) {
      document.getElementById('anomaly-tab').textContent =
        `Anomalies (${overview.anomalies.length})`;
      renderAnomalies(overview.anomalies);
    } else {
      document.getElementById('anomalies-container').innerHTML =
        `<div class="empty-state"><p class="label">No anomalies flagged</p></div>`;
    }
  } catch (err) {
    console.error('overview failed:', err);
  }
}

// ─── Divisions ────────────────────────────────────────────────────

async function loadDivisions() {
  const container = document.getElementById('divisions-container');
  try {
    const divisions = await adminApi('divisions');

    if (!divisions.length) {
      container.innerHTML = `<div class="empty-state"><p class="label">No divisions yet</p></div>`;
      return;
    }

    const rows = divisions.map(d => {
      const expiry = d.expires_at
        ? new Date(d.expires_at).toLocaleDateString('en-CA', { year:'numeric', month:'short', day:'numeric' })
        : '—';
      return `
        <tr data-id="${d.id}" data-type="division">
          <td><strong>${escapeHtml(d.name)}</strong></td>
          <td>${d.enrolment_band ? capitalize(d.enrolment_band) : '—'}</td>
          <td>
            <select class="tier-select" onchange="setTier('division','${d.id}',this.value)">
              ${tierOptions(d.tier)}
            </select>
          </td>
          <td>${expiry}</td>
          <td>
            <input class="notes-input" type="text" value="${escapeHtml(d.notes || '')}"
              placeholder="Add notes…"
              onblur="setNotes('division','${d.id}',this.value)"
              onkeydown="if(event.key==='Enter')this.blur()">
          </td>
          <td><span class="label" style="font-family:monospace; text-transform:none; letter-spacing:0; font-size:0.7rem;">${d.id.slice(0,8)}…</span></td>
        </tr>`;
    }).join('');

    container.innerHTML = `
      <table class="admin-table">
        <thead>
          <tr>
            <th>Name</th>
            <th>Size</th>
            <th>Tier</th>
            <th>Expires</th>
            <th>Notes / Flags</th>
            <th>ID</th>
          </tr>
        </thead>
        <tbody>${rows}</tbody>
      </table>`;
  } catch (err) {
    container.innerHTML = `<p class="label text-accent">Could not load divisions: ${escapeHtml(err.message)}</p>`;
  }
}

async function createDivision() {
  const name = document.getElementById('new-div-name').value.trim();
  const band = document.getElementById('new-div-band').value;
  const tier = document.getElementById('new-div-tier').value;
  if (!name) { alert('Division name is required.'); return; }

  try {
    await adminApi('create-division', 'POST', { name, enrolmentBand: band || null, tier });
    document.getElementById('new-div-name').value = '';
    document.getElementById('new-div-band').value = '';
    document.getElementById('new-div-tier').value = 'free';
    toggleCreateForm('division-form');
    await Promise.all([loadDivisions(), loadOverview()]);
  } catch (err) {
    alert('Could not create division: ' + err.message);
  }
}

// ─── Schools ──────────────────────────────────────────────────────

async function loadSchools() {
  const container = document.getElementById('schools-container');
  try {
    const schools = await adminApi('schools');

    if (!schools.length) {
      container.innerHTML = `<div class="empty-state"><p class="label">No schools yet</p></div>`;
      return;
    }

    const rows = schools.map(s => {
      const divName = s.divisions?.name || '—';
      return `
        <tr data-id="${s.id}" data-type="school">
          <td><strong>${escapeHtml(s.name)}</strong></td>
          <td style="color:var(--muted); font-size:0.8rem;">${escapeHtml(divName)}</td>
          <td>
            <select class="tier-select" onchange="setTier('school','${s.id}',this.value)">
              ${tierOptions(s.tier)}
            </select>
          </td>
          <td>
            <input class="notes-input" type="text" value="${escapeHtml(s.notes || '')}"
              placeholder="Add notes…"
              onblur="setNotes('school','${s.id}',this.value)"
              onkeydown="if(event.key==='Enter')this.blur()">
          </td>
          <td><span class="label" style="font-family:monospace; text-transform:none; letter-spacing:0; font-size:0.7rem;">${s.id.slice(0,8)}…</span></td>
        </tr>`;
    }).join('');

    container.innerHTML = `
      <table class="admin-table">
        <thead>
          <tr>
            <th>Name</th>
            <th>Division</th>
            <th>Tier</th>
            <th>Notes / Flags</th>
            <th>ID</th>
          </tr>
        </thead>
        <tbody>${rows}</tbody>
      </table>`;
  } catch (err) {
    container.innerHTML = `<p class="label text-accent">Could not load schools: ${escapeHtml(err.message)}</p>`;
  }
}

async function createSchool() {
  const name      = document.getElementById('new-school-name').value.trim();
  const divisionId = document.getElementById('new-school-div').value.trim() || null;
  const tier      = document.getElementById('new-school-tier').value;
  if (!name) { alert('School name is required.'); return; }

  try {
    await adminApi('create-school', 'POST', { name, divisionId, tier });
    document.getElementById('new-school-name').value = '';
    document.getElementById('new-school-div').value  = '';
    document.getElementById('new-school-tier').value = 'free';
    toggleCreateForm('school-form');
    await Promise.all([loadSchools(), loadOverview()]);
  } catch (err) {
    alert('Could not create school: ' + err.message);
  }
}

// ─── Teachers ─────────────────────────────────────────────────────

async function loadTeachers() {
  const container = document.getElementById('teachers-container');
  try {
    allTeachers = await adminApi('teachers');
    renderTeachers(allTeachers);
  } catch (err) {
    container.innerHTML = `<p class="label text-accent">Could not load teachers: ${escapeHtml(err.message)}</p>`;
  }
}

function filterTeachers(query) {
  const q = query.toLowerCase();
  const filtered = allTeachers.filter(t =>
    (t.email || '').toLowerCase().includes(q) ||
    (t.division_name || '').toLowerCase().includes(q) ||
    (t.school_name || '').toLowerCase().includes(q)
  );
  renderTeachers(filtered);
}

function renderTeachers(teachers) {
  const container = document.getElementById('teachers-container');

  if (!teachers.length) {
    container.innerHTML = `<div class="empty-state"><p class="label">No teachers found</p></div>`;
    return;
  }

  const rows = teachers.map(t => {
    const org = t.school_name
      ? escapeHtml(t.school_name) + (t.division_name_org ? ` <span style="color:var(--muted);">/ ${escapeHtml(t.division_name_org)}</span>` : '')
      : (t.division_name_org ? escapeHtml(t.division_name_org) : '<span style="color:var(--muted);">—</span>');

    const effectiveTier = t.tier_override || t.tier || 'free';

    return `
      <tr>
        <td style="font-size:0.85rem;">${escapeHtml(t.email || '—')}</td>
        <td style="font-size:0.82rem;">${org}</td>
        <td>
          <select class="tier-select" onchange="setTier('teacher','${t.id}',this.value)">
            ${tierOptions(effectiveTier)}
          </select>
        </td>
        <td>
          <select class="tier-select" onchange="setRole('${t.id}',this.value)">
            ${roleOptions(t.role || 'teacher')}
          </select>
        </td>
        <td>
          <span class="label" style="text-transform:none; letter-spacing:0;">
            ${t.country_code || '?'}
          </span>
        </td>
        <td>
          <input class="notes-input" type="text" value="${escapeHtml(t.notes || '')}"
            placeholder="Add notes…"
            onblur="setNotes('teacher','${t.id}',this.value)"
            onkeydown="if(event.key==='Enter')this.blur()">
        </td>
      </tr>`;
  }).join('');

  container.innerHTML = `
    <table class="admin-table">
      <thead>
        <tr>
          <th>Email</th>
          <th>School / Division</th>
          <th>Tier Override</th>
          <th>Role</th>
          <th>Country</th>
          <th>Notes / Flags</th>
        </tr>
      </thead>
      <tbody>${rows}</tbody>
    </table>`;
}

// ─── Anomalies ────────────────────────────────────────────────────

function renderAnomalies(anomalies) {
  const container = document.getElementById('anomalies-container');

  const rows = anomalies.map(a => `
    <tr>
      <td>${escapeHtml(a.id)}</td>
      <td><span class="anomaly-flag">${escapeHtml(a.country_code || '?')}</span></td>
      <td style="color:var(--muted); font-size:0.85rem;">${escapeHtml(a.division_name || '—')}</td>
    </tr>`).join('');

  container.innerHTML = `
    <p style="font-size:0.85rem; color:var(--muted); margin-bottom:1rem;">
      These accounts have a non-Canadian country code detected on sign-up.
      Review and add a note, or ignore if legitimate.
    </p>
    <table class="admin-table">
      <thead>
        <tr>
          <th>User ID</th>
          <th>Country</th>
          <th>Division (self-reported)</th>
        </tr>
      </thead>
      <tbody>${rows}</tbody>
    </table>`;
}

// ─── Tier & Notes updates ─────────────────────────────────────────

async function setTier(entityType, entityId, tier) {
  try {
    await adminApi('set-tier', 'POST', { entityType, entityId, tier });
  } catch (err) {
    alert('Could not update tier: ' + err.message);
    // Reload to restore the previous value
    if (entityType === 'division') loadDivisions();
    else if (entityType === 'school') loadSchools();
    else loadTeachers();
  }
}

async function setRole(userId, role) {
  try {
    await adminApi('set-role', 'POST', { userId, role });
  } catch (err) {
    alert('Could not update role: ' + err.message);
    loadTeachers(); // restore previous value
  }
}

async function setNotes(entityType, entityId, notes) {
  try {
    await adminApi('set-notes', 'POST', { entityType, entityId, notes });
  } catch (err) {
    console.error('Could not save notes:', err.message);
  }
}

// ─── Tab switching ────────────────────────────────────────────────

function switchTab(name, btn) {
  document.querySelectorAll('.admin-panel').forEach(p => p.classList.remove('admin-panel--active'));
  document.querySelectorAll('.admin-tab').forEach(b => b.classList.remove('admin-tab--active'));
  document.getElementById(`panel-${name}`).classList.add('admin-panel--active');
  btn.classList.add('admin-tab--active');
}

// ─── Create form toggle ───────────────────────────────────────────

function toggleCreateForm(id) {
  document.getElementById(id).classList.toggle('hidden');
}

// ─── Util ─────────────────────────────────────────────────────────

function tierOptions(current) {
  return ['free','premium','school','division'].map(t =>
    `<option value="${t}" ${t === current ? 'selected' : ''}>${capitalize(t)}</option>`
  ).join('');
}

function roleOptions(current) {
  const roles = [
    ['teacher',        'Teacher'],
    ['school_admin',   'School Admin'],
    ['division_admin', 'Division Admin'],
    ['platform_admin', 'Platform Admin'],
  ];
  return roles.map(([val, label]) =>
    `<option value="${val}" ${val === current ? 'selected' : ''}>${label}</option>`
  ).join('');
}

function capitalize(str) {
  return str ? str.charAt(0).toUpperCase() + str.slice(1) : '';
}

function escapeHtml(str) {
  if (!str) return '';
  return String(str)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#39;');
}
