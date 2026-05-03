# Inline Images in Text Assessments — Implementation Plan

> **For Hermes:** Use subagent-driven-development skill to implement this plan task-by-task.

**Goal:** Let teachers paste images inline with text in assessments. Images display inline in the extension player. TTS skips them silently.

**Architecture:** Teacher dashboard gains a `contenteditable` div that accepts pasted images. Images are uploaded to a new Supabase Storage bucket (`assessment-images`) at submit time. The `text_content` column stores sanitized HTML with placeholder `<img>` tags. The session API resolves those placeholders to signed URLs. The extension player renders HTML (instead of plain text) with DOMPurify sanitization. TTS reads only text nodes, naturally skipping `<img>`.

**Tech Stack:** Vanilla JS, Supabase Storage (new bucket `assessment-images`), DOMPurify (minified, included in extension), same no-build pipeline.

**Constraints (from user):**
- 2 MB max per image
- Images count toward the 50 MB storage cap (checked at upload time)
- TTS ignores images completely — no alt text, no "image" placeholder in speech
- Images are paragraph-level (they live inside `<p>` tags where the teacher pastes them)

---

### Task 1: DB Migration — Add image_count column

**Objective:** Extend the uploads table to track inline image count.

**Files:**
- Create: `supabase/migrations/020_inline_images.sql`

**Step 1: Write the migration SQL**

```sql
-- Migration 020: Inline Image Support
-- Run in Supabase SQL editor AFTER migration 019.
--
-- Adds image_count to uploads so the session API knows how many
-- signed URLs to generate for inline images.

ALTER TABLE uploads
  ADD COLUMN IF NOT EXISTS image_count integer NOT NULL DEFAULT 0;

-- Text assessments with images must have image_count > 0
-- (plain text assessments keep 0)
ALTER TABLE uploads
  DROP CONSTRAINT IF EXISTS uploads_image_count_check,
  ADD CONSTRAINT uploads_image_count_check
  CHECK (
    assessment_type <> 'text'
    OR image_count >= 0
  );
```

**Step 2: Run in Supabase SQL editor**

**Step 3: Verify**

```sql
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'uploads' AND column_name = 'image_count';
-- Expected: image_count | integer | NO
```

**Step 4: Create Supabase Storage bucket**

In Supabase Dashboard → Storage → New Bucket:
- Name: `assessment-images`
- Public bucket: NO (private — accessed via signed URLs)
- File size limit: 2 MB

**Step 5: Set bucket RLS policies** (in Supabase SQL editor)

```sql
-- Teachers can upload images to their own directory
CREATE POLICY "teachers_upload_own_images"
  ON storage.objects
  FOR INSERT
  WITH CHECK (
    bucket_id = 'assessment-images'
    AND auth.role() = 'authenticated'
    AND (storage.foldername(name))[1] = auth.uid()::text
  );

-- Teachers can delete their own images
CREATE POLICY "teachers_delete_own_images"
  ON storage.objects
  FOR DELETE
  USING (
    bucket_id = 'assessment-images'
    AND auth.role() = 'authenticated'
    AND (storage.foldername(name))[1] = auth.uid()::text
  );

-- Session API uses service role (bypasses RLS) — no SELECT policy needed
```

**Step 6: Commit**

```bash
git add supabase/migrations/020_inline_images.sql
git commit -m "feat: add image_count column and assessment-images bucket for inline images"
```

---

### Task 2: Add contenteditable editor to dashboard HTML

**Objective:** Replace the `<textarea>` for text assessments with a `contenteditable` div that accepts images.

**Files:**
- Modify: `app/dashboard.html` (replace textarea with contenteditable)
- Modify: `app/css/styles.css` (style the editor)

**Step 1: Replace the textarea in dashboard.html**

In `app/dashboard.html`, find (around line 194):

