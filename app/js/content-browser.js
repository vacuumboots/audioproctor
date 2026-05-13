// ─── Shared Content Browser ───────────────────────────────────────
// Renders teacher upload tables with inline audio/text playback,
// filtering, and pagination. Used by admin-content.js,
// school-admin-content.js, and division-admin-content.js.
//
// Each panel module sets global options before calling initContentBrowser():
//   window.contentBrowserOpts = {
//     containerId: 'panel-content',          // panel element id
//     apiFn:       adminApi,                 // async (action, method, body) => data
//     listAction:  'list-teacher-uploads',   // GET action name for the list
//     contentAction: 'get-upload-content',   // GET action name for single upload
//     showSchool:  false,                    // include School column?
//     showTeacher: true,                     // include Teacher column?
//     perPage:     50,
//   }

let contentUploads      = [];
let contentFiltered     = [];
let contentPage         = 0;
let contentOpts         = null;
const CONTENT_PER_PAGE  = 50;

// ─── Field name normalization ─────────────────────────────────────
// Normalizes common camelCase API responses to snake_case so the
// frontend consistently accesses e.g. u.assessment_type, u.created_at.
function normalizeRow(r) {
  if (!r || typeof r !== 'object') return r;
  const map = {
    assessmentType:   'assessment_type',
    fileSizeMb:       'file_size_mb',
    createdAt:        'created_at',
    expiresAt:        'expires_at',
    teacherEmail:     'teacher_email',
    teacherName:      'teacher_name',
    schoolName:       'school_name',
    divisionName:     'division_name',
    accessCode:       'access_code',
    processingStatus: 'processing_status',
    textCharCount:    'text_char_count',
    imageCount:       'image_count',
    signedUrl:        'signed_url',
    textContent:      'text_content',
  };
  const n = { ...r };
  for (const [camel, snake] of Object.entries(map)) {
    if (camel in n && !(snake in n)) {
      n[snake] = n[camel];
      delete n[camel];
    }
  }
  return n;
}

function normalizeUploads(data) {
  if (Array.isArray(data)) return data.map(normalizeRow);
  if (data && Array.isArray(data.uploads)) return data.uploads.map(normalizeRow);
  return [];
}

// ─── Init ─────────────────────────────────────────────────────────

async function initContentBrowser(opts) {
  contentOpts      = opts;
  contentUploads   = [];
  contentFiltered  = [];
  contentPage      = 0;

  const container = document.getElementById(opts.containerId);
  if (!container) return;

  container.innerHTML = `<div class="empty-state"><p class="label">Loading…</p></div>`;

  try {
    const data = await contentOpts.apiFn(contentOpts.listAction);
    contentUploads = normalizeUploads(data);
    applyFilters();
    renderPanel(container);
  } catch (err) {
    container.innerHTML = `
      <div class="empty-state">
        <p class="label text-accent">Could not load uploads</p>
        <p style="font-size:0.85rem; color:var(--muted); margin-top:0.5rem;">
          ${escapeHtml(err.message)}
        </p>
        <button class="btn btn--ghost btn--small mt-2"
          onclick="initContentBrowser(contentOpts)">Retry</button>
      </div>`;
  }
}

// ─── Filtering ────────────────────────────────────────────────────

function applyFilters() {
  const q      = (document.getElementById('cb-search')?.value || '').toLowerCase().trim();
  const school = document.getElementById('cb-filter-school')?.value || '';
  const type   = document.getElementById('cb-filter-type')?.value || '';

  contentFiltered = contentUploads.filter(u => {
    if (q && !(u.teacher_name || u.teacher_email || '').toLowerCase().includes(q)) return false;
    if (school && (u.school_name || '') !== school) return false;
    if (type && (u.assessment_type || '') !== type) return false;
    return true;
  });

  contentPage = 0;
}

function onFilterChange() {
  applyFilters();
  const container = document.getElementById(contentOpts.containerId);
  if (container) renderPanel(container);
}

// ─── Panel render ─────────────────────────────────────────────────

