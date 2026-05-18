// ─── Divisions ────────────────────────────────────────────────────

async function loadDivisions() {
  const container = document.getElementById('divisions-container');
  try {
    const divisions = await adminApi('divisions');
    allDivisionsList = divisions;

    if (!divisions.length) {
      container.innerHTML = `<div class="empty-state"><p class="label">${t('admin.entities.divisions.noData')}</p></div>`;
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
              placeholder="${t('admin.entities.teachers.addNotes')}"
              onblur="setNotes('division','${d.id}',this.value)"
              onkeydown="if(event.key==='Enter')this.blur()">
          </td>
          <td>
            <button class="btn btn--small" style="border:1px solid var(--accent); background:transparent; color:var(--accent); cursor:pointer; font-family:'DM Sans',sans-serif; font-size:0.75rem; padding:0.3rem 0.75rem;"
              onclick="deleteDivision('${d.id}', '${escapeHtml(d.name)}')">${t('common.delete')}</button>
          </td>
        </tr>`;
    }).join('');

    container.innerHTML = `
      <table class="admin-table">
        <thead>
          <tr>
            <th>${t('admin.entities.divisions.tableHeaders.name')}</th>
            <th>${t('admin.entities.divisions.tableHeaders.size')}</th>
            <th>${t('admin.entities.divisions.tableHeaders.tier')}</th>
            <th>${t('admin.entities.divisions.tableHeaders.expires')}</th>
            <th>${t('admin.entities.divisions.tableHeaders.notes')}</th>
            <th>${t('admin.entities.divisions.tableHeaders.actions')}</th>
          </tr>
        </thead>
        <tbody>${rows}</tbody>
      </table>`;
  } catch (err) {
    container.innerHTML = `<p class="label text-accent">${t('admin.entities.divisions.loadError', { error: escapeHtml(err.message) })}</p>`;
  }
}

async function createDivision() {
  const name = document.getElementById('new-div-name').value.trim();
  const band = document.getElementById('new-div-band').value;
  const tier = document.getElementById('new-div-tier').value;
  if (!name) { alert(t('admin.entities.divisions.nameRequired')); return; }

  try {
    await adminApi('create-division', 'POST', { name, enrolmentBand: band || null, tier });
    document.getElementById('new-div-name').value = '';
    document.getElementById('new-div-band').value = '';
    document.getElementById('new-div-tier').value = 'free';
    toggleCreateForm('division-form');
    await Promise.all([loadDivisions(), loadOverview()]);
  } catch (err) {
    alert(t('admin.entities.divisions.createError', { error: err.message }));
  }
}

// ─── Schools ──────────────────────────────────────────────────────

async function loadSchools() {
  const container = document.getElementById('schools-container');
  try {
    const schools = await adminApi('schools');
    allSchoolsList = schools;

    if (!schools.length) {
      container.innerHTML = `<div class="empty-state"><p class="label">${t('admin.entities.schools.noData')}</p></div>`;
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
              placeholder="${t('admin.entities.teachers.addNotes')}"
              onblur="setNotes('school','${s.id}',this.value)"
              onkeydown="if(event.key==='Enter')this.blur()">
          </td>
          <td>
            <button class="btn btn--small" style="border:1px solid var(--accent); background:transparent; color:var(--accent); cursor:pointer; font-family:'DM Sans',sans-serif; font-size:0.75rem; padding:0.3rem 0.75rem;"
              onclick="deleteSchool('${s.id}', '${escapeHtml(s.name)}')">${t('common.delete')}</button>
          </td>
        </tr>`;
    }).join('');

    container.innerHTML = `
      <table class="admin-table">
        <thead>
          <tr>
            <th>${t('admin.entities.schools.tableHeaders.name')}</th>
            <th>${t('admin.entities.schools.tableHeaders.division')}</th>
            <th>${t('admin.entities.schools.tableHeaders.tier')}</th>
            <th>${t('admin.entities.schools.tableHeaders.notes')}</th>
            <th>${t('admin.entities.schools.tableHeaders.actions')}</th>
          </tr>
        </thead>
        <tbody>${rows}</tbody>
      </table>`;
  } catch (err) {
    container.innerHTML = `<p class="label text-accent">${t('admin.entities.schools.loadError', { error: escapeHtml(err.message) })}</p>`;
  }
}

