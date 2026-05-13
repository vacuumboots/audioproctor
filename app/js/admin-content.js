// ─── Platform Admin Content Tab ───────────────────────────────────
// Requires content-browser.js to be loaded first.
// Calls GET /api/admin?action=list-teacher-uploads and
// GET /api/admin?action=get-upload-content&uploadId=

async function initAdminContent() {
  const opts = {
    containerId:    'panel-content',
    apiFn:          adminApi,
    listAction:     'list-teacher-uploads',
    contentAction:  'get-upload-content',
    showSchool:     true,
    showTeacher:    true,
    perPage:        50,
  };
  window.adminContentOpts = opts;
  await initContentBrowser(opts);
}
