// ─── Exit Word List ──────────────────────────────────────────────
// ~100 simple 4-6 letter English words, easy to say and spell aloud.
const EXIT_WORDS = [
  'maple', 'river', 'cloud', 'stone', 'bread', 'storm', 'flame',
  'lunar', 'amber', 'cedar', 'crane', 'ember', 'frost', 'grove',
  'haven', 'heron', 'lemon', 'lilac', 'marsh', 'north', 'ocean',
  'olive', 'outer', 'pearl', 'pilot', 'pine',  'plumb', 'polar',
  'prism', 'quill', 'radar', 'rally', 'rapid', 'raven', 'ridge',
  'robin', 'rocky', 'rover', 'sabre', 'scout', 'shade', 'shelf',
  'shore', 'sigma', 'silk',  'slate', 'solar', 'sonic', 'spark',
  'spire', 'spoke', 'spore', 'squid', 'staff', 'stalk', 'stark',
  'stern', 'stoic', 'stork', 'sugar', 'swift', 'sword', 'thorn',
  'tiger', 'titan', 'torch', 'tower', 'trace', 'track', 'trail',
  'train', 'trawl', 'trend', 'trout', 'trunk', 'trust', 'tulip',
  'tundra','ultra', 'union', 'urban', 'valor', 'vapor', 'vault',
  'venus', 'viper', 'vista', 'vitae', 'vivid', 'vocal', 'wagon',
  'waltz', 'watch', 'water', 'wheat', 'wheel', 'winch', 'winds',
  'witch', 'wolfe', 'woods', 'world', 'wrath', 'xenon', 'yarns',
];

// Characters for access codes — ambiguous chars removed (O, I, L, 0, 1)
const CODE_LETTERS = 'ABCDEFGHJKMNPQRSTUVWXYZ';
const CODE_DIGITS  = '23456789';

// ─── Access Code Generation ──────────────────────────────────────

function randomChar(pool) {
  return pool[Math.floor(Math.random() * pool.length)];
}

function generateCodeString() {
  const letters = [0,1,2].map(() => randomChar(CODE_LETTERS)).join('');
  const digits  = [0,1,2].map(() => randomChar(CODE_DIGITS)).join('');
  return letters + '-' + digits;
}

async function generateAccessCode() {
  let code;
  let attempts = 0;
  do {
    code = generateCodeString();
    attempts++;
    if (attempts > 20) throw new Error('Could not generate a unique access code. Please try again.');
  } while (await checkCodeExists(code));
  return code;
}

async function checkCodeExists(code) {
  const { data } = await supabaseClient
    .from('uploads')
    .select('id')
    .eq('access_code', code)
    .maybeSingle();
  return data !== null;
}

// ─── Exit Word ───────────────────────────────────────────────────

function pickExitWord() {
  return EXIT_WORDS[Math.floor(Math.random() * EXIT_WORDS.length)];
}

async function hashWord(word) {
  const data = new TextEncoder().encode(word.toLowerCase().trim());
  const buf  = await crypto.subtle.digest('SHA-256', data);
  return Array.from(new Uint8Array(buf))
    .map(b => b.toString(16).padStart(2, '0'))
    .join('');
}

// ─── File Select ─────────────────────────────────────────────────

function handleFileSelect(input) {
  const file = input.files[0];
  const btn  = document.getElementById('btn-upload');
  const hint = document.getElementById('file-hint');

  if (!file) {
    btn.disabled = true;
    hint.textContent = 'Max 100 MB · MP3 only';
    return;
  }

  if (!file.type.includes('mpeg') && !file.name.endsWith('.mp3')) {
    showUploadNotice('Please select an MP3 file.', 'error');
    input.value = '';
    btn.disabled = true;
    return;
  }

  const maxBytes = 100 * 1024 * 1024;
  if (file.size > maxBytes) {
    showUploadNotice('File is too large. Maximum size is 100 MB.', 'error');
    input.value = '';
    btn.disabled = true;
    return;
  }

  hint.textContent = `${file.name} (${(file.size / 1024 / 1024).toFixed(1)} MB)`;
  btn.disabled = false;
  hideUploadNotice();
}

// ─── Upload ──────────────────────────────────────────────────────

