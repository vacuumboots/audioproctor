// ─── Division Admin Dashboard ─────────────────────────────────────────────
// Requires role = 'division_admin' on the profiles row.
// Includes Division Plan billing management.

const ORG_API = '/api/org';

let orgJwt            = null;
let allSchools        = [];
let divisionId        = null;
let divisionTier      = 'free';
let divisionStripStatus = null;
let divisionEnrolmentBand = null;

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
          <p class="label" style="margin-bottom:1rem; color:var(--accent);">${t('admin.accessDenied')}</p>
          <p style="color:var(--muted); margin-bottom:1.5rem;">${t('admin.divisionAdmin.accessDenied')}</p>
          <a href="/dashboard.html" class="btn btn--ghost">${t('admin.goToDashboard')}</a>
        </div>
      </div>`;
    return;
  }

  divisionId = profile.division_id;

  if (divisionId) {
    const { data: division } = await supabaseClient
      .from('divisions')
      .select('name, tier, enrolment_band, stripe_subscription_status, stripe_subscription_id')
      .eq('id', divisionId)
      .maybeSingle();
    if (division) {
      document.getElementById('division-name-title').textContent = division.name;
      divisionTier = division.tier || 'free';
      divisionStripStatus = division.stripe_subscription_status;
      divisionEnrolmentBand = division.enrolment_band;
    }
  }

  await Promise.all([loadDivisionReport(), loadSchools(), loadActivityChart(), renderDivisionBilling()]);
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

// ─── Billing ──────────────────────────────────────────────────────────────

async function renderDivisionBilling() {
  const block = document.getElementById('billing-block');
  const badge = document.getElementById('billing-badge');
  if (!block) return;

  if (divisionTier === 'division') {
    const statusLabel = divisionStripStatus === 'active' ? t('admin.divisionAdmin.billing.statusActive') :
      divisionStripStatus === 'past_due' ? t('admin.divisionAdmin.billing.statusPastDue') :
      divisionStripStatus === 'canceled' ? t('admin.divisionAdmin.billing.statusCanceled') : t('admin.divisionAdmin.billing.statusActive');

    const statusColor = divisionStripStatus === 'active' ? '#4a7c59' :
      divisionStripStatus === 'past_due' ? 'var(--accent)' : 'var(--muted)';

    badge.textContent = statusLabel;
    badge.style.color = 'var(--paper)';
    badge.style.background = statusColor;
    badge.style.border = `1px solid ${statusColor}`;
    badge.classList.remove('hidden');

    const bandLabel = divisionEnrolmentBand
      ? capitalize(divisionEnrolmentBand) + ' Division'
      : t('admin.divisionAdmin.billing.divisionPlan');

    block.innerHTML = `
      <p><strong>${t('admin.divisionAdmin.billing.onPlan', { plan: bandLabel })}</strong></p>
      <p style="margin-top:0.5rem; color:var(--muted);">
        ${t('admin.divisionAdmin.billing.onPlanDesc')}
      </p>
      <p style="margin-top:0.75rem; font-size:0.8rem; color:var(--muted);">
        ${t('admin.divisionAdmin.billing.billingManaged')}
      </p>`;
  } else {
    badge.classList.add('hidden');

    // Fetch pricing options
    const { data: pricing } = await supabaseClient
      .from('division_pricing')
      .select('*')
      .order('annual_price_cents', { ascending: true });

    const band = divisionEnrolmentBand || 'small';
    let optionsHtml = '';
    if (pricing && pricing.length > 0) {
      optionsHtml = pricing.map(p => `
        <label style="display:flex; align-items:center; gap:0.75rem; padding:0.75rem 0; border-bottom:1px solid var(--warm-mid); cursor:pointer;">
          <input type="radio" name="enrolment-band" value="${p.enrolment_band}"
            ${p.enrolment_band === band ? 'checked' : ''}
            data-price-id="${p.stripe_price_id}">
          <div>
            <strong>${p.label}</strong>
            ${p.description ? `<span style="font-size:0.8rem; color:var(--muted); margin-left:0.5rem;">${p.description}</span>` : ''}
            <div style="font-size:0.8rem; color:var(--ink); margin-top:0.15rem;">
              $${(p.annual_price_cents / 100).toLocaleString('en-US', { minimumFractionDigits: 2 })}/year
            </div>
          </div>
        </label>`).join('');
    }

    block.innerHTML = `
      <p><strong>${t('admin.divisionAdmin.billing.onFreeTier')}</strong></p>
      <p style="margin-top:0.5rem; color:var(--muted); line-height:1.6; margin-bottom:1rem;">
        ${t('admin.divisionAdmin.billing.purchasePrompt')}
      </p>
      ${optionsHtml ? `
        <div style="margin-top:0.5rem; margin-bottom:1.25rem; border:var(--border); padding:0.75rem 1rem;">
          <p class="label" style="margin-bottom:0.5rem;">${t('admin.divisionAdmin.billing.selectBand')}</p>
          ${optionsHtml}
        </div>
      ` : ''}
      <div style="display:flex; gap:1rem; align-items:center;">
        <button id="btn-purchase-division-plan" class="btn btn--primary btn--small"
          onclick="startDivisionCheckout()">${t('admin.divisionAdmin.billing.purchaseButton')}</button>
        <span style="font-size:0.75rem; color:var(--muted);">${t('admin.divisionAdmin.billing.billedAnnually')}</span>
      </div>
      <p style="margin-top:0.75rem; font-size:0.8rem; color:var(--muted);">
        ${t('admin.divisionAdmin.billing.invoiceLink')}
      </p>`;
  }
}

async function startDivisionCheckout() {
  const btn = document.getElementById('btn-purchase-division-plan');
  if (btn) {
    btn.disabled = true;
    btn.textContent = t('admin.divisionAdmin.billing.redirecting');
  }

  const session = await getSession();
  if (!session) { window.location = '/login.html'; return; }

  // Get selected enrolment band
  const selectedBand = document.querySelector('input[name="enrolment-band"]:checked');
  const enrolmentBand = selectedBand ? selectedBand.value : divisionEnrolmentBand;
  const priceId = selectedBand ? selectedBand.dataset.priceId : null;

  try {
    const res = await fetch('/api/stripe-checkout', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${session.access_token}`
      },
      body: JSON.stringify({ action: 'division', divisionId, enrolmentBand, priceId })
    });

    const data = await res.json();
    if (!res.ok) throw new Error(data.error || 'Checkout failed');
    window.location = data.url;
  } catch (err) {
    alert(t('admin.divisionAdmin.billing.checkoutError', { error: err.message }));
    if (btn) {
      btn.disabled = false;
      btn.textContent = t('admin.divisionAdmin.billing.purchaseButton');
    }
  }
}

