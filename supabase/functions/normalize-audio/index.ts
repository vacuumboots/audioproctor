// ─── Audio Normalization Edge Function ─────────────────────────────
// Supabase Edge Function (Deno) — transcodes uploaded audio to 32kbps
// mono MP3 using ffmpeg.wasm.
//
// Triggered by: POST request from Vercel's api/trigger-normalize.js
//               (relay) or called directly with service-role auth.
// Payload: { upload_id: "uuid" }
//
// Flow:
//   1. Download file from staging/{userId}/{accessCode}.mp3
//   2. Transcode to 32kbps mono MP3 via ffmpeg.wasm
//   3. Upload normalized file to {userId}/{accessCode}.mp3
//   4. Update uploads.storage_path and processing_status='ready'
//   5. Delete staging file

import { serve } from 'https://deno.land/std@0.177.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.39.0'
import { FFmpeg } from 'https://esm.sh/@ffmpeg/ffmpeg@0.12.10'

const SUPABASE_URL = Deno.env.get('SUPABASE_URL') ?? ''
const SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''

const AUDIO_BUCKET = 'audio-files'

serve(async (req) => {
  const startTime = Date.now()

  // CORS
  if (req.method === 'OPTIONS') {
    return new Response(null, {
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'POST, OPTIONS',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization',
      },
    })
  }

  if (req.method !== 'POST') {
    return new Response(JSON.stringify({ error: 'Method not allowed' }), {
      status: 405,
      headers: { 'Content-Type': 'application/json' },
    })
  }

  // Verify auth token — only the trigger function (or service role) should call us
  const authHeader = req.headers.get('Authorization') || ''
  if (!authHeader.startsWith('Bearer ') || authHeader.slice(7) !== SERVICE_ROLE_KEY) {
    return new Response(JSON.stringify({ error: 'Unauthorized' }), {
      status: 401,
      headers: { 'Content-Type': 'application/json' },
    })
  }

  const supabase = createClient(SUPABASE_URL, SERVICE_ROLE_KEY)

  // Parse payload
  let uploadId: string
  try {
    const body = await req.json()
    uploadId = body.upload_id
    if (!uploadId || typeof uploadId !== 'string') {
      throw new Error('Missing or invalid upload_id')
    }
  } catch (err) {
    return new Response(JSON.stringify({ error: 'Invalid payload: upload_id required' }), {
      status: 400,
      headers: { 'Content-Type': 'application/json' },
    })
  }

  // Fetch upload record
  const { data: upload, error: fetchError } = await supabase
    .from('uploads')
    .select('id, storage_path, teacher_id, access_code, assessment_type, processing_status')
    .eq('id', uploadId)
    .single()

  if (fetchError || !upload) {
    return new Response(JSON.stringify({ error: 'Upload not found', detail: fetchError?.message }), {
      status: 404,
      headers: { 'Content-Type': 'application/json' },
    })
  }

  // Validate — audio only, must be pending
  if (upload.assessment_type !== 'audio') {
    return new Response(JSON.stringify({ error: 'Not an audio assessment' }), {
      status: 400,
      headers: { 'Content-Type': 'application/json' },
    })
  }

  if (upload.processing_status === 'ready') {
    return new Response(JSON.stringify({
      status: 'ready',
      message: 'Upload is already normalized',
    }), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    })
  }

  if (upload.processing_status === 'failed') {
    // Allow retry — reprocess failed uploads
    await supabase
      .from('uploads')
      .update({ processing_status: 'processing' })
      .eq('id', uploadId)
  } else if (upload.processing_status === 'processing') {
    return new Response(JSON.stringify({
      status: 'processing',
      message: 'Upload is already being processed',
    }), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    })
  } else if (upload.processing_status !== 'pending') {
    // Mark as processing
    await supabase
      .from('uploads')
      .update({ processing_status: 'processing' })
      .eq('id', uploadId)
  }

  const userId = upload.teacher_id
  const accessCode = upload.access_code
  const stagingPath = upload.storage_path  // e.g. staging/{userId}/{accessCode}.mp3
  const finalPath = `${userId}/${accessCode}.mp3`

  try {
    // 1. Download the staging file
    const { data: stagingData, error: downloadError } = await supabase
      .storage
      .from(AUDIO_BUCKET)
      .download(stagingPath)

    if (downloadError || !stagingData) {
      throw new Error(`Download failed: ${downloadError?.message || 'no data'}`)
    }

    // 2. Transcode to 32kbps mono MP3 via ffmpeg.wasm
    const ffmpeg = new FFmpeg()

    // Load the ffmpeg WASM core (fetches from default CDN)
    await ffmpeg.load()

    // Write input file to ffmpeg's virtual filesystem
    // The filename extension doesn't matter — ffmpeg auto-detects the
    // audio format from the file headers (magic bytes).
    const inputBytes = await stagingData.arrayBuffer()
    await ffmpeg.writeFile('input', new Uint8Array(inputBytes))

    // Run transcoding: 32kbps, mono, 22050 Hz, constant bitrate
    await ffmpeg.exec([
      '-i', 'input',
      '-b:a', '32k',
      '-ac', '1',
      '-ar', '22050',
      '-codec:a', 'libmp3lame',
      '-y',
      'output.mp3',
    ])

    // Read output from virtual filesystem
    const outputData = await ffmpeg.readFile('output.mp3')

    // Clean up ffmpeg
    ffmpeg.terminate()

    // 3. Upload normalized file to final path
    const normalizedBlob = new Blob([outputData], { type: 'audio/mpeg' })
    const normalizedSizeMb = normalizedBlob.size / 1024 / 1024

    const { error: uploadError } = await supabase
      .storage
      .from(AUDIO_BUCKET)
      .upload(finalPath, normalizedBlob, {
        contentType: 'audio/mpeg',
        upsert: false,
      })

    if (uploadError) {
      throw new Error(`Final upload failed: ${uploadError.message}`)
    }

    // 4. Update DB record
    const { error: updateError } = await supabase
      .from('uploads')
      .update({
        storage_path: finalPath,
        processing_status: 'ready',
        file_size_mb: Math.round(normalizedSizeMb * 100) / 100,
      })
      .eq('id', uploadId)

    if (updateError) {
      // Non-fatal — log but don't throw; the file is already in place
      console.error(`DB update failed for ${uploadId}: ${updateError.message}`)
    }

    // 5. Delete staging file (best-effort)
    const { error: deleteError } = await supabase
      .storage
      .from(AUDIO_BUCKET)
      .remove([stagingPath])

    if (deleteError) {
      console.warn(`Staging delete failed for ${stagingPath}: ${deleteError.message}`)
    }

    const elapsed = ((Date.now() - startTime) / 1000).toFixed(1)

    return new Response(JSON.stringify({
      ok: true,
      upload_id: uploadId,
      final_path: finalPath,
      size_mb: normalizedSizeMb,
      elapsed_sec: parseFloat(elapsed),
    }), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    })

  } catch (err) {
    // Mark as failed
    await supabase
      .from('uploads')
      .update({ processing_status: 'failed' })
      .eq('id', uploadId)

    console.error(`Normalize failed for ${uploadId}:`, err.message)

    return new Response(JSON.stringify({
      error: err.message,
      upload_id: uploadId,
    }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    })
  }
})