```html
<div id="text-input-group" class="form-group hidden">
  <label class="label" for="text-content-input">Assessment Text</label>
  <textarea
    id="text-content-input"
    class="input-field"
    rows="12"
    maxlength="25000"
    placeholder="Paste the passage or assessment text here…"
    oninput="handleTextInput()"
  ></textarea>
  <span id="text-hint" class="label text-muted">Plain text only · Max 25,000 characters</span>
</div>
```

Replace with:

```html
<div id="text-input-group" class="form-group hidden">
  <label class="label">Assessment Text</label>
  <div
    id="text-content-editor"
    class="text-editor"
    contenteditable="true"
    placeholder="Paste the passage or assessment text here…"
  ></div>
  <span id="text-hint" class="label text-muted">Paste text and images · Max 2 MB per image</span>
</div>
```

**Step 2: Add editor CSS to `app/css/styles.css`**

```css
/* ── Contenteditable text editor ── */
.text-editor {
  border: 1px solid var(--ink);
  background: var(--paper);
  color: var(--ink);
  font-family: 'DM Sans', system-ui, -apple-system, sans-serif;
  font-size: 0.95rem;
  line-height: 1.7;
  padding: 0.85rem 1rem;
  min-height: 16rem;
  max-height: 32rem;
  overflow-y: auto;
  outline: none;
  word-wrap: break-word;
}

.text-editor:focus {
  outline: 2px solid var(--ink);
  outline-offset: 1px;
}

/* Placeholder shown when editor is empty */
.text-editor:empty::before {
  content: attr(placeholder);
  color: var(--muted);
  pointer-events: none;
}

/* Images inside the editor — constrained width, inline */
.text-editor img {
  max-width: 100%;
  height: auto;
  display: inline-block;
  vertical-align: middle;
  margin: 0.25rem 0;
  border: 1px solid var(--warm-mid);
}
```

**Step 3: Commit**

```bash
git add app/dashboard.html app/css/styles.css
git commit -m "feat: add contenteditable editor for text assessments with image paste support"
```

---

### Task 3: Wire up editor — paste handling + validation

**Objective:** Handle paste events in the contenteditable editor. When the clipboard contains images, extract them as blobs, validate type/size, and insert as `<img>` with blob URLs (temporary preview). Plain text pastes normally.

**Files:**
- Modify: `app/js/dashboard.js` (add editor initialization, paste handler, new validation functions)

**Step 1: Add editor initialization function**

Insert after the existing `selectAssessmentType()` function (around line 338):

