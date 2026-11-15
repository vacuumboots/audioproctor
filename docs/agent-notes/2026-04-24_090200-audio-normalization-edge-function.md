# Shipment — Audio Normalization via Supabase Edge Function

> **Status:** NOT STARTED  
> **Priority:** Medium (reduces storage costs 4–6x, improves playback consistency)  
> **Estimated effort:** 4–6 hours  
> **Depends on:** Supabase Edge Functions enabled, ffmpeg.wasm or remote ffmpeg worker

**Goal:** Every uploaded MP3 is automatically transcoded to 32kbps mono MP3 before being stored in the `audio-files` bucket. This reduces file sizes dramatically, ensures consistent playback quality on school networks, and protects against teachers uploading 50MB+ high-bitrate files that blow through free-tier storage.

---

## Current State

- Teachers upload MP3s directly to Supabase Storage at `{teacher_id}/{access_code}.mp3`
- No processing happens — the file is stored as-is
- Free tier storage cap is 50MB; a single 45-minute 320kbps stereo MP3 can exceed this
- Large files cause slow uploads on school WiFi and slow downloads on student Chromebooks

---

## Architecture

Browser uploads original MP3 → Supabase Storage staging path `{teacher_id}/{access_code}_raw.mp3` → Edge Function triggered by Storage webhook → ffmpeg transcodes to 32kbps mono → normalized file saved to final path `{teacher_id}/{access_code}.mp3` → staging file deleted → DB row updated with normalized file size.

**Why 32kbps mono:**
- Spoken-word audio (assessment instructions, read-alouds) is intelligible at 32kbps
- Mono because most assessment audio is single-source voice
- MP3 format preserved for universal Chromebook compatibility
- A 10MB file becomes ~1.5MB; a 50MB file becomes ~7.5MB

**Why Edge Function:**
- Runs server-side, so teachers don't wait for browser-based transcoding
- ffmpeg.wasm in the browser is heavy (~25MB WASM download)
- Supabase Edge Functions have 150s execution limit, sufficient for files up to ~100MB
- Can be retried independently if a specific upload fails

---

## Deliverables

1. New Supabase Edge Function `normalize-audio` with ffmpeg
2. Storage bucket webhook trigger on `audio-files` insert
3. Update `app/js/dashboard.js` `handleUpload()` to write to staging path first
4. Update `api/session.js` to serve from final path only (no change needed if paths stay the same)
5. Handle failure gracefully — if normalization fails, keep the original file and log an error

---

## Definition of Done

- [ ] Any uploaded MP3 > 1MB is automatically transcoded to 32kbps mono MP3
- [ ] Normalized file replaces the original at the same storage path
- [ ] `uploads.file_size_mb` is updated to reflect the normalized size
- [ ] If normalization fails, the original file is preserved and an error is logged
- [ ] Teacher sees no delay — upload completes, then normalization happens asynchronously
- [ ] Free tier storage cap becomes effectively ~300MB of real audio content (50MB cap × ~6x reduction)

---

## Implementation

### Step 1: Edge Function scaffold

```bash
supabase functions new normalize-audio
```

### Step 2: Edge Function code

`supabase/functions/normalize-audio/index.ts`:

