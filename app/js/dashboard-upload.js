// ─── Inline image upload helpers ─────────────────────────────────

async function uploadInlineImages(teacherId, accessCode) {
  if (pendingImages.length === 0) return { html: null, count: 0, totalBytes: 0 };

  const editor = document.getElementById('text-content-editor');
  let totalBytes = 0;

  for (let i = 0; i < pendingImages.length; i++) {
    const { blob } = pendingImages[i];
    const ext = blob.type === 'image/png' ? 'png'
              : blob.type === 'image/webp' ? 'webp'
              : 'jpg';
    const storagePath = teacherId + '/' + accessCode + '/img_' + i + '.' + ext;

    showProgress(10 + Math.round((i / pendingImages.length) * 70), t('dashboard.uploadingImage', { current: i + 1, total: pendingImages.length }));

    const { error } = await supabaseClient.storage
      .from('assessment-images')
      .upload(storagePath, blob, {
        contentType: blob.type,
        upsert: false,
      });

    if (error) throw new Error(t('dashboard.imageUploadFailed', { error: error.message }));

    totalBytes += blob.size;
  }

  // Build HTML: replace blob URLs in editor with placeholder img tags
  const imgs = editor.querySelectorAll('img');
  let imgIdx = 0;
  for (const img of imgs) {
    if (img.src.startsWith('blob:')) {
      img.setAttribute('data-apimg-idx', String(imgIdx));
      img.removeAttribute('src');
      imgIdx++;
    }
  }

  // Extract and normalize HTML from editor
  let html = normalizeEditorHTML(editor);

  return { html, count: pendingImages.length, totalBytes };
}

