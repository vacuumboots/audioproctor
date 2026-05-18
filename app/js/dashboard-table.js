// ─── Uploads Table ───────────────────────────────────────────────

async function loadUploads() {
  const container = document.getElementById('uploads-container');

  const { data: uploads, error } = await supabaseClient
    .from('uploads')
    .select('id, filename, label, access_code, exit_word, expires_at, storage_path, file_size_mb, assessment_type, text_char_count, processing_status')
    .order('created_at', { ascending: false });

  if (error) {
    container.textContent = '';
    const p = document.createElement('p');
    p.className = 'label text-accent';
    p.textContent = t('dashboard.couldNotLoad');
    container.appendChild(p);
    return;
  }

  allUploads = uploads || [];

  if (!uploads || uploads.length === 0) {
    container.innerHTML = `
      <div class="empty-state" style="text-align:left; padding:2.5rem; border:1px solid var(--ink); background:var(--paper);">
        <h2 style="font-family:'Playfair Display',serif; font-size:1.4rem; margin-bottom:0.5rem; color:var(--ink);">${t('dashboard.emptyStateTitle')}</h2>
        <p style="color:var(--muted); font-size:0.9rem; margin-bottom:1.5rem; line-height:1.5;">
          Once you upload an audio file, you'll get an <strong>access code</strong> for your student and an <strong>exit word</strong> that you read aloud when the assessment is finished.
        </p>

        <div style="display:flex; flex-direction:column; gap:1rem; margin-bottom:1.5rem;">
          <div style="border:1px solid var(--warm-mid); padding:1rem;">
            <p class="label" style="margin-bottom:0.3rem;">${t('dashboard.emptyStateStep1Title')}</p>
            <p style="font-size:0.85rem; color:var(--muted); margin:0;">${t('dashboard.emptyStateStep1Desc')}</p>
          </div>
          <div style="border:1px solid var(--warm-mid); padding:1rem;">
            <p class="label" style="margin-bottom:0.3rem;">${t('dashboard.emptyStateStep2Title')}</p>
            <p style="font-size:0.85rem; color:var(--muted); margin:0;">${t('dashboard.emptyStateStep2Desc')}</p>
          </div>
          <div style="border:1px solid var(--warm-mid); padding:1rem;">
            <p class="label" style="margin-bottom:0.3rem;">${t('dashboard.emptyStateStep3Title')}</p>
            <p style="font-size:0.85rem; color:var(--muted); margin:0;">${t('dashboard.emptyStateStep3Desc')}</p>
          </div>
        </div>

        <button class="btn" onclick="document.getElementById('upload-modal').style.display='block'" style="font-size:0.85rem; padding:0.6rem 1.2rem;">${t('dashboard.emptyStateUploadBtn')}
        </button>
      </div>`;
    return;
  }
  // Fetch summaries for paid tiers — fire in parallel with rendering
  if (currentTier !== 'free') {
    const { data: summaryRows } = await supabaseClient.rpc('get_my_upload_summaries');
    allSummaries = {};
    (summaryRows || []).forEach(s => { allSummaries[s.upload_id] = s; });
  }

  const rows = uploads.map(u => {
    const { text: expiryText, expired } = formatExpiry(u.expires_at);
    const chipClass    = expired ? 'chip--expired' : 'chip--active';
    const isText       = u.assessment_type === 'text';
    const isAudio      = !isText;
    const displayName  = u.label || (isText ? 'Text Assessment' : u.filename);
    const processingStatus = u.processing_status;

    // Show a processing badge for audio uploads still being normalized
    let statusBadge = '';
    if (isAudio && processingStatus && processingStatus !== 'ready') {
      if (processingStatus === 'pending' || processingStatus === 'processing') {
        statusBadge = `<span class="chip chip--active" style="font-size:0.65rem; margin-left:0.4rem; background:var(--warm-mid); border-color:var(--ink);">${t('dashboard.processingBadge')}</span>`;
      } else if (processingStatus === 'failed') {
        statusBadge = `<span class="chip" style="font-size:0.65rem; margin-left:0.4rem; border-color:var(--accent); color:var(--accent);">${t('dashboard.failedBadge')}</span>`;
      }
    }

    const typeBadge    = isText
      ? `<span class="chip chip--active" style="font-size:0.65rem; margin-left:0.4rem;">${t('dashboard.textBadge')}</span>`
      : '';
    const metaLine     = isText
      ? `<div class="col-assessment__filename">${t('dashboard.textCharCountPlain', { count: u.text_char_count || 0 })}</div>`
      : (u.label && u.label !== u.filename ? `<div class="col-assessment__filename">${escapeHtml(u.filename)}</div>` : '');

    const extendBtn = (!expired && currentTier !== 'free')
      ? `<button class="btn btn--ghost btn--small" onclick="openExpiryModal('${u.id}', '${u.expires_at}')">${t('dashboard.extendExpiry')}</button>`
      : '';

    const retryBtn = (processingStatus === 'failed')
      ? `<button class="btn btn--ghost btn--small" onclick="retryNormalize('${u.id}', this)" style="color:var(--accent);">${t('dashboard.retry')}</button>`
      : '';

    const statsBlock = buildUploadStatsBlock(u.id);

    return `
      <tr>
        <td class="col-assessment">
          <div class="col-assessment__label">${escapeHtml(displayName)}${typeBadge}${statusBadge}</div>
          ${metaLine}
          ${statsBlock}
        </td>
        <td class="col-code">
          <div class="cell-copy-group">
            <span class="monospace">${u.access_code}</span>
            <button class="btn btn--ghost btn--small" data-copy="${u.access_code}" onclick="copyCode(this.dataset.copy, this)">${t('dashboard.copyCode')}</button>
          </div>
        </td>
        <td class="col-word">
          <div class="cell-copy-group">
            <span>${escapeHtml(u.exit_word)}</span>
            <button class="btn btn--ghost btn--small" data-copy="${escapeHtml(u.exit_word)}" onclick="copyCode(this.dataset.copy, this)">${t('dashboard.copyCode')}</button>
          </div>
        </td>
        <td><span class="chip ${chipClass}">${expiryText}</span></td>
        <td>
          <div class="action-row">
            <button class="btn btn--ghost btn--small" onclick="openEditModal('${u.id}', '${escapeHtml(u.label || u.filename)}')">${t('dashboard.rename')}</button>
            <button class="btn btn--ghost btn--small" onclick="duplicateUpload('${u.id}', this)">${t('dashboard.duplicate')}</button>
            ${extendBtn}
            ${retryBtn}
            <button class="btn btn--danger btn--small" onclick="deleteUpload('${u.id}', '${u.storage_path}', this, '${u.assessment_type || 'audio'}')">${t('dashboard.deleteAssessment')}</button>
          </div>
        </td>
      </tr>`;
  }).join('');

  container.innerHTML = `
    <table class="uploads-table">
      <thead>
        <tr>
          <th>${t('dashboard.tableHeaders.assessment')}</th>
          <th>${t('dashboard.tableHeaders.accessCode')}</th>
          <th>${t('dashboard.tableHeaders.exitWord')}</th>
          <th>${t('dashboard.tableHeaders.expires')}</th>
          <th>${t('dashboard.tableHeaders.actions')}</th>
        </tr>
      </thead>
      <tbody>${rows}</tbody>
    </table>`;

  // Show insights card for paid tiers
  if (currentTier !== 'free') {
    loadInsights();
  }
}