```typescript
import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

serve(async (req) => {
  const { record } = await req.json()
  const path = record.name // e.g. "teacher-uuid/ABC-123_raw.mp3"

  if (!path.endsWith('_raw.mp3')) return new Response('Not a raw file', { status: 200 })

  const supabase = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
  )

  const finalPath = path.replace('_raw.mp3', '.mp3')

  // Download raw file to temp
  const { data: blob } = await supabase.storage.from('audio-files').download(path)
  if (!blob) return new Response('Download failed', { status: 500 })

  // Run ffmpeg via Deno subprocess (ffmpeg must be in the Edge Function image)
  // NOTE: Supabase Edge Functions do not include ffmpeg by default.
  // Options:
  //   A) Use ffmpeg.wasm inside the Edge Function (slower, large WASM)
  //   B) Use a separate ffmpeg-as-a-service worker (e.g. Cloudflare Worker with ffmpeg.wasm)
  //   C) Use Deno FFmpeg binding if available in the runtime
  //
  // For this plan, assume Option A (ffmpeg.wasm) for self-contained deployment:

  const { FFmpeg } = await import('https://esm.sh/@ffmpeg/ffmpeg@0.12.7')
  const { fetchFile } = await import('https://esm.sh/@ffmpeg/util@0.12.1')
  const ffmpeg = new FFmpeg()
  await ffmpeg.load()

  await ffmpeg.writeFile('input.mp3', await fetchFile(blob))
  await ffmpeg.exec([
    '-i', 'input.mp3',
    '-ar', '22050',      // 22.05kHz sample rate
    '-ac', '1',          // mono
    '-b:a', '32k',       // 32kbps
    '-map_metadata', '-1', // strip metadata
    'output.mp3'
  ])

  const data = await ffmpeg.readFile('output.mp3')
  const normalizedBlob = new Blob([data], { type: 'audio/mpeg' })

  // Upload normalized file
  const { error: uploadError } = await supabase.storage
    .from('audio-files')
    .upload(finalPath, normalizedBlob, { contentType: 'audio/mpeg', upsert: true })

  if (uploadError) {
    console.error('Normalized upload failed:', uploadError.message)
    return new Response('Upload failed', { status: 500 })
  }

  // Delete staging file
  await supabase.storage.from('audio-files').remove([path])

  // Update file_size_mb in uploads table
  const sizeMb = normalizedBlob.size / 1024 / 1024
  const { error: dbError } = await supabase
    .from('uploads')
    .update({ file_size_mb: sizeMb })
    .eq('storage_path', finalPath)

  if (dbError) console.error('DB update failed:', dbError.message)

  return new Response('OK', { status: 200 })
})
```

### Step 3: Update dashboard upload flow

In `app/js/dashboard.js` `handleUpload()`:

```js
// Change storage path to staging
const storagePath = `${userId}/${accessCode}_raw.mp3`;

// After successful DB insert, the Edge Function will:
// 1. Transcode the file
// 2. Replace it at the final path (same accessCode, no _raw suffix)
// 3. Update file_size_mb
// 4. Delete the staging file
```

No other changes needed — the DB row already stores `storage_path` without `_raw`, and the Edge Function writes to the final path.

### Step 4: Storage webhook

In Supabase Dashboard → Storage → `audio-files` bucket → Webhooks:
- Trigger: `object.created`
- Endpoint: `https://<project-ref>.functions.supabase.co/normalize-audio`
- Filter: path matches `*_raw.mp3`

### Step 5: Commit and push

```bash
git add supabase/functions/normalize-audio/ app/js/dashboard.js
git commit -m "feat: add audio normalization Edge Function (32kbps mono)"
git push origin main
```

---

## Open Questions / Risks

- **ffmpeg in Edge Functions**: Supabase Edge Functions run Deno and do not include ffmpeg by default. ffmpeg.wasm is ~25MB and may exceed Edge Function cold-start limits. Alternative: run normalization in a Vercel serverless function instead, triggered by a Supabase database webhook on the `uploads` table.
- **Vercel alternative**: Instead of an Edge Function, use a Vercel function (`api/normalize-audio.js`) triggered by a Supabase database webhook when `uploads` row is inserted. Vercel functions have 10s limit (Hobby) / 60s (Pro), which may not be enough for large files. Stripe or background job service (e.g. Inngest, QStash) may be needed.
- **Best practical approach for pilot**: Skip Edge Function entirely. Add client-side ffmpeg.wasm in the browser. Teacher uploads → browser transcodes before upload → much smaller file uploaded. Tradeoff: first upload has a ~5s delay while ffmpeg loads, but no server infrastructure needed.

---

## Recommended First Slice

Given the infrastructure uncertainty, the fastest path to value is:

1. **Client-side transcoding in the browser** — add ffmpeg.wasm to `app/js/dashboard.js`
   - Load ffmpeg.wasm on first upload (lazy load)
   - Transcode to 32kbps mono before calling `supabase.storage.upload()`
   - Show "Optimizing audio…" progress step
   - Single file change, no server infrastructure

2. **Server-side fallback** — if client-side proves unreliable on school Chromebooks, move to Vercel function or Edge Function later.

This is a one-file change (`app/js/dashboard.js`) with immediate 4–6x storage reduction.