async function createSchool() {
  const name      = document.getElementById('new-school-name').value.trim();
  const divisionId = document.getElementById('new-school-div').value.trim() || null;
  const tier      = document.getElementById('new-school-tier').value;
  if (!name) { alert(t('admin.entities.schools.nameRequired')); return; }

  try {
    await adminApi('create-school', 'POST', { name, divisionId, tier });
    document.getElementById('new-school-name').value = '';
    document.getElementById('new-school-div').value  = '';
    document.getElementById('new-school-tier').value = 'free';
    toggleCreateForm('school-form');
    await Promise.all([loadSchools(), loadOverview()]);
  } catch (err) {
    alert(t('admin.entities.schools.createError', { error: err.message }));
  }
}

// ─── Teachers ─────────────────────────────────────────────────────

async function loadTeachers() {
  const container = document.getElementById('teachers-container');
  try {
    allTeachers = await adminApi('teachers');
    renderTeachers(allTeachers);
  } catch (err) {
    container.innerHTML = `<p class="label text-accent">${t('admin.entities.teachers.loadError', { error: escapeHtml(err.message) })}</p>`;
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
    container.innerHTML = `<div class="empty-state"><p class="label">${t('admin.entities.teachers.noData')}</p></div>`;
    return;
  }

  const rows = teachers.map(t => {
    const org = t.school_name
      ? escapeHtml(t.school_name) + (t.division_name_org ? ` <span style="color:var(--muted);">/ ${escapeHtml(t.division_name_org)}</span>` : '')
      : (t.division_name_org ? escapeHtml(t.division_name_org) : '<span style="color:var(--muted);">—</span>');

    const effectiveTier = t.tier_override || t.tier || 'free';

    // Trial status
    let trialHtml = '<span style="color:var(--muted); font-size:0.8rem;">—</span>';
    if (t.expires_at) {
      const exp = new Date(t.expires_at);
      const now = new Date();
      const dateStr = exp.toLocaleDateString('en-CA', { year:'numeric', month:'short', day:'numeric' });
      const daysLeft = Math.ceil((exp - now) / (1000 * 60 * 60 * 24));
      if (exp > now) {
        trialHtml = `<span style="color:#4a7c59; font-size:0.8rem;">${t('admin.entities.teachers.expires', { date: dateStr })}</span>`;
        if (daysLeft <= 7) {
          trialHtml = `<span style="color:var(--accent); font-size:0.8rem; font-weight:500;">${t('admin.entities.teachers.expires', { date: dateStr })}</span>`;
        }
      } else {
        trialHtml = `<span style="color:var(--accent); font-size:0.8rem;">${t('admin.entities.teachers.expired', { date: dateStr })}</span>`;
      }
    }

    const deactivatedBadge = t.is_deactivated
      ? `<span style="color:var(--accent); font-size:0.75rem; margin-left:0.4rem;">${t('admin.entities.teachers.deactivated')}</span>`
      : '';

    const deactivateBtn = t.is_deactivated
      ? `<button class="btn btn--ghost btn--small" onclick="toggleDeactivation('${escapeHtml(t.id)}', false, this)">${t('admin.entities.teachers.reactivate')}</button>`
      : `<button class="btn btn--small" style="border:1px solid var(--warm-mid); background:transparent; color:var(--muted); cursor:pointer; font-family:'DM Sans',sans-serif; font-size:0.75rem; padding:0.3rem 0.75rem;" onclick="toggleDeactivation('${escapeHtml(t.id)}', true, this)">${t('admin.entities.teachers.deactivate')}</button>`;

    return `
      <tr style="${t.is_deactivated ? 'opacity:0.55;' : ''}">
        <td style="font-size:0.85rem;">${escapeHtml(t.email || '—')}${deactivatedBadge}</td>
        <td style="font-size:0.82rem;">${org}</td>
        <td>
          <select class="tier-select" onchange="setTier('teacher','${t.id}',this.value)">
            ${tierOptions(effectiveTier)}
          </select>
        </td>
        <td style="white-space:nowrap;">
          ${trialHtml}
          <button class="btn btn--ghost btn--small" style="margin-left:0.5rem; padding:0.2rem 0.5rem; font-size:0.65rem;"
            onclick="extendTrial('${t.id}', 30)">${t('admin.entities.teachers.extend30d')}</button>
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
            placeholder="${t('admin.entities.teachers.addNotes')}"
            onblur="setNotes('teacher','${t.id}',this.value)"
            onkeydown="if(event.key==='Enter')this.blur()">
        </td>
        <td>
          ${deactivateBtn}
          <button class="btn btn--ghost btn--small" onclick="openReassignModal('${t.id}', '${escapeHtml(t.email || '')}', '${t.school_id || ''}', '${t.division_id || ''}')">${t('admin.entities.teachers.reassign')}</button>
          <button class="btn btn--small" style="margin-left:0.5rem; border:1px solid var(--accent); background:transparent; color:var(--accent); cursor:pointer; font-family:'DM Sans',sans-serif; font-size:0.75rem; padding:0.3rem 0.75rem;"
            onclick="deleteTeacher('${t.id}', '${escapeHtml(t.email || '')}')">${t('common.delete')}</button>
        </td>
      </tr>`;
  }).join('');

  container.innerHTML = `
    <table class="admin-table">
      <thead>
        <tr>
          <th>${t('admin.entities.teachers.tableHeaders.email')}</th>
          <th>${t('admin.entities.teachers.tableHeaders.schoolDivision')}</th>
          <th>${t('admin.entities.teachers.tableHeaders.tierOverride')}</th>
          <th>${t('admin.entities.teachers.tableHeaders.trial')}</th>
          <th>${t('admin.entities.teachers.tableHeaders.role')}</th>
          <th>${t('admin.entities.teachers.tableHeaders.country')}</th>
          <th>${t('admin.entities.teachers.tableHeaders.notes')}</th>
          <th>${t('admin.entities.teachers.tableHeaders.actions')}</th>
        </tr>
      </thead>
      <tbody>${rows}</tbody>
    </table>`;
}

