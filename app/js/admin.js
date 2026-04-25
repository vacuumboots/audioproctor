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

  await Promise.all([loadOverview(), loadDivisions(), loadSchools(), loadTeachers(), loadRequests(), loadInvitations(), loadAnalytics()]);
  loadDemoPanel();
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

// ─── Analytics ────────────────────────────────────────────────────

async function loadAnalytics() {
  try {
    const data = await adminApi('platform-analytics');

    document.getElementById('pa-sessions').textContent    = data.totalSessions;
    document.getElementById('pa-completions').textContent = data.totalCompletions;
    document.getElementById('pa-rate').textContent        = data.completionRate != null ? data.completionRate + '%' : '—';
    document.getElementById('pa-replays').textContent     = data.totalReplays;
    document.getElementById('pa-listen').textContent      = data.avgListenSeconds != null
      ? `${Math.floor(data.avgListenSeconds / 60)}:${String(data.avgListenSeconds % 60).padStart(2, '0')}`
      : '—';

    renderPlatformActivityChart(data.weeklyActivity, document.getElementById('pa-activity-chart'));
    renderPlatformDivisionTable(data.divisions, document.getElementById('pa-divisions-container'));
  } catch (err) {
    console.error('platform-analytics failed:', err);
    document.getElementById('pa-activity-chart').innerHTML = `<p class="label text-accent">Could not load activity data</p>`;
    document.getElementById('pa-divisions-container').innerHTML = `<p class="label text-accent">Could not load division data</p>`;
  }
}

function renderPlatformActivityChart(data, container) {
  if (!data || data.length === 0 || data.every(d => d.sessions === 0)) {
    container.innerHTML = `<p style="font-size:0.85rem; color:var(--muted); padding:0.5rem 0;">No session data yet. Data will appear here once students use access codes.</p>`;
    return;
  }

  const maxSessions = Math.max(...data.map(d => d.sessions), 1);
  const barW     = 38;
  const gap      = 6;
  const chartH   = 80;
  const labelH   = 20;
  const totalW   = data.length * (barW + gap);

  const bars = data.map((d, i) => {
    const barH  = Math.max(Math.round((d.sessions / maxSessions) * chartH), d.sessions > 0 ? 2 : 0);
    const x     = i * (barW + gap);
    const y     = chartH - barH;
    const date  = new Date(d.week + 'T00:00:00Z');
    const label = date.toLocaleDateString('en-CA', { month: 'short', day: 'numeric', timeZone: 'UTC' });
    return `
      <rect x="${x}" y="${y}" width="${barW}" height="${barH}" fill="var(--ink)" opacity="0.75"/>
      <text x="${x + barW / 2}" y="${chartH + 13}" text-anchor="middle" font-size="8" fill="var(--muted)" font-family="'DM Sans',sans-serif">${label}</text>
      ${d.sessions > 0 ? `<text x="${x + barW / 2}" y="${y - 3}" text-anchor="middle" font-size="8" fill="var(--ink)" font-family="'DM Sans',sans-serif">${d.sessions}</text>` : ''}
    `;
  }).join('');

  container.innerHTML = `
    <div class="chart-container">
      <svg width="${totalW}" height="${chartH + labelH}" viewBox="0 0 ${totalW} ${chartH + labelH}" style="display:block;">
        ${bars}
      </svg>
    </div>
    <p style="font-size:0.75rem; color:var(--muted); margin-top:0.5rem;">Sessions per week (last 12 weeks)</p>
  `;
}

function renderPlatformDivisionTable(divisions, container) {
  if (!divisions || !divisions.length) {
    container.innerHTML = `<div class="empty-state"><p class="label">No division data yet</p></div>`;
    return;
  }

  const rows = divisions.map(d => `
    <tr>
      <td><strong>${escapeHtml(d.name)}</strong></td>
      <td style="text-align:center;">${d.uploads}</td>
      <td style="text-align:center;">${d.sessions}</td>
      <td style="text-align:center;">${d.completionRate != null ? d.completionRate + '%' : '—'}</td>
      <td style="text-align:center;">${d.replays}</td>
    </tr>
  `).join('');

  container.innerHTML = `
    <table class="admin-table">
      <thead>
        <tr>
          <th>Division</th>
          <th style="text-align:center;">Uploads</th>
          <th style="text-align:center;">Sessions</th>
          <th style="text-align:center;">Completion</th>
          <th style="text-align:center;">Replays</th>
        </tr>
      </thead>
      <tbody>${rows}</tbody>
    </table>`;
}

