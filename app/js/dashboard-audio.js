// ─── WAV-to-MP3 Conversion ───────────────────────────────────────

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