function renderPanel(container) {
  const total    = contentFiltered.length;
  const totalPages = Math.max(1, Math.ceil(total / CONTENT_PER_PAGE));
  const start    = contentPage * CONTENT_PER_PAGE;
  const page     = contentFiltered.slice(start, start + CONTENT_PER_PAGE);

  // Collect unique schools and types for filter dropdowns
  const schools = [...new Set(contentUploads.map(u => u.school_name).filter(Boolean))].sort();
  const types   = [...new Set(contentUploads.map(u => u.assessment_type).filter(Boolean))].sort();

  container.innerHTML = `
    <div class="cb-filter-bar">
      <input type="text" id="cb-search" class="input-field"
        placeholder="Search by teacher name…"
        value="${escapeHtml(document.getElementById('cb-search')?.value || '')}"
        oninput="onFilterChange()" style="width:220px; font-size:0.875rem;">

      ${contentOpts.showSchool ? `
        <select id="cb-filter-school" class="input-field"
          onchange="onFilterChange()" style="width:180px; font-size:0.875rem;">
          <option value="">All Schools</option>
          ${schools.map(s => `<option value="${escapeHtml(s)}">${escapeHtml(s)}</option>`).join('')}
        </select>` : ''}

      <select id="cb-filter-type" class="input-field"
        onchange="onFilterChange()" style="width:140px; font-size:0.875rem;">
        <option value="">All Types</option>
        ${types.map(t => `<option value="${escapeHtml(t)}">${escapeHtml(capitalize(t))}</option>`).join('')}
      </select>

      <span class="cb-count">${total} upload${total !== 1 ? 's' : ''}</span>
    </div>

    <div id="cb-table-wrapper">
      ${page.length === 0
        ? '<div class="empty-state"><p class="label">No uploads found</p></div>'
        : buildTable(page, start)}
    </div>

    ${totalPages > 1 ? buildPagination(totalPages) : ''}
  `;
}

// ─── Table ────────────────────────────────────────────────────────

function buildTable(page, start) {
  const rows = page.map((u, i) => {
    const created = u.created_at
      ? new Date(u.created_at).toLocaleDateString('en-CA', {
          year: 'numeric', month: 'short', day: 'numeric'
        })
      : '—';

    const size = u.file_size_mb != null
      ? (Number(u.file_size_mb) < 1
          ? Math.round(Number(u.file_size_mb) * 1000) + ' KB'
          : Number(u.file_size_mb).toFixed(1) + ' MB')
      : '—';

    const typeLabel    = u.assessment_type === 'text' ? 'Text' : 'Audio';
    const rowId        = `cb-row-${start + i}`;
    const teacherName  = u.teacher_name || u.teacher_email || '—';

    return `
      <tr class="cb-row" data-upload-id="${escapeHtml(String(u.id))}"
        onclick="toggleInlineViewer('${escapeHtml(String(u.id))}', '${rowId}', this)"
        data-row-id="${rowId}">
        ${contentOpts.showTeacher
          ? `<td>${escapeHtml(teacherName)}</td>` : ''}
        ${contentOpts.showSchool
          ? `<td>${escapeHtml(u.school_name || '—')}</td>` : ''}
        <td><span class="cb-type-badge cb-type-badge--${u.assessment_type === 'text' ? 'text' : 'audio'}">${typeLabel}</span></td>
        <td class="cb-filename">${escapeHtml(u.filename || '—')}</td>
        <td class="cb-size">${size}</td>
        <td class="cb-date">${created}</td>
        <td><span class="cb-play-icon">▶</span></td>
      </tr>
      <tr class="cb-detail-row" id="cb-detail-${u.id}" style="display:none;">
        <td colspan="${contentOpts.showSchool && contentOpts.showTeacher ? 7 : contentOpts.showSchool || contentOpts.showTeacher ? 6 : 5}">
          <div class="cb-detail-cell" id="cb-detail-content-${u.id}">
            <div class="empty-state" style="padding:1.5rem;"><p class="label">Loading…</p></div>
          </div>
        </td>
      </tr>`;
  }).join('');

  return `
    <table class="cb-table">
      <thead>
        <tr>
          ${contentOpts.showTeacher ? '<th>Teacher</th>' : ''}
          ${contentOpts.showSchool ? '<th>School</th>' : ''}
          <th>Type</th>
          <th>Filename</th>
          <th>Size</th>
          <th>Created</th>
          <th style="width:50px; text-align:center;">▶</th>
        </tr>
      </thead>
      <tbody>${rows}</tbody>
    </table>`;
}

// ─── Inline viewer (toggled by clicking a row) ────────────────────

let currentOpenUploadId = null;