// ─── Divisions ────────────────────────────────────────────────────

async function loadDivisions() {
  const container = document.getElementById('divisions-container');
  try {
    const divisions = await adminApi('divisions');
    allDivisionsList = divisions;

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
          <td>
            <button class="btn btn--small" style="border:1px solid var(--accent); background:transparent; color:var(--accent); cursor:pointer; font-family:'DM Sans',sans-serif; font-size:0.75rem; padding:0.3rem 0.75rem;"
              onclick="deleteDivision('${d.id}', '${escapeHtml(d.name)}')">Delete</button>
          </td>
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
            <th>Actions</th>
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
    allSchoolsList = schools;

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
          <td>
            <button class="btn btn--small" style="border:1px solid var(--accent); background:transparent; color:var(--accent); cursor:pointer; font-family:'DM Sans',sans-serif; font-size:0.75rem; padding:0.3rem 0.75rem;"
              onclick="deleteSchool('${s.id}', '${escapeHtml(s.name)}')">Delete</button>
          </td>
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
            <th>Actions</th>
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

    const deactivatedBadge = t.is_deactivated
      ? `<span style="color:var(--accent); font-size:0.75rem; margin-left:0.4rem;">(deactivated)</span>`
      : '';

    const deactivateBtn = t.is_deactivated
      ? `<button class="btn btn--ghost btn--small" onclick="toggleDeactivation('${escapeHtml(t.id)}', false, this)">Reactivate</button>`
      : `<button class="btn btn--small" style="border:1px solid var(--warm-mid); background:transparent; color:var(--muted); cursor:pointer; font-family:'DM Sans',sans-serif; font-size:0.75rem; padding:0.3rem 0.75rem;" onclick="toggleDeactivation('${escapeHtml(t.id)}', true, this)">Deactivate</button>`;

    return `
      <tr style="${t.is_deactivated ? 'opacity:0.55;' : ''}">
        <td style="font-size:0.85rem;">${escapeHtml(t.email || '—')}${deactivatedBadge}</td>
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
        <td>
          ${deactivateBtn}
          <button class="btn btn--ghost btn--small" onclick="openReassignModal('${t.id}', '${escapeHtml(t.email || '')}', '${t.school_id || ''}', '${t.division_id || ''}')">Reassign</button>
          <button class="btn btn--small" style="margin-left:0.5rem; border:1px solid var(--accent); background:transparent; color:var(--accent); cursor:pointer; font-family:'DM Sans',sans-serif; font-size:0.75rem; padding:0.3rem 0.75rem;"
            onclick="deleteTeacher('${t.id}', '${escapeHtml(t.email || '')}')">Delete</button>
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
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>${rows}</tbody>
    </table>`;
}

// ─── Reassign Modal ───────────────────────────────────────────────

function openReassignModal(userId, email, currentSchoolId, currentDivisionId) {
  if (!allSchoolsList.length || !allDivisionsList.length) {
    alert('Organizations still loading. Please try again in a moment.');
    return;
  }

  const old = document.getElementById('reassign-modal');
  if (old) old.remove();

  const schoolOpts = allSchoolsList.map(s =>
    `<option value="${s.id}" ${s.id === currentSchoolId ? 'selected' : ''}>${escapeHtml(s.name)}</option>`
  ).join('');

  const divisionOpts = allDivisionsList.map(d =>
    `<option value="${d.id}" ${d.id === currentDivisionId ? 'selected' : ''}>${escapeHtml(d.name)}</option>`
  ).join('');

  const modal = document.createElement('div');
  modal.id = 'reassign-modal';
  modal.style.cssText = `
    position:fixed; inset:0; background:rgba(26,26,46,0.55); z-index:1000;
    display:flex; align-items:center; justify-content:center; padding:1rem;
  `;

  modal.innerHTML = `
    <div style="background:var(--paper); border:var(--border); max-width:420px; width:100%; padding:2rem;">
      <p class="label" style="margin-bottom:1rem;">Reassign ${escapeHtml(email || userId)}</p>

      <div style="margin-bottom:1rem;">
        <label class="label" style="display:block; margin-bottom:0.4rem;">School</label>
        <select id="reassign-school" class="input-field" style="font-size:0.875rem;">
          <option value="">— None —</option>
          ${schoolOpts}
        </select>
      </div>

      <div style="margin-bottom:1.5rem;">
        <label class="label" style="display:block; margin-bottom:0.4rem;">Division</label>
        <select id="reassign-division" class="input-field" style="font-size:0.875rem;">
          <option value="">— None —</option>
          ${divisionOpts}
        </select>
      </div>

      <div style="display:flex; gap:0.75rem;">
        <button class="btn btn--primary btn--small" onclick="submitReassign('${userId}')">Reassign</button>
        <button class="btn btn--ghost btn--small" onclick="document.getElementById('reassign-modal').remove()">Cancel</button>
      </div>
    </div>
  `;

  document.body.appendChild(modal);
  modal.addEventListener('click', e => { if (e.target === modal) modal.remove(); });
}

async function submitReassign(userId) {
  const schoolId   = document.getElementById('reassign-school').value || null;
  const divisionId = document.getElementById('reassign-division').value || null;

  try {
    await adminApi('reassign-teacher', 'POST', { userId, schoolId, divisionId });
    document.getElementById('reassign-modal').remove();
    await loadTeachers();
  } catch (err) {
    alert('Could not reassign teacher: ' + err.message);
  }
}

async function deleteTeacher(userId, email) {
  if (!confirm(`Permanently delete teacher ${email || userId} and all their uploads? This cannot be undone.`)) return;
  try {
    await adminApi('delete-teacher', 'POST', { userId });
    await Promise.all([loadTeachers(), loadOverview()]);
  } catch (err) {
    alert('Could not delete teacher: ' + err.message);
  }
}

async function deleteSchool(schoolId, name) {
  if (!confirm(`Delete school "${name || schoolId}"? Teachers currently in this school will become unattached. This cannot be undone.`)) return;
  try {
    await adminApi('delete-school', 'POST', { schoolId });
    await Promise.all([loadSchools(), loadDivisions(), loadTeachers(), loadOverview()]);
  } catch (err) {
    alert('Could not delete school: ' + err.message);
  }
}

async function deleteDivision(divisionId, name) {
  if (!confirm(`Delete division "${name || divisionId}"? Schools and teachers in this division will become unattached. This cannot be undone.`)) return;
  try {
    await adminApi('delete-division', 'POST', { divisionId });
    await Promise.all([loadDivisions(), loadSchools(), loadTeachers(), loadOverview()]);
  } catch (err) {
    alert('Could not delete division: ' + err.message);
  }
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

async function toggleDeactivation(userId, deactivate, btn) {
  const actionLabel = deactivate ? 'Deactivate' : 'Reactivate';
  if (!confirm(`${actionLabel} this teacher?`)) return;

  btn.disabled    = true;
  btn.textContent = `${actionLabel}…`;

  try {
    await adminApi('toggle-deactivation', 'POST', { userId, deactivated: deactivate });
    await loadTeachers();
  } catch (err) {
    alert('Could not update status: ' + err.message);
    btn.disabled    = false;
    btn.textContent = actionLabel;
  }
}

// ─── Tab switching ────────────────────────────────────────────────────────────────────

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

// ─── Demo Panel ───────────────────────────────────────────────────

const DEMO_PANEL_DATA = [
  {
    group: 'Aspen Peaks School Division',
    subtitle: 'Division Plan · Silverwood High attached',
    personas: [
      { key: 'marcus',  name: 'Marcus Vance',    email: 'm.vance@apsd.net',                    role: 'division_admin', roleLabel: 'Division Admin'  },
      { key: 'elena',   name: 'Elena Rodriguez', email: 'e.rodriguez@silverwood.apsd.net',      role: 'school_admin',   roleLabel: 'School IT Specialist' },
      { key: 'julian',  name: 'Julian Thorne',   email: 'j.thorne@silverwood.apsd.net',         role: 'teacher',        roleLabel: 'Teacher'          },
      { key: 'sarah',   name: 'Sarah Jenkins',   email: 's.jenkins@silverwood.apsd.net',        role: 'teacher',        roleLabel: 'Teacher'          },
      { key: 'david',   name: 'David Wu',        email: 'd.wu@silverwood.apsd.net',             role: 'teacher',        roleLabel: 'Teacher'          },
    ],
  },
  {
    group: 'Horizon Charter Academy',
    subtitle: 'School Plan · Independent',
    personas: [
      { key: 'chloe',   name: 'Chloe Simmons',  email: 'c.simmons@horizoncharter.org',         role: 'school_admin',   roleLabel: 'School IT Specialist' },
      { key: 'robert',  name: 'Robert Finch',   email: 'r.finch@horizoncharter.org',            role: 'teacher',        roleLabel: 'Teacher'          },
      { key: 'linda',   name: 'Linda Grewal',   email: 'l.grewal@horizoncharter.org',           role: 'teacher',        roleLabel: 'Teacher'          },
      { key: 'thomas',  name: 'Thomas Beck',    email: 't.beck@horizoncharter.org',             role: 'teacher',        roleLabel: 'Teacher'          },
    ],
  },
];

// ─── Requests ─────────────────────────────────────────────────────

async function loadRequests() {
  const container = document.getElementById('requests-container');
  if (!container) return;

  try {
    const requests = await adminApi('list-requests');

    const pending = requests.filter(r => r.status === 'pending');

    // Badge the tab with pending count
    const tab = document.getElementById('requests-tab');
    if (tab) tab.textContent = pending.length > 0 ? `Requests (${pending.length})` : 'Requests';

    if (!requests.length) {
      container.innerHTML = `<div class="empty-state"><p class="label">No requests yet</p></div>`;
      return;
    }

    const rows = requests.map(r => {
      const date = new Date(r.created_at).toLocaleDateString('en-CA', { year:'numeric', month:'short', day:'numeric' });
      const statusBadge = r.status === 'pending'
        ? `<span style="color:var(--ink); font-weight:500;">Pending</span>`
        : r.status === 'approved'
          ? `<span style="color:#4a7c59;">Approved</span>`
          : `<span style="color:var(--muted);">Rejected</span>`;

      const typeLabel = {
        access:          'New Account',
        premium_trial:   'Premium Trial',
        school_plan:     'School Plan',
        division_plan:   'Division Plan',
      }[r.request_type] || r.request_type;

      const isExisting = !!r.teacher_id;
      const teacherTag = isExisting
        ? `<span style="display:inline-block; padding:0.1rem 0.45rem; font-size:0.6rem; letter-spacing:0.1em; text-transform:uppercase; font-weight:500; border:1px solid var(--ink); margin-left:0.4rem;">Existing Teacher</span>`
        : '';

      const actions = r.status === 'pending' ? `
        <button class="btn btn--ghost btn--small" onclick="approveRequest('${r.id}', '${escapeHtml(r.email)}')">Approve</button>
        <button class="btn btn--small" style="margin-left:0.5rem; border:1px solid var(--warm-mid); background:transparent; color:var(--muted); cursor:pointer; font-family:'DM Sans',sans-serif; font-size:0.75rem; padding:0.3rem 0.75rem;"
          onclick="rejectRequest('${r.id}')">Reject</button>
      ` : '—';

      return `
        <tr>
          <td><strong>${escapeHtml(r.name)}</strong>${teacherTag}<br><span style="color:var(--muted); font-size:0.8rem;">${escapeHtml(r.email)}</span></td>
          <td style="font-size:0.85rem;">${typeLabel}</td>
          <td style="font-size:0.85rem;">${escapeHtml(r.school || '—')}</td>
          <td style="font-size:0.85rem;">${escapeHtml(r.division || '—')}</td>
          <td style="font-size:0.8rem; color:var(--muted); max-width:200px; white-space:normal;">${escapeHtml(r.message || '—')}</td>
          <td style="font-size:0.8rem; color:var(--muted);">${date}</td>
          <td>${statusBadge}</td>
          <td>${actions}</td>
          <td id="invite-link-${r.id}"></td>
        </tr>`;
    }).join('');

    container.innerHTML = `
      <table class="admin-table">
        <thead>
          <tr>
            <th>Name / Email</th>
            <th>Type</th>
            <th>School</th>
            <th>Division</th>
            <th>Message</th>
            <th>Submitted</th>
            <th>Status</th>
            <th>Actions</th>
            <th>Invite Link</th>
          </tr>
        </thead>
        <tbody>${rows}</tbody>
      </table>`;
  } catch (err) {
    container.innerHTML = `<p class="label" style="color:var(--accent);">Could not load requests: ${escapeHtml(err.message)}</p>`;
  }
}

async function loadInvitations() {
  const container = document.getElementById('invitations-container');
  if (!container) return;

  try {
    const invitations = await adminApi('list-invitations');

    const now = new Date();
    const pending = invitations.filter(i => new Date(i.expires_at) > now);
    const expired = invitations.filter(i => new Date(i.expires_at) <= now);

    const tab = document.getElementById('invitations-tab');
    if (tab) tab.textContent = pending.length > 0 ? `Invitations (${pending.length})` : 'Invitations';

    if (!invitations.length) {
      container.innerHTML = `<div class="empty-state"><p class="label">No pending invitations</p></div>`;
      return;
    }

    const renderRows = (list, isExpired) => list.map(inv => {
      const date = new Date(inv.created_at).toLocaleDateString('en-CA', { year:'numeric', month:'short', day:'numeric' });
      const expDate = new Date(inv.expires_at).toLocaleDateString('en-CA', { year:'numeric', month:'short', day:'numeric' });
      const org = inv.schools?.name || inv.divisions?.name || '—';
      const status = isExpired
        ? `<span style="color:var(--accent);">Expired ${expDate}</span>`
        : `<span style="color:#4a7c59;">Expires ${expDate}</span>`;
      const emailWarning = inv.lastEmailOk === false
        ? `<span style="display:inline-block; width:6px; height:6px; background:var(--accent); border-radius:50%; margin-left:0.4rem; vertical-align:middle;" title="Last email send failed"></span>`
        : '';
      return `
        <tr>
          <td><strong>${escapeHtml(inv.email)}</strong>${emailWarning}</td>
          <td style="font-size:0.85rem;">${escapeHtml(inv.role.replace(/_/g, ' '))}</td>
          <td style="font-size:0.85rem;">${escapeHtml(org)}</td>
          <td style="font-size:0.8rem; color:var(--muted);">${date}</td>
          <td>${status}</td>
          <td>
            <button class="btn btn--ghost btn--small" onclick="resendInvite('${inv.id}', '${escapeHtml(inv.email)}')">Resend</button>
          </td>
          <td id="resend-status-${inv.id}"></td>
        </tr>`;
    }).join('');

    let html = '';
    if (pending.length) {
      html += `
        <p class="label" style="margin-bottom:0.5rem;">Active</p>
        <table class="admin-table">
          <thead>
            <tr><th>Email</th><th>Role</th><th>Org</th><th>Sent</th><th>Status</th><th>Actions</th><th></th></tr>
          </thead>
          <tbody>${renderRows(pending, false)}</tbody>
        </table>`;
    }
    if (expired.length) {
      html += `
        <p class="label" style="margin:1.5rem 0 0.5rem;">Expired</p>
        <table class="admin-table">
          <thead>
            <tr><th>Email</th><th>Role</th><th>Org</th><th>Sent</th><th>Status</th><th>Actions</th><th></th></tr>
          </thead>
          <tbody>${renderRows(expired, true)}</tbody>
        </table>`;
    }

    container.innerHTML = html;
  } catch (err) {
    container.innerHTML = `<p class="label" style="color:var(--accent);">Could not load invitations: ${escapeHtml(err.message)}</p>`;
  }
}

async function resendInvite(invitationId, email) {
  if (!confirm(`Resend invitation to ${email}?`)) return;
  try {
    const data = await adminApi('resend-invite', 'POST', { invitationId });
    const cell = document.getElementById(`resend-status-${invitationId}`);
    if (cell) {
      if (data.emailOk === false) {
        cell.innerHTML = `<span style="color:var(--accent); font-size:0.75rem;">Email failed: ${escapeHtml(data.emailError || 'Unknown')}</span>`;
      } else {
        cell.innerHTML = `<span style="color:#4a7c59; font-size:0.75rem;">Resent</span>`;
      }
    }
    await loadInvitations();
  } catch (err) {
    alert('Could not resend invitation: ' + err.message);
  }
}

async function approveRequest(requestId, email) {
  if (!confirm(`Approve access request from ${email}?`)) return;
  try {
    const data = await adminApi('approve-request', 'POST', { requestId });
    // Show invite link inline (only for new-account requests)
    const cell = document.getElementById(`invite-link-${requestId}`);
    if (cell && data.inviteUrl) {
      let html = `
        <input type="text" value="${escapeHtml(data.inviteUrl)}" readonly
          style="font-size:0.7rem; font-family:monospace; border:1px solid var(--warm-mid);
                 padding:0.25rem 0.4rem; width:220px; background:var(--paper);"
          onclick="this.select()">`;
      if (data.emailOk === false) {
        html += `<div style="font-size:0.7rem; color:var(--accent); margin-top:0.25rem;">Email failed: ${escapeHtml(data.emailError || 'Unknown error')}</div>`;
      }
      cell.innerHTML = html;
    }
    await loadRequests();
  } catch (err) {
    alert('Could not approve request: ' + err.message);
  }
}

async function rejectRequest(requestId) {
  const notes = prompt('Reason for rejection (optional):');
  if (notes === null) return; // cancelled
  try {
    await adminApi('reject-request', 'POST', { requestId, notes: notes || null });
    await loadRequests();
  } catch (err) {
    alert('Could not reject request: ' + err.message);
  }
}

async function loadDemoPanel() {
  // Build the persona list immediately (static); the "View as" buttons call the API
  const container = document.getElementById('demo-personas');
  if (!container) return;

  const html = DEMO_PANEL_DATA.map(group => `
    <div style="margin-bottom:2rem;">
      <p style="font-weight:500; margin-bottom:0.25rem;">${escapeHtml(group.group)}</p>
      <p class="label" style="color:var(--muted); margin-bottom:0.75rem;">${escapeHtml(group.subtitle)}</p>
      <table class="admin-table">
        <tbody>
          ${group.personas.map(p => `
            <tr>
              <td style="font-size:0.875rem;"><strong style="font-weight:500;">${escapeHtml(p.name)}</strong></td>
              <td style="font-size:0.8rem; color:var(--muted);">${escapeHtml(p.roleLabel)}</td>
              <td style="font-size:0.8rem; color:var(--muted); font-family:monospace;">${escapeHtml(p.email)}</td>
              <td style="width:100px; text-align:right;">
                <button class="btn btn--ghost btn--small" onclick="viewAs('${p.key}','${escapeHtml(p.name)}','${escapeHtml(p.email)}',this)">View as</button>
              </td>
            </tr>`).join('')}
        </tbody>
      </table>
    </div>`).join('');

  container.innerHTML = html;
}

async function viewAs(key, name, email, btn) {
  btn.disabled    = true;
  btn.textContent = 'Loading…';

  try {
    // Find userId from the loaded teacher list (already fetched by initAdmin)
    const teacher = allTeachers.find(t => t.email === email);
    if (!teacher) throw new Error('Demo account not found — seed demo data first.');

    const data = await adminApi(`login-link&userId=${teacher.id}`, 'GET');

    btn.disabled    = false;
    btn.textContent = 'View as';

    showViewAsModal(name, data.email, data.role, data.redirectTo, data.link);
  } catch (err) {
    btn.disabled    = false;
    btn.textContent = 'View as';
    alert('Could not generate login link: ' + err.message);
  }
}

function showViewAsModal(name, email, role, redirectTo, link) {
  // Remove any existing modal
  const old = document.getElementById('view-as-modal');
  if (old) old.remove();

  const modal = document.createElement('div');
  modal.id = 'view-as-modal';
  modal.style.cssText = `
    position:fixed; inset:0; background:rgba(26,26,46,0.55); z-index:1000;
    display:flex; align-items:center; justify-content:center; padding:1rem;
  `;

  modal.innerHTML = `
    <div style="background:var(--paper); border:var(--border); max-width:480px; width:100%; padding:2rem;">
      <p class="label" style="margin-bottom:0.5rem;">View as ${escapeHtml(name)}</p>
      <p style="font-size:0.85rem; color:var(--muted); margin-bottom:1.25rem; line-height:1.5;">
        This one-time link signs in as <strong style="font-weight:500;">${escapeHtml(email)}</strong>
        and opens <code style="font-size:0.75rem;">${escapeHtml(redirectTo.replace('https://app.audioproctor.com',''))}</code>.
      </p>

      <div style="border:1px solid var(--accent); padding:0.75rem 1rem; background:var(--light-accent); margin-bottom:1.25rem;">
        <p style="font-size:0.8rem; color:var(--accent); font-weight:500; margin-bottom:0.25rem;">Session warning</p>
        <p style="font-size:0.8rem; color:var(--muted); line-height:1.4;">
          Supabase stores sessions in localStorage — opening this link in any tab of this browser
          will replace your current admin session. Use an incognito or separate browser window
          to keep your admin session active.
        </p>
      </div>

      <div style="display:flex; gap:0.75rem; flex-wrap:wrap;">
        <button class="btn btn--primary" onclick="copyViewAsLink('${escapeHtml(link)}', this)">Copy link</button>
        <a href="${escapeHtml(link)}" target="_blank" class="btn btn--ghost" onclick="document.getElementById('view-as-modal').remove()">Open in new tab (signs out admin)</a>
        <button class="btn btn--ghost" onclick="document.getElementById('view-as-modal').remove()">Cancel</button>
      </div>
    </div>
  `;

  document.body.appendChild(modal);
  modal.addEventListener('click', e => { if (e.target === modal) modal.remove(); });
}

function copyViewAsLink(link, btn) {
  navigator.clipboard.writeText(link).then(() => {
    btn.textContent = 'Copied!';
    setTimeout(() => { btn.textContent = 'Copy link'; }, 2000);
  });
}

async function seedDemoData(btn) {
  if (!confirm('This will create 9 demo accounts, 2 schools, 1 division, 27 uploads, and ~2,000 session events. Safe to run multiple times (idempotent). Continue?')) return;

  btn.disabled    = true;
  btn.textContent = 'Seeding…';
  const notice = document.getElementById('seed-notice');
  notice.textContent = '';
  notice.className = 'notice hidden';

  try {
    const result = await adminApi('seed-demo', 'POST');
    notice.textContent = `Done. ${result.usersCreated} users created, ${result.usersFound} already existed. ${result.uploads} uploads, ${result.events} session events inserted. Analytics will refresh within 15 minutes (or run REFRESH MATERIALIZED VIEW upload_summaries in SQL editor now).`;
    notice.className = 'notice notice--success';
    // Reload teachers so "View as" can find the new user IDs
    await loadTeachers();
  } catch (err) {
    notice.textContent = 'Seed failed: ' + err.message;
    notice.className = 'notice notice--error';
  } finally {
    btn.disabled    = false;
    btn.textContent = 'Seed / Refresh Demo Data';
  }
}
