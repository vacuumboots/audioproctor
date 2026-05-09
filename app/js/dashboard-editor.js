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
    // Initialize editor if not already done
    if (!document.getElementById('text-content-editor')._initialized) {
      initTextEditor();
      document.getElementById('text-content-editor')._initialized = true;
    }
    // Clear editor
    const editor = document.getElementById('text-content-editor');
    editor.innerHTML = '';
    // Revoke old blob URLs
    pendingImages.forEach(img => URL.revokeObjectURL(img.url));
    pendingImages = [];
    handleEditorInput();
  } else {
    audioGroup.classList.remove('hidden');
    textGroup.classList.add('hidden');
    // Clear editor when leaving text mode
    const editor = document.getElementById('text-content-editor');
    if (editor) {
      editor.innerHTML = '';
      pendingImages.forEach(img => URL.revokeObjectURL(img.url));
      pendingImages = [];
    }
  }

  btn.disabled = true;
  hideUploadNotice();
}

// ─── Contenteditable editor ──────────────────────────────────────

function initTextEditor() {
  const editor = document.getElementById('text-content-editor');
  if (!editor) return;

  editor.addEventListener('paste', handleEditorPaste);
  editor.addEventListener('input', handleEditorInput);

  // Prevent drag-and-drop of arbitrary files
  editor.addEventListener('dragover', e => e.preventDefault());
  editor.addEventListener('drop', e => {
    e.preventDefault();
    const files = e.dataTransfer?.files;
    if (files && files.length > 0) {
      insertImageFiles(files);
    }
  });
}

function handleEditorPaste(e) {
  const editor = document.getElementById('text-content-editor');
  const items = e.clipboardData?.items;
  if (!items) return;

  const imageItems = [];
  for (const item of items) {
    if (item.type.startsWith('image/')) {
      imageItems.push(item);
    }
  }

  if (imageItems.length === 0) {
    // Plain text/HTML paste — let default behavior handle it
    setTimeout(async () => {
      stripUnwantedEditorHTML();
      await capturePastedHTMLImages();
      handleEditorInput();
    }, 50);
    return;
  }

  // Has images — prevent default, handle ourselves
  e.preventDefault();

  for (const item of imageItems) {
    const blob = item.getAsFile();
    if (!blob) continue;

    // Validate type
    if (!['image/png', 'image/jpeg', 'image/webp'].includes(blob.type)) {
      showUploadNotice('Only PNG, JPEG, and WebP images are supported.', 'error');
      continue;
    }

    // Validate size
    if (blob.size > 2 * 1024 * 1024) {
      showUploadNotice('Image is larger than 2 MB. Please resize it.', 'error');
      continue;
    }

    // Create blob URL for preview
    const url = URL.createObjectURL(blob);
    const img = document.createElement('img');
    img.src = url;
    img.style.maxWidth = '100%';
    img.style.height = 'auto';

    // Insert at cursor position
    const sel = window.getSelection();
    if (sel.rangeCount > 0 && editor.contains(sel.anchorNode)) {
      const range = sel.getRangeAt(0);
      range.deleteContents();
      range.insertNode(img);
      range.setStartAfter(img);
      range.collapse(true);
      sel.removeAllRanges();
      sel.addRange(range);
    } else {
      editor.appendChild(img);
    }

    // Track for upload
    pendingImages.push({ blob, url, name: blob.name || 'pasted-image' });
  }

  handleEditorInput();
}

async function capturePastedHTMLImages() {
  const editor = document.getElementById('text-content-editor');
  if (!editor) return;

  const imgs = editor.querySelectorAll('img');
  let strippedCount = 0;

  for (const img of imgs) {
    const src = img.getAttribute('src');
    if (!src || src.startsWith('blob:')) continue;

    // Try loading the image with CORS to extract as blob
    try {
      const blob = await loadExternalImageAsBlob(src);
      if (!blob) { img.remove(); strippedCount++; continue; }

      if (!['image/png', 'image/jpeg', 'image/webp'].includes(blob.type)) {
        img.remove();
        strippedCount++;
        continue;
      }

      if (blob.size > 2 * 1024 * 1024) {
        img.remove();
        strippedCount++;
        continue;
      }

      const url = URL.createObjectURL(blob);
      img.src = url;
      img.style.maxWidth = '100%';
      img.style.height = 'auto';

      pendingImages.push({ blob, url, name: 'pasted-image' });
    } catch {
      // CORS blocked or network error — remove the image
      img.remove();
      strippedCount++;
    }
  }

  if (strippedCount > 0) {
    const msg = strippedCount === 1
      ? 'One image from the pasted content could not be included. Try taking a screenshot and pasting that instead.'
      : strippedCount + ' images from the pasted content could not be included. Try taking a screenshot and pasting that instead.';
    showUploadNotice(msg, 'error');
  }
}

