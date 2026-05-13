// ─── Division Admin Content Tab ───────────────────────────────────
// Requires content-browser.js to be loaded first.
// Calls GET /api/org?action=division-uploads

async function initDivisionContent() {
  const opts = {
    containerId:    'panel-content',
    apiFn:          orgApi,
    listAction:     'division-uploads',
    contentAction:  'division-uploads',
    showSchool:     true,
    showTeacher:    true,
    perPage:        50,
  };
  window.divisionContentOpts = opts;
  await initContentBrowser(opts);
}
