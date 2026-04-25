// ─── Division Admin Dashboard ─────────────────────────────────────────────
// Requires role = 'division_admin' on the profiles row.

const ORG_API = '/api/org';

let orgJwt            = null;
let allSchools        = [];

async function initDivisionAdmin(user) {
  const session = await getSession();
  if (!session) { window.location.href = '/login.html'; return; }
  orgJwt = session.access_token;

  // Verify division_admin role
  const { data: profile } = await supabaseClient
    .from('profiles')
    .select('role, division_id')
    .eq('id', user.id)
    .maybeSingle();

  if (!profile || !['division_admin', 'platform_admin'].includes(profile.role)) {
    document.body.innerHTML = `
      <div style="display:flex; align-items:center; justify-content:center; min-height:100vh; padding:2rem; text-align:center;">
        <div>
          <p class="label" style="margin-bottom:1rem; color:var(--accent);">Access denied</p>
          <p style="color:var(--muted); margin-bottom:1.5rem;">This page requires the Division Admin role.</p>
          <a href="/dashboard.html" class="btn btn--ghost">Go to Dashboard</a>
        </div>
      </div>`;
    return;
  }

  if (profile.division_id) {
    const { data: division } = await supabaseClient
      .from('divisions')
      .select('name')
      .eq('id', profile.division_id)
      .maybeSingle();
    if (division) document.getElementById('division-name-title').textContent = division.name;
  }

  await Promise.all([loadDivisionReport(), loadSchools(), loadActivityChart()]);
}

// ─── API helper ───────────────────────────────────────────────────────────

async function orgApi(action, method = 'GET', body = null, extraParams = '') {
  const opts = {
    method,
    headers: {
      'Authorization': `Bearer ${orgJwt}`,
      'Content-Type':  'application/json',
    },
  };
  if (body) opts.body = JSON.stringify(body);
  const res  = await fetch(`${ORG_API}?action=${action}${extraParams}`, opts);
  const data = await res.json();
  if (!res.ok) throw new Error(data.error || `API error ${res.status}`);
  return data;
}

// ─── Division report ──────────────────────────────────────────────────────

async function loadDivisionReport() {
  try {
    const report = await orgApi('division-report');
    document.getElementById('stat-schools').textContent  = report.schoolCount;
    document.getElementById('stat-teachers').textContent = report.teacherCount;
    document.getElementById('stat-active').textContent   = report.activeTeacherCount;
    document.getElementById('stat-sessions').textContent = report.totalSessions;
  } catch (err) {
    console.error('division-report failed:', err.message);
  }
}

// ─── Activity chart ───────────────────────────────────────────────────────

async function loadActivityChart() {
  const container = document.getElementById('activity-chart');
  try {
    const data = await orgApi('division-activity');
    renderActivityChart(data, container);
  } catch (err) {
    container.innerHTML = `<p class="label text-muted" style="padding:0.75rem 0;">No activity data yet.</p>`;
  }
}