function buildUploadStatsBlock(uploadId) {
  if (currentTier === 'free') return '';
  const s = allSummaries[uploadId];
  if (!s || !s.total_sessions) return `<div class="upload-stats">${t('dashboard.noSessions')}</div>`;

  const completionRate = Math.round(s.completions / s.total_sessions * 100);
  const rateColor = completionRate >= 80 ? '#27ae60' : completionRate >= 60 ? '#e67e22' : 'var(--accent)';
  const avgTime   = s.avg_listen_seconds ? formatDuration(s.avg_listen_seconds) : null;

  let parts = [
    `${t('dashboard.sessionsCount', { count: s.total_sessions, plural: s.total_sessions === 1 ? '' : 's' })}`,
    `<span style="color:${rateColor}; font-weight:500;">${t('dashboard.completionRate', { rate: completionRate })}</span>`,
  ];
  if (s.replays > 0) parts.push(`${t('dashboard.replaysCount', { count: s.replays, plural: s.replays === 1 ? '' : 's' })}`);
  if (avgTime)       parts.push(`${t('dashboard.avgTime', { time: avgTime })}`);

  return `<div class="upload-stats">${parts.join(' · ')}</div>`;
}

// ─── Delete ──────────────────────────────────────────────────────

async function deleteUpload(id, storagePath, btn, assessmentType) {
  if (!confirm(t('dashboard.deleteConfirm'))) return;

  btn.disabled    = true;
  btn.textContent = t('dashboard.deleting');

  // Audio: only delete the storage file if no other upload shares this path (duplicates)
  if (assessmentType !== 'text') {
    const { count } = await supabaseClient
      .from('uploads')
      .select('id', { count: 'exact', head: true })
      .eq('storage_path', storagePath)
      .neq('id', id);

    if (count === 0) {
      const { error: storageErr } = await supabaseClient.storage
        .from('audio-files')
        .remove([storagePath]);

      if (storageErr) {
        alert('Could not delete audio file: ' + storageErr.message);
        btn.disabled    = false;
        btn.textContent = t('dashboard.deleteAssessment');
        return;
      }
    }
  }

  // Delete images from assessment-images bucket for text assessments
  if (assessmentType === 'text') {
    const { data: upload } = await supabaseClient
      .from('uploads')
      .select('image_count, access_code')
      .eq('id', id)
      .maybeSingle();

    if (upload && upload.image_count > 0) {
      const teacherId = (await getSession()).user.id;
      const accessCode = upload.access_code;
      const paths = [];
      for (let i = 0; i < upload.image_count; i++) {
        for (const ext of ['png', 'jpg', 'webp']) {
          paths.push(teacherId + '/' + accessCode + '/img_' + i + '.' + ext);
        }
      }
      // Fire-and-forget — best-effort cleanup
      supabaseClient.storage.from('assessment-images').remove(paths);
    }
  }

  const { error: dbErr } = await supabaseClient
    .from('uploads')
    .delete()
    .eq('id', id);

  if (dbErr) alert('Audio file deleted, but could not remove record: ' + dbErr.message);

  await loadUploads();
  const session = await getSession();
  if (session) {
    await recalculateStorage(session.user.id);
    await loadQuota();
  }
}