// ─── Reassign Modal ───────────────────────────────────────────────

function openReassignModal(userId, email, currentSchoolId, currentDivisionId) {
  if (!allSchoolsList.length || !allDivisionsList.length) {
    alert(t('admin.entities.teachers.orgsLoading'));
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
      <p class="label" style="margin-bottom:1rem;">${t('admin.entities.teachers.reassignTitle', { email: escapeHtml(email || userId) })}</p>

      <div style="margin-bottom:1rem;">
        <label class="label" style="display:block; margin-bottom:0.4rem;">${t('admin.entities.teachers.reassignSchool')}</label>
        <select id="reassign-school" class="input-field" style="font-size:0.875rem;">
          <option value="">${t('admin.entities.teachers.noneOption')}</option>
          ${schoolOpts}
        </select>
      </div>

      <div style="margin-bottom:1.5rem;">
        <label class="label" style="display:block; margin-bottom:0.4rem;">${t('admin.entities.teachers.reassignDivision')}</label>
        <select id="reassign-division" class="input-field" style="font-size:0.875rem;">
          <option value="">${t('admin.entities.teachers.noneOption')}</option>
          ${divisionOpts}
        </select>
      </div>

      <div style="display:flex; gap:0.75rem;">
        <button class="btn btn--primary btn--small" onclick="submitReassign('${userId}')">${t('admin.entities.teachers.reassignSubmit')}</button>
        <button class="btn btn--ghost btn--small" onclick="document.getElementById('reassign-modal').remove()">${t('admin.entities.teachers.reassignCancel')}</button>
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
    alert(t('admin.entities.teachers.reassignError', { error: err.message }));
  }
}