```javascript
// ─── Contenteditable editor ──────────────────────────────────────
let pendingImages = [];  // { blob, name } — queued for upload on submit

function initTextEditor() {
  const editor = document.getElementById('text-content-editor');
  if (!editor) return;

  editor.addEventListener('paste', handleEditorPaste);
  editor.addEventListener('input', handleEditorInput);

  // Prevent drag-and-drop of arbitrary files (keep it simple)
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
  const items = e.clipboardData?.items;
  if (!items) return;

  const imageItems = [];
  for (const item of items) {
    if (item.type.startsWith('image/')) {
      imageItems.push(item);
    }
  }

  if (imageItems.length === 0) {
    // Plain text paste — let default behavior handle it, then normalize
    // Wait a tick for the paste to settle, then strip unwanted HTML
    setTimeout(() => {
      stripUnwantedEditorHTML();
      handleEditorInput();
    }, 0);
    return;
  }

  // Has images — prevent default, handle ourselves
  e.preventDefault();

  for (const item of imageItems) {
    const blob = item.getAsFile();
    if (!blob) continue;

    // Validate
    if (!['image/png', 'image/jpeg', 'image/webp'].includes(blob.type)) {
      showUploadNotice('Only PNG, JPEG, and WebP images are supported.', 'error');
      continue;
    }
    if (blob.size > 2 * 1024 * 1024) {
      showUploadNotice(`Image "${blob.name || 'pasted image'}" is larger than 2 MB.`, 'error');
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
    if (sel.rangeCount > 0) {
      const range = sel.getRangeAt(0);
      range.deleteContents();
      range.insertNode(img);
      // Move cursor after the image
      range.setStartAfter(img);
      range.collapse(true);
      sel.removeAllRanges();
      sel.addRange(range);
    } else {
      editor.appendChild(img);
    }

    // Track for upload
    pendingImages.push({ blob, url, name: blob.name || 'pasted-image' });

    // Trigger character count update
    handleEditorInput();
  }
}

function insertImageFiles(files) {
  for (const file of files) {
    if (!['image/png', 'image/jpeg', 'image/webp'].includes(file.type)) {
      showUploadNotice(`"${file.name}" is not a supported image type.`, 'error');
      continue;
    }
    if (file.size > 2 * 1024 * 1024) {
      showUploadNotice(`"${file.name}" is larger than 2 MB.`, 'error');
      continue;
    }

    const url = URL.createObjectURL(file);
    const img = document.createElement('img');
    img.src = url;
    img.style.maxWidth = '100%';
    img.style.height = 'auto';
    editor.appendChild(img);

    pendingImages.push({ blob: file, url, name: file.name });

    // Add a line break after dropped images for usability
    editor.appendChild(document.createElement('br'));
    handleEditorInput();
  }
}

function stripUnwantedEditorHTML() {
  const editor = document.getElementById('text-content-editor');
  if (!editor) return;

  // Remove any HTML that isn't <p>, <br>, <strong>, <em>, <img>
  // Walk child nodes, unwrap divs/spans, strip disallowed elements
  const walk = (node) => {
    const children = [...node.childNodes];
    for (const child of children) {
      if (child.nodeType === Node.ELEMENT_NODE) {
        const tag = child.tagName.toLowerCase();
        if (tag === 'div' || tag === 'span' || tag === 'font') {
          // Unwrap: move children up
          while (child.firstChild) {
            node.insertBefore(child.firstChild, child);
          }
          node.removeChild(child);
        } else if (!['p', 'br', 'strong', 'em', 'b', 'i', 'img'].includes(tag)) {
          // Remove disallowed elements
          child.remove();
        } else if (tag === 'img') {
          // Strip style attributes except max-width and height
          // Keep blob src for preview
        } else {
          walk(child);
        }
      }
    }
  };
  walk(editor);

  // Normalize: ensure paragraphs are wrapped in <p> tags
  // If editor contains bare text nodes at the top level, wrap them
  // (document.execCommand can do this but is deprecated; we'll normalize at submit time)
}
```

**Step 2: Add editor input handler (character count + button state)**

```javascript
function handleEditorInput() {
  const editor = document.getElementById('text-content-editor');
  const btn    = document.getElementById('btn-upload');
  const hint   = document.getElementById('text-hint');
  if (!editor) return;

  // Get plain text length (approximation for character limit)
  const text = editor.innerText || '';
  const imageCount = pendingImages.length;
  const imageSizeMB = pendingImages.reduce((sum, img) => sum + img.blob.size, 0) / 1024 / 1024;

  if (text.length === 0 && imageCount === 0) {
    btn.disabled = true;
    hint.textContent = 'Paste text and images · Max 2 MB per image';
    return;
  }

  if (text.length > 25000) {
    btn.disabled = true;
    hint.textContent = `${text.length.toLocaleString()} / 25,000 characters — too long`;
    return;
  }

  btn.disabled = false;
  hint.textContent = `${text.length.toLocaleString()} characters · ${imageCount} image${imageCount !== 1 ? 's' : ''} · ${imageSizeMB.toFixed(1)} MB`;
}
```

**Step 3: Update `selectAssessmentType` to init/clear editor**

Modify the existing `selectAssessmentType('text')` path (around line 320):

```javascript
if (type === 'text') {
  textGroup.classList.remove('hidden');
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
}
```

**Step 4: Commit**

```bash
git add app/js/dashboard.js
git commit -m "feat: add image paste handling to contenteditable editor"
```

---

### Task 4: Update upload flow — store images in Supabase Storage

**Objective:** When the teacher clicks "Upload Assessment" for a text assessment with images, upload images to Supabase Storage, build HTML with placeholder tags, and store everything in the uploads record.