function normalizeEditorHTML(editor) {
  // Clone the editor DOM so we don't modify the displayed version
  const clone = editor.cloneNode(true);

  // Wrap bare top-level text nodes in <p> tags
  const children = [...clone.childNodes];
  clone.innerHTML = '';
  for (const child of children) {
    if (child.nodeType === Node.TEXT_NODE) {
      const text = child.textContent.trim();
      if (text.length === 0) continue;
      const p = document.createElement('p');
      p.textContent = text;
      clone.appendChild(p);
    } else if (child.nodeType === Node.ELEMENT_NODE) {
      clone.appendChild(child);
    }
  }

  // Strip non-whitelisted attributes from all elements
  const ALLOWED_ATTRS = new Set(['data-apimg-idx', 'alt']);
  const walkAttrs = (el) => {
    for (const attr of [...el.attributes]) {
      if (!ALLOWED_ATTRS.has(attr.name)) {
        el.removeAttribute(attr.name);
      }
    }
    for (const child of el.children) walkAttrs(child);
  };
  walkAttrs(clone);

  return clone.innerHTML;
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
      const editorEl = document.getElementById('text-content-editor');
      const raw = editorEl ? editorEl.innerText || '' : '';
      textContent = normalizeTextContent(raw);
      if ((!textContent || textContent.length === 0) && pendingImages.length === 0) {
        btn.disabled = false;
        showUploadNotice(t('dashboard.textEmpty'), 'error');
        return;
      }
      if (textContent.length > 25000) {
        btn.disabled = false;
        showUploadNotice(t('dashboard.textTooLong'), 'error');
        return;
      }
      textCharCount = textContent.length;
      dbFilename    = 'text-assessment.txt';
      storagePath   = `text/${userId}`;  // synthetic placeholder (NOT NULL constraint)
      uploadFile    = null;

      // Check total image size against storage cap (free tier)
      const totalImageMB = pendingImages.reduce((sum, img) => sum + img.blob.size, 0) / 1024 / 1024;
      if (currentTier === 'free') {
        const { data: profile } = await supabaseClient
          .from('profiles')
          .select('storage_used_mb')
          .eq('id', userId)
          .maybeSingle();
        const storageUsed = profile?.storage_used_mb || 0;
        if (storageUsed + totalImageMB > 50) {
          btn.disabled = false;
          showUploadNotice(
            t('dashboard.storageExceededImages', { size: totalImageMB.toFixed(1), remaining: (50 - storageUsed).toFixed(1) }),
            'error'
          );
          return;
        }
      }
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
        const proceed = confirm(t('dashboard.duplicateConfirm', { name: dbFilename }));
        if (!proceed) { btn.disabled = false; return; }
      }

      // Check storage cap for audio — use original file size as estimate
      // (staging file is temporary, but we check conservatively)
      if (currentTier === 'free') {
        const { data: profile } = await supabaseClient
          .from('profiles')
          .select('storage_used_mb')
          .eq('id', userId)
          .maybeSingle();
        const storageUsed = profile?.storage_used_mb || 0;
        const estimatedUploadMb = selectedFile.size / 1024 / 1024;
        if (storageUsed + estimatedUploadMb > 50) {
          btn.disabled = false;
          showUploadNotice(
            t('dashboard.storageExceeded', { size: estimatedUploadMb.toFixed(1), used: storageUsed.toFixed(1) }),
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
        const locale   = window.getLocale ? window.getLocale() : 'en';
        const resetFmt = new Intl.DateTimeFormat(locale, { month: 'long', day: 'numeric' }).format(reset);
        showUploadNotice(
          t('dashboard.quotaFreeFull', { limit: 3, date: resetFmt }),
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
      showUploadNotice(t('dashboard.exitWordRequired'), 'error');
      return;
    }

    // Generate access code
    showProgress(0, t('dashboard.preparing'));
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

    // ─── Text with images: upload to assessment-images bucket ─────
    let imageCount = 0;
    let imageTotalBytes = 0;
    if (assessmentType === 'text' && pendingImages.length > 0) {
      const result = await uploadInlineImages(userId, accessCode);
      textContent = result.html;
      imageCount = result.count;
      imageTotalBytes = result.totalBytes;
    } else if (assessmentType === 'text') {
      // Plain text (no images) — wrap in <p> tags for consistent player rendering
      if (textContent) {
        textContent = textContent
          .split(/\n{2,}/)
          .map(s => s.trim())
          .filter(s => s.length > 0)
          .map(s => '<p>' + escapeHtml(s) + '</p>')
          .join('\n');
      } else {
        textContent = '';
      }
      imageCount = 0;
    }

    // ─── Audio: upload original file to staging path ─────────────
    // The original file (WAV or MP3) is uploaded to a staging prefix.
    // A server-side process (Vercel function ffmpeg) will transcode it
    // (32kbps for free tier, 128kbps for non-free) and move to final path.
    if (assessmentType === 'audio') {
      // Determine content type from the actual file
      const contentType = isWavFile(uploadFile) ? 'audio/wav' : 'audio/mpeg';

      // Upload to staging path — the Edge Function will move to final
      storagePath = `staging/${userId}/${accessCode}.mp3`;
      showProgress(10, t('dashboard.uploadingAudio'));
      const { error: storageError } = await supabaseClient.storage
        .from('audio-files')
        .upload(storagePath, uploadFile, {
          contentType: contentType,
          upsert: false,
          onUploadProgress: (progress) => {
            const pct = Math.round((progress.loaded / progress.total) * 80) + 10;
            showProgress(Math.min(89, pct), t('dashboard.uploading') + ' ' + t('dashboard.uploadProgress', { pct: Math.min(89, pct) }));
          },
        });
      if (storageError) throw new Error(t('dashboard.audioUploadFailed', { error: storageError.message }));
    } else {
      showProgress(50, t('common.saving'));
    }

    // ─── Save to database ─────────────────────────────────────────
    showProgress(90, t('dashboard.savingRecord'));
    const expiresAt = new Date(Date.now() + 7 * 24 * 60 * 60 * 1000).toISOString();

    // Audio assessments start with processing_status='pending' — the
    // Edge Function will transition to 'ready' after transcoding.
    // Text assessments and legacy rows use 'ready'.
    const processingStatus = assessmentType === 'audio' ? 'pending' : 'ready';

    const { data: insertedRecord, error: dbError } = await supabaseClient
      .from('uploads')
      .insert({
        teacher_id:       userId,
        filename:         dbFilename,
        label:            label,
        storage_path:     storagePath,
        access_code:      accessCode,
        exit_word:        exitWord,
        exit_word_hash:   exitWordHash,
        expires_at:       expiresAt,
        file_size_mb:     uploadFile
          ? uploadFile.size / 1024 / 1024
          : (imageTotalBytes / 1024 / 1024),
        assessment_type:  assessmentType,
        text_content:     textContent,
        text_char_count:  textCharCount,
        image_count:      imageCount,
        processing_status: processingStatus,
      })
      .select('id')
      .maybeSingle();

    if (dbError) {
      if (assessmentType === 'audio') {
        await supabaseClient.storage.from('audio-files').remove([storagePath]);
      }
      if (dbError.code === '23505') {
        throw new Error(t('dashboard.duplicateCode'));
      }
      throw new Error(t('dashboard.saveRecordFailed', { error: dbError.message }));
    }

    const uploadId = insertedRecord?.id;

    // ─── Trigger audio normalization (only for audio assessments) ──
    if (assessmentType === 'audio' && uploadId) {
      const quality = (currentTier !== 'free') ? '128kbps' : '32kbps';
      showProgress(92, t('dashboard.normalizingAudio', { quality }));

      // Call the Vercel trigger function (native ffmpeg transcoding)
      const controller = new AbortController();
      const timeoutId = setTimeout(() => controller.abort(), 30000);

      const triggerResp = await fetch('/api/trigger-normalize', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + session.access_token,
        },
        body: JSON.stringify({ upload_id: uploadId }),
        signal: controller.signal,
      });
      clearTimeout(timeoutId);

      if (!triggerResp.ok) {
        const errData = await triggerResp.json().catch(() => ({}));
        console.warn('Normalization trigger returned', triggerResp.status, errData);
        // Don't throw — polling will eventually time out and we'll show a
        // warning. The file stays in staging and processing_status stays
        // at 'pending', allowing manual retry via the dashboard.
      }

      // Poll for processing to complete (up to ~5 minutes)
      let normalized = false;
      for (let i = 0; i < 60; i++) {
        await new Promise(r => setTimeout(r, 5000)); // 5s between polls

        const { data: statusCheck } = await supabaseClient
          .from('uploads')
          .select('processing_status, storage_path')
          .eq('id', uploadId)
          .maybeSingle();

        if (statusCheck?.processing_status === 'ready') {
          // Normalization completed — storage_path now points to final path
          storagePath = statusCheck.storage_path;
          showProgress(100, t('dashboard.audioNormalized'));
          await new Promise(r => setTimeout(r, 500));
          normalized = true;
          break;
        }

        if (statusCheck?.processing_status === 'failed') {
          throw new Error(t('dashboard.normalizationFailed'));
        }

        // Still processing — show periodic status
        const elapsed = (i + 1) * 5;
        showProgress(92, t('dashboard.normalizingAudioElapsed', { elapsed }));
      }

      if (!normalized) {
        // Polling exhausted — normalization is still running in the background.
        // The record will eventually be marked 'ready' or 'failed'.
        console.warn('Normalization polling exhausted for', uploadId);
        showUploadNotice(
          t('dashboard.processingBackground'),
          'success'
        );
      }
    }

    // Persist the teacher's preferred exit word mode for next time
    await supabaseClient.from('profiles').update({ exit_word_mode: exitWordMode }).eq('id', userId);

    // Reset form
    hideProgress();
    document.getElementById('label-input').value = '';
    document.getElementById('file-input').value = '';
    const textEditor = document.getElementById('text-content-editor');
    if (textEditor) {
      textEditor.innerHTML = '';
      pendingImages.forEach(img => URL.revokeObjectURL(img.url));
      pendingImages = [];
    }
    const quality = (currentTier !== 'free') ? '128kbps' : '32kbps';
    document.getElementById('file-hint').textContent = t('dashboard.audioHint', { bitrate: quality });
    document.getElementById('text-hint').textContent = t('dashboard.textHint');
    document.getElementById('assessment-type').value = 'audio';
    selectAssessmentType('audio');
    if (document.getElementById('exit-word-mode'))  document.getElementById('exit-word-mode').value  = 'random-short';
    if (document.getElementById('code-format'))     document.getElementById('code-format').value     = 'standard';
    if (document.getElementById('custom-exit-word')) document.getElementById('custom-exit-word').value = '';
    if (document.getElementById('custom-code'))     document.getElementById('custom-code').value     = '';
    toggleCustomExitWord();
    toggleCustomCode();
    btn.disabled = true;
    showUploadNotice(t('dashboard.uploadSuccess'), 'success');
    await loadUploads();
    await recalculateStorage(userId);
    await loadQuota();

  } catch (err) {
    hideProgress();
    btn.disabled = false;
    showUploadNotice(err.message, 'error');
  }
}

