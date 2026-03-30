// ─── Exit Word List ──────────────────────────────────────────────
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

  hint.textContent = `${file.name} · ${(file.size / 1024 / 1024).toFixed(1)} MB`;
  btn.disabled = false;
  hideUploadNotice();
}

// ─── Upload ──────────────────────────────────────────────────────

async function handleUpload() {
  const fileInput = document.getElementById('file-input');
  const file = fileInput.files[0];
  if (!file) return;

  const label = document.getElementById('label-input').value.trim() || null;
  const btn   = document.getElementById('btn-upload');

  btn.disabled = true;
  hideUploadNotice();

  try {
    const session = await getSession();
    if (!session) { window.location.href = '/login.html'; return; }
    const userId = session.user.id;

    // Check for duplicate filename
    const { data: existing } = await supabaseClient
      .from('uploads')
      .select('id')
      .eq('teacher_id', userId)
      .eq('filename', file.name)
      .maybeSingle();

    if (existing) {
      const proceed = confirm(`You already have an upload named "${file.name}". Upload another copy anyway?`);
      if (!proceed) {
        btn.disabled = false;
        return;
      }
    }

    // Check quota (UI-side gate; server enforces via RLS)
    const { data: profile } = await supabaseClient
      .from('profiles')
      .select('tier')
      .eq('id', userId)
      .maybeSingle();

    if (!profile || profile.tier === 'free') {
      const now        = new Date();
      const monthStart = new Date(now.getFullYear(), now.getMonth(), 1).toISOString();
      const { count }  = await supabaseClient
        .from('uploads')
        .select('id', { count: 'exact', head: true })
        .eq('teacher_id', userId)
        .gte('created_at', monthStart);
      if (count >= 3) {
        btn.disabled  = false;
        const reset   = new Date(now.getFullYear(), now.getMonth() + 1, 1);
        const resetFmt = reset.toLocaleDateString('en-CA', { month: 'long', day: 'numeric' });
        showUploadNotice(
          `You've used all 3 uploads for this month. Your quota resets on ${resetFmt}.`,
          'error'
        );
        return;
      }
    }

    // Generate access code and exit word
    showProgress(0, 'Preparing…');
    const accessCode   = await generateAccessCode();
    const exitWord     = pickExitWord();
    const exitWordHash = await hashWord(exitWord);

    // Upload to Supabase Storage with progress tracking
    const storagePath = `${userId}/${accessCode}.mp3`;
    showProgress(0, 'Uploading…');

    const { error: storageError } = await supabaseClient.storage
      .from('audio-files')
      .upload(storagePath, file, {
        contentType: 'audio/mpeg',
        upsert: false,
        onUploadProgress: (progress) => {
          const pct = Math.round((progress.loaded / progress.total) * 100);
          showProgress(pct, `Uploading… ${pct}%`);
        },
      });

    if (storageError) throw new Error('Upload failed: ' + storageError.message);

    // Save to database
    showProgress(100, 'Saving…');
    const expiresAt = new Date(Date.now() + 7 * 24 * 60 * 60 * 1000).toISOString();

    const { error: dbError } = await supabaseClient
      .from('uploads')
      .insert({
        teacher_id:     userId,
        filename:       file.name,
        label:          label,
        storage_path:   storagePath,
        access_code:    accessCode,
        exit_word:      exitWord,
        exit_word_hash: exitWordHash,
        expires_at:     expiresAt,
        file_size_mb:   file.size / 1024 / 1024,
      });

    if (dbError) {
      await supabaseClient.storage.from('audio-files').remove([storagePath]);
      throw new Error('Could not save upload record: ' + dbError.message);
    }

    // Success
    hideProgress();
    fileInput.value = '';
    document.getElementById('label-input').value = '';
    document.getElementById('file-hint').textContent = 'Max 100 MB · MP3 only';
    btn.disabled = true;
    showUploadNotice('Assessment uploaded successfully.', 'success');
    await loadUploads();
    await recalculateStorage(userId);
    await loadQuota();

  } catch (err) {
    hideProgress();
    btn.disabled = false;
    showUploadNotice(err.message, 'error');
  }
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

// ─── Uploads Table ───────────────────────────────────────────────

async function loadUploads() {
  const container = document.getElementById('uploads-container');

  const { data: uploads, error } = await supabaseClient
    .from('uploads')
    .select('id, filename, label, access_code, exit_word, expires_at, storage_path')
    .order('created_at', { ascending: false });

  if (error) {
    container.innerHTML = `<p class="label text-accent">Could not load uploads: ${error.message}</p>`;
    return;
  }

  if (!uploads || uploads.length === 0) {
    container.innerHTML = `
      <div class="empty-state" style="text-align:left; padding:2.5rem;">
        <p class="label" style="margin-bottom:1rem;">Get started in three steps</p>
        <ol style="list-style:none; display:flex; flex-direction:column; gap:0.75rem;">
          <li style="font-size:0.9rem; color:var(--muted);"><strong style="color:var(--ink);">1. Add a label</strong> — give the assessment a name your students will recognise</li>
          <li style="font-size:0.9rem; color:var(--muted);"><strong style="color:var(--ink);">2. Choose an MP3</strong> — the audio file for this assessment</li>
          <li style="font-size:0.9rem; color:var(--muted);"><strong style="color:var(--ink);">3. Upload</strong> — you'll get an access code and exit word to share with your student</li>
        </ol>
      </div>`;
    return;
  }

  const rows = uploads.map(u => {
    const { text: expiryText, expired } = formatExpiry(u.expires_at);
    const chipClass    = expired ? 'chip--expired' : 'chip--active';
    const displayName  = u.label || u.filename;
    const showFilename = u.label && u.label !== u.filename;

    return `
      <tr>
        <td class="col-assessment">
          <div class="col-assessment__label">${escapeHtml(displayName)}</div>
          ${showFilename ? `<div class="col-assessment__filename">${escapeHtml(u.filename)}</div>` : ''}
        </td>
        <td class="col-code"><span class="monospace">${u.access_code}</span></td>
        <td class="col-word">${escapeHtml(u.exit_word)}</td>
        <td><span class="chip ${chipClass}">${expiryText}</span></td>
        <td>
          <div class="action-row">
            <button class="btn btn--ghost btn--small" onclick="copyCode('${u.access_code}', this)">Copy Code</button>
            <button class="btn btn--danger btn--small" onclick="deleteUpload('${u.id}', '${u.storage_path}', this)">Delete</button>
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
}

function formatExpiry(expiresAt) {
  const now     = new Date();
  const expires = new Date(expiresAt);
  const diff    = expires - now;

  if (diff < 0) return { text: 'Expired', expired: true };

  const days  = Math.floor(diff / (1000 * 60 * 60 * 24));
  const hours = Math.floor((diff % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));

  if (days > 0)  return { text: `${days}d left`, expired: false };
  if (hours > 0) return { text: `${hours}h left`, expired: false };
  return { text: 'Expiring soon', expired: false };
}

async function deleteUpload(id, storagePath, btn) {
  if (!confirm('Delete this assessment? Students will lose access immediately.')) return;

  btn.disabled    = true;
  btn.textContent = 'Deleting…';

  const { error: storageErr } = await supabaseClient.storage
    .from('audio-files')
    .remove([storagePath]);

  if (storageErr) {
    alert('Could not delete audio file: ' + storageErr.message);
    btn.disabled    = false;
    btn.textContent = 'Delete';
    return;
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

// ─── Quota ───────────────────────────────────────────────────────

async function loadQuota() {
  const session = await getSession();
  if (!session) return;
  const userId = session.user.id;

  const { data: profile } = await supabaseClient
    .from('profiles')
    .select('tier, storage_used_mb')
    .eq('id', userId)
    .maybeSingle();

  const tier = profile?.tier || 'free';
  const el   = document.getElementById('quota-indicator');
  if (!el) return;

  if (tier !== 'free') {
    el.classList.add('hidden');
    return;
  }

  const now        = new Date();
  const monthStart = new Date(now.getFullYear(), now.getMonth(), 1).toISOString();
  const { count }  = await supabaseClient
    .from('uploads')
    .select('id', { count: 'exact', head: true })
    .eq('teacher_id', userId)
    .gte('created_at', monthStart);

  const used   = count || 0;
  const limit  = 3;
  const reset  = new Date(now.getFullYear(), now.getMonth() + 1, 1);
  const resetFmt = reset.toLocaleDateString('en-CA', { month: 'long', day: 'numeric' });

  el.classList.remove('hidden', 'quota-bar--full');

  if (used >= limit) {
    el.classList.add('quota-bar--full');
    el.innerHTML = `You've used all ${limit} uploads for this month. Quota resets on ${resetFmt}.`;
    document.getElementById('btn-upload').disabled = true;
  } else {
    el.textContent = `${used} of ${limit} uploads used this month · Resets ${resetFmt}`;
  }
}

async function recalculateStorage(userId) {
  const { data } = await supabaseClient
    .from('uploads')
    .select('file_size_mb')
    .eq('teacher_id', userId);

  const total = (data || []).reduce((sum, row) => sum + (row.file_size_mb || 0), 0);

  await supabaseClient
    .from('profiles')
    .update({ storage_used_mb: total })
    .eq('id', userId);
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

// ─── Util ────────────────────────────────────────────────────────

function escapeHtml(str) {
  return str
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}
