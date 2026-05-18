// language-toggle.js — EN | FR toggle for the nav bar
// Load as a regular <script> — reads window.t, window.getLocale, window.setLocale
(function () {
  // Wait for i18n module to be ready
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
        '<button class="lang-btn' + (!isEn ? ' active' : '') + '" data-lang="fr" aria-label="Français">FR</button>';

      container.querySelectorAll('.lang-btn').forEach(function (btn) {
        btn.addEventListener('click', function () {
          var lang = btn.getAttribute('data-lang');
          if (lang === window.getLocale()) return;
          window.setLocale(lang).then(function () {
            // Persist to server if user is logged in
            try {
              fetch('/api/account', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ action: 'set-lang', lang: lang })
              });
            } catch (e) { /* non-critical */ }
            render();
          });
        });
      });
    }

    render();

    // Re-render when locale changes from another source
    window.addEventListener('localechanged', render);
  }
})();
