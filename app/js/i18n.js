// i18n.js — Lightweight locale resolver for AudioProctor
// Usage: t('dashboard.upload.title') -> "Upload Assessment"
// Usage: t('common.showing', { from: 1, to: 10, total: 42 }) -> "Showing 1–10 of 42"
//
// The module loads locale JSON files from /locales/{locale}.json and caches
// them in module state. Dotted keys are resolved by traversing the object
// tree. Missing keys log a warning and return the key name (visible in dev).
// Placeholders use {key} syntax inside the locale string.

let currentLocale = localStorage.getItem('ap_lang') || 'en';
let strings = {};

/**
 * Fetch and cache a locale file.
 * Falls back to English if the requested locale cannot be loaded.
 * @param {string} locale - Locale code, e.g. 'en' or 'fr-CA'
 * @returns {Promise<boolean>} true if locale was loaded successfully
 */
async function loadLocale(locale) {
  try {
    const resp = await fetch(`/locales/${locale}.json`);
    if (!resp.ok) throw new Error(`HTTP ${resp.status}`);
    strings = await resp.json();
    currentLocale = locale;
    localStorage.setItem('ap_lang', locale);
    document.documentElement.lang = locale;
    return true;
  } catch (err) {
    console.warn(`[i18n] Could not load locale "${locale}", falling back to English`, err);
    if (locale !== 'en') return loadLocale('en');
    strings = {};
    return false;
  }
}

/**
 * Resolve a dotted key like 'dashboard.upload.title' against a locale object.
 * @param {string} key
 * @param {object} localeStrings
 * @returns {string|undefined}
 */
function resolve(key, localeStrings) {
  const parts = key.split('.');
  let obj = localeStrings;
  for (const part of parts) {
    if (obj == null || typeof obj !== 'object') return undefined;
    obj = obj[part];
  }
  return typeof obj === 'string' ? obj : undefined;
}

/**
 * Translate a dotted key to the localized string.
 * @param {string} key - Dotted key path, e.g. 'dashboard.upload.title'
 * @param {object} [replacements] - Optional {placeholder} substitutions
 * @returns {string} Localized string, or the key itself if untranslated
 */
function t(key, replacements) {
  let value = resolve(key, strings);
  if (value === undefined) {
    console.warn(`[i18n] Missing translation key: "${key}" (${currentLocale})`);
    return key;
  }
  // Apply {placeholder} replacements
  if (replacements) {
    Object.keys(replacements).forEach(k => {
      value = value.replace(new RegExp(`\\{${k}\\}`, 'g'), replacements[k]);
    });
  }
  return value;
}

/**
 * Get the current locale code.
 * @returns {string} e.g. 'en' or 'fr-CA'
 */
function getLocale() {
  return currentLocale;
}

/**
 * Switch to a different locale and dispatch a 'localechanged' event.
 * @param {string} locale
 * @returns {Promise<boolean>} true on success
 */
async function setLocale(locale) {
  const ok = await loadLocale(locale);
  if (ok) {
    window.dispatchEvent(new CustomEvent('localechanged', { detail: { locale } }));
  }
  return ok;
}

// Initialize: load the saved (or default) locale on module import
const initPromise = loadLocale(currentLocale);

export { t, getLocale, setLocale, initPromise, loadLocale };

// Expose on window so regular (non-module) scripts can access them
window.t = t;
window.getLocale = getLocale;
window.setLocale = setLocale;
window.i18nReady = initPromise;

// If a bridge placeholder exists (set by inline script before module loaded),
// resolve it so regular scripts that called .then() on the placeholder fire.
if (window._i18nBridge) {
  initPromise.then(function () { window._i18nBridge(); });
}
