// ─── Onboarding Wizard ────────────────────────────────────────────────
// First-visit tutorial wizard for new teachers. Walks through the
// assessment creation → sharing → student flow in 5 friendly steps.
// Shown automatically when a teacher has 0 uploads and hasn't seen it
// before (tracked via localStorage 'ap-onboarding-seen').
// Repeatable via the help icon in the dashboard UI.

(function () {
  'use strict';

  var STORAGE_KEY = 'ap-onboarding-seen';
  var TOTAL_STEPS = 5;

  // Steps 1-4 use "Next" button; step 5 uses "Finish" button
  var STEPS = [
    {
      titleKey: 'dashboard.onboarding.step1Title',
      bodyKey:  'dashboard.onboarding.step1Body'
    },
    {
      titleKey: 'dashboard.onboarding.step2Title',
      bodyKey:  'dashboard.onboarding.step2Body'
    },
    {
      titleKey: 'dashboard.onboarding.step3Title',
      bodyKey:  'dashboard.onboarding.step3Body'
    },
    {
      titleKey: 'dashboard.onboarding.step4Title',
      bodyKey:  'dashboard.onboarding.step4Body'
    },
    {
      titleKey: 'dashboard.onboarding.step5Title',
      bodyKey:  'dashboard.onboarding.step5Body'
    }
  ];

  var currentStep = 0;

  // ─── Element refs ──────────────────────────────────────────────────

  function $id(id) { return document.getElementById(id); }

  function getElements() {
    return {
      overlay:  $id('onboarding-overlay'),
      progress: $id('onboarding-progress'),
      step:     $id('onboarding-step'),
      skipBtn:  $id('onboarding-skip'),
      backBtn:  $id('onboarding-back'),
      nextBtn:  $id('onboarding-next'),
      finishBtn:$id('onboarding-finish')
    };
  }

  // ─── Render ────────────────────────────────────────────────────────

  function renderProgress() {
    var el = $id('onboarding-progress');
    if (!el) return;
    var html = '';
    for (var i = 0; i < TOTAL_STEPS; i++) {
      var cls = 'onboarding-dot';
      if (i === currentStep) cls += ' onboarding-dot--active';
      else if (i < currentStep) cls += ' onboarding-dot--done';
      html += '<span class="' + cls + '"></span>';
    }
    el.innerHTML = html;
  }

  function renderStep() {
    var stepData = STEPS[currentStep];
    var el = $id('onboarding-step');
    if (!el) return;

    el.innerHTML =
      '<h2 class="onboarding-step__title">' + t(stepData.titleKey) + '</h2>' +
      '<p class="onboarding-step__body">' + t(stepData.bodyKey) + '</p>' +
      '<p style="font-size:0.7rem; letter-spacing:0.14em; text-transform:uppercase; color:var(--muted); margin-top:1.5rem;">' +
        t('dashboard.onboarding.stepIndicator', { current: String(currentStep + 1), total: String(TOTAL_STEPS) }) +
      '</p>';
  }

  function renderButtons() {
    var backBtn   = $id('onboarding-back');
    var nextBtn   = $id('onboarding-next');
    var finishBtn = $id('onboarding-finish');
    if (!backBtn || !nextBtn || !finishBtn) return;

    // Back button visible on steps 1+
    if (currentStep === 0) {
      backBtn.classList.add('hidden');
    } else {
      backBtn.classList.remove('hidden');
    }

    // Last step shows Finish, others show Next
    if (currentStep === TOTAL_STEPS - 1) {
      nextBtn.classList.add('hidden');
      finishBtn.classList.remove('hidden');
    } else {
      nextBtn.classList.remove('hidden');
      finishBtn.classList.add('hidden');
    }
  }

  function applyI18n() {
    var skipBtn   = $id('onboarding-skip');
    var backBtn   = $id('onboarding-back');
    var nextBtn   = $id('onboarding-next');
    var finishBtn = $id('onboarding-finish');
    if (skipBtn)   skipBtn.textContent   = t('dashboard.onboarding.skip');
    if (backBtn)   backBtn.textContent   = t('dashboard.onboarding.back');
    if (nextBtn)   nextBtn.textContent   = t('dashboard.onboarding.next');
    if (finishBtn) finishBtn.textContent = t('dashboard.onboarding.finish');
  }

  function renderAll() {
    renderProgress();
    renderStep();
    renderButtons();
  }

  // ─── Navigation ────────────────────────────────────────────────────

  function goToStep(n) {
    currentStep = Math.max(0, Math.min(TOTAL_STEPS - 1, n));
    renderAll();
    // Scroll card to top on mobile
    var card = document.querySelector('.onboarding-card');
    if (card) card.scrollTop = 0;
  }

  function goNext() {
    if (currentStep < TOTAL_STEPS - 1) {
      goToStep(currentStep + 1);
    }
  }

  function goBack() {
    if (currentStep > 0) {
      goToStep(currentStep - 1);
    }
  }

  // ─── Show / Hide ───────────────────────────────────────────────────

  function showOnboarding() {
    currentStep = 0;
    renderAll();
    applyI18n();
    var overlay = $id('onboarding-overlay');
    if (overlay) overlay.classList.remove('hidden');
    // Focus trap: prevent background scrolling
    document.body.style.overflow = 'hidden';
  }

  function hideOnboarding() {
    var overlay = $id('onboarding-overlay');
    if (overlay) overlay.classList.add('hidden');
    document.body.style.overflow = '';
    try { localStorage.setItem(STORAGE_KEY, '1'); } catch (e) { /* ignore */ }
  }

  function finishOnboarding() {
    hideOnboarding();
  }

  // ─── Auto-trigger check ────────────────────────────────────────────

  function startOnboardingIfNeeded() {
    // Only show if never seen before
    try {
      if (localStorage.getItem(STORAGE_KEY)) return;
    } catch (e) { /* ignore */ }

    // Only show if the user has no uploads (checked by caller)
    showOnboarding();
  }

  // ─── Reset (for testing / manual re-trigger) ───────────────────────

  function resetOnboarding() {
    try { localStorage.removeItem(STORAGE_KEY); } catch (e) { /* ignore */ }
    showOnboarding();
  }

  // ─── Event binding ─────────────────────────────────────────────────

  function bindEvents() {
    var skipBtn   = $id('onboarding-skip');
    var backBtn   = $id('onboarding-back');
    var nextBtn   = $id('onboarding-next');
    var finishBtn = $id('onboarding-finish');

    if (skipBtn)   skipBtn.addEventListener('click', finishOnboarding);
    if (backBtn)   backBtn.addEventListener('click', goBack);
    if (nextBtn)   nextBtn.addEventListener('click', goNext);
    if (finishBtn) finishBtn.addEventListener('click', finishOnboarding);

    // Close on overlay click (outside card)
    var overlay = $id('onboarding-overlay');
    if (overlay) {
      overlay.addEventListener('click', function (e) {
        if (e.target === overlay) finishOnboarding();
      });
    }

    // Keyboard: Escape to skip, Arrow keys to navigate
    document.addEventListener('keydown', function (e) {
      if (!$id('onboarding-overlay') || $id('onboarding-overlay').classList.contains('hidden')) return;
      if (e.key === 'Escape') { finishOnboarding(); }
      if (e.key === 'ArrowRight') { goNext(); }
      if (e.key === 'ArrowLeft') { goBack(); }
    });
  }

  // ─── I18n live refresh ─────────────────────────────────────────────

  function onLocaleChange() {
    var overlay = $id('onboarding-overlay');
    if (!overlay || overlay.classList.contains('hidden')) return;
    applyI18n();
    renderStep();
    renderButtons();
  }

  // ─── Init ─────────────────────────────────────────────────────────

  window.i18nReady.then(function () {
    bindEvents();
    window.addEventListener('localechanged', onLocaleChange);
  });

  // ─── Public API ────────────────────────────────────────────────────

  window.showOnboarding           = showOnboarding;
  window.hideOnboarding           = hideOnboarding;
  window.startOnboardingIfNeeded  = startOnboardingIfNeeded;
  window.resetOnboarding          = resetOnboarding;

})();
