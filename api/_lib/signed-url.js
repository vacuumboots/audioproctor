// ─── api/_lib/signed-url ──────────────────────────────────────────
// Shared helpers for generating signed URLs for admin content access.
// Used by api/admin.js, api/org.js, and api/session.js.
//
// All functions require a Supabase client initialized with the service role key.

const AUDIO_BUCKET = 'audio-files';
const IMAGES_BUCKET = 'assessment-images';
const DEFAULT_EXPIRY  = 3600; // 1 hour

function escapeHTMLAttr(str) {
  return str.replace(/&/g, '&amp;').replace(/"/g, '&quot;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
}

/**
 * Generate a signed URL for a stored audio file.
 * @param {object} supabase — service-role Supabase client
 * @param {string} storagePath — e.g. "teacher-uuid/ABC-123.mp3"
 * @param {number} expiresIn — seconds until expiry (default 3600)
 * @returns {object} { signedUrl } or throws
 */
async function getAudioSignedUrl(supabase, storagePath, expiresIn = DEFAULT_EXPIRY) {
  const { data: signed, error } = await supabase
    .storage
    .from(AUDIO_BUCKET)
    .createSignedUrl(storagePath, expiresIn);

  if (error || !signed) {
    throw new Error(`Signed URL generation failed: ${error?.message || 'no data'}`);
  }

  return { signedUrl: signed.signedUrl };
}

/**
 * Resolve image placeholders in text content to signed URLs.
 * Replaces <img data-apimg-idx="N"> with <img src="<signed-url>">.
 * @param {object} supabase — service-role Supabase client
 * @param {string} teacherId
 * @param {string} accessCode
 * @param {number} imageCount
 * @returns {string} resolved HTML
 */
async function resolveTextContent(supabase, teacherId, accessCode, imageCount) {
  // Generate signed URLs for each image
  const signedUrls = [];
  for (let i = 0; i < imageCount; i++) {
    let found = false;
    for (const ext of ['png', 'jpg', 'webp']) {
      const imgPath = `${teacherId}/${accessCode}/img_${i}.${ext}`;
      const { data: signed, error: signError } = await supabase
        .storage
        .from(IMAGES_BUCKET)
        .createSignedUrl(imgPath, DEFAULT_EXPIRY);

      if (!signError && signed) {
        signedUrls[i] = signed.signedUrl;
        found = true;
        break;
      }
    }
    if (!found) {
      signedUrls[i] = '';
    }
  }

  // Build resolver callback
  return (html) => {
    return html.replace(
      /<img[^>]*data-apimg-idx="(\d+)"[^>]*>/g,
      (match, idx) => {
        const url = signedUrls[parseInt(idx)] || '';
        if (!url) return '';
        return `<img src="${escapeHTMLAttr(url)}" style="max-width:100%;height:auto;display:inline-block;vertical-align:middle;margin:0.25rem 0;border:1px solid #e8e0d0;">`;
      }
    );
  };
}

module.exports = { getAudioSignedUrl, resolveTextContent, AUDIO_BUCKET, IMAGES_BUCKET, DEFAULT_EXPIRY };
