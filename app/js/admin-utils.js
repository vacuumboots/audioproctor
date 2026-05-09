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

// ─── Option helpers ───────────────────────────────────────────────

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
    .replace(/\"/g, '&quot;')
    .replace(/'/g, '&#39;');
}