async function handleUpload() {
  const fileInput = document.getElementById('file-input');
  const file = fileInput.files[0];
  if (!file) return;

  const btn    = document.getElementById('btn-upload');
  const status = document.getElementById('upload-status');

  btn.disabled = true;
  status.classList.remove('hidden');
  hideUploadNotice();

  try {
    // Get current user
    const session = await getSession();
    if (!session) { window.location.href = '/index.html'; return; }
    const userId = session.user.id;

    // Generate unique access code
    setStatus('Generating code…');
    const accessCode = await generateAccessCode();

    // Pick and hash exit word
    const exitWord     = pickExitWord();
    const exitWordHash = await hashWord(exitWord);

    // Upload to Supabase Storage
    setStatus('Uploading audio…');
    const storagePath = `${userId}/${accessCode}.mp3`;
    const { error: storageError } = await supabaseClient.storage
      .from('audio-files')
      .upload(storagePath, file, { contentType: 'audio/mpeg', upsert: false });

    if (storageError) throw new Error('Upload failed: ' + storageError.message);

    // Insert DB row
    setStatus('Saving…');
    const expiresAt = new Date(Date.now() + 7 * 24 * 60 * 60 * 1000).toISOString();

    const { error: dbError } = await supabaseClient
      .from('uploads')
      .insert({
        teacher_id:     userId,
        filename:       file.name,
        storage_path:   storagePath,
        access_code:    accessCode,
        exit_word:      exitWord,
        exit_word_hash: exitWordHash,
        expires_at:     expiresAt,
      });

    if (dbError) {
      // Cleanup orphaned storage file
      await supabaseClient.storage.from('audio-files').remove([storagePath]);
      throw new Error('Could not save upload record: ' + dbError.message);
    }

    // Success
    setStatus('');
    status.classList.add('hidden');
    fileInput.value = '';
    document.getElementById('file-hint').textContent = 'Max 100 MB · MP3 only';
    btn.disabled = true;
    showUploadNotice('Assessment uploaded successfully.', 'success');
    await loadUploads();

  } catch (err) {
    setStatus('');
    status.classList.add('hidden');
    btn.disabled = false;
    showUploadNotice(err.message, 'error');
  }
}

function setStatus(text) {
  const el = document.getElementById('upload-status');
  el.textContent = text;
}

// ─── Uploads Table ───────────────────────────────────────────────

async function loadUploads() {
  const container = document.getElementById('uploads-container');

  const { data: uploads, error } = await supabaseClient
    .from('uploads')
    .select('id, filename, access_code, exit_word, expires_at, storage_path')
    .order('created_at', { ascending: false });

  if (error) {
    container.innerHTML = `<p class="label text-accent">Could not load uploads: ${error.message}</p>`;
    return;
  }

  if (!uploads || uploads.length === 0) {
    container.innerHTML = `
      <div class="empty-state">
        <p class="label">No assessments uploaded yet</p>
      </div>`;
    return;
  }

  const rows = uploads.map(u => {
    const { text: expiryText, expired } = formatExpiry(u.expires_at);
    const chipClass = expired ? 'chip--expired' : 'chip--active';
    return `
      <tr data-id="${u.id}" data-path="${u.storage_path}">
        <td class="col-filename">${escapeHtml(u.filename)}</td>
        <td class="col-code">
          <span class="monospace">${u.access_code}</span>
        </td>
        <td class="col-word">${escapeHtml(u.exit_word)}</td>
        <td><span class="chip ${chipClass}">${expiryText}</span></td>
        <td>
          <div class="action-row">
            <button
              class="btn btn--ghost btn--small"
              onclick="copyCode('${u.access_code}', this)"
            >Copy Code</button>
            <button
              class="btn btn--danger btn--small"
              onclick="deleteUpload('${u.id}', '${u.storage_path}', this)"
            >Delete</button>
          </div>
        </td>
      </tr>`;
  }).join('');

  container.innerHTML = `
    <table class="uploads-table">
      <thead>
        <tr>
          <th>Filename</th>
          <th>Access Code</th>
          <th>Exit Word</th>
          <th>Expires</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>${rows}</tbody>
    </table>`;
}

function formatExpiry(expiresAt) {
  const now     = new Date();
  const expires = new Date(expiresAt);
  const diff    = expires - now;

  if (diff < 0) return { text: 'Expired', expired: true };

  const days    = Math.floor(diff / (1000 * 60 * 60 * 24));
  const hours   = Math.floor((diff % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));

  if (days > 0) return { text: `${days}d left`, expired: false };
  if (hours > 0) return { text: `${hours}h left`, expired: false };
  return { text: 'Expiring soon', expired: false };
}

async function deleteUpload(id, storagePath, btn) {
  if (!confirm('Delete this assessment? Students will lose access immediately.')) return;

  btn.disabled = true;
  btn.textContent = 'Deleting…';

  // Delete storage object first
  const { error: storageErr } = await supabaseClient.storage
    .from('audio-files')
    .remove([storagePath]);

  if (storageErr) {
    alert('Could not delete audio file: ' + storageErr.message);
    btn.disabled = false;
    btn.textContent = 'Delete';
    return;
  }

  // Delete DB row
  const { error: dbErr } = await supabaseClient
    .from('uploads')
    .delete()
    .eq('id', id);

  if (dbErr) {
    alert('Audio file deleted, but could not remove record: ' + dbErr.message);
  }

  await loadUploads();
}

async function copyCode(code, btn) {
  try {
    await navigator.clipboard.writeText(code);
    const original = btn.textContent;
    btn.textContent = 'Copied!';
    setTimeout(() => { btn.textContent = original; }, 1500);
  } catch {
    alert('Could not copy. Code: ' + code);
  }
}

// ─── Notices ─────────────────────────────────────────────────────

function showUploadNotice(message, type) {
  const el = document.getElementById('upload-notice');
  el.textContent = message;
  el.className = 'notice' + (type === 'error' ? ' notice--error' : ' notice--success');
  el.classList.remove('hidden');
}

function hideUploadNotice() {
  document.getElementById('upload-notice').classList.add('hidden');
}

// ─── Util ────────────────────────────────────────────────────────

function escapeHtml(str) {
  return str
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}
