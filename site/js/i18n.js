// site/js/i18n.js — Lightweight i18n for the static marketing site
// Works as a plain <script> tag (no ES module, no build step).
//
// Usage:
//   t('site.nav.home')                    -> "Home"
//   t('site.hero.headline')               -> "Audio and text accommodation..."
//   t('site.pricing.footnote', { url: '#' }) -> "All prices in CAD..."
//   setLocale('fr-CA')                    -> loads French locale
//
// Language detection order:
//   1. ?lang= URL parameter
//   2. localStorage.ap_lang
//   3. navigator.language (first two chars)
//   4. 'en'
//
// Exposes on window: t, getLocale, setLocale, i18nReady

(function () {
  'use strict';

  var currentLocale = 'en';
  var strings = {};

  /**
   * Fetch and cache a locale file from /site/locales/{locale}.json.
   * Falls back to English on failure.
   * Normalises 'fr-CA' to 'fr' for file lookup.
   * @param {string} locale
   * @returns {Promise<boolean>}
   */
  function loadLocale(locale) {
    var fileLocale = locale === 'fr-CA' ? 'fr' : locale;
    return fetch('/site/locales/' + fileLocale + '.json')
      .then(function (resp) {
        if (!resp.ok) throw new Error('HTTP ' + resp.status);
        return resp.json();
      })
      .then(function (data) {
        strings = data;
        currentLocale = locale;
        localStorage.setItem('ap_lang', locale);
        document.documentElement.lang = locale;
        return true;
      })
      .catch(function (err) {
        console.warn('[i18n] Could not load locale "' + locale + '", falling back to English', err);
        if (locale !== 'en') return loadLocale('en');
        strings = {};
        return false;
      });
  }

  /**
   * Resolve a dotted key against a locale object.
   * @param {string} key
   * @param {object} obj
   * @returns {string|undefined}
   */
  function resolve(key, obj) {
    var parts = key.split('.');
    var cur = obj;
    for (var i = 0; i < parts.length; i++) {
      if (cur == null || typeof cur !== 'object') return undefined;
      cur = cur[parts[i]];
    }
    return typeof cur === 'string' ? cur : undefined;
  }

  /**
   * Translate a dotted key to the localized string.
   * @param {string} key - Dotted path, e.g. 'site.nav.home'
   * @param {object} [replacements] - Optional {placeholder} substitutions
   * @returns {string}
   */
  function t(key, replacements) {
    var value = resolve(key, strings);
    if (value === undefined) {
      console.warn('[i18n] Missing translation key: "' + key + '" (' + currentLocale + ')');
      return key;
    }
    if (replacements) {
      var keys = Object.keys(replacements);
      for (var i = 0; i < keys.length; i++) {
        value = value.split('{' + keys[i] + '}').join(replacements[keys[i]]);
      }
    }
    return value;
  }

  /** @returns {string} Current locale code */
  function getLocale() {
    return currentLocale;
  }

  /**
   * Switch to a different locale and dispatch a 'localechanged' event.
   * @param {string} locale
   * @returns {Promise<boolean>}
   */
  function setLocale(locale) {
    return loadLocale(locale).then(function (ok) {
      if (ok) {
        window.dispatchEvent(new CustomEvent('localechanged', { detail: { locale: locale } }));
      }
      return ok;
    });
  }

  // ── Initialisation ──
  // Detect language: URL param > localStorage > browser > 'en'
  function detectLanguage() {
    var params = new URLSearchParams(window.location.search);
    var langParam = params.get('lang');
    if (langParam) return langParam;

    var stored = localStorage.getItem('ap_lang');
    if (stored) return stored;

    var browser = (navigator.language || '').substring(0, 2);
    if (browser === 'fr') return 'fr-CA';

    return 'en';
  }

  currentLocale = detectLanguage();
  var initPromise = loadLocale(currentLocale);

  /**
   * Resolve a dotted key and return the raw value (string or array).
   * Useful for accessing arrays (e.g. pricing feature lists).
   * @param {string} key
   * @returns {*}
   */
  function resolveKey(key) {
    var parts = key.split('.');
    var cur = strings;
    for (var i = 0; i < parts.length; i++) {
      if (cur == null || typeof cur !== 'object') return undefined;
      cur = cur[parts[i]];
    }
    return cur;
  }

  // Expose on window for non-module access
  window.t = t;
  window.resolveKey = resolveKey;
  window.getLocale = getLocale;
  window.setLocale = setLocale;
  window.i18nReady = initPromise;
})();
