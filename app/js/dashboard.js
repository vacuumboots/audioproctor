// ─── Exit Word Lists ─────────────────────────────────────────────
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

const LONG_EXIT_WORDS = [
  'anchor', 'basket', 'beacon', 'blanket', 'cabinet', 'captain',
  'careful', 'central', 'chapter', 'charter', 'cluster', 'coastal',
  'comfort', 'council', 'counter', 'current', 'curtain', 'decimal',
  'distant', 'eastern', 'evening', 'express', 'falling', 'feature',
  'federal', 'finding', 'flowing', 'forward', 'freedom', 'general',
  'granite', 'harbour', 'harvest', 'heading', 'highway', 'history',
  'horizon', 'justice', 'kitchen', 'landing', 'lantern', 'lasting',
  'morning', 'network', 'outdoor', 'passage', 'quarter', 'railway',
  'section', 'shelter', 'thunder', 'venture', 'western', 'younger',
];

const CODE_LETTERS = 'ABCDEFGHJKMNPQRSTUVWXYZ';
const CODE_DIGITS  = '23456789';

// ─── Module state ────────────────────────────────────────────────
let currentTier   = 'free';
let currentRole   = 'teacher';
let editTargetId  = null;
let allUploads    = [];
let allSummaries  = {};

const MAX_UPLOAD_BYTES = 50 * 1024 * 1024;

// ─── Access Code Generation ──────────────────────────────────────

function randomChar(pool) {
  return pool[Math.floor(Math.random() * pool.length)];
}

function generateCodeString() {
  const letters = [0,1,2].map(() => randomChar(CODE_LETTERS)).join('');
  const digits  = [0,1,2].map(() => randomChar(CODE_DIGITS)).join('');
  return letters + '-' + digits;
}

function generateShortCodeString() {
  const letters = [0,1].map(() => randomChar(CODE_LETTERS)).join('');
  const digits  = [0,1].map(() => randomChar(CODE_DIGITS)).join('');
  return letters + digits;
}

