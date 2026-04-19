// Injects the shared nav and footer into every marketing site page.
// Each page must have <div id="site-nav"></div> and <div id="site-footer"></div>.

(function () {
  const currentPath = window.location.pathname.replace(/\/$/, '') || '/';

  const navLinks = [
    { href: '/',           label: 'Home' },
    { href: '/use-cases',  label: 'Use Cases' },
    { href: '/about',      label: 'About' },
    { href: '/contact',    label: 'Contact' },
  ];

  const linkHtml = navLinks.map(({ href, label }) => {
    const active = (currentPath === href) ? ' style="color:var(--ink);font-weight:500;"' : '';
    return `<a href="${href}" class="site-nav__link"${active}>${label}</a>`;
  }).join('');

  document.getElementById('site-nav').innerHTML = `
    <nav class="site-nav">
      <div class="site-nav__inner">
        <a href="/" class="wordmark">Audio<span class="accent">Proctor</span></a>
        <div class="site-nav__links">
          ${linkHtml}
          <a href="https://app.audioproctor.com/login.html" class="site-nav__link">Sign in</a>
          <a href="/contact" class="btn btn--danger btn--small">Schedule a Demo</a>
        </div>
        <button class="site-nav__burger" id="nav-burger" aria-label="Open menu">&#9776;</button>
      </div>
      <div class="site-nav__mobile" id="nav-mobile">
        ${navLinks.map(({ href, label }) => `<a href="${href}" class="site-nav__mobile-link">${label}</a>`).join('')}
        <a href="https://app.audioproctor.com/login.html" class="site-nav__mobile-link">Sign in</a>
        <a href="/contact" class="btn btn--danger btn--small" style="margin-top:0.5rem;">Schedule a Demo</a>
      </div>
    </nav>`;

  document.getElementById('site-footer').innerHTML = `
    <footer class="site-footer">
      <div class="site-container">
        <div class="site-footer__inner">
          <span class="wordmark" style="font-size:1rem;">Audio<span class="accent">Proctor</span></span>
          <div class="site-footer__links">
            <a href="/privacy">Privacy Policy</a>
            <a href="/terms">Terms of Service</a>
            <a href="mailto:hello@audioproctor.com">hello@audioproctor.com</a>
          </div>
          <span class="label">&copy; ${new Date().getFullYear()} AudioProctor</span>
        </div>
      </div>
    </footer>`;

  // Mobile burger toggle
  document.getElementById('nav-burger').addEventListener('click', () => {
    const mobile = document.getElementById('nav-mobile');
    mobile.classList.toggle('open');
  });
})();
