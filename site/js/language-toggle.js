// site/js/language-toggle.js — EN | FR toggle for marketing site pages
// Load as a regular <script> — reads window.t, window.getLocale, window.setLocale
(function () {
  'use strict';

  window.i18nReady.then(function () {
    initLanguageToggle('#lang-toggle');
  });

  function initLanguageToggle(selector) {
    var container = document.querySelector(selector);
    if (!container) return;

    function render() {
      var current = window.getLocale();
      var isEn = current === 'en';
      container.innerHTML =
        '<button class="lang-btn' + (isEn ? ' active' : '') + '" data-lang="en" aria-label="English">EN</button>' +
        '<span class="lang-sep">|</span>' +
        '<button class="lang-btn' + (!isEn ? ' active' : '') + '" data-lang="fr" aria-label="Fran\u00e7ais">FR</button>';

      container.querySelectorAll('.lang-btn').forEach(function (btn) {
        btn.addEventListener('click', function () {
          var lang = btn.getAttribute('data-lang');
          if (lang === window.getLocale()) return;
          window.setLocale(lang).then(render);
        });
      });
    }

    render();

    window.addEventListener('localechanged', render);
  }
})();