// ─── Copy Code ───────────────────────────────────────────────────

async function copyCode(code, btn) {
  try {
    await navigator.clipboard.writeText(code);
    const original  = btn.textContent;
    btn.textContent = t('dashboard.copied');
    setTimeout(() => { btn.textContent = original; }, 1500);
  } catch {
    alert(t('dashboard.copyError', { code }));
  }
}

// ─── Rename ──────────────────────────────────────────────────────

function openEditModal(id, currentLabel) {
  editTargetId = id;
  document.getElementById('edit-label-input').value = currentLabel;
  document.getElementById('edit-label-modal').classList.remove('hidden');
  document.getElementById('edit-label-input').focus();
}

async function saveEditLabel() {
  const newLabel = document.getElementById('edit-label-input').value.trim();
  if (!newLabel || !editTargetId) return;

  const { error } = await supabaseClient
    .from('uploads')
    .update({ label: newLabel })
    .eq('id', editTargetId);

  if (error) {
    alert(t('dashboard.renameFailed', { error: error.message }));
    return;
  }

  document.getElementById('edit-label-modal').classList.add('hidden');
  editTargetId = null;
  await loadUploads();
}

// ─── Expiry ───────────────────────────────────────────────────────

function openExpiryModal(id, currentExpiry) {
  editTargetId = id;
  // Format the current expiry as a local datetime-local value
  const d   = new Date(currentExpiry);
  const pad = n => String(n).padStart(2, '0');
  const localVal = `${d.getFullYear()}-${pad(d.getMonth()+1)}-${pad(d.getDate())}T${pad(d.getHours())}:${pad(d.getMinutes())}`;
  document.getElementById('expiry-date-input').value = localVal;
  document.getElementById('edit-expiry-modal').classList.remove('hidden');
}

async function saveExpiryDate() {
  const val = document.getElementById('expiry-date-input').value;
  if (!val || !editTargetId) return;

  const newExpiry = new Date(val);
  if (isNaN(newExpiry.getTime())) {
    alert(t('dashboard.extendInvalidDate'));
    return;
  }
  if (newExpiry <= new Date()) {
    alert(t('dashboard.extendFutureDate'));
    return;
  }

  const { error } = await supabaseClient
    .from('uploads')
    .update({ expires_at: newExpiry })
    .eq('id', editTargetId);

  if (error) {
    alert(t('dashboard.extendFailed', { error: error.message }));
    return;
  }

  document.getElementById('edit-expiry-modal').classList.add('hidden');
  editTargetId = null;
  await loadUploads();
}

