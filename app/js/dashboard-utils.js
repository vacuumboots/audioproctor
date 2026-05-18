// ─── Shared Utilities ─────────────────────────────────────────────

function escapeHtml(str) {
  return str
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/\"/g, '&quot;')
    .replace(/'/g, '&#39;');
}

function randomChar(pool) {
  return pool[Math.floor(Math.random() * pool.length)];
}

function formatExpiry(expiresAt) {
  const now     = new Date();
  const expires = new Date(expiresAt);
  const diff    = expires - now;

  if (diff < 0) return { text: t('dashboard.expired'), expired: true };

  const days  = Math.floor(diff / (1000 * 60 * 60 * 24));
  const hours = Math.floor((diff % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));

  if (days > 0)  return { text: t('dashboard.expiryDays', { days, plural: days > 1 ? 's' : '' }), expired: false };
  if (hours > 0) return { text: t('dashboard.expiryHours', { hours, plural: hours > 1 ? 's' : '' }), expired: false };
  return { text: t('dashboard.expirySoon'), expired: false };
}

function formatDuration(seconds) {
  if (!seconds) return null;
  const m = Math.floor(seconds / 60);
  const s = Math.floor(seconds % 60).toString().padStart(2, '0');
  return `${m}:${s}`;
}

function isMp3File(file) {
  const name = (file?.name || '').toLowerCase();
  const type = (file?.type || '').toLowerCase();
  return type.includes('mpeg') || name.endsWith('.mp3');
}

function isWavFile(file) {
  const name = (file?.name || '').toLowerCase();
  const type = (file?.type || '').toLowerCase();
  return type.includes('wav') || name.endsWith('.wav');
}

function isSupportedAudioFile(file) {
  return isMp3File(file) || isWavFile(file);
}

function estimateMp3UpperBoundBytes(file) {
  return Math.ceil(file.size * 1.02) + 2048;
}

// ─── Notices ─────────────────────────────────────────────────────

function showUploadNotice(message, type) {
  const el    = document.getElementById('upload-notice');
  el.textContent = message;
  el.className   = 'notice' + (type === 'error' ? ' notice--error' : ' notice--success');
  el.classList.remove('hidden');
}

function hideUploadNotice() {
  document.getElementById('upload-notice').classList.add('hidden');
}

// ─── Progress Bar ─────────────────────────────────────────────────

function showProgress(pct, text) {
  const wrap  = document.getElementById('upload-progress');
  const fill  = document.getElementById('progress-fill');
  const lbl   = document.getElementById('progress-label');
  wrap.style.display = 'block';
  fill.style.width   = pct + '%';
  lbl.textContent    = text;
}

function hideProgress() {
  document.getElementById('upload-progress').style.display = 'none';
  document.getElementById('progress-fill').style.width = '0%';
}