// ─── Tier, Role, Notes Updates ─────────────────────────────────────

async function setTier(entityType, entityId, tier) {
  try {
    await adminApi('set-tier', 'POST', { entityType, entityId, tier });
  } catch (err) {
    alert(t('admin.entities.teachers.tierError', { error: err.message }));
    if (entityType === 'division') loadDivisions();
    else if (entityType === 'school') loadSchools();
    else loadTeachers();
  }
}

async function setRole(userId, role) {
  try {
    await adminApi('set-role', 'POST', { userId, role });
  } catch (err) {
    alert(t('admin.entities.teachers.roleError', { error: err.message }));
    loadTeachers();
  }
}

async function setNotes(entityType, entityId, notes) {
  try {
    await adminApi('set-notes', 'POST', { entityType, entityId, notes });
  } catch (err) {
    console.error('Could not save notes:', err.message);
  }
}

async function extendTrial(userId, days) {
  try {
    const teacher = allTeachers.find(t => t.id === userId);
    const baseDate = (teacher?.expires_at && new Date(teacher.expires_at) > new Date())
      ? new Date(teacher.expires_at)
      : new Date();
    baseDate.setDate(baseDate.getDate() + days);
    const iso = baseDate.toISOString();
    await adminApi('set-expires', 'POST', { entityType: 'teacher', entityId: userId, expiresAt: iso });
    await loadTeachers();
  } catch (err) {
    alert(t('admin.entities.teachers.trialError', { error: err.message }));
  }
}

async function toggleDeactivation(userId, deactivate, btn) {
  const actionLabel = deactivate
    ? t('admin.entities.teachers.deactivate')
    : t('admin.entities.teachers.reactivate');
  const confirmMsg = deactivate
    ? t('admin.entities.teachers.deactivateConfirm')
    : t('admin.entities.teachers.reactivateConfirm');
  if (!confirm(confirmMsg)) return;

  btn.disabled    = true;
  btn.textContent = actionLabel + '…';

  try {
    await adminApi('toggle-deactivation', 'POST', { userId, deactivated: deactivate });
    await loadTeachers();
  } catch (err) {
    alert(t('admin.entities.teachers.statusError', { error: err.message }));
    btn.disabled    = false;
    btn.textContent = actionLabel;
  }
}

// ─── Delete operations ────────────────────────────────────────────

async function deleteTeacher(userId, email) {
  if (!confirm(t('admin.entities.teachers.deleteConfirm', { email: email || userId }))) return;
  try {
    await adminApi('delete-teacher', 'POST', { userId });
    await Promise.all([loadTeachers(), loadOverview()]);
  } catch (err) {
    alert(t('admin.entities.teachers.deleteError', { error: err.message }));
  }
}

async function deleteSchool(schoolId, name) {
  if (!confirm(t('admin.entities.schools.deleteConfirm', { name: name || schoolId }))) return;
  try {
    await adminApi('delete-school', 'POST', { schoolId });
    await Promise.all([loadSchools(), loadDivisions(), loadTeachers(), loadOverview()]);
  } catch (err) {
    alert(t('admin.entities.schools.deleteError', { error: err.message }));
  }
}

async function deleteDivision(divisionId, name) {
  if (!confirm(t('admin.entities.divisions.deleteConfirm', { name: name || divisionId }))) return;
  try {
    await adminApi('delete-division', 'POST', { divisionId });
    await Promise.all([loadDivisions(), loadSchools(), loadTeachers(), loadOverview()]);
  } catch (err) {
    alert(t('admin.entities.divisions.deleteError', { error: err.message }));
  }
}
