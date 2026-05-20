// Injects the shared nav and footer into every marketing site page.
// Each page must have <div id="site-nav"></div> and <div id="site-footer"></div>.
// i18n-aware: uses window.t() when available, falls back to English keys.

(function () {
  'use strict';

  var currentPath = window.location.pathname.replace(/\/$/, '') || '/';

  var navLinks = [
    { href: '/' },
    { href: '/use-cases' },
    { href: '/about' },
    { href: '/contact' },
  ];

  // Nav link key mapping
  var linkKeys = {
    '/':       'nav.home',
    '/use-cases': 'nav.useCases',
    '/about':  'nav.about',
    '/contact':'nav.contact',
  };

  function tr(key, replacements) {
    if (typeof window.t === 'function') {
      return window.t(key, replacements);
    }
    return key;
  }

  function getLocale() {
    if (typeof window.getLocale === 'function') {
      return window.getLocale();
    }
    return 'en';
  }

  function setLocale(locale) {
    if (typeof window.setLocale === 'function') {
      window.setLocale(locale);
    }
  }

  function renderNav() {
    var locale = getLocale();
    var isEn = locale === 'en' || locale.indexOf('en') === 0;
    var isFr = !isEn;

    var linkHtml = navLinks.map(function (item) {
      var label = tr(linkKeys[item.href]);
      var active = (currentPath === item.href) ? ' style="color:var(--ink);font-weight:500;"' : '';
      return '<a href="' + item.href + '" class="site-nav__link"' + active + '>' + label + '</a>';
    }).join('');

    var localeHtml = ''
      + '<div class="site-nav__locale">'
      + '<button class="site-nav__locale-btn' + (isEn ? ' site-nav__locale-btn--active' : '') + '" data-locale="en" title="Available in English and French for Alberta\u2019s francophone school communities.">EN</button>'
      + '<span class="site-nav__locale-sep">|</span>'
      + '<button class="site-nav__locale-btn' + (isFr ? ' site-nav__locale-btn--active' : '') + '" data-locale="fr" title="Disponible en anglais et en fran\u00e7ais pour les communaut\u00e9s scolaires francophones de l\u2019Alberta.">FR</button>'
      + '</div>';

    document.getElementById('site-nav').innerHTML = ''
      + '<nav class="site-nav">'
      + '<div class="site-nav__inner">'
      + '<a href="/" class="wordmark">Audio<span class="accent">Proctor</span></a>'
      + '<div class="site-nav__links">'
      + linkHtml
      + '<a href="https://app.audioproctor.com/login.html" class="site-nav__link">' + tr('nav.signIn') + '</a>'
      + '<a href="/contact" class="btn btn--danger btn--small">' + tr('nav.scheduleDemo') + '</a>'
      + localeHtml
      + '</div>'
      + '<button class="site-nav__burger" id="nav-burger" aria-label="' + tr('nav.home') + '">&#9776;</button>'
      + '</div>'
      + '<div class="site-nav__mobile" id="nav-mobile">'
      + navLinks.map(function (item) {
          return '<a href="' + item.href + '" class="site-nav__mobile-link">' + tr(linkKeys[item.href]) + '</a>';
        }).join('')
      + '<a href="https://app.audioproctor.com/login.html" class="site-nav__mobile-link">' + tr('nav.signIn') + '</a>'
      + '<a href="/contact" class="btn btn--danger btn--small" style="margin-top:0.5rem;">' + tr('nav.scheduleDemo') + '</a>'
      + localeHtml
      + '</div>'
      + '</nav>';

    // Wire up locale toggle buttons
    var btns = document.querySelectorAll('.site-nav__locale-btn');
    for (var i = 0; i < btns.length; i++) {
      btns[i].addEventListener('click', function (e) {
        var newLocale = e.currentTarget.getAttribute('data-locale');
        setLocale(newLocale);
      });
    }

    // Mobile burger
    var burger = document.getElementById('nav-burger');
    if (burger) {
      burger.addEventListener('click', function () {
        var mobile = document.getElementById('nav-mobile');
        mobile.classList.toggle('open');
      });
    }
  }

  function renderFooter() {
    document.getElementById('site-footer').innerHTML = ''
      + '<footer class="site-footer">'
      + '<div class="site-container">'
      + '<div class="site-footer__inner">'
      + '<span class="wordmark" style="font-size:1rem;">Audio<span class="accent">Proctor</span></span>'
      + '<div class="site-footer__links">'
      + '<a href="/privacy">' + tr('footer.privacy') + '</a>'
      + '<a href="/terms">' + tr('footer.terms') + '</a>'
      + '<a href="mailto:hello@audioproctor.com">' + tr('footer.email') + '</a>'
      + '</div>'
      + '<span class="label">' + tr('footer.copyright', { year: new Date().getFullYear() }) + '</span>'
      + '</div>'
      + '</div>'
      + '</footer>';
  }

  function renderAll() {
    renderNav();
    renderFooter();
  }

  // Initial render: wait for i18n if available, otherwise render immediately
  if (window.i18nReady) {
    window.i18nReady.then(renderAll);
  } else {
    renderAll();
  }

  // Re-render on locale change
  window.addEventListener('localechanged', renderAll);
})();
