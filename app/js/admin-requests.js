// ─── Requests ─────────────────────────────────────────────────────

async function loadRequests() {
  const container = document.getElementById('requests-container');
  if (!container) return;

  try {
    const requests = await adminApi('list-requests');

    const pending = requests.filter(r => r.status === 'pending');

    // Badge the tab with pending count
    const tab = document.getElementById('requests-tab');
    if (tab) tab.textContent = pending.length > 0
      ? t('admin.tabs.requestsWithCount', { count: pending.length })
      : t('admin.tabs.requests');

    if (!requests.length) {
      container.innerHTML = `<div class="empty-state"><p class="label">${t('admin.requests.noData')}</p></div>`;
      return;
    }

    const rows = requests.map(r => {
      const date = new Date(r.created_at).toLocaleDateString('en-CA', { year:'numeric', month:'short', day:'numeric' });
      const statusBadge = r.status === 'pending'
        ? `<span style="color:var(--ink); font-weight:500;">${t('admin.requests.statusPending')}</span>`
        : r.status === 'approved'
          ? `<span style="color:#4a7c59;">${t('admin.requests.statusApproved')}</span>`
          : `<span style="color:var(--muted);">${t('admin.requests.statusRejected')}</span>`;

      const typeLabel = {
        access:          t('admin.requests.typeNewAccount'),
        premium_trial:   t('admin.requests.typePremiumTrial'),
        school_plan:     t('admin.requests.typeSchoolPlan'),
        division_plan:   t('admin.requests.typeDivisionPlan'),
      }[r.request_type] || r.request_type;

      const isExisting = !!r.teacher_id;
      const teacherTag = isExisting
        ? `<span style="display:inline-block; padding:0.1rem 0.45rem; font-size:0.6rem; letter-spacing:0.1em; text-transform:uppercase; font-weight:500; border:1px solid var(--ink); margin-left:0.4rem;">${t('admin.requests.existingTeacher')}</span>`
        : '';

      const actions = r.status === 'pending' ? `
        <button class="btn btn--ghost btn--small" onclick="approveRequest('${r.id}', '${escapeHtml(r.email)}')">${t('admin.requests.approve')}</button>
        <button class="btn btn--small" style="margin-left:0.5rem; border:1px solid var(--warm-mid); background:transparent; color:var(--muted); cursor:pointer; font-family:'DM Sans',sans-serif; font-size:0.75rem; padding:0.3rem 0.75rem;"
          onclick="rejectRequest('${r.id}')">${t('admin.requests.reject')}</button>
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
            <th>${t('admin.requests.tableHeaders.nameEmail')}</th>
            <th>${t('admin.requests.tableHeaders.type')}</th>
            <th>${t('admin.requests.tableHeaders.school')}</th>
            <th>${t('admin.requests.tableHeaders.division')}</th>
            <th>${t('admin.requests.tableHeaders.message')}</th>
            <th>${t('admin.requests.tableHeaders.submitted')}</th>
            <th>${t('admin.requests.tableHeaders.status')}</th>
            <th>${t('admin.requests.tableHeaders.actions')}</th>
            <th>${t('admin.requests.tableHeaders.inviteLink')}</th>
          </tr>
        </thead>
        <tbody>${rows}</tbody>
      </table>`;
  } catch (err) {
    container.innerHTML = `<p class="label" style="color:var(--accent);">${t('admin.requests.loadError', { error: escapeHtml(err.message) })}</p>`;
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
    if (tab) tab.textContent = pending.length > 0
      ? t('admin.tabs.invitationsWithCount', { count: pending.length })
      : t('admin.tabs.invitations');

    if (!invitations.length) {
      container.innerHTML = `<div class="empty-state"><p class="label">${t('admin.invitations.noData')}</p></div>`;
      return;
    }

    const renderRows = (list, isExpired) => list.map(inv => {
      const date = new Date(inv.created_at).toLocaleDateString('en-CA', { year:'numeric', month:'short', day:'numeric' });
      const expDate = new Date(inv.expires_at).toLocaleDateString('en-CA', { year:'numeric', month:'short', day:'numeric' });
      const org = inv.schools?.name || inv.divisions?.name || '—';
      const status = isExpired
        ? `<span style="color:var(--accent);">${t('admin.invitations.expired', { date: expDate })}</span>`
        : `<span style="color:#4a7c59;">${t('admin.invitations.expires', { date: expDate })}</span>`;
      const emailWarning = inv.lastEmailOk === false
        ? `<span style="display:inline-block; width:6px; height:6px; background:var(--accent); border-radius:50%; margin-left:0.4rem; vertical-align:middle;" title="${t('admin.invitations.emailSendFailed')}"></span>`
        : '';
      return `
        <tr>
          <td><strong>${escapeHtml(inv.email)}</strong>${emailWarning}</td>
          <td style="font-size:0.85rem;">${escapeHtml(inv.role.replace(/_/g, ' '))}</td>
          <td style="font-size:0.85rem;">${escapeHtml(org)}</td>
          <td style="font-size:0.8rem; color:var(--muted);">${date}</td>
          <td>${status}</td>
          <td>
            <button class="btn btn--ghost btn--small" onclick="resendInvite('${inv.id}', '${escapeHtml(inv.email)}')">${t('admin.invitations.resend')}</button>
          </td>
          <td id="resend-status-${inv.id}"></td>
        </tr>`;
    }).join('');

    let html = '';
    if (pending.length) {
      html += `
        <p class="label" style="margin-bottom:0.5rem;">${t('admin.invitations.activeLabel')}</p>
        <table class="admin-table">
          <thead>
            <tr><th>${t('admin.invitations.tableHeaders.email')}</th><th>${t('admin.invitations.tableHeaders.role')}</th><th>${t('admin.invitations.tableHeaders.org')}</th><th>${t('admin.invitations.tableHeaders.sent')}</th><th>${t('admin.invitations.tableHeaders.status')}</th><th>${t('admin.invitations.tableHeaders.actions')}</th><th></th></tr>
          </thead>
          <tbody>${renderRows(pending, false)}</tbody>
        </table>`;
    }
    if (expired.length) {
      html += `
        <p class="label" style="margin:1.5rem 0 0.5rem;">${t('admin.invitations.expiredLabel')}</p>
        <table class="admin-table">
          <thead>
            <tr><th>${t('admin.invitations.tableHeaders.email')}</th><th>${t('admin.invitations.tableHeaders.role')}</th><th>${t('admin.invitations.tableHeaders.org')}</th><th>${t('admin.invitations.tableHeaders.sent')}</th><th>${t('admin.invitations.tableHeaders.status')}</th><th>${t('admin.invitations.tableHeaders.actions')}</th><th></th></tr>
          </thead>
          <tbody>${renderRows(expired, true)}</tbody>
        </table>`;
    }

    container.innerHTML = html;
  } catch (err) {
    container.innerHTML = `<p class="label" style="color:var(--accent);">${t('admin.invitations.loadError', { error: escapeHtml(err.message) })}</p>`;
  }
}

async function resendInvite(invitationId, email) {
  if (!confirm(t('admin.invitations.resendConfirm', { email }))) return;
  try {
    const data = await adminApi('resend-invite', 'POST', { invitationId });
    const cell = document.getElementById(`resend-status-${invitationId}`);
    if (cell) {
      if (data.emailOk === false) {
        cell.innerHTML = `<span style="color:var(--accent); font-size:0.75rem;">${t('admin.invitations.emailFailed', { error: escapeHtml(data.emailError || 'Unknown') })}</span>`;
      } else {
        cell.innerHTML = `<span style="color:#4a7c59; font-size:0.75rem;">${t('admin.invitations.resent')}</span>`;
      }
    }
    await loadInvitations();
  } catch (err) {
    alert(t('admin.invitations.resendError', { error: err.message }));
  }
}

async function approveRequest(requestId, email) {
  if (!confirm(t('admin.requests.approveConfirm', { email }))) return;
  try {
    const data = await adminApi('approve-request', 'POST', { requestId });
    const cell = document.getElementById(`invite-link-${requestId}`);
    if (cell && data.inviteUrl) {
      let html = `
        <input type="text" value="${escapeHtml(data.inviteUrl)}" readonly
          style="font-size:0.7rem; font-family:monospace; border:1px solid var(--warm-mid);
                 padding:0.25rem 0.4rem; width:220px; background:var(--paper);"
          onclick="this.select()">`;
      if (data.emailOk === false) {
        html += `<div style="font-size:0.7rem; color:var(--accent); margin-top:0.25rem;">${t('admin.requests.emailFailed', { error: escapeHtml(data.emailError || 'Unknown error') })}</div>`;
      }
      cell.innerHTML = html;
    }
    await loadRequests();
  } catch (err) {
    alert(t('admin.requests.approveError', { error: err.message }));
  }
}

async function rejectRequest(requestId) {
  const notes = prompt(t('admin.requests.rejectPrompt'));
  if (notes === null) return;
  try {
    await adminApi('reject-request', 'POST', { requestId, notes: notes || null });
    await loadRequests();
  } catch (err) {
    alert(t('admin.requests.rejectError', { error: err.message }));
  }
}