**Files:**
- Modify: `app/js/dashboard.js` (update `handleUpload()` text branch)

**Step 1: Add image upload helper**

```javascript
async function uploadInlineImages(teacherId, accessCode) {
  if (pendingImages.length === 0) return { html: null, count: 0, totalBytes: 0 };

  const editor = document.getElementById('text-content-editor');
  const imagePaths = [];
  let totalBytes = 0;

  for (let i = 0; i < pendingImages.length; i++) {
    const { blob, url, name } = pendingImages[i];
    const ext = blob.type === 'image/png' ? 'png'
              : blob.type === 'image/webp' ? 'webp'
              : 'jpg';
    const storagePath = `${teacherId}/${accessCode}/img_${i}.${ext}`;

    showProgress(10 + Math.round((i / pendingImages.length) * 70), `Uploading image ${i + 1} of ${pendingImages.length}…`);

    const { error } = await supabaseClient.storage
      .from('assessment-images')
      .upload(storagePath, blob, {
        contentType: blob.type,
        upsert: false,
      });

    if (error) throw new Error(`Image upload failed: ${error.message}`);

    imagePaths.push(storagePath);
    totalBytes += blob.size;
  }

  // Build HTML: replace blob URLs in editor with placeholder img tags
  const imgs = editor.querySelectorAll('img');
  let imgIdx = 0;
  for (const img of imgs) {
    if (img.src.startsWith('blob:')) {
      img.setAttribute('data-apimg-idx', String(imgIdx));
      img.removeAttribute('src');  // Clear blob URL; session API fills it in
      imgIdx++;
    }
  }

  // Extract HTML from editor — normalize to clean HTML
  let html = normalizeEditorHTML(editor);

  return { html, count: pendingImages.length, totalBytes };
}
```

**Step 2: Add HTML normalization function**

```javascript
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
```

**Step 3: Modify `handleUpload()` text branch**

Replace the text branch in `handleUpload()` (lines 388-404) with:

```javascript
if (assessmentType === 'text') {
  const editor = document.getElementById('text-content-editor');
  const rawText = (editor.innerText || '').trim();

  if (!rawText && pendingImages.length === 0) {
    btn.disabled = false;
    showUploadNotice('Please add some text or images.', 'error');
    return;
  }
  if (rawText.length > 25000) {
    btn.disabled = false;
    showUploadNotice('Text is too long. Maximum 25,000 characters of text.', 'error');
    return;
  }

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
        `Images (${totalImageMB.toFixed(1)} MB) would exceed your 50 MB storage limit. You have ${(50 - storageUsed).toFixed(1)} MB remaining.`,
        'error'
      );
      return;
    }
  }

  textCharCount = rawText.length;
  dbFilename    = 'text-assessment.txt';
  storagePath   = `text/${userId}`;  // placeholder
  uploadFile    = null;

  // Image upload happens below, after access code is generated
  // (textContent set later after image upload)
}
```

Then after the access code generation (around line 486), add the image upload for text:

```javascript
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
  textContent = textContent  // already set above
    .split(/\n{2,}/)
    .map(s => s.trim())
    .filter(s => s.length > 0)
    .map(s => `<p>${escapeHTML(s)}</p>`)
    .join('\n');
  imageCount = 0;
}
```

Add the `imageCount` to the DB insert (around line 541):

```javascript
const { error: dbError } = await supabaseClient
  .from('uploads')
  .insert({
    // ... existing fields ...
    image_count:     imageCount,
  });
```

**Step 4: Add HTML escape helper**

```javascript
function escapeHTML(str) {
  const div = document.createElement('div');
  div.textContent = str;
  return div.innerHTML;
}
```

**Step 5: Update the progress flow**

For text assessments with images, after image upload completes:
```javascript
showProgress(90, 'Saving…');
```

**Step 6: Reset pendingImages on form clear**

In the reset section (around line 558-566), add:
```javascript
// Revoke blob URLs
pendingImages.forEach(img => URL.revokeObjectURL(img.url));
pendingImages = [];
const editor = document.getElementById('text-content-editor');
if (editor) editor.innerHTML = '';
```

