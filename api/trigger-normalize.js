// ─── /api/trigger-normalize ─────────────────────────────────────────
// Vercel serverless function.
// POST /api/trigger-normalize  { upload_id: "uuid" }
//
// Called by the dashboard after the staging upload succeeds.
// Uses native ffmpeg (ffmpeg-static) to transcode to 32kbps mono MP3.
// Flow:
//   1. Verify auth — user must own the upload
//   2. Download from staging path in Supabase Storage
//   3. Transcode to 32kbps mono MP3 at 22050 Hz
//   4. Upload normalized file to final path
//   5. Update DB (storage_path, processing_status, file_size_mb)
//   6. Delete staging file
//
// Requires SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY env vars.

const { createClient } = require('@supabase/supabase-js');
const ffmpegPath      = require('ffmpeg-static');
const { execFile }    = require('child_process');
const fs              = require('fs');
const path            = require('path');
const os              = require('os');
const { promisify }   = require('util');

const execFileAsync = promisify(execFile);

const AUDIO_BUCKET = 'audio-files';

module.exports = async (req, res) => {
  // CORS — called from the dashboard (same origin, but still set for flexibility)
  res.setHeader('Access-Control-Allow-Origin',  '*');
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  if (req.method === 'OPTIONS') return res.status(200).end();
  if (req.method !== 'POST')    return res.status(405).json({ error: 'Method not allowed' });

  // ─── Auth: verify the caller's Bearer token ─────────────────────
  const authHeader = req.headers.authorization || '';
  const token = authHeader.replace('Bearer ', '');
  if (!token) return res.status(401).json({ error: 'Missing auth token' });

  const supabase = createClient(
    process.env.SUPABASE_URL,
    process.env.SUPABASE_SERVICE_ROLE_KEY
  );

  const { data: { user }, error: authErr } = await supabase.auth.getUser(token);
  if (authErr || !user) {
    return res.status(401).json({ error: 'Invalid token' });
  }

  const { upload_id } = req.body || {};
  if (!upload_id) {
    return res.status(400).json({ error: 'Missing upload_id' });
  }

  const startTime = Date.now();

  try {
    // 1. Fetch upload record — verify ownership
    const { data: upload, error: fetchError } = await supabase
      .from('uploads')
      .select('id, storage_path, teacher_id, access_code, assessment_type, processing_status')
      .eq('id', upload_id)
      .single();

    if (fetchError || !upload) {
      return res.status(404).json({ error: 'Upload not found' });
    }

    // Verify the caller owns this upload
    if (upload.teacher_id !== user.id) {
      return res.status(403).json({ error: 'Not authorized to process this upload' });
    }

    if (upload.assessment_type !== 'audio') {
      return res.status(400).json({ error: 'Not an audio assessment' });
    }

    // Idempotency: if already processed, return success
    if (upload.processing_status === 'ready') {
      return res.status(200).json({
        ok: true,
        upload_id,
        status: 'already_ready',
        final_path: upload.storage_path,
      });
    }

    if (upload.processing_status === 'failed') {
      // Allow retry — transition back to processing
      await supabase
        .from('uploads')
        .update({ processing_status: 'processing' })
        .eq('id', upload_id);
    } else if (upload.processing_status === 'processing') {
      // Already being processed by another invocation — skip
      return res.status(200).json({
        status: upload.processing_status,
        message: `Upload is already ${upload.processing_status}`,
      });
    } else if (upload.processing_status !== 'pending') {
      // Unknown status
      return res.status(200).json({
        status: upload.processing_status,
        message: `Unexpected processing status: ${upload.processing_status}`,
      });
    } else {
      // 2. Mark as processing
      await supabase
        .from('uploads')
        .update({ processing_status: 'processing' })
        .eq('id', upload_id);
    }

    const userId      = upload.teacher_id;
    const accessCode  = upload.access_code;
    const stagingPath = upload.storage_path;  // e.g. staging/{userId}/{accessCode}.mp3
    const finalPath   = `${userId}/${accessCode}.mp3`;

    // 3. Download the staging file
    const { data: stagingData, error: downloadError } = await supabase
      .storage
      .from(AUDIO_BUCKET)
      .download(stagingPath);

    if (downloadError || !stagingData) {
      throw new Error(`Download failed: ${downloadError?.message || 'no data'}`);
    }

    // 4. Write to temp file for ffmpeg
    const tmpDir  = fs.mkdtempSync(path.join(os.tmpdir(), 'ap-'));
    const inputPath  = path.join(tmpDir, 'input');
    const outputPath = path.join(tmpDir, 'output.mp3');

    const buffer = Buffer.from(await stagingData.arrayBuffer());
    fs.writeFileSync(inputPath, buffer);

    // 5. Run ffmpeg — 32kbps mono MP3 at 22050 Hz
    // Using libmp3lame encoder for best compatibility at low bitrates.
    // Note: input has no extension — ffmpeg auto-detects format from headers.
    await execFileAsync(ffmpegPath, [
      '-i', inputPath,
      '-b:a', '32k',
      '-ac', '1',
      '-ar', '22050',
      '-codec:a', 'libmp3lame',
      '-y',
      outputPath,
    ]);

    // 6. Read the output and upload to final path
    const normalizedBuffer = fs.readFileSync(outputPath);
    const normalizedSizeMb = normalizedBuffer.length / 1024 / 1024;

    const { error: uploadError } = await supabase
      .storage
      .from(AUDIO_BUCKET)
      .upload(finalPath, normalizedBuffer, {
        contentType: 'audio/mpeg',
        upsert: false,
      });

    if (uploadError) {
      throw new Error(`Final upload failed: ${uploadError.message}`);
    }

    // 7. Update DB record
    const { error: updateError } = await supabase
      .from('uploads')
      .update({
        storage_path:     finalPath,
        processing_status: 'ready',
        file_size_mb:     Math.round(normalizedSizeMb * 100) / 100,
      })
      .eq('id', upload_id);

    if (updateError) {
      console.error(`DB update failed for ${upload_id}: ${updateError.message}`);
    }

    // 8. Delete staging file (best-effort)
    const { error: deleteError } = await supabase
      .storage
      .from(AUDIO_BUCKET)
      .remove([stagingPath]);

    if (deleteError) {
      console.warn(`Staging delete failed for ${stagingPath}: ${deleteError.message}`);
    }

    // 9. Clean up temp files
    try {
      fs.rmSync(tmpDir, { recursive: true, force: true });
    } catch (cleanupErr) {
      console.warn('tmp cleanup failed:', cleanupErr.message);
    }

    const elapsed = ((Date.now() - startTime) / 1000).toFixed(1);

    return res.status(200).json({
      ok: true,
      upload_id,
      final_path: finalPath,
      size_mb: normalizedSizeMb,
      elapsed_sec: parseFloat(elapsed),
    });

  } catch (err) {
    // Mark as failed
    await supabase
      .from('uploads')
      .update({ processing_status: 'failed' })
      .eq('id', upload_id);

    console.error(`Normalize failed for ${upload_id}:`, err.message);

    return res.status(500).json({
      error: err.message,
      upload_id,
    });
  }
};
