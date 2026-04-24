// ─── Web Player ──────────────────────────────────────────────────
// Used by player.html (the web fallback player — not the extension).
// Reads the ?code= URL param, calls /api/session, loads the audio.

(async () => {
  const params = new URLSearchParams(window.location.search);
  const code   = params.get('code');

  if (!code) {
    showError('No access code in URL. Add ?code=ABC-123 to the address.');
    return;
  }

  let session;
  try {
    const res = await fetch('/api/session?code=' + encodeURIComponent(code));
    session   = await res.json();
    if (!res.ok) {
      showError(session.error || 'Could not load assessment.');
      return;
    }
  } catch {
    showError('Network error — could not reach the server.');
    return;
  }

  // Populate player
  document.getElementById('player-filename').textContent = session.filename;
  document.title = 'AudioProctor — ' + session.filename;

  const audio = document.getElementById('audio-el');
  audio.src   = session.signedUrl;

  // Wire controls
  document.getElementById('btn-play').addEventListener('click', togglePlay);
  document.getElementById('progress-bar').addEventListener('input', seekAudio);
  audio.addEventListener('timeupdate', updateProgress);
  audio.addEventListener('loadedmetadata', () => {
    document.getElementById('progress-bar').max = audio.duration;
    document.getElementById('time-total').textContent = formatTime(audio.duration);
  });
  audio.addEventListener('ended', () => {
    document.getElementById('btn-play').innerHTML = '&#9654;';
  });
  audio.addEventListener('error', () => {
    showError('Audio failed to load. The signed link may have expired — ask your teacher to re-open the assessment.');
  });

  showPlayer();
})();

function togglePlay() {
  const audio = document.getElementById('audio-el');
  const btn   = document.getElementById('btn-play');
  if (audio.paused) {
    audio.play();
    btn.innerHTML = '&#9646;&#9646;';
  } else {
    audio.pause();
    btn.innerHTML = '&#9654;';
  }
}

function rewind() {
  const audio = document.getElementById('audio-el');
  audio.currentTime = Math.max(0, audio.currentTime - 10);
}

function changeSpeed(rate) {
  document.getElementById('audio-el').playbackRate = parseFloat(rate);
}

function seekAudio() {
  const audio = document.getElementById('audio-el');
  audio.currentTime = parseFloat(this.value);
}

function updateProgress() {
  const audio = document.getElementById('audio-el');
  const bar   = document.getElementById('progress-bar');
  bar.value   = audio.currentTime;
  document.getElementById('time-current').textContent = formatTime(audio.currentTime);
}

function formatTime(secs) {
  const m = Math.floor(secs / 60);
  const s = Math.floor(secs % 60).toString().padStart(2, '0');
  return `${m}:${s}`;
}

// ─── State helpers ───────────────────────────────────────────────

function showPlayer() {
  document.getElementById('state-loading').classList.add('hidden');
  document.getElementById('state-player').classList.remove('hidden');
}

function showError(msg) {
  document.getElementById('state-loading').classList.add('hidden');
  document.getElementById('error-message').textContent = msg;
  document.getElementById('state-error').classList.remove('hidden');
}