function renderActivityChart(data, container) {
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

// ─── Schools list ─────────────────────────────────────────────────────────

async function loadSchools() {
  const container = document.getElementById('schools-container');
  try {
    allSchools = await orgApi('division-schools');

    if (!allSchools.length) {
      container.innerHTML = `<div class="empty-state"><p class="label">No schools attached to this division yet.</p></div>`;
      return;
    }

    renderSchoolsTable(allSchools, container);
  } catch (err) {
    container.innerHTML = `<p class="label text-accent">Could not load schools: ${escapeHtml(err.message)}</p>`;
  }
}

function renderSchoolsTable(schools, container) {
  const rows = schools.map(s => `
    <tr>
      <td><strong>${escapeHtml(s.name)}</strong></td>
      <td style="text-align:center;">${s.teacher_count}</td>
      <td style="text-align:center;">${s.total_sessions}</td>
      <td style="text-align:center;">${s.completion_rate != null ? s.completion_rate + '%' : '—'}</td>
      <td style="text-align:center;">${s.replays}</td>
      <td>
        <div style="display:flex; gap:0.5rem; flex-wrap:wrap;">
          <button class="btn btn--ghost btn--small" onclick="openDrillDown('${s.id}', '${escapeHtml(s.name)}')">View Teachers</button>
          <button class="btn btn--ghost btn--small" onclick="detachSchool('${s.id}', '${escapeHtml(s.name)}', this)">Remove from Division</button>
        </div>
      </td>
    </tr>`).join('');

  container.innerHTML = `
    <table class="admin-table">
      <thead>
        <tr>
          <th>School</th>
          <th style="text-align:center;">Teachers</th>
          <th style="text-align:center;">Sessions</th>
          <th style="text-align:center;">Completion</th>
          <th style="text-align:center;">Replays</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>${rows}</tbody>
    </table>`;
}

async function detachSchool(schoolId, name, btn) {
  if (!confirm(`Remove "${name}" from this division? The school and its teachers revert to free tier immediately. Existing uploads remain until they expire.`)) return;
  btn.disabled    = true;
  btn.textContent = 'Removing…';
  try {
    await orgApi('detach-school', 'POST', { schoolId });
    await Promise.all([loadSchools(), loadDivisionReport()]);
  } catch (err) {
    alert('Could not remove school: ' + err.message);
    btn.disabled    = false;
    btn.textContent = 'Remove from Division';
  }
}

// ─── School drill-down ────────────────────────────────────────────────────

async function openDrillDown(schoolId, schoolName) {
  document.getElementById('schools-container').classList.add('hidden');
  const panel = document.getElementById('drill-down-panel');
  panel.classList.remove('hidden');
  document.getElementById('drill-down-title').textContent = schoolName;

  const container = document.getElementById('drill-down-container');
  container.innerHTML = `<div class="empty-state"><p class="label">Loading…</p></div>`;

  try {
    const detail = await orgApi('school-detail', 'GET', null, `&schoolId=${encodeURIComponent(schoolId)}`);
    const teachers = detail.teachers || [];

    if (!teachers.length) {
      container.innerHTML = `<div class="empty-state"><p class="label">No teachers attached to this school.</p></div>`;
      return;
    }

    const rows = teachers.map(t => {
      const lastActive = t.last_active
        ? new Date(t.last_active).toLocaleDateString('en-CA', { year: 'numeric', month: 'short', day: 'numeric' })
        : '—';
      const roleTag = t.role === 'school_admin'
        ? `<span style="display:inline-block; padding:0.1rem 0.45rem; font-size:0.6rem; letter-spacing:0.1em; text-transform:uppercase; font-weight:500; border:1px solid var(--ink);">Admin</span> `
        : '';
      const listenTime = t.avg_listen_seconds != null
        ? `${Math.floor(t.avg_listen_seconds / 60)}:${String(t.avg_listen_seconds % 60).padStart(2, '0')}`
        : '—';
      const completionRate = t.completion_rate != null ? `${t.completion_rate}%` : '—';

      return `
        <tr>
          <td>${roleTag}<span style="font-size:0.85rem;">${escapeHtml(t.email || '—')}</span></td>
          <td style="text-align:center;">${t.upload_count}</td>
          <td style="text-align:center;">${t.session_count}</td>
          <td style="text-align:center;">${completionRate}</td>
          <td style="text-align:center;">${t.replays}</td>
          <td style="text-align:center;">${listenTime}</td>
          <td style="color:var(--muted); font-size:0.82rem;">${lastActive}</td>
          <td>
            <div style="display:flex; gap:0.5rem; flex-wrap:wrap;">
              <button class="btn btn--ghost btn--small" onclick="detachTeacher('${t.id}', '${escapeHtml(t.email || t.id)}', this)">Detach</button>
              ${t.role === 'school_admin' ? `<button class="btn btn--ghost btn--small" onclick="removeSchoolAdmin('${t.id}', '${escapeHtml(t.email || t.id)}', this)">Remove Admin Role</button>` : ''}
            </div>
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
            <th style="text-align:center;">Completion</th>
            <th style="text-align:center;">Replays</th>
            <th style="text-align:center;">Avg Listen</th>
            <th>Last Active</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>${rows}</tbody>
      </table>`;
  } catch (err) {
    container.innerHTML = `<p class="label text-accent">Could not load school details: ${escapeHtml(err.message)}</p>`;
  }
}

function closeDrillDown() {
  document.getElementById('drill-down-panel').classList.add('hidden');
  document.getElementById('schools-container').classList.remove('hidden');
}

async function removeSchoolAdmin(userId, email, btn) {
  if (!confirm(`Remove the School Admin role from ${email}? They will revert to a regular teacher.`)) return;
  btn.disabled    = true;
  btn.textContent = 'Removing…';
  try {
    await orgApi('remove-school-admin', 'POST', { userId });
    btn.closest('td').innerHTML = '';
  } catch (err) {
    alert('Could not remove admin role: ' + err.message);
    btn.disabled    = false;
    btn.textContent = 'Remove Admin Role';
  }
}

// ─── Detach teacher ───────────────────────────────────────────────────────

async function detachTeacher(userId, email, btn) {
  if (!confirm(`Detach ${email}? They will be removed from their school and division and revert to free tier immediately. Existing uploads remain until they expire.`)) return;
  btn.disabled    = true;
  btn.textContent = 'Detaching…';
  try {
    await orgApi('detach-teacher', 'POST', { userId });
    btn.closest('tr').remove();
  } catch (err) {
    alert('Could not detach teacher: ' + err.message);
    btn.disabled    = false;
    btn.textContent = 'Detach';
  }
}

// ─── CSV Export ───────────────────────────────────────────────────────────

async function exportDivisionCsv() {
  const btn = document.querySelector('[onclick="exportDivisionCsv()"]');
  if (btn) { btn.disabled = true; btn.textContent = 'Exporting…'; }

  try {
    // Build CSV from loaded schools data
    if (!allSchools.length) { alert('No schools to export.'); return; }

    const headers = ['School', 'Teachers', 'Total Sessions'];
    const rows    = allSchools.map(s => [
      `"${(s.name || '').replace(/"/g, '""')}"`,
      s.teacher_count,
      s.total_sessions,
    ]);

    const csv  = [headers.join(','), ...rows.map(r => r.join(','))].join('\n');
    const blob = new Blob([csv], { type: 'text/csv' });
    const url  = URL.createObjectURL(blob);
    const a    = document.createElement('a');
    a.href     = url;
    a.download = `division-report-${new Date().toISOString().slice(0, 10)}.csv`;
    a.click();
    URL.revokeObjectURL(url);
  } catch (err) {
    alert('Export failed: ' + err.message);
  } finally {
    if (btn) { btn.disabled = false; btn.textContent = 'Export CSV'; }
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
