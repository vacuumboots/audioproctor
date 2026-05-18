// ─── Demo Panel Data ──────────────────────────────────────────────

const DEMO_PANEL_DATA = [
  {
    group: 'Aspen Peaks School Division',
    subtitle: 'Division Plan · Silverwood High attached',
    personas: [
      { key: 'marcus',  name: 'Marcus Vance',    email: 'm.vance@apsd.net',                    role: 'division_admin', roleLabel: 'Division Admin'  },
      { key: 'elena',   name: 'Elena Rodriguez', email: 'e.rodriguez@silverwood.apsd.net',      role: 'school_admin',   roleLabel: 'School IT Specialist' },
      { key: 'julian',  name: 'Julian Thorne',   email: 'j.thorne@silverwood.apsd.net',         role: 'teacher',        roleLabel: 'Teacher'          },
      { key: 'sarah',   name: 'Sarah Jenkins',   email: 's.jenkins@silverwood.apsd.net',        role: 'teacher',        roleLabel: 'Teacher'          },
      { key: 'david',   name: 'David Wu',        email: 'd.wu@silverwood.apsd.net',             role: 'teacher',        roleLabel: 'Teacher'          },
    ],
  },
  {
    group: 'Horizon Charter Academy',
    subtitle: 'School Plan · Independent',
    personas: [
      { key: 'chloe',   name: 'Chloe Simmons',  email: 'c.simmons@horizoncharter.org',         role: 'school_admin',   roleLabel: 'School IT Specialist' },
      { key: 'robert',  name: 'Robert Finch',   email: 'r.finch@horizoncharter.org',            role: 'teacher',        roleLabel: 'Teacher'          },
      { key: 'linda',   name: 'Linda Grewal',   email: 'l.grewal@horizoncharter.org',           role: 'teacher',        roleLabel: 'Teacher'          },
      { key: 'thomas',  name: 'Thomas Beck',    email: 't.beck@horizoncharter.org',             role: 'teacher',        roleLabel: 'Teacher'          },
    ],
  },
];

// ─── Demo Panel ───────────────────────────────────────────────────

async function loadDemoPanel() {
  const container = document.getElementById('demo-personas');
  if (!container) return;

  const html = DEMO_PANEL_DATA.map(group => `
    <div style="margin-bottom:2rem;">
      <p style="font-weight:500; margin-bottom:0.25rem;">${escapeHtml(group.group)}</p>
      <p class="label" style="color:var(--muted); margin-bottom:0.75rem;">${escapeHtml(group.subtitle)}</p>
      <table class="admin-table">
        <tbody>
          ${group.personas.map(p => `
            <tr>
              <td style="font-size:0.875rem;"><strong style="font-weight:500;">${escapeHtml(p.name)}</strong></td>
              <td style="font-size:0.8rem; color:var(--muted);">${escapeHtml(p.roleLabel)}</td>
              <td style="font-size:0.8rem; color:var(--muted); font-family:monospace;">${escapeHtml(p.email)}</td>
              <td style="width:100px; text-align:right;">
                <button class="btn btn--ghost btn--small" onclick="viewAs('${p.key}','${escapeHtml(p.name)}','${escapeHtml(p.email)}',this)">${t('admin.demo.viewAs')}</button>
              </td>
            </tr>`).join('')}
        </tbody>
      </table>
    </div>`).join('');

  container.innerHTML = html;
}

// ─── View As ──────────────────────────────────────────────────────

async function viewAs(key, name, email, btn) {
  btn.disabled    = true;
  btn.textContent = t('common.loading');

  try {
    const teacher = allTeachers.find(t => t.email === email);
    if (!teacher) throw new Error(t('admin.demo.demoNotFound'));

    const data = await adminApi(`login-link&userId=${teacher.id}`, 'GET');

    btn.disabled    = false;
    btn.textContent = t('admin.demo.viewAs');

    showViewAsModal(name, data.email, data.role, data.redirectTo, data.link);
  } catch (err) {
    btn.disabled    = false;
    btn.textContent = t('admin.demo.viewAs');
    alert(t('admin.demo.loginLinkError', { error: err.message }));
  }
}

function showViewAsModal(name, email, role, redirectTo, link) {
  const old = document.getElementById('view-as-modal');
  if (old) old.remove();

  const modal = document.createElement('div');
  modal.id = 'view-as-modal';
  modal.style.cssText = `
    position:fixed; inset:0; background:rgba(26,26,46,0.55); z-index:1000;
    display:flex; align-items:center; justify-content:center; padding:1rem;
  `;

  modal.innerHTML = `
    <div style="background:var(--paper); border:var(--border); max-width:480px; width:100%; padding:2rem;">
      <p class="label" style="margin-bottom:0.5rem;">${t('admin.demo.viewAsTitle', { name: escapeHtml(name) })}</p>
      <p style="font-size:0.85rem; color:var(--muted); margin-bottom:1.25rem; line-height:1.5;">
        ${t('admin.demo.viewAsDescription', { email: escapeHtml(email), path: escapeHtml(redirectTo.replace('https://app.audioproctor.com','')) })}
      </p>

      <div style="border:1px solid var(--accent); padding:0.75rem 1rem; background:var(--light-accent); margin-bottom:1.25rem;">
        <p style="font-size:0.8rem; color:var(--accent); font-weight:500; margin-bottom:0.25rem;">${t('admin.demo.sessionWarningTitle')}</p>
        <p style="font-size:0.8rem; color:var(--muted); line-height:1.4;">
          ${t('admin.demo.sessionWarningDesc')}
        </p>
      </div>

      <div style="display:flex; gap:0.75rem; flex-wrap:wrap;">
        <button class="btn btn--primary" onclick="copyViewAsLink('${escapeHtml(link)}', this)">${t('admin.demo.copyLink')}</button>
        <a href="${escapeHtml(link)}" target="_blank" class="btn btn--ghost" onclick="document.getElementById('view-as-modal').remove()">${t('admin.demo.openNewTab')}</a>
        <button class="btn btn--ghost" onclick="document.getElementById('view-as-modal').remove()">${t('admin.demo.cancel')}</button>
      </div>
    </div>
  `;

  document.body.appendChild(modal);
  modal.addEventListener('click', e => { if (e.target === modal) modal.remove(); });
}

function copyViewAsLink(link, btn) {
  navigator.clipboard.writeText(link).then(() => {
    btn.textContent = t('admin.demo.copied');
    setTimeout(() => { btn.textContent = t('admin.demo.copyLink'); }, 2000);
  });
}

// ─── Seed Demo Data ───────────────────────────────────────────────

async function seedDemoData(btn) {
  if (!confirm(t('admin.demo.seedConfirm'))) return;

  btn.disabled    = true;
  btn.textContent = t('admin.demo.seeding');
  const notice = document.getElementById('seed-notice');
  notice.textContent = '';
  notice.className = 'notice hidden';

  try {
    const result = await adminApi('seed-demo', 'POST');
    notice.textContent = t('admin.demo.seedDone', {
      usersCreated: result.usersCreated,
      usersFound: result.usersFound,
      uploads: result.uploads,
      events: result.events,
    });
    notice.className = 'notice notice--success';
    await loadTeachers();
  } catch (err) {
    notice.textContent = t('admin.demo.seedFailed', { error: err.message });
    notice.className = 'notice notice--error';
  } finally {
    btn.disabled    = false;
    btn.textContent = t('admin.demo.seedButton');
  }
}
