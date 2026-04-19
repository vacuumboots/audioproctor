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

  await Promise.all([loadOverview(), loadDivisions(), loadSchools(), loadTeachers(), loadRequests()]);
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

      const actions = r.status === 'pending' ? `
        <button class="btn btn--ghost btn--small" onclick="approveRequest('${r.id}', '${escapeHtml(r.email)}')">Approve</button>
        <button class="btn btn--small" style="margin-left:0.5rem; border:1px solid var(--warm-mid); background:transparent; color:var(--muted); cursor:pointer; font-family:'DM Sans',sans-serif; font-size:0.75rem; padding:0.3rem 0.75rem;"
          onclick="rejectRequest('${r.id}')">Reject</button>
      ` : '—';

      return `
        <tr>
          <td><strong>${escapeHtml(r.name)}</strong><br><span style="color:var(--muted); font-size:0.8rem;">${escapeHtml(r.email)}</span></td>
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

async function approveRequest(requestId, email) {
  if (!confirm(`Approve access request from ${email}?`)) return;
  try {
    const data = await adminApi('approve-request', 'POST', { requestId });
    // Show invite link inline
    const cell = document.getElementById(`invite-link-${requestId}`);
    if (cell) {
      cell.innerHTML = `
        <input type="text" value="${escapeHtml(data.inviteUrl)}" readonly
          style="font-size:0.7rem; font-family:monospace; border:1px solid var(--warm-mid);
                 padding:0.25rem 0.4rem; width:220px; background:var(--paper);"
          onclick="this.select()">`;
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
