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
    p.textContent = 'Could not load uploads. Please refresh and try again.';
    container.appendChild(p);
    return;
  }

  allUploads = uploads || [];

  if (!uploads || uploads.length === 0) {
    container.innerHTML = `
      <div class="empty-state" style="text-align:left; padding:2.5rem; border:1px solid var(--ink); background:var(--paper);">
        <h2 style="font-family:'Playfair Display',serif; font-size:1.4rem; margin-bottom:0.5rem; color:var(--ink);">Upload your first assessment</h2>
        <p style="color:var(--muted); font-size:0.9rem; margin-bottom:1.5rem; line-height:1.5;">
          Once you upload an audio file, you'll get an <strong>access code</strong> for your student and an <strong>exit word</strong> that you read aloud when the assessment is finished.
        </p>

        <div style="display:flex; flex-direction:column; gap:1rem; margin-bottom:1.5rem;">
          <div style="border:1px solid var(--warm-mid); padding:1rem;">
            <p class="label" style="margin-bottom:0.3rem;">Step 1 — Label</p>
            <p style="font-size:0.85rem; color:var(--muted); margin:0;">Give the assessment a name your students will recognise (e.g. "Grade 7 Reading — May 26").</p>
          </div>
          <div style="border:1px solid var(--warm-mid); padding:1rem;">
            <p class="label" style="margin-bottom:0.3rem;">Step 2 — Choose Audio File</p>
            <p style="font-size:0.85rem; color:var(--muted); margin:0;">Select an MP3 or WAV file from your computer. WAV files convert to MP3 automatically.</p>
          </div>
          <div style="border:1px solid var(--warm-mid); padding:1rem;">
            <p class="label" style="margin-bottom:0.3rem;">Step 3 — Share</p>
            <p style="font-size:0.85rem; color:var(--muted); margin:0;">Give the student the <strong>access code</strong>. Keep the <strong>exit word</strong> private — only read it aloud when the assessment is done.</p>
          </div>
        </div>

        <button class="btn" onclick="document.getElementById('upload-modal').style.display='block'" style="font-size:0.85rem; padding:0.6rem 1.2rem;">
          Upload Audio
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
        statusBadge = '<span class="chip chip--active" style="font-size:0.65rem; margin-left:0.4rem; background:var(--warm-mid); border-color:var(--ink);">Normalizing…</span>';
      } else if (processingStatus === 'failed') {
        statusBadge = '<span class="chip" style="font-size:0.65rem; margin-left:0.4rem; border-color:var(--accent); color:var(--accent);">Failed</span>';
      }
    }

    const typeBadge    = isText
      ? '<span class="chip chip--active" style="font-size:0.65rem; margin-left:0.4rem;">Text</span>'
      : '';
    const metaLine     = isText
      ? `<div class="col-assessment__filename">${u.text_char_count || 0} chars</div>`
      : (u.label && u.label !== u.filename ? `<div class="col-assessment__filename">${escapeHtml(u.filename)}</div>` : '');

    const extendBtn = (!expired && currentTier !== 'free')
      ? `<button class="btn btn--ghost btn--small" onclick="openExpiryModal('${u.id}', '${u.expires_at}')">Edit Expiry</button>`
      : '';

    const retryBtn = (processingStatus === 'failed')
      ? `<button class="btn btn--ghost btn--small" onclick="retryNormalize('${u.id}', this)" style="color:var(--accent);">Retry</button>`
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
            <button class="btn btn--ghost btn--small" data-copy="${u.access_code}" onclick="copyCode(this.dataset.copy, this)">Copy</button>
          </div>
        </td>
        <td class="col-word">
          <div class="cell-copy-group">
            <span>${escapeHtml(u.exit_word)}</span>
            <button class="btn btn--ghost btn--small" data-copy="${escapeHtml(u.exit_word)}" onclick="copyCode(this.dataset.copy, this)">Copy</button>
          </div>
        </td>
        <td><span class="chip ${chipClass}">${expiryText}</span></td>
        <td>
          <div class="action-row">
            <button class="btn btn--ghost btn--small" onclick="openEditModal('${u.id}', '${escapeHtml(u.label || u.filename)}')">Rename</button>
            <button class="btn btn--ghost btn--small" onclick="duplicateUpload('${u.id}', this)">Duplicate</button>
            ${extendBtn}
            ${retryBtn}
            <button class="btn btn--danger btn--small" onclick="deleteUpload('${u.id}', '${u.storage_path}', this, '${u.assessment_type || 'audio'}')">Delete</button>
          </div>
        </td>
      </tr>`;
  }).join('');

  container.innerHTML = `
    <table class="uploads-table">
      <thead>
        <tr>
          <th>Assessment</th>
          <th>Access Code</th>
          <th>Exit Word</th>
          <th>Expires</th>
          <th>Actions</th>
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
  if (!s || !s.total_sessions) return `<div class="upload-stats">No sessions yet</div>`;

  const completionRate = Math.round(s.completions / s.total_sessions * 100);
  const rateColor = completionRate >= 80 ? '#27ae60' : completionRate >= 60 ? '#e67e22' : 'var(--accent)';
  const avgTime   = s.avg_listen_seconds ? formatDuration(s.avg_listen_seconds) : null;

  let parts = [
    `${s.total_sessions} session${s.total_sessions === 1 ? '' : 's'}`,
    `<span style="color:${rateColor}; font-weight:500;">${completionRate}% completed</span>`,
  ];
  if (s.replays > 0) parts.push(`${s.replays} replay${s.replays === 1 ? '' : 's'}`);
  if (avgTime)       parts.push(`Avg ${avgTime}`);

  return `<div class="upload-stats">${parts.join(' · ')}</div>`;
}

// ─── Delete ──────────────────────────────────────────────────────

async function deleteUpload(id, storagePath, btn, assessmentType) {
  if (!confirm('Delete this assessment? Students will lose access immediately.')) return;

  btn.disabled    = true;
  btn.textContent = 'Deleting…';

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
        btn.textContent = 'Delete';
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
    btn.textContent = 'Copied!';
    setTimeout(() => { btn.textContent = original; }, 1500);
  } catch {
    alert('Could not copy. Code: ' + code);
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
    alert('Could not save label: ' + error.message);
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
    alert('Please enter a valid date and time.');
    return;
  }
  if (newExpiry <= new Date()) {
    alert('Please choose a date and time in the future.');
    return;
  }

  const { error } = await supabaseClient
    .from('uploads')
    .update({ expires_at: newExpiry })
    .eq('id', editTargetId);

  if (error) {
    alert('Could not update expiry: ' + error.message);
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
    alert('Could not extend expiry: ' + error.message);
    return;
  }

  document.getElementById('edit-expiry-modal').classList.add('hidden');
  editTargetId = null;
  await loadUploads();
}

// ─── CSV Export ──────────────────────────────────────────────────

async function exportCsv() {
  const btn = document.getElementById('btn-export-csv');
  if (btn) { btn.disabled = true; btn.textContent = 'Exporting…'; }

  try {
    const { data, error } = await supabaseClient.rpc('get_my_session_events');
    if (error) throw new Error(error.message);

    if (!data || data.length === 0) {
      alert('No session data to export yet.');
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
    a.download = `audioproctor-sessions-${new Date().toISOString().slice(0, 10)}.csv`;
    a.click();
    URL.revokeObjectURL(url);
  } catch (err) {
    alert('Export failed: ' + err.message);
  } finally {
    if (btn) { btn.disabled = false; btn.textContent = 'Export CSV'; }
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
    container.innerHTML = `<div class="empty-state"><p class="label">No session data yet. Stats will appear here once students use access codes.</p></div>`;
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
        <div class="label">Total Sessions</div>
      </div>
      <div class="stat-box">
        <div class="stat-box__value" style="color:${rateColor};">${completionRate != null ? completionRate + '%' : '—'}</div>
        <div class="label">Completion Rate</div>
      </div>
      <div class="stat-box">
        <div class="stat-box__value">${totalReplays}</div>
        <div class="label">Total Replays</div>
      </div>
    </div>
    ${mostUsedName ? `<p style="font-size:0.85rem; color:var(--muted);">Most-used assessment: <strong style="color:var(--ink);">${escapeHtml(mostUsedName)}</strong> (${mostUsed.total_sessions} sessions)</p>` : ''}
  `;
}