async function generateAccessCode(format, customCode) {
  if (format === 'custom') {
    const code = (customCode || '').toUpperCase().trim();
    if (!/^[A-Z0-9]{3,20}$/.test(code)) {
      throw new Error('Custom code must be 3–20 letters and numbers, no spaces or symbols.');
    }
    if (await checkCodeExists(code)) {
      throw new Error(`The code "${code}" is already in use. Choose a different one.`);
    }
    return code;
  }

  const generator = format === 'short' ? generateShortCodeString : generateCodeString;
  let code;
  let attempts = 0;
  do {
    code = generator();
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

function pickExitWordByComplexity(complexity) {
  switch (complexity) {
    case 'long':   return LONG_EXIT_WORDS[Math.floor(Math.random() * LONG_EXIT_WORDS.length)];
    case 'phrase': return pickTwoWordPhrase();
    case 'pin':    return pickNumericPin();
    default:       return pickExitWord();
  }
}

function pickTwoWordPhrase() {
  const a = pickExitWord();
  let b;
  do { b = pickExitWord(); } while (b === a);
  return a + ' ' + b;
}

function pickNumericPin() {
  return [0,1,2,3].map(() => randomChar('0123456789')).join('');
}

async function hashWord(word) {
  const data = new TextEncoder().encode(word.toLowerCase().trim());
  const buf  = await crypto.subtle.digest('SHA-256', data);
  return Array.from(new Uint8Array(buf))
    .map(b => b.toString(16).padStart(2, '0'))
    .join('');
}

// ─── Advanced Options UI ─────────────────────────────────────────

function toggleCustomExitWord() {
  const mode  = document.getElementById('exit-word-mode')?.value;
  const group = document.getElementById('custom-exit-word-group');
  if (!group) return;
  group.classList.toggle('hidden', mode !== 'custom');
}

function toggleCustomCode() {
  const format = document.getElementById('code-format')?.value;
  const group  = document.getElementById('custom-code-group');
  if (!group) return;
  group.classList.toggle('hidden', format !== 'custom');
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
  // Conservative estimate for validation: conversion + MP3 framing overhead can grow slightly.
  return Math.ceil(file.size * 1.02) + 2048;
}

function toInt16Sample(floatSample) {
  const clamped = Math.max(-1, Math.min(1, floatSample));
  return clamped < 0 ? clamped * 0x8000 : clamped * 0x7fff;
}

function interleaveStereo(left, right) {
  const length = left.length + right.length;
  const result = new Int16Array(length);
  let idx = 0;
  for (let i = 0; i < left.length; i++) {
    result[idx++] = toInt16Sample(left[i]);
    result[idx++] = toInt16Sample(right[i]);
  }
  return result;
}

function floatToMonoInt16(channel) {
  const out = new Int16Array(channel.length);
  for (let i = 0; i < channel.length; i++) out[i] = toInt16Sample(channel[i]);
  return out;
}

function encodeBufferToMp3(audioBuffer) {
  if (!window.lamejs) {
    throw new Error('Audio conversion library failed to load. Please refresh and try again.');
  }

  const channels = audioBuffer.numberOfChannels;
  if (channels < 1 || channels > 2) {
    throw new Error('Only mono or stereo WAV files are supported right now.');
  }

  const sampleRate = audioBuffer.sampleRate;
  const kbps = 128;
  const encoder = new window.lamejs.Mp3Encoder(channels, sampleRate, kbps);

  const left  = audioBuffer.getChannelData(0);
  const right = channels === 2 ? audioBuffer.getChannelData(1) : null;

  const blockSize = 1152;
  const mp3Chunks = [];

  if (channels === 1) {
    const mono = floatToMonoInt16(left);
    for (let i = 0; i < mono.length; i += blockSize) {
      const chunk = mono.subarray(i, i + blockSize);
      const mp3buf = encoder.encodeBuffer(chunk);
      if (mp3buf.length > 0) mp3Chunks.push(new Int8Array(mp3buf));
    }
  } else {
    const stereoInterleaved = interleaveStereo(left, right);
    for (let i = 0; i < stereoInterleaved.length; i += blockSize * 2) {
      const frame = stereoInterleaved.subarray(i, i + blockSize * 2);
      const leftChunk = new Int16Array(Math.ceil(frame.length / 2));
      const rightChunk = new Int16Array(Math.floor(frame.length / 2));
      for (let j = 0, l = 0, r = 0; j < frame.length; j++) {
        if (j % 2 === 0) leftChunk[l++] = frame[j];
        else rightChunk[r++] = frame[j];
      }
      const mp3buf = encoder.encodeBuffer(leftChunk, rightChunk);
      if (mp3buf.length > 0) mp3Chunks.push(new Int8Array(mp3buf));
    }
  }

  const end = encoder.flush();
  if (end.length > 0) mp3Chunks.push(new Int8Array(end));

  return new Blob(mp3Chunks, { type: 'audio/mpeg' });
}

async function convertWavFileToMp3(file) {
  const arrayBuffer = await file.arrayBuffer();

  let audioContext;
  try {
    audioContext = new (window.AudioContext || window.webkitAudioContext)();
    const audioBuffer = await audioContext.decodeAudioData(arrayBuffer.slice(0));
    const mp3Blob = encodeBufferToMp3(audioBuffer);

    if (!mp3Blob || mp3Blob.size === 0) {
      throw new Error('Converted audio was empty.');
    }

    const outName = file.name.replace(/\.wav$/i, '.mp3');
    return new File([mp3Blob], outName, {
      type: 'audio/mpeg',
      lastModified: Date.now(),
    });
  } catch (err) {
    if (err?.message?.includes('mono or stereo')) throw err;
    throw new Error('Could not convert WAV to MP3. Please re-export as MP3 and try again.');
  } finally {
    if (audioContext && typeof audioContext.close === 'function') {
      try { await audioContext.close(); } catch {}
    }
  }
}

// ─── File Select ─────────────────────────────────────────────────

function handleFileSelect(input) {
  const file = input.files[0];
  const btn  = document.getElementById('btn-upload');
  const hint = document.getElementById('file-hint');

  if (!file) {
    btn.disabled = true;
    hint.textContent = 'Max 50 MB · MP3 or WAV (WAV converts to MP3)';
    return;
  }

  if (!isSupportedAudioFile(file)) {
    showUploadNotice('Please select an MP3 or WAV file.', 'error');
    input.value = '';
    btn.disabled = true;
    return;
  }

  const effectiveBytes = isWavFile(file) ? estimateMp3UpperBoundBytes(file) : file.size;
  if (effectiveBytes > MAX_UPLOAD_BYTES) {
    showUploadNotice('File is too large. Maximum size is 50 MB.', 'error');
    input.value = '';
    btn.disabled = true;
    return;
  }

  const suffix = isWavFile(file) ? ' · WAV will convert to MP3 on upload' : '';
  hint.textContent = `${file.name} · ${(file.size / 1024 / 1024).toFixed(1)} MB${suffix}`;
  btn.disabled = false;
  hideUploadNotice();
}

// ─── Assessment Type Toggle ──────────────────────────────────────

function getSelectedAssessmentType() {
  return document.getElementById('assessment-type')?.value || 'audio';
}

function selectAssessmentType(type) {
  const hidden = document.getElementById('assessment-type');
  if (hidden) hidden.value = type;

  // Update toggle button states
  const btns = document.querySelectorAll('#assessment-type-toggle .type-toggle__btn');
  btns.forEach(btn => {
    btn.classList.toggle('type-toggle__btn--active', btn.dataset.type === type);
  });

  toggleAssessmentType();
}

function toggleAssessmentType() {
  const type      = getSelectedAssessmentType();
  const audioGroup = document.getElementById('audio-input-group');
  const textGroup  = document.getElementById('text-input-group');
  const btn        = document.getElementById('btn-upload');

  if (type === 'text') {
    audioGroup.classList.add('hidden');
    textGroup.classList.remove('hidden');
    // Reset audio input
    document.getElementById('file-input').value = '';
    document.getElementById('file-hint').textContent = 'Max 50 MB · MP3 or WAV (WAV converts to MP3)';
  } else {
    audioGroup.classList.remove('hidden');
    textGroup.classList.add('hidden');
    // Reset text input
    document.getElementById('text-content-input').value = '';
    document.getElementById('text-hint').textContent = 'Plain text only · Max 25,000 characters';
  }

  btn.disabled = true;
  hideUploadNotice();
}

function normalizeTextContent(raw) {
  return raw
    .replace(/\r\n/g, '\n')           // CRLF → LF
    .replace(/\r/g, '\n')             // lone CR → LF
    .replace(/\n{3,}/g, '\n\n')       // collapse 3+ blank lines to 2
    .trim();
}

function handleTextInput() {
  const raw  = document.getElementById('text-content-input').value;
  const text = normalizeTextContent(raw);
  const btn  = document.getElementById('btn-upload');
  const hint = document.getElementById('text-hint');

  if (text.length === 0) {
    btn.disabled = true;
    hint.textContent = 'Plain text only · Max 25,000 characters';
    return;
  }

  if (text.length > 25000) {
    btn.disabled = true;
    hint.textContent = `${text.length.toLocaleString()} / 25,000 characters — too long`;
    return;
  }

  btn.disabled = false;
  hint.textContent = `${text.length.toLocaleString()} characters`;
}

// ─── Upload ──────────────────────────────────────────────────────

async function handleUpload() {
  const assessmentType = getSelectedAssessmentType();
  const label = document.getElementById('label-input').value.trim() || null;
  const btn   = document.getElementById('btn-upload');

  btn.disabled = true;
  hideUploadNotice();

  try {
    const session = await getSession();
    if (!session) { window.location.href = '/login.html'; return; }
    const userId = session.user.id;

    // ─── Type-specific input validation ────────────────────────────
    let dbFilename, storagePath, uploadFile, textContent, textCharCount;

    if (assessmentType === 'text') {
      const raw  = document.getElementById('text-content-input').value;
      textContent = normalizeTextContent(raw);
      if (!textContent || textContent.length === 0) {
        btn.disabled = false;
        showUploadNotice('Please paste some assessment text.', 'error');
        return;
      }
      if (textContent.length > 25000) {
        btn.disabled = false;
        showUploadNotice('Text is too long. Maximum 25,000 characters.', 'error');
        return;
      }
      textCharCount = textContent.length;
      dbFilename    = 'text-assessment.txt';
      storagePath   = `text/${userId}`;  // synthetic placeholder (NOT NULL constraint)
      uploadFile    = null;
    } else {
      const fileInput    = document.getElementById('file-input');
      const selectedFile = fileInput.files[0];
      if (!selectedFile) { btn.disabled = false; return; }
      dbFilename = isWavFile(selectedFile)
        ? selectedFile.name.replace(/\.wav$/i, '.mp3')
        : selectedFile.name;
      uploadFile   = selectedFile;
      textContent  = null;
      textCharCount = 0;

      // Check for duplicate filename
      const { data: existing } = await supabaseClient
        .from('uploads')
        .select('id')
        .eq('teacher_id', userId)
        .eq('filename', dbFilename)
        .maybeSingle();
      if (existing) {
        const proceed = confirm(`You already have an upload named "${dbFilename}". Upload another copy anyway?`);
        if (!proceed) { btn.disabled = false; return; }
      }

      // Check storage cap for audio
      if (currentTier === 'free') {
        const { data: profile } = await supabaseClient
          .from('profiles')
          .select('storage_used_mb')
          .eq('id', userId)
          .maybeSingle();
        const storageUsed = profile?.storage_used_mb || 0;
        const estimatedUploadMb = (isWavFile(selectedFile)
          ? estimateMp3UpperBoundBytes(selectedFile)
          : selectedFile.size) / 1024 / 1024;
        if (storageUsed + estimatedUploadMb > 50) {
          btn.disabled = false;
          showUploadNotice(
            `This file would exceed your 50 MB storage limit. You've used ${storageUsed.toFixed(1)} of 50 MB.`,
            'error'
          );
          return;
        }
      }
    }

    // ─── Shared: quota check (both types count toward monthly limit) ─
    if (currentTier === 'free') {
      const now        = new Date();
      const monthStart = new Date(now.getFullYear(), now.getMonth(), 1).toISOString();
      const { count }  = await supabaseClient
        .from('uploads')
        .select('id', { count: 'exact', head: true })
        .eq('teacher_id', userId)
        .gte('created_at', monthStart);
      if (count >= 3) {
        btn.disabled  = false;
        const reset    = new Date(now.getFullYear(), now.getMonth() + 1, 1);
        const resetFmt = reset.toLocaleDateString('en-CA', { month: 'long', day: 'numeric' });
        showUploadNotice(
          `You've used all 3 uploads for this month. Your quota resets on ${resetFmt}.`,
          'error'
        );
        return;
      }
    }

    // Read advanced options (premium only — elements absent for free tier)
    const codeFormat   = document.getElementById('code-format')?.value   || 'standard';
    const exitWordMode = document.getElementById('exit-word-mode')?.value || 'random-short';
    const customCode   = document.getElementById('custom-code')?.value?.trim()           || '';
    const customWord   = document.getElementById('custom-exit-word')?.value?.trim()      || '';

    // Validate custom exit word before doing any work
    if (exitWordMode === 'custom' && !customWord) {
      btn.disabled = false;
      showUploadNotice('Please enter your custom exit word.', 'error');
      return;
    }

    // Generate access code
    showProgress(0, 'Preparing…');
    const accessCode = await generateAccessCode(codeFormat, customCode);

    // Generate exit word
    let exitWord;
    if (exitWordMode === 'custom') {
      exitWord = customWord.toLowerCase().trim();
    } else {
      const complexity = exitWordMode.replace('random-', '');
      exitWord = pickExitWordByComplexity(complexity);
    }
    const exitWordHash = await hashWord(exitWord);

    // ─── Audio: convert + upload to storage ───────────────────────
    if (assessmentType === 'audio') {
      if (isWavFile(uploadFile)) {
        showProgress(5, 'Converting WAV to MP3…');
        uploadFile = await convertWavFileToMp3(uploadFile);
        if (uploadFile.size > MAX_UPLOAD_BYTES) {
          throw new Error('Converted MP3 is larger than 50 MB. Please trim or compress the source audio.');
        }
      }
      storagePath = `${userId}/${accessCode}.mp3`;
      showProgress(10, 'Uploading…');
      const { error: storageError } = await supabaseClient.storage
        .from('audio-files')
        .upload(storagePath, uploadFile, {
          contentType: 'audio/mpeg',
          upsert: false,
          onUploadProgress: (progress) => {
            const pct = Math.round((progress.loaded / progress.total) * 90) + 10;
            showProgress(Math.min(99, pct), `Uploading… ${Math.min(99, pct)}%`);
          },
        });
      if (storageError) throw new Error('Upload failed: ' + storageError.message);
    } else {
      showProgress(50, 'Saving…');
    }

    // ─── Save to database ─────────────────────────────────────────
    showProgress(100, 'Saving…');
    const expiresAt = new Date(Date.now() + 7 * 24 * 60 * 60 * 1000).toISOString();

    const { error: dbError } = await supabaseClient
      .from('uploads')
      .insert({
        teacher_id:     userId,
        filename:       dbFilename,
        label:          label,
        storage_path:   storagePath,
        access_code:    accessCode,
        exit_word:      exitWord,
        exit_word_hash: exitWordHash,
        expires_at:     expiresAt,
        file_size_mb:   uploadFile ? uploadFile.size / 1024 / 1024 : 0,
        assessment_type: assessmentType,
        text_content:    textContent,
        text_char_count: textCharCount,
      });

    if (dbError) {
      if (assessmentType === 'audio') {
        await supabaseClient.storage.from('audio-files').remove([storagePath]);
      }
      if (dbError.code === '23505') {
        throw new Error('The generated access code was already taken — this is rare. Please try uploading again.');
      }
      throw new Error('Could not save upload record: ' + dbError.message);
    }

    // Persist the teacher's preferred exit word mode for next time
    await supabaseClient.from('profiles').update({ exit_word_mode: exitWordMode }).eq('id', userId);

    // Reset form
    hideProgress();
    document.getElementById('label-input').value = '';
    document.getElementById('file-input').value = '';
    document.getElementById('text-content-input').value = '';
    document.getElementById('file-hint').textContent = 'Max 50 MB · MP3 or WAV (WAV converts to MP3)';
    document.getElementById('text-hint').textContent = 'Plain text only · Max 25,000 characters';
    document.getElementById('assessment-type').value = 'audio';
    selectAssessmentType('audio');
    if (document.getElementById('exit-word-mode'))  document.getElementById('exit-word-mode').value  = 'random-short';
    if (document.getElementById('code-format'))     document.getElementById('code-format').value     = 'standard';
    if (document.getElementById('custom-exit-word')) document.getElementById('custom-exit-word').value = '';
    if (document.getElementById('custom-code'))     document.getElementById('custom-code').value     = '';
    toggleCustomExitWord();
    toggleCustomCode();
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
    .select('id, filename, label, access_code, exit_word, expires_at, storage_path, file_size_mb, assessment_type, text_char_count')
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
          Once you upload an audio file, you’ll get an <strong>access code</strong> for your student and an <strong>exit word</strong> that you read aloud when the assessment is finished.
        </p>

        <div style="display:flex; flex-direction:column; gap:1rem; margin-bottom:1.5rem;">
          <div style="border:1px solid var(--warm-mid); padding:1rem;">
            <p class="label" style="margin-bottom:0.3rem;">Step 1 — Label</p>
            <p style="font-size:0.85rem; color:var(--muted); margin:0;">Give the assessment a name your students will recognise (e.g. “Grade 7 Reading — May 26”).</p>
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
    const displayName  = u.label || (isText ? 'Text Assessment' : u.filename);
    const typeBadge    = isText
      ? '<span class="chip chip--active" style="font-size:0.65rem; margin-left:0.4rem;">Text</span>'
      : '';
    const metaLine     = isText
      ? `<div class="col-assessment__filename">${u.text_char_count || 0} chars</div>`
      : (u.label && u.label !== u.filename ? `<div class="col-assessment__filename">${escapeHtml(u.filename)}</div>` : '');

    const extendBtn = (!expired && currentTier !== 'free')
      ? `<button class="btn btn--ghost btn--small" onclick="openExpiryModal('${u.id}', '${u.expires_at}')">Edit Expiry</button>`
      : '';

    const statsBlock = buildUploadStatsBlock(u.id);

    return `
      <tr>
        <td class="col-assessment">
          <div class="col-assessment__label">${escapeHtml(displayName)}${typeBadge}</div>
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

function formatDuration(seconds) {
  if (!seconds) return null;
  const m = Math.floor(seconds / 60);
  const s = Math.floor(seconds % 60).toString().padStart(2, '0');
  return `${m}:${s}`;
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

// ─── Duplicate ───────────────────────────────────────────────────

async function duplicateUpload(id, btn) {
  if (!confirm('Create a new access code for this audio file? The original will remain unchanged.')) return;

  btn.disabled    = true;
  btn.textContent = 'Duplicating…';

  try {
    const session = await getSession();
    if (!session) { window.location.href = '/login.html'; return; }
    const userId = session.user.id;

    // Fetch source row
    const { data: source, error: fetchErr } = await supabaseClient
      .from('uploads')
      .select('filename, label, storage_path, file_size_mb, assessment_type, text_content, text_char_count')
      .eq('id', id)
      .single();

    if (fetchErr || !source) throw new Error('Could not load assessment details.');

    // Generate new code and exit word (standard format defaults).
    // Retry up to 3 times on the rare chance of a global code collision (23505).
    const expiresAt = new Date(Date.now() + 7 * 24 * 60 * 60 * 1000).toISOString();
    let lastErr;
    let inserted = false;

    for (let attempt = 0; attempt < 3; attempt++) {
      const newCode     = await generateAccessCode('standard');
      const newWord     = pickExitWord();
      const newWordHash = await hashWord(newWord);

      const { error } = await supabaseClient
        .from('uploads')
        .insert({
          teacher_id:     userId,
          filename:       source.filename,
          label:          source.label,
          storage_path:   source.storage_path,
          access_code:    newCode,
          exit_word:      newWord,
          exit_word_hash: newWordHash,
          expires_at:     expiresAt,
          file_size_mb:   source.file_size_mb || 0,
          assessment_type: source.assessment_type || 'audio',
          text_content:    source.text_content || null,
          text_char_count: source.text_char_count || 0,
        });

      if (!error) { inserted = true; break; }
      if (error.code !== '23505') { lastErr = error; break; }
      lastErr = error; // code collision — try again
    }

    if (!inserted) throw new Error('Could not create duplicate: ' + (lastErr?.message || 'unknown error'));

    await loadUploads();
    await loadQuota();

  } catch (err) {
    alert(err.message);
  } finally {
    btn.disabled    = false;
    btn.textContent = 'Duplicate';
  }
}

// ─── Stripe upgrade ──────────────────────────────────────────────

async function startUpgrade() {
  const btn = document.getElementById('btn-upgrade');
  if (btn) btn.textContent = 'Redirecting…';
  const session = await getSession();
  if (!session) { window.location = '/login.html'; return; }

  const res = await fetch('/api/stripe-checkout', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${session.access_token}` }
  });
  const { url, error } = await res.json();
  if (error) { alert('Could not start checkout: ' + error); if (btn) btn.textContent = 'Upgrade to Premium →'; return; }
  window.location = url;
}