// Handle successful return from Stripe
if (new URLSearchParams(window.location.search).get('upgraded') === 'division') {
  history.replaceState(null, '', window.location.pathname);
  const banner = document.createElement('div');
  banner.style.cssText = 'position:fixed;top:0;left:0;right:0;background:var(--ink);color:var(--paper);text-align:center;padding:0.6rem;font-size:0.85rem;z-index:999;';
  banner.textContent = t('admin.divisionAdmin.billing.activatedBanner');
  document.body.prepend(banner);
  setTimeout(() => banner.remove(), 6000);
}

// ─── Activity chart ───────────────────────────────────────────────────────

async function loadActivityChart() {
  const container = document.getElementById('activity-chart');
  try {
    const data = await orgApi('division-activity');
    renderActivityChart(data, container);
  } catch (err) {
    container.innerHTML = `<p class="label text-muted" style="padding:0.75rem 0;">${t('admin.divisionAdmin.activity.noData')}</p>`;
  }
}

function renderActivityChart(data, container) {
  if (!data || data.length === 0 || data.every(d => d.sessions === 0)) {
    container.innerHTML = `<p style="font-size:0.85rem; color:var(--muted); padding:0.5rem 0;">${t('admin.divisionAdmin.activity.noSessionData')}</p>`;
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
    <p style="font-size:0.75rem; color:var(--muted); margin-top:0.5rem;">${t('admin.divisionAdmin.activity.sessionsPerWeek')}</p>
  `;
}

// ─── Schools list ─────────────────────────────────────────────────────────

async function loadSchools() {
  const container = document.getElementById('schools-container');
  try {
    allSchools = await orgApi('division-schools');

    if (!allSchools.length) {
      container.innerHTML = `<div class="empty-state"><p class="label">${t('admin.divisionAdmin.schools.noData')}</p></div>`;
      return;
    }

    renderSchoolsTable(allSchools, container);
  } catch (err) {
    container.innerHTML = `<p class="label text-accent">${t('admin.divisionAdmin.schools.loadError', { error: escapeHtml(err.message) })}</p>`;
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
          <button class="btn btn--ghost btn--small" onclick="openDrillDown('${s.id}', '${escapeHtml(s.name)}')">${t('admin.divisionAdmin.schools.viewTeachers')}</button>
          <button class="btn btn--ghost btn--small" onclick="detachSchool('${s.id}', '${escapeHtml(s.name)}', this)">${t('admin.divisionAdmin.schools.removeFromDivision')}</button>
        </div>
      </td>
    </tr>`).join('');

  container.innerHTML = `
    <table class="admin-table">
      <thead>
        <tr>
          <th>${t('admin.divisionAdmin.schools.tableHeaders.school')}</th>
          <th style="text-align:center;">${t('admin.divisionAdmin.schools.tableHeaders.teachers')}</th>
          <th style="text-align:center;">${t('admin.divisionAdmin.schools.tableHeaders.sessions')}</th>
          <th style="text-align:center;">${t('admin.divisionAdmin.schools.tableHeaders.completion')}</th>
          <th style="text-align:center;">${t('admin.divisionAdmin.schools.tableHeaders.replays')}</th>
          <th>${t('admin.divisionAdmin.schools.tableHeaders.actions')}</th>
        </tr>
      </thead>
      <tbody>${rows}</tbody>
    </table>`;
}

