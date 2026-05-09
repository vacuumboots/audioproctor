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
  if (notes === null) return;
  try {
    await adminApi('reject-request', 'POST', { requestId, notes: notes || null });
    await loadRequests();
  } catch (err) {
    alert('Could not reject request: ' + err.message);
  }
}