async function extendSevenDays() {
  if (!editTargetId) return;
  const newExpiry = new Date(Date.now() + 7 * 24 * 60 * 60 * 1000).toISOString();

  const { error } = await supabaseClient
    .from('uploads')
    .update({ expires_at: newExpiry })
    .eq('id', editTargetId);

  if (error) {
    alert(t('dashboard.extendFailed', { error: error.message }));
    return;
  }

  document.getElementById('edit-expiry-modal').classList.add('hidden');
  editTargetId = null;
  await loadUploads();
}

// ─── CSV Export ──────────────────────────────────────────────────

async function exportCsv() {
  const btn = document.getElementById('btn-export-csv');
  if (btn) { btn.disabled = true; btn.textContent = t('dashboard.exportingCSV'); }

  try {
    const { data, error } = await supabaseClient.rpc('get_my_session_events');
    if (error) throw new Error(error.message);

    if (!data || data.length === 0) {
      alert(t('dashboard.noSessionDataToExport'));
      return;
    }

    const headers = ['Assessment', 'Access Code', 'Event Type', 'Occurred At (UTC)', 'Position (seconds)'];
    const rows = data.map(r => [
      `"${(r.upload_label || '').replace(/"/g, '""')}"`,
      r.access_code,
      r.event_type,
      r.occurred_at,
      r.position_seconds != null ? r.position_seconds : '',
    ]);

    const csv  = [headers.join(','), ...rows.map(r => r.join(','))].join('\n');
    const blob = new Blob([csv], { type: 'text/csv' });
    const url  = URL.createObjectURL(blob);
    const a    = document.createElement('a');
    a.href     = url;
    a.download = t('dashboard.csvFilename', { date: new Date().toISOString().slice(0, 10) });
    a.click();
    URL.revokeObjectURL(url);
  } catch (err) {
    alert(t('dashboard.exportFailed', { error: err.message }));
  } finally {
    if (btn) { btn.disabled = false; btn.textContent = t('dashboard.exportCSV'); }
  }
}

// ─── Insights ────────────────────────────────────────────────────

function loadInsights() {
  const card = document.getElementById('insights-card');
  if (!card) return;
  card.classList.remove('hidden');

  const container = document.getElementById('insights-container');
  const summaryValues = Object.values(allSummaries);

  if (summaryValues.length === 0) {
    container.innerHTML = `<div class="empty-state"><p class="label">${t('dashboard.insightsNoSessionData')}</p></div>`;
    return;
  }

  let totalSessions = 0, totalCompletions = 0, totalReplays = 0;
  let mostUsed = null;

  summaryValues.forEach(s => {
    totalSessions    += s.total_sessions || 0;
    totalCompletions += s.completions    || 0;
    totalReplays     += s.replays        || 0;
    if (!mostUsed || (s.total_sessions || 0) > (mostUsed.total_sessions || 0)) mostUsed = s;
  });

  const completionRate = totalSessions > 0 ? Math.round(totalCompletions / totalSessions * 100) : null;
  const rateColor = completionRate == null ? 'var(--muted)'
    : completionRate >= 80 ? '#27ae60'
    : completionRate >= 60 ? '#e67e22'
    : 'var(--accent)';

  const mostUsedUpload = mostUsed ? allUploads.find(u => u.id === mostUsed.upload_id) : null;
  const mostUsedName   = mostUsedUpload ? (mostUsedUpload.label || mostUsedUpload.filename) : null;

  container.innerHTML = `
    <div style="display:grid; grid-template-columns: repeat(3, 1fr); gap:1rem; margin-bottom:${mostUsedName ? '1.5rem' : '0'};">
      <div class="stat-box">
        <div class="stat-box__value">${totalSessions}</div>
        <div class="label">${t('dashboard.insightsTotalSessions')}</div>
      </div>
      <div class="stat-box">
        <div class="stat-box__value" style="color:${rateColor};">${completionRate != null ? completionRate + '%' : '—'}</div>
        <div class="label">${t('dashboard.insightsCompletionRate')}</div>
      </div>
      <div class="stat-box">
        <div class="stat-box__value">${totalReplays}</div>
        <div class="label">${t('dashboard.insightsTotalReplays')}</div>
      </div>
    </div>
    ${mostUsedName ? `<p style="font-size:0.85rem; color:var(--muted);">${t('dashboard.insightsMostUsed', { name: `<strong style="color:var(--ink);">${escapeHtml(mostUsedName)}</strong>`, count: mostUsed.total_sessions })}</p>` : ''}
  `;
}