// ─── Duplicate ───────────────────────────────────────────────────

async function duplicateUpload(id, btn) {
  if (!confirm(t('dashboard.duplicateUpload'))) return;

  btn.disabled    = true;
  btn.textContent = t('dashboard.duplicateUploading');

  try {
    const session = await getSession();
    if (!session) { window.location.href = '/login.html'; return; }
    const userId = session.user.id;

    // Fetch source row
    const { data: source, error: fetchErr } = await supabaseClient
      .from('uploads')
      .select('filename, label, storage_path, file_size_mb, assessment_type, text_content, text_char_count, image_count, access_code, teacher_id')
      .eq('id', id)
      .single();

    if (fetchErr || !source) throw new Error(t('dashboard.loadAssessmentDetailsFailed'));

    // Generate new code and exit word (standard format defaults).
    // Retry up to 3 times on the rare chance of a global code collision (23505).
    const expiresAt = new Date(Date.now() + 7 * 24 * 60 * 60 * 1000).toISOString();
    let lastErr;
    let inserted = false;

    for (let attempt = 0; attempt < 3; attempt++) {
      const newCode     = await generateAccessCode('standard');
      const newWord     = pickExitWord();
      const newWordHash = await hashWord(newWord);

      // Copy inline images if present (first attempt only)
      let imageCount = 0;
      let imageTotalBytes = 0;
      if (attempt === 0 && source.assessment_type === 'text' && source.image_count > 0) {
        for (let i = 0; i < source.image_count; i++) {
          let copied = false;
          for (const ext of ['png', 'jpg', 'webp']) {
            const oldPath = source.teacher_id + '/' + source.access_code + '/img_' + i + '.' + ext;
            const newPath = userId + '/' + newCode + '/img_' + i + '.' + ext;

            const { data: signedData, error: signError } = await supabaseClient
              .storage
              .from('assessment-images')
              .createSignedUrl(oldPath, 60);

            if (!signError && signedData) {
              const response = await fetch(signedData.signedUrl);
              if (!response.ok) continue;
              const blob = await response.blob();

              const { error: uploadError } = await supabaseClient.storage
                .from('assessment-images')
                .upload(newPath, blob, {
                  contentType: blob.type,
                  upsert: false,
                });

              if (!uploadError) {
                imageCount++;
                imageTotalBytes += blob.size;
                copied = true;
              }
              break;
            }
          }
        }
      }

      // Duplicate points to the SAME final storage path as the original
      // (the file on disk is shared). processing_status is 'ready' since
      // the audio is already normalized.
      const { error } = await supabaseClient
        .from('uploads')
        .insert({
          teacher_id:        userId,
          filename:          source.filename,
          label:             source.label,
          storage_path:      source.storage_path,
          access_code:       newCode,
          exit_word:         newWord,
          exit_word_hash:    newWordHash,
          expires_at:        expiresAt,
          file_size_mb:      (source.file_size_mb || 0) + (imageTotalBytes / (1024 * 1024)),
          assessment_type:   source.assessment_type || 'audio',
          text_content:      source.text_content || null,
          text_char_count:   source.text_char_count || 0,
          image_count:       imageCount,
          processing_status: 'ready',
        });

      if (!error) { inserted = true; break; }
      if (error.code !== '23505') { lastErr = error; break; }
      lastErr = error; // code collision — try again
    }

    if (!inserted) throw new Error(t('dashboard.duplicateFailed', { error: lastErr?.message || 'unknown error' }));

    await loadUploads();
    await loadQuota();

  } catch (err) {
    alert(err.message);
  } finally {
    btn.disabled    = false;
    btn.textContent = t('dashboard.duplicate');
  }
}

