// ─── api/_lib/i18n ─────────────────────────────────────────────────
// Server-side language detection and localized API messages.
//
// Exports:
//   getRequestLanguage(req)   — reads ?lang= or Accept-Language, returns 'en' | 'fr'
//   apiMessage(key, lang, replacements) — looks up localized string with {placeholder} substitution

const messages = require('./api-messages.json');

const SUPPORTED_LANGS = ['en', 'fr'];
const DEFAULT_LANG    = 'en';

/**
 * Determine the request language from query param or Accept-Language header.
 *
 * Priority:
 *   1. ?lang= query parameter (explicit override)
 *   2. Accept-Language header (browser preference)
 *   3. Default: 'en'
 *
 * @param {object} req — Express-style request object with .query and .headers
 * @returns {string} 'en' or 'fr'
 */
function getRequestLanguage(req) {
  // 1. Explicit query-parameter override
  if (req.query && typeof req.query.lang === 'string') {
    const lang = req.query.lang.trim().toLowerCase();
    if (SUPPORTED_LANGS.includes(lang)) {
      return lang;
    }
  }

  // 2. Accept-Language header (browser preference)
  if (req.headers && typeof req.headers['accept-language'] === 'string') {
    // Accept-Language: "fr-FR,fr;q=0.9,en;q=0.8"
    // Extract the primary language tag from the first preference
    const raw = req.headers['accept-language'].split(',')[0];
    if (raw) {
      const tag = raw.split(';')[0].trim().toLowerCase().slice(0, 2);
      if (SUPPORTED_LANGS.includes(tag)) {
        return tag;
      }
    }
  }

  // 3. Default
  return DEFAULT_LANG;
}

/**
 * Retrieve a localized API message by key.
 *
 * @param {string} key — Message key (e.g. 'missing_param', 'session_invalid')
 * @param {string} [lang='en'] — Language code
 * @param {object} [replacements] — Optional key-value pairs for {placeholder} substitution
 * @returns {string} Localized message string
 */
function apiMessage(key, lang = DEFAULT_LANG, replacements) {
  const langMap = messages[lang] || messages[DEFAULT_LANG];
  let msg = langMap[key];

  // Fall back to English if the key is missing in the requested language
  if (msg === undefined && lang !== DEFAULT_LANG) {
    msg = messages[DEFAULT_LANG][key];
  }

  // Final fallback — return the key itself so callers aren't silently broken
  if (msg === undefined) {
    return key;
  }

  // Substitute {placeholder} values
  if (replacements) {
    for (const [placeholder, value] of Object.entries(replacements)) {
      msg = msg.replace(new RegExp(`\\{${placeholder}\\}`, 'g'), String(value));
    }
  }

  return msg;
}

module.exports = { getRequestLanguage, apiMessage };