**Step 7: Commit**

```bash
git add app/js/dashboard.js
git commit -m "feat: upload inline images to Supabase Storage on assessment submit"
```

---

### Task 5: Update session API — resolve image placeholders to signed URLs

**Objective:** When serving a text assessment with images, the session API generates signed URLs for each image and replaces the `<img data-apimg-idx="N">` placeholders with `<img src="signed-url">`.

**Files:**
- Modify: `api/session.js`

**Step 1: Add image resolution to the text branch**

In `api/session.js`, modify the text response block (around line 94):

```javascript
if (upload.assessment_type === 'text') {
  let resolvedHtml = upload.text_content;

  // Resolve inline images if present
  if (upload.image_count > 0) {
    const storagePath = upload.storage_path;  // e.g. "text/{userId}"
    const pathParts = storagePath.split('/');
    // Extract teacher_id — the storage path for text is "text/{teacherId}"
    // but we need to know the actual teacher_id. Use upload.teacher_id directly.
    const teacherId = upload.teacher_id;

    // Generate signed URLs for each image
    const signedUrls = [];
    for (let i = 0; i < upload.image_count; i++) {
      // We don't know the extension — try common ones
      // Store: {teacherId}/{accessCode}/img_{i}.{png|jpg|webp}
      // Strategy: try png first, then jpg, then webp — whichever gets a signed URL
      let found = false;
      for (const ext of ['png', 'jpg', 'webp']) {
        const imgPath = `${teacherId}/${code.toUpperCase().trim()}/img_${i}.${ext}`;
        const { data: signed, error: signError } = await supabase
          .storage
          .from('assessment-images')
          .createSignedUrl(imgPath, 3600);

        if (!signError && signed) {
          signedUrls[i] = signed.signedUrl;
          found = true;
          break;
        }
      }
      if (!found) {
        signedUrls[i] = '';  // Fallback — image not found
      }
    }

    // Replace <img data-apimg-idx="N"> with <img src="signed-url">
    // The stored HTML has: <img data-apimg-idx="0">
    resolvedHtml = resolvedHtml.replace(
      /<img[^>]*data-apimg-idx="(\d+)"[^>]*>/g,
      (match, idx) => {
        const url = signedUrls[parseInt(idx)] || '';
        if (!url) return '';  // Remove broken image references
        return `<img src="${escapeHTMLAttr(url)}" style="max-width:100%;height:auto;display:inline-block;vertical-align:middle;margin:0.25rem 0;border:1px solid #e8e0d0;">`;
      }
    );
  }

  responseBody = {
    assessmentType: 'text',
    title:          upload.label || upload.filename || 'Text Assessment',
    textContent:    resolvedHtml,
    textCharCount:  upload.text_char_count,
    exitWordHash:   upload.exit_word_hash,
    imageCount:     upload.image_count,
  };
}
```

**Step 2: Add HTML attribute escape helper in the API**

At the top of `api/session.js`:

```javascript
function escapeHTMLAttr(str) {
  return str.replace(/&/g, '&amp;').replace(/"/g, '&quot;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
}
```

**Step 3: Commit**

```bash
git add api/session.js
git commit -m "feat: resolve inline image placeholders to signed URLs in session API"
```

**Note:** The extension-finding strategy (trying png→jpg→webp) is a pragmatic simplification. A cleaner approach would be to store the extension in the DB, but that requires schema changes. For now, 3 attempts per image is negligible overhead (max 3 × 10 images = 30 storage API calls, ~1 second total).

---

### Task 6: Update extension popup — pass imageCount through

**Objective:** Pass `imageCount` from session API response through to the player via `chrome.storage.session`.

**Files:**
- Modify: `extension/popup.js`

**Step 1: Add imageCount to sessionData**

In `popup.js`, around line 57, add:

```javascript
await chrome.storage.session.set({
  sessionData: {
    // ... existing fields ...
    // Text-only fields
    textContent:    session.textContent,
    textCharCount:  session.textCharCount,
    imageCount:     session.imageCount,       // NEW
  },
});
```