async function toggleInlineViewer(uploadId, rowId, rowEl) {
  const detailRow  = document.getElementById(`cb-detail-${uploadId}`);
  const contentDiv = document.getElementById(`cb-detail-content-${uploadId}`);

  if (!detailRow || !contentDiv) return;

  // Close previously open row
  if (currentOpenUploadId && currentOpenUploadId !== uploadId) {
    const prevDetail = document.getElementById(`cb-detail-${currentOpenUploadId}`);
    if (prevDetail) prevDetail.style.display = 'none';
    // Re-enable prev row click
    const prevRow = document.querySelector(`.cb-row[data-upload-id="${currentOpenUploadId}"]`);
    if (prevRow) prevRow.classList.remove('cb-row--open');
  }

  if (detailRow.style.display === 'table-row') {
    // Close this row
    detailRow.style.display = 'none';
    rowEl.classList.remove('cb-row--open');
    currentOpenUploadId = null;
    return;
  }

  // Open this row
  detailRow.style.display    = 'table-row';
  rowEl.classList.add('cb-row--open');
  currentOpenUploadId = uploadId;

  // Load content if not already loaded
  if (!contentDiv.dataset.loaded) {
    try {
      const data = await contentOpts.apiFn(contentOpts.contentAction, 'GET', null,
        `&uploadId=${encodeURIComponent(uploadId)}`);

      // Normalize response field names (camelCase → snake_case safety net)
      const normData = normalizeRow(data);

      if (normData.assessment_type === 'text' || normData.text_content) {
        contentDiv.innerHTML = buildTextViewer(normData);
      } else {
        contentDiv.innerHTML = buildAudioPlayer(normData);
      }
      contentDiv.dataset.loaded = '1';
    } catch (err) {
      contentDiv.innerHTML = `
        <div class="cb-error">
          <p class="label text-accent">Failed to load content</p>
          <p style="font-size:0.85rem; color:var(--muted); margin-top:0.25rem;">
            ${escapeHtml(err.message)}
          </p>
        </div>`;
    }
  }
}

// ─── Audio player ─────────────────────────────────────────────────

function buildAudioPlayer(data) {
  const signedUrl = data.signed_url || data.url || '';
  if (!signedUrl) {
    return `<div class="cb-error"><p class="label text-accent">No audio URL available</p></div>`;
  }

  return `
    <div class="cb-player">
      <p class="cb-player__label">Audio</p>
      <audio controls src="${escapeHtml(signedUrl)}"
        style="width:100%; max-width:480px;"
        onerror="handleAudioError(this)"
        preload="none">
        Your browser does not support the audio element.
      </audio>
    </div>`;
}

function handleAudioError(el) {
  // If playback fails, show session expired message
  const parent = el.closest('.cb-player');
  if (!parent) return;
  parent.innerHTML = `
    <div class="cb-error">
      <p class="label text-accent">Session expired — refresh to reload</p>
      <p style="font-size:0.85rem; color:var(--muted); margin-top:0.25rem;">
        The signed URL has expired. Close and re-open this row to refresh.
      </p>
    </div>`;
}

// ─── Text viewer ──────────────────────────────────────────────────

function buildTextViewer(data) {
  const textContent = data.text_content || data.html || '';
  if (!textContent) {
    return `<div class="cb-error"><p class="label text-accent">No text content</p></div>`;
  }

  return `
    <div class="cb-text-viewer">
      <p class="cb-player__label">Text Assessment</p>
      <div class="cb-text-content">${textContent}</div>
    </div>`;
}

// ─── Pagination ───────────────────────────────────────────────────

function buildPagination(totalPages) {
  const prevDisabled = contentPage === 0;
  const nextDisabled = contentPage >= totalPages - 1;

  return `
    <div class="cb-pagination">
      <button class="btn btn--ghost btn--small" ${prevDisabled ? 'disabled' : ''}
        onclick="goContentPage(${contentPage - 1})">← Prev</button>
      <span class="cb-page-info">Page ${contentPage + 1} of ${totalPages}</span>
      <button class="btn btn--ghost btn--small" ${nextDisabled ? 'disabled' : ''}
        onclick="goContentPage(${contentPage + 1})">Next →</button>
    </div>`;
}

function goContentPage(page) {
  const totalPages = Math.max(1, Math.ceil(contentFiltered.length / CONTENT_PER_PAGE));
  if (page < 0 || page >= totalPages) return;
  contentPage = page;

  // Close any open detail row
  if (currentOpenUploadId) {
    const prevDetail = document.getElementById(`cb-detail-${currentOpenUploadId}`);
    if (prevDetail) prevDetail.style.display = 'none';
    const prevRow = document.querySelector(`.cb-row[data-upload-id="${currentOpenUploadId}"]`);
    if (prevRow) prevRow.classList.remove('cb-row--open');
    currentOpenUploadId = null;
  }

  const container = document.getElementById(contentOpts.containerId);
  if (container) renderPanel(container);
}

// ─── Helper ───────────────────────────────────────────────────────

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