function loadExternalImageAsBlob(src) {
  return new Promise((resolve) => {
    const image = new Image();
    let settled = false;
    const done = (blob) => {
      if (settled) return;
      settled = true;
      resolve(blob);
    };

    image.crossOrigin = 'anonymous';
    image.onload = () => {
      try {
        const canvas = document.createElement('canvas');
        canvas.width  = image.naturalWidth;
        canvas.height = image.naturalHeight;
        const ctx = canvas.getContext('2d');
        ctx.drawImage(image, 0, 0);
        canvas.toBlob(blob => done(blob || null), 'image/png');
      } catch {
        done(null); // canvas tainted (CORS blocked)
      }
    };
    image.onerror = () => done(null);
    image.src = src;

    // Safety timeout: CORS-blocked loads may hang in some browsers.
    // Ensure the promise resolves within 5s.
    setTimeout(() => done(null), 5000);
  });
}

function insertImageFiles(files) {
  const editor = document.getElementById('text-content-editor');
  if (!editor) return;

  for (const file of files) {
    if (!['image/png', 'image/jpeg', 'image/webp'].includes(file.type)) {
      showUploadNotice('"' + file.name + '" is not a supported image type.', 'error');
      continue;
    }
    if (file.size > 2 * 1024 * 1024) {
      showUploadNotice('"' + file.name + '" is larger than 2 MB.', 'error');
      continue;
    }

    const url = URL.createObjectURL(file);
    const img = document.createElement('img');
    img.src = url;
    img.style.maxWidth = '100%';
    img.style.height = 'auto';
    editor.appendChild(img);
    editor.appendChild(document.createElement('br'));

    pendingImages.push({ blob: file, url, name: file.name });
  }

  handleEditorInput();
}

function stripUnwantedEditorHTML() {
  const editor = document.getElementById('text-content-editor');
  if (!editor) return;

  const DANGEROUS = new Set(['script', 'style', 'iframe', 'object', 'embed', 'link', 'meta', 'noscript', 'template', 'applet']);
  const KEEP = new Set(['p', 'br', 'strong', 'em', 'b', 'i', 'img']);

  const walk = (node) => {
    const children = [...node.childNodes];
    for (const child of children) {
      if (child.nodeType === Node.ELEMENT_NODE) {
        const tag = child.tagName.toLowerCase();
        if (DANGEROUS.has(tag)) {
          // Truly dangerous — remove entirely
          child.remove();
        } else if (KEEP.has(tag)) {
          // Whitelisted — keep and recurse into children
          walk(child);
        } else {
          // Non-whitelisted wrapper (figure, a, picture, ul, etc.) — unwrap, keep children
          while (child.firstChild) {
            node.insertBefore(child.firstChild, child);
          }
          node.removeChild(child);
        }
      }
    }
  };
  walk(editor);
}

function handleEditorInput() {
  const editor = document.getElementById('text-content-editor');
  const btn    = document.getElementById('btn-upload');
  const hint   = document.getElementById('text-hint');
  if (!editor) return;

  const text = editor.innerText || '';
  const imageCount = pendingImages.length;

  if (text.length === 0 && imageCount === 0) {
    btn.disabled = true;
    hint.textContent = 'Paste text and images · Max 2 MB per image';
    return;
  }

  if (text.length > 25000) {
    btn.disabled = true;
    hint.textContent = text.length.toLocaleString() + ' / 25,000 characters — too long';
    return;
  }

  const imageSizeMB = pendingImages.reduce((sum, img) => sum + img.blob.size, 0) / 1024 / 1024;
  btn.disabled = false;
  hint.textContent = text.length.toLocaleString() + ' characters · ' + imageCount + ' image' + (imageCount !== 1 ? 's' : '') + ' · ' + imageSizeMB.toFixed(1) + ' MB';
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