// ─── Retry Normalization ────────────────────────────────────────

async function retryNormalize(uploadId, btn) {
  btn.disabled    = true;
  btn.textContent = t('dashboard.normalizationRetrying');

  try {
    const session = await getSession();
    if (!session) { window.location.href = '/login.html'; return; }

    // Reset processing_status to 'pending' so the function will process it
    const { error: resetError } = await supabaseClient
      .from('uploads')
      .update({ processing_status: 'pending' })
      .eq('id', uploadId);

    if (resetError) throw new Error(t('dashboard.resetStatusFailed', { error: resetError.message }));

    // Call trigger-normalize
    const resp = await fetch('/api/trigger-normalize', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + session.access_token,
      },
      body: JSON.stringify({ upload_id: uploadId }),
    });

    if (!resp.ok) {
      const err = await resp.json().catch(() => ({}));
      console.warn('Retry trigger returned', resp.status, err);
    }

    // Poll for completion (up to ~5 minutes)
    for (let i = 0; i < 60; i++) {
      await new Promise(r => setTimeout(r, 5000));

      const { data: statusCheck } = await supabaseClient
        .from('uploads')
        .select('processing_status')
        .eq('id', uploadId)
        .maybeSingle();

      if (statusCheck?.processing_status === 'ready') {
        btn.textContent = t('dashboard.retry');
        btn.disabled = false;
        await loadUploads();
        return;
      }

      if (statusCheck?.processing_status === 'failed') {
        throw new Error(t('dashboard.normalizationRetryFailed'));
      }
    }

    // Timed out — tell user to check back
    btn.textContent = t('dashboard.retry');
    btn.disabled = false;
    alert(t('dashboard.processingBackground'));
    await loadUploads();

  } catch (err) {
    btn.textContent = t('dashboard.retry');
    btn.disabled = false;
    alert(t('dashboard.retryAlert', { error: err.message }));
    await loadUploads();
  }
}