async function detachSchool(schoolId, name, btn) {
  if (!confirm(t('admin.divisionAdmin.schools.removeConfirm', { name }))) return;
  btn.disabled    = true;
  btn.textContent = t('admin.divisionAdmin.schools.removing');
  try {
    await orgApi('detach-school', 'POST', { schoolId });
    await Promise.all([loadSchools(), loadDivisionReport()]);
  } catch (err) {
    alert(t('admin.divisionAdmin.schools.removeError', { error: err.message }));
    btn.disabled    = false;
    btn.textContent = t('admin.divisionAdmin.schools.removeFromDivision');
  }
}

// ─── School drill-down ────────────────────────────────────────────────────

async function openDrillDown(schoolId, schoolName) {
  document.getElementById('schools-container').classList.add('hidden');
  const panel = document.getElementById('drill-down-panel');
  panel.classList.remove('hidden');
  document.getElementById('drill-down-title').textContent = schoolName;

  const container = document.getElementById('drill-down-container');
  container.innerHTML = `<div class="empty-state"><p class="label">${t('common.loading')}</p></div>`;

  try {
    const detail = await orgApi('school-detail', 'GET', null, `&schoolId=${encodeURIComponent(schoolId)}`);
    const teachers = detail.teachers || [];

    if (!teachers.length) {
      container.innerHTML = `<div class="empty-state"><p class="label">${t('admin.divisionAdmin.schools.drillDownNoData')}</p></div>`;
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
              <button class="btn btn--ghost btn--small" onclick="detachTeacher('${t.id}', '${escapeHtml(t.email || t.id)}', this)">${t('admin.divisionAdmin.schools.detach')}</button>
              ${t.role === 'school_admin' ? `<button class="btn btn--ghost btn--small" onclick="removeSchoolAdmin('${t.id}', '${escapeHtml(t.email || t.id)}', this)">${t('admin.divisionAdmin.schools.removeAdminRole')}</button>` : ''}
            </div>
          </td>
        </tr>`;
    }).join('');

    container.innerHTML = `
      <table class="admin-table">
        <thead>
          <tr>
            <th>${t('admin.divisionAdmin.schools.drillDownTableHeaders.email')}</th>
            <th style="text-align:center;">${t('admin.divisionAdmin.schools.drillDownTableHeaders.uploads')}</th>
            <th style="text-align:center;">${t('admin.divisionAdmin.schools.drillDownTableHeaders.sessions')}</th>
            <th style="text-align:center;">${t('admin.divisionAdmin.schools.drillDownTableHeaders.completion')}</th>
            <th style="text-align:center;">${t('admin.divisionAdmin.schools.drillDownTableHeaders.replays')}</th>
            <th style="text-align:center;">${t('admin.divisionAdmin.schools.drillDownTableHeaders.avgListen')}</th>
            <th>${t('admin.divisionAdmin.schools.drillDownTableHeaders.lastActive')}</th>
            <th>${t('admin.divisionAdmin.schools.drillDownTableHeaders.actions')}</th>
          </tr>
        </thead>
        <tbody>${rows}</tbody>
      </table>`;
  } catch (err) {
    container.innerHTML = `<p class="label text-accent">${t('admin.divisionAdmin.schools.drillDownLoadError', { error: escapeHtml(err.message) })}</p>`;
  }
}

function closeDrillDown() {
  document.getElementById('drill-down-panel').classList.add('hidden');
  document.getElementById('schools-container').classList.remove('hidden');
}

async function removeSchoolAdmin(userId, email, btn) {
  if (!confirm(t('admin.divisionAdmin.schools.removeAdminRoleConfirm', { email }))) return;
  btn.disabled    = true;
  btn.textContent = t('common.saving');
  try {
    await orgApi('remove-school-admin', 'POST', { userId });
    btn.closest('td').innerHTML = '';
  } catch (err) {
    alert(t('admin.divisionAdmin.schools.removeAdminRoleError', { error: err.message }));
    btn.disabled    = false;
    btn.textContent = t('admin.divisionAdmin.schools.removeAdminRole');
  }
}

// ─── Detach teacher ───────────────────────────────────────────────────────

async function detachTeacher(userId, email, btn) {
  if (!confirm(t('admin.divisionAdmin.schools.detachConfirm', { email }))) return;
  btn.disabled = true;
  btn.textContent = t('admin.divisionAdmin.schools.detaching');
  try {
    await orgApi('detach-teacher', 'POST', { userId });
    btn.closest('tr').remove();
  } catch (err) {
    alert(t('admin.divisionAdmin.schools.detachError', { error: err.message }));
    btn.disabled    = false;
    btn.textContent = t('admin.divisionAdmin.schools.detach');
  }
}

// ─── Invite Teacher ─────────────────────────────────────────────────────

function showInviteTeacherModal() {
  document.getElementById('invite-email-input').value = '';
  document.getElementById('invite-notice').classList.add('hidden');
  document.getElementById('invite-notice').textContent = '';

  // Populate school selector from allSchools
  const select = document.getElementById('invite-school-select');
  select.innerHTML = `<option value="">${t('admin.divisionAdmin.inviteTeacher.anySchool')}</option>`;
  allSchools.forEach(s => {
    const opt = document.createElement('option');
    opt.value = s.id;
    opt.textContent = s.name;
    select.appendChild(opt);
  });
  select.value = '';

  document.getElementById('invite-teacher-modal').classList.remove('hidden');
  setTimeout(() => document.getElementById('invite-email-input').focus(), 100);
}

async function inviteTeacher() {
  const email = document.getElementById('invite-email-input').value.trim();
  const schoolId = document.getElementById('invite-school-select').value || null;
  const notice = document.getElementById('invite-notice');
  if (!email) {
    notice.textContent = t('admin.divisionAdmin.inviteTeacher.emailRequired');
    notice.className = 'notice';
    notice.classList.remove('hidden');
    return;
  }

  const btn = document.querySelector('#invite-teacher-modal .btn--primary');
  btn.disabled = true;
  btn.textContent = t('admin.divisionAdmin.inviteTeacher.sending');

  try {
    const body = { email };
    if (schoolId) body.schoolId = schoolId;
    await orgApi('invite-teacher', 'POST', body);
    notice.textContent = t('admin.divisionAdmin.inviteTeacher.sent');
    notice.className = 'notice';
    notice.classList.remove('hidden');
    document.getElementById('invite-email-input').value = '';
    document.getElementById('invite-school-select').value = '';
    // Reload both schools and the drill-down if open
    await Promise.all([loadSchools(), loadDivisionReport()]);
    setTimeout(() => {
      document.getElementById('invite-teacher-modal').classList.add('hidden');
      notice.classList.add('hidden');
    }, 2000);
  } catch (err) {
    notice.textContent = t('admin.divisionAdmin.inviteTeacher.failed', { error: err.message });
    notice.className = 'notice text-accent';
    notice.classList.remove('hidden');
  } finally {
    btn.disabled = false;
    btn.textContent = t('admin.divisionAdmin.inviteTeacher.sendButton');
  }
}

// ─── CSV Export ───────────────────────────────────────────────────────────

async function exportDivisionCsv() {
  const btn = document.querySelector('[onclick="exportDivisionCsv()"]');
  if (btn) { btn.disabled = true; btn.textContent = t('admin.divisionAdmin.csv.exporting'); }

  try {
    if (!allSchools.length) { alert(t('admin.divisionAdmin.csv.noSchools')); return; }

    const headers = [t('admin.divisionAdmin.schools.tableHeaders.school'), t('admin.divisionAdmin.schools.tableHeaders.teachers'), t('admin.divisionAdmin.stats.totalSessions')];
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
    alert(t('admin.divisionAdmin.csv.failed', { error: err.message }));
  } finally {
    if (btn) { btn.disabled = false; btn.textContent = t('admin.divisionAdmin.csv.button'); }
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

function capitalize(str) {
  if (!str) return '';
  return str.charAt(0).toUpperCase() + str.slice(1);
}
