// ─── School Admin Content Tab ─────────────────────────────────────
// Requires content-browser.js to be loaded first.
// Calls GET /api/org?action=school-uploads
//
// i18n: init opts are parameter-driven (no hardcoded strings here).
//       Static panel labels are translated by applySchoolAdminI18n()
//       in school-admin.html. Content-browser.js strings (table headers,
//       filter placeholders, pagination) are wired separately.
//
// TODO: Once content-browser.js has its own i18n wiring, add a
//       localechanged listener here to re-render the content panel.

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
