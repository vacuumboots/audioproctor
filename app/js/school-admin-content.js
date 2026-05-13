// ─── School Admin Content Tab ─────────────────────────────────────
// Requires content-browser.js to be loaded first.
// Calls GET /api/org?action=school-uploads

async function initSchoolContent() {
  const opts = {
    containerId:    'panel-content',
    apiFn:          orgApi,
    listAction:     'school-uploads',
    contentAction:  'school-uploads',  // re-fetches details inline if needed
    showSchool:     false,
    showTeacher:    true,
    perPage:        50,
  };
  window.schoolContentOpts = opts;
  await initContentBrowser(opts);
}