**Step 2: Commit**

```bash
git add extension/popup.js
git commit -m "feat: pass imageCount through popup to extension player"
```

---

### Task 7: Update extension player — render HTML, sanitize, TTS skips images

**Objective:** The extension player renders resolved HTML (with `<img>` tags) instead of plain text paragraphs. TTS reads only text content. Images display inline within their paragraphs.

**Files:**
- Modify: `extension/player.js` (rewrite `renderTextParagraphs`, update TTS to skip images)
- Modify: `extension/player.html` (adjust text reader card max-width for images)
- Create: `extension/lib/purify.min.js` (bundled DOMPurify for sanitization)

**Step 1: Download DOMPurify minified**

```bash
cd extension/lib
curl -O https://raw.githubusercontent.com/cure53/DOMPurify/main/dist/purify.min.js
```

Or create a minimal sanitizer if you prefer no dependency:

```javascript
// extension/lib/sanitize.js — minimal HTML sanitizer for our controlled HTML
function sanitizeHTML(html) {
  const doc = new DOMParser().parseFromString(html, 'text/html');
  const ALLOWED_TAGS = new Set(['p', 'br', 'strong', 'em', 'b', 'i', 'img']);
  const ALLOWED_ATTRS = new Set(['src', 'alt', 'style']);

  function clean(node) {
    if (node.nodeType === Node.COMMENT_NODE) {
      node.remove();
      return;
    }
    if (node.nodeType === Node.ELEMENT_NODE) {
      if (!ALLOWED_TAGS.has(node.tagName.toLowerCase())) {
        // Unwrap: move children up, remove this element
        while (node.firstChild) {
          node.parentNode.insertBefore(node.firstChild, node);
        }
        node.remove();
        return;
      }
      // Strip disallowed attributes
      for (const attr of [...node.attributes]) {
        if (!ALLOWED_ATTRS.has(attr.name)) {
          node.removeAttribute(attr.name);
        }
      }
      // Block javascript: URLs
      if (node.tagName.toLowerCase() === 'img') {
        const src = node.getAttribute('src');
        if (src && /^javascript:/i.test(src.trim())) {
          node.removeAttribute('src');
        }
      }
    }
    // Recurse (use [...node.childNodes] since children may change during iteration)
    for (const child of [...node.childNodes]) {
      clean(child);
    }
  }

  clean(doc.body);
  return doc.body.innerHTML;
}
```

**Step 2: Load sanitizer in player.html**

In `extension/player.html`, before the `player.js` script:

```html
<script src="lib/sanitize.js"></script>
<script src="player.js"></script>
```

**Step 3: Rewrite `renderTextParagraphs` in player.js**

Replace the existing `renderTextParagraphs` (lines 198-216) with:

```javascript
function renderTextContent(rawHTML) {
  const container = document.getElementById('text-paragraphs');

  // Sanitize the resolved HTML
  const cleanHTML = sanitizeHTML(rawHTML);

  // Set innerHTML — images render inline, paragraphs wrap text
  container.innerHTML = cleanHTML;

  // Collect paragraph elements for TTS navigation
  ttsParagraphs = [...container.querySelectorAll('p')];
}
```

**Step 4: Update the session load code to call new function**

In the session load callback (around line 103), change:

```javascript
// Old:
renderTextParagraphs(sessionData.textContent);

// New:
renderTextContent(sessionData.textContent);
```

**Step 5: TTS — it already works correctly**

The existing TTS code reads `ttsParagraphs[idx].textContent` (line 309). This naturally skips `<img>` tags because `textContent` only returns text nodes. No changes needed — images inside `<p>` tags are silently ignored during read-aloud.

However, we need to handle the case where a paragraph contains ONLY an image (no text). In `speakParagraph`:

```javascript
function speakParagraph(idx) {
  if (idx < 0 || idx >= ttsParagraphs.length) return;

  ttsParagraphs.forEach(p => p.classList.remove('tts-active'));
  ttsCurrentIdx = idx;
  ttsParagraphs[idx].classList.add('tts-active');
  ttsParagraphs[idx].scrollIntoView({ behavior: 'smooth', block: 'center' });

  const text = ttsParagraphs[idx].textContent.trim();
  const statusEl = document.getElementById('tts-status');
  statusEl.textContent = `Paragraph ${idx + 1} of ${ttsParagraphs.length}`;

  // Skip image-only paragraphs (no text to speak)
  if (!text) {
    // Auto-advance to next paragraph
    if (idx < ttsParagraphs.length - 1) {
      speakParagraph(idx + 1);
    } else {
      stopReadAloud();
      statusEl.textContent = 'Finished';
    }
    return;
  }

  chrome.tts.speak(text, {
    // ... existing options ...
  });
  // ... rest unchanged
}
```

**Step 6: Update player.html card width**

Change `.text-reader-card` max-width from `720px` to `800px` to accommodate images:

```css
.text-reader-card {
  max-width: 800px;
}
```

**Step 7: Commit**

```bash
git add extension/player.js extension/player.html extension/lib/sanitize.js
git commit -m "feat: render HTML with inline images in extension player, TTS skips images"
```

---

### Task 8: Handle image cleanup on upload deletion

**Objective:** When a teacher deletes an upload that has inline images, also delete the images from Supabase Storage.

**Files:**
- Modify: `app/js/dashboard.js` (`deleteUpload` function)

**Step 1: Update deleteUpload**

In `deleteUpload()` (around line 861), after the existing DB delete:

```javascript
// Delete images from assessment-images bucket if present
if (assessmentType === 'text') {
  // Get image_count from the upload record
  const { data: upload } = await supabaseClient
    .from('uploads')
    .select('image_count, storage_path, access_code')
    .eq('id', id)
    .maybeSingle();

  if (upload && upload.image_count > 0) {
    const teacherId = (await getSession()).user.id;
    const accessCode = upload.access_code;

    // Try to delete all possible images (png/jpg/webp for each index)
    const paths = [];
    for (let i = 0; i < upload.image_count; i++) {
      for (const ext of ['png', 'jpg', 'webp']) {
        paths.push(`${teacherId}/${accessCode}/img_${i}.${ext}`);
      }
    }
    // Fire-and-forget — best-effort cleanup
    supabaseClient.storage.from('assessment-images').remove(paths);
  }
}
```

**Step 2: Commit**

```bash
git add app/js/dashboard.js
git commit -m "feat: clean up inline images when upload is deleted"
```

---

### Task 9: Update RLS policy for uploads — include image_count in insert check

**Objective:** Ensure the RLS insert policy for uploads accounts for image storage in the 50 MB cap.

**Files:**
- Create: `supabase/migrations/021_image_storage_quota.sql`