// Check for successful return from Stripe
if (new URLSearchParams(window.location.search).get('upgraded') === '1') {
  history.replaceState(null, '', window.location.pathname);
  const banner = document.createElement('div');
  banner.style.cssText = 'position:fixed;top:0;left:0;right:0;background:var(--ink);color:var(--paper);text-align:center;padding:0.6rem;font-size:0.85rem;z-index:999;';
  banner.textContent = 'Welcome to Teacher Premium! Your account has been upgraded.';
  document.body.prepend(banner);
  setTimeout(() => banner.remove(), 6000);
}

// ─── Quota ───────────────────────────────────────────────────────

async function loadQuota() {
  const session = await getSession();
  if (!session) return;
  const userId = session.user.id;

  // Resolve tier via the cascade function (division → school → teacher → free)
  currentTier = await getEffectiveTier(userId);

  // Fetch profile for role and org affiliation
  const { data: profile } = await supabaseClient
    .from('profiles')
    .select('role, school_id, division_id, tier, tier_override, expires_at, exit_word_mode')
    .eq('id', userId)
    .maybeSingle();

  // Pre-select the exit word mode dropdown to the saved preference
  if (profile?.exit_word_mode) {
    const modeEl = document.getElementById('exit-word-mode');
    if (modeEl) modeEl.value = profile.exit_word_mode;
  }

  currentRole = profile?.role || 'teacher';

  // Show role-appropriate nav links
  if (currentRole === 'platform_admin') {
    document.getElementById('admin-nav-link')?.classList.remove('hidden');
  } else if (currentRole === 'school_admin') {
    document.getElementById('school-admin-nav-link')?.classList.remove('hidden');
  } else if (currentRole === 'division_admin') {
    document.getElementById('div-admin-nav-link')?.classList.remove('hidden');
  }

  // Tier badge
  const badgeEl = document.getElementById('tier-badge');
  if (badgeEl) {
    const badgeLabels = { free: 'Free', premium: 'Teacher Premium', school: 'School Plan', division: 'Division Plan' };
    badgeEl.textContent  = badgeLabels[currentTier] || currentTier;
    badgeEl.classList.remove('hidden', 'tier-badge--paid');
    if (currentTier !== 'free') badgeEl.classList.add('tier-badge--paid');
  }

  // Show/hide premium advanced options section
  const advancedSection = document.getElementById('advanced-options');
  if (advancedSection) {
    advancedSection.classList.toggle('hidden', currentTier === 'free');
  }

  // Upgrade CTA / trial status
  const ctaEl = document.getElementById('upgrade-cta');
  const trialBanner = document.getElementById('trial-banner');
  const trialBannerText = document.getElementById('trial-banner-text');
  const trialBannerBtn = document.getElementById('trial-banner-btn');

  if (ctaEl) {
    const expiresAt = profile?.expires_at ? new Date(profile.expires_at) : null;
    const isTrial   = expiresAt && profile?.tier === 'premium' && !profile?.tier_override && !profile?.school_id && !profile?.division_id;
    const trialExpired = isTrial && expiresAt < new Date();
    const daysSinceExpiry = trialExpired ? Math.floor((Date.now() - expiresAt) / (1000 * 60 * 60 * 24)) : null;
    const daysLeft = expiresAt ? Math.ceil((expiresAt - Date.now()) / (1000 * 60 * 60 * 24)) : null;

    // ——— Visible trial banner ———
    if (isTrial && daysLeft !== null && daysLeft > 0) {
      trialBanner?.classList.remove('hidden');
      if (daysLeft <= 7) {
        trialBanner.style.background = 'var(--light-accent)';
        trialBanner.style.borderColor = 'var(--accent)';
        trialBannerText.innerHTML = `<strong style="color:var(--accent);">Trial ends in ${daysLeft} day${daysLeft === 1 ? '' : 's'}</strong> — Upgrade to keep unlimited uploads.`;
      } else {
        trialBanner.style.background = '#f0f8f0';
        trialBanner.style.borderColor = '#4a7c59';
        trialBannerText.innerHTML = `<strong style="color:#4a7c59;">Trial ends in ${daysLeft} day${daysLeft === 1 ? '' : 's'}</strong> — Upgrade to keep unlimited uploads.`;
      }
      trialBannerBtn.textContent = 'Upgrade Now';
      trialBannerBtn.onclick = startUpgrade;
    } else if (trialExpired && daysSinceExpiry !== null && daysSinceExpiry <= 15) {
      trialBanner?.classList.remove('hidden');
      trialBanner.style.background = 'var(--light-accent)';
      trialBanner.style.borderColor = 'var(--accent)';
      trialBannerText.innerHTML = `<strong style="color:var(--accent);">Your trial has expired</strong> — You're back on the Free plan.`;
      trialBannerBtn.textContent = 'Request Extension';
      trialBannerBtn.onclick = () => openRequestModal('premium_trial');
    } else {
      trialBanner?.classList.add('hidden');
    }

    if (currentTier === 'free') {
      if (trialExpired && daysSinceExpiry !== null && daysSinceExpiry <= 15) {
        ctaEl.innerHTML = `
          <span>Your 30-day premium trial has expired.</span>
          <button id="btn-request-premium" style="margin-left:1rem; padding:0.3rem 0.9rem; border:1px solid var(--ink); background:var(--paper); color:var(--ink); font-family:inherit; font-size:0.8rem; letter-spacing:0.08em; text-transform:uppercase; cursor:pointer;">Request Premium Access</button>
        `;
        ctaEl.classList.remove('hidden');
        document.getElementById('btn-request-premium')?.addEventListener('click', () => openRequestModal('premium_trial'));
      } else {
        ctaEl.innerHTML = `
          <span>You're on the Free plan — 3 uploads/month, 50 MB storage.</span>
          <button id="btn-upgrade" style="margin-left:1rem; padding:0.3rem 0.9rem; border:1px solid var(--ink); background:var(--ink); color:var(--paper); font-family:inherit; font-size:0.8rem; letter-spacing:0.08em; text-transform:uppercase; cursor:pointer;">Upgrade to Premium →</button>
        `;
        ctaEl.classList.remove('hidden');
        document.getElementById('btn-upgrade')?.addEventListener('click', startUpgrade);
      }
    } else if (isTrial && daysLeft !== null && daysLeft <= 7 && daysLeft > 0) {
      ctaEl.innerHTML = `
        <span>Premium trial expires in ${daysLeft} day${daysLeft === 1 ? '' : 's'}.</span>
        <button id="btn-extend-trial" style="margin-left:1rem; padding:0.3rem 0.9rem; border:1px solid var(--ink); background:var(--paper); color:var(--ink); font-family:inherit; font-size:0.8rem; letter-spacing:0.08em; text-transform:uppercase; cursor:pointer;">Request Extension</button>
      `;
      ctaEl.classList.remove('hidden');
      document.getElementById('btn-extend-trial')?.addEventListener('click', () => openRequestModal('premium_trial'));
    } else if (profile?.school_id) {
      ctaEl.innerHTML = `Your school is on a plan. <a href="/settings.html" style="color:var(--ink);">View subscription details</a>`;
      ctaEl.classList.remove('hidden');
    } else if (profile?.division_id) {
      ctaEl.innerHTML = `Your division is on a plan. <a href="/settings.html" style="color:var(--ink);">View subscription details</a>`;
      ctaEl.classList.remove('hidden');
    } else {
      ctaEl.classList.add('hidden');
    }
  }

  const el = document.getElementById('quota-indicator');
  if (!el) return;

  if (currentTier !== 'free') {
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

  const used     = count || 0;
  const limit    = 3;
  const reset    = new Date(now.getFullYear(), now.getMonth() + 1, 1);
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
    .select('storage_path, file_size_mb')
    .eq('teacher_id', userId);

  // De-duplicate by storage_path so duplicated uploads don't double-count
  const seen  = new Set();
  const total = (data || []).reduce((sum, row) => {
    if (seen.has(row.storage_path)) return sum;
    seen.add(row.storage_path);
    return sum + (row.file_size_mb || 0);
  }, 0);

  await supabaseClient
    .from('profiles')
    .update({ storage_used_mb: total })
    .eq('id', userId);
}

// ─── First Login ─────────────────────────────────────────────────

async function checkFirstLogin() {
  const session = await getSession();
  if (!session) return;

  const { data: profile } = await supabaseClient
    .from('profiles')
    .select('division_name')
    .eq('id', session.user.id)
    .maybeSingle();

  if (!profile || !profile.division_name) {
    document.getElementById('first-login-modal').classList.remove('hidden');
    populateDivisionSuggestions();
  }
}

async function populateDivisionSuggestions() {
  try {
    const { data: divisions } = await supabaseClient
      .from('divisions')
      .select('name')
      .order('name');
    const datalist = document.getElementById('division-suggestions');
    if (datalist && divisions) {
      datalist.innerHTML = divisions
        .map(d => `<option value="${escapeHtml(d.name)}">`)
        .join('');
    }
  } catch {
    // Non-critical — freeform input still works if this fails
  }
}

async function submitDivisionSetup() {
  if (document.getElementById('division-honeypot').value) {
    document.getElementById('first-login-modal').classList.add('hidden');
    return;
  }

  const divisionName = document.getElementById('division-name-input').value.trim();
  if (!divisionName) {
    document.getElementById('division-name-input').focus();
    return;
  }

  const session = await getSession();
  if (!session) return;

  await supabaseClient
    .from('profiles')
    .update({ division_name: divisionName, tos_accepted_at: new Date().toISOString() })
    .eq('id', session.user.id);

  document.getElementById('first-login-modal').classList.add('hidden');
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

// ─── In-App Request Flow ─────────────────────────────────────────

function openRequestModal(defaultType) {
  const modal = document.getElementById('request-modal');
  const select = document.getElementById('request-type-select');
  if (select && defaultType) select.value = defaultType;
  updateRequestModalTitle();
  document.getElementById('request-message').value = '';
  modal.classList.remove('hidden');
}

function updateRequestModalTitle() {
  const type = document.getElementById('request-type-select')?.value;
  const titles = {
    premium_trial: 'Request Premium Access',
    school_plan:   'Request School Plan',
    division_plan: 'Request Division Plan',
  };
  document.getElementById('request-modal-title').textContent = titles[type] || 'Request Access';
}

async function submitRequest() {
  const type    = document.getElementById('request-type-select').value;
  const message = document.getElementById('request-message').value.trim();

  try {
    const session = await getSession();
    if (!session) { window.location.href = '/login.html'; return; }

    const user = session.user;

    const res = await fetch('/api/request-access', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        name:      user.user_metadata?.full_name || user.email,
        email:     user.email,
        teacherId: user.id,
        requestType: type,
        message:   message,
      }),
    });

    const data = await res.json();
    if (!res.ok) throw new Error(data.error || 'Request failed');

    document.getElementById('request-modal').classList.add('hidden');
    showUploadNotice('Request submitted. You\'ll be notified by email when it\'s reviewed.', 'success');
  } catch (err) {
    showUploadNotice(err.message, 'error');
  }
}

// ─── Util ────────────────────────────────────────────────────────

function escapeHtml(str) {
  return str
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#39;');
}