**Step 1: The existing RLS policy already checks `storage_used_mb + file_size_mb <= 50`.**  
For text assessments, `file_size_mb` is 0 (images aren't counted). We have two options:

A. Update the policy to also check against a new `image_storage_mb` column  
B. Enforce the cap in the frontend only (what we already did in Task 4)

Option B is simpler and consistent with how the app already works (frontend enforces, DB provides defense-in-depth). The DB doesn't know image sizes until after upload, and we don't want failed inserts after the teacher waited for uploads.

**Decision:** Keep frontend enforcement. No DB migration needed for this.

Actually, on reflection — we should at least track image storage so the profile's `storage_used_mb` is accurate. But that's a larger change (would need to update `storage_used_mb` when images are uploaded/deleted). Let's defer that — the AGENTS.md already says upload quota is enforced at DB layer, but the RLS policy already captures `file_size_mb`. We'll add image bytes to `file_size_mb` for text assessments.

**Step 2: Update handleUpload to set file_size_mb for text with images**

In the DB insert (around line 541):

```javascript
file_size_mb: uploadFile
  ? uploadFile.size / 1024 / 1024
  : (imageTotalBytes / 1024 / 1024),  // Text: count image storage toward cap
```

This makes the existing RLS policy (`storage_used_mb + file_size_mb <= 50`) correctly enforce the cap for text+image assessments.

**Step 3: Commit**

```bash
git add app/js/dashboard.js
git commit -m "fix: count image storage in file_size_mb for RLS quota enforcement"
```

---

### Task 10: Update the duplicates feature to handle images

**Objective:** When a teacher duplicates a text assessment with images, copy the images to new paths.

**Files:**
- Modify: `app/js/dashboard.js` (`duplicateUpload` function, around line 1000)

**Step 1: Add image duplication logic**

In the duplicate function, after generating the new access code:

```javascript
// Copy inline images if present
let imageCount = 0;
if (assessmentType === 'text' && upload.image_count > 0) {
  for (let i = 0; i < upload.image_count; i++) {
    // Try to find and copy each image
    for (const ext of ['png', 'jpg', 'webp']) {
      const oldPath = `${upload.teacher_id}/${upload.access_code}/img_${i}.${ext}`;
      const newPath = `${userId}/${newAccessCode}/img_${i}.${ext}`;

      const { data: signedData, error: signError } = await supabaseClient
        .storage
        .from('assessment-images')
        .createSignedUrl(oldPath, 60);

      if (!signError && signedData) {
        // Download the image
        const response = await fetch(signedData.signedUrl);
        const blob = await response.blob();

        // Upload to new path
        const { error: uploadError } = await supabaseClient.storage
          .from('assessment-images')
          .upload(newPath, blob, { contentType: blob.type, upsert: false });

        if (!uploadError) {
          imageCount++;
        }
        break;  // Found and copied — move to next index
      }
    }
  }

  // Update text_content to reference new access code (regex replace old code with new)
  // The stored HTML has data-apimg-idx attributes, not paths — no change needed
}
```

**Step 2: Commit**

```bash
git add app/js/dashboard.js
git commit -m "feat: duplicate inline images when duplicating text assessments"
```

---

## Summary of changes

| File | Action | Purpose |
|---|---|---|
| `supabase/migrations/020_inline_images.sql` | Create | Add `image_count` column, storage bucket |
| `app/dashboard.html` | Modify | Replace textarea with contenteditable div |
| `app/css/styles.css` | Modify | Style the contenteditable editor + images |
| `app/js/dashboard.js` | Modify | Paste handler, image upload, HTML normalization, cleanup, duplication |
| `api/session.js` | Modify | Resolve `<img data-apimg-idx>` to signed URLs |
| `extension/popup.js` | Modify | Pass `imageCount` through session data |
| `extension/player.js` | Modify | Render HTML with innerHTML, TTS skips images |
| `extension/player.html` | Modify | Load sanitizer, widen card for images |
| `extension/lib/sanitize.js` | Create | Minimal HTML sanitizer for extension |

## Edge cases handled

1. **Pasting mixed content** (text + images together): Text pastes as plain text, images extracted as blobs, both inserted at cursor position.
2. **Multiple images in one paste**: Each validated and queued separately.
3. **Image-only paragraph**: TTS auto-skips to next paragraph.
4. **Broken image at playback**: Session API replaces with empty string (image tag removed from HTML).
5. **Free tier storage cap**: Checked before upload, image bytes counted in `file_size_mb`.
6. **Duplicate upload**: Images copied to new access code path.
7. **Delete upload**: Best-effort cleanup of image files.
8. **Backward compatibility**: Plain text assessments without images continue to work — the contenteditable editor wraps text in `<p>` tags, and TTS navigation works identically.

## What this does NOT do

- No image resizing/compression (teacher is responsible for reasonable file sizes, 2 MB cap)
- No alt text support (per user request — TTS ignores images)
- No image alignment controls (images always inline with text, max-width: 100%)
- No separate image caption support
- No EXIF stripping (browser strips EXIF from pasted images by default)
- No `storage_used_mb` tracking for images (deferred — images are small and the 50 MB cap is enforced at upload time via `file_size_mb`)
