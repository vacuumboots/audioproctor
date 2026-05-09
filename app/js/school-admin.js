// ─── School Admin Dashboard ───────────────────────────────────────────────
// Requires role = 'school_admin' on the profiles row.
// Includes School Plan billing management.

const ORG_API = '/api/org';

let orgJwt = null;
let schoolId = null;
let schoolTier = 'free';
let schoolStripeStatus = null;

async function initSchoolAdmin(user) {
  const session = await getSession();
  if (!session) { window.location.href = '/login.html'; return; }
  orgJwt = session.access_token;

  // Verify school_admin role
  const { data: profile } = await supabaseClient
    .from('profiles')
    .select('role, school_id')
    .eq('id', user.id)
    .maybeSingle();

  if (!profile || !['school_admin', 'platform_admin'].includes(profile.role)) {
    document.body.innerHTML = `
      <div style="display:flex; align-items:center; justify-content:center; min-height:100vh; padding:2rem; text-align:center;">
        <div>
          <p class="label" style="margin-bottom:1rem; color:var(--accent);">Access denied</p>
          <p style="color:var(--muted); margin-bottom:1.5rem;">This page requires the School Admin role.</p>
          <a href="/dashboard.html" class="btn btn--ghost">Go to Dashboard</a>
        </div>
      </div>`;
    return;
  }

  schoolId = profile.school_id;

  // Load school name
  if (schoolId) {
    const { data: school } = await supabaseClient
      .from('schools')
      .select('name, tier, stripe_subscription_status, stripe_subscription_id')
      .eq('id', schoolId)
      .maybeSingle();
    if (school) {
      document.getElementById('school-name-title').textContent = school.name;
      schoolTier = school.tier || 'free';
      schoolStripeStatus = school.stripe_subscription_status;
    }
  }

  await Promise.all([loadSchoolReport(), loadTeachers(), renderBilling()]);
}

// ─── API helper ───────────────────────────────────────────────────────────

async function orgApi(action, method = 'GET', body = null, params = '') {
  const opts = {
    method,
    headers: {
      'Authorization': `Bearer ${orgJwt}`,
      'Content-Type':  'application/json',
    },
  };
  if (body) opts.body = JSON.stringify(body);
  const res  = await fetch(`${ORG_API}?action=${action}${params}`, opts);
  const data = await res.json();
  if (!res.ok) throw new Error(data.error || `API error ${res.status}`);
  return data;
}

// ─── Stats ────────────────────────────────────────────────────────────────

async function loadSchoolReport() {
  try {
    const report = await orgApi('school-report');
    document.getElementById('stat-teachers').textContent  = report.teacherCount;
    document.getElementById('stat-uploads').textContent   = report.uploadCount;
    document.getElementById('stat-sessions').textContent  = report.totalSessions;
    const rate = report.completionRate;
    const rateEl = document.getElementById('stat-completion');
    if (rate != null) {
      rateEl.textContent  = rate + '%';
      rateEl.style.color  = rate >= 80 ? '#27ae60' : rate >= 60 ? '#e67e22' : 'var(--accent)';
    } else {
      rateEl.textContent = '—';
    }
  } catch (err) {
    console.error('school-report failed:', err.message);
  }
}

// ─── Teachers ─────────────────────────────────────────────────────────────

async function loadTeachers() {
  const container = document.getElementById('teachers-container');
  try {
    const teachers = await orgApi('school-teachers');

    if (!teachers.length) {
      container.innerHTML = `<div class="empty-state"><p class="label">No teachers attached to this school yet.</p></div>`;
      return;
    }

    const rows = teachers.map(t => {
      const lastActive = t.last_active
        ? new Date(t.last_active).toLocaleDateString('en-CA', { year: 'numeric', month: 'short', day: 'numeric' })
        : '—';
      const roleTag = t.role === 'school_admin'
        ? `<span class="role-badge">Admin</span> `
        : '';
      const listenTime = t.avg_listen_seconds != null
        ? `${Math.floor(t.avg_listen_seconds / 60)}:${String(t.avg_listen_seconds % 60).padStart(2, '0')}`
        : '—';
      const completionRate = t.completion_rate != null ? `${t.completion_rate}%` : '—';

      return `
        <tr>
          <td>${roleTag}<span style="font-size:0.85rem;">${escapeHtml(t.email || '—')}</span></td>
          <td style="text-align:center;">${t.upload_count}</td>
          <td style="text-align:center;">${t.session_count}</td>
          <td style="text-align:center;">${completionRate}</td>
          <td style="text-align:center;">${t.replays}</td>
          <td style="text-align:center;">${listenTime}</td>
          <td style="color:var(--muted); font-size:0.82rem;">${lastActive}</td>
          <td>
            <button class="btn btn--ghost btn--small" onclick="detachTeacher('${t.id}', '${escapeHtml(t.email || t.id)}', this)">Remove</button>
          </td>
        </tr>`;
    }).join('');

    container.innerHTML = `
      <table class="admin-table">
        <thead>
          <tr>
            <th>Email</th>
            <th style="text-align:center;">Uploads</th>
            <th style="text-align:center;">Sessions</th>
            <th style="text-align:center;">Completion</th>
            <th style="text-align:center;">Replays</th>
            <th style="text-align:center;">Avg Listen</th>
            <th>Last Active</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>${rows}</tbody>
      </table>`;
  } catch (err) {
    container.innerHTML = `<p class="label text-accent">Could not load teachers: ${escapeHtml(err.message)}</p>`;
  }
}

async function detachTeacher(userId, email, btn) {
  if (!confirm(`Remove ${email} from this school? Their account and uploads will be preserved — they revert to the free tier.`)) return;
  btn.disabled    = true;
  btn.textContent = 'Removing…';
  try {
    await orgApi('detach-teacher', 'POST', { userId });
    await Promise.all([loadTeachers(), loadSchoolReport()]);
  } catch (err) {
    alert('Could not remove teacher: ' + err.message);
    btn.disabled    = false;
    btn.textContent = 'Remove';
  }
}

// ─── Billing ──────────────────────────────────────────────────────────────

async function renderBilling() {
  const block = document.getElementById('billing-block');
  const badge = document.getElementById('billing-badge');
  if (!block) return;

  if (schoolTier === 'school' || schoolTier === 'division') {
    const statusLabel = schoolStripeStatus === 'active' ? 'Active' :
      schoolStripeStatus === 'past_due' ? 'Past Due' :
      schoolStripeStatus === 'canceled' ? 'Canceled' : 'Active';

    const statusColor = schoolStripeStatus === 'active' ? '#4a7c59' :
      schoolStripeStatus === 'past_due' ? 'var(--accent)' : 'var(--muted)';

    badge.textContent = statusLabel;
    badge.style.color = 'var(--paper)';
    badge.style.background = statusColor;
    badge.style.border = `1px solid ${statusColor}`;
    badge.classList.remove('hidden');

    const tierLabel = schoolTier === 'division' ? 'Division Plan' : 'School Plan';
    block.innerHTML = `
      <p><strong>This school is on a ${tierLabel}.</strong></p>
      <p style="margin-top:0.5rem; color:var(--muted);">
        All teachers at this school have unlimited uploads, full analytics, and all features included.
      </p>
      <p style="margin-top:0.75rem; font-size:0.8rem; color:var(--muted);">
        Billing is managed by your division or platform administrator.
        Contact them for any changes to your plan.
      </p>`;
  } else {
    badge.classList.add('hidden');
    block.innerHTML = `
      <p><strong>This school is on the Free tier.</strong></p>
      <p style="margin-top:0.5rem; color:var(--muted); line-height:1.6;">
        Purchase a School Plan to give every teacher at this school unlimited uploads,
        full analytics, and all premium features.
      </p>
      <div style="margin-top:1rem; display:flex; gap:1rem; align-items:center;">
        <button id="btn-purchase-school-plan" class="btn btn--primary btn--small"
          onclick="startSchoolCheckout()">Purchase School Plan</button>
        <span style="font-size:0.75rem; color:var(--muted);">Billed annually</span>
      </div>
      <p style="margin-top:0.75rem; font-size:0.8rem; color:var(--muted);">
        Prefer an invoice? <a href="/request-access" style="color:var(--ink);">Submit a request</a>.
      </p>`;
  }
}

async function startSchoolCheckout() {
  const btn = document.getElementById('btn-purchase-school-plan');
  if (btn) {
    btn.disabled = true;
    btn.textContent = 'Redirecting…';
  }

  const session = await getSession();
  if (!session) { window.location = '/login.html'; return; }

  try {
    const res = await fetch('/api/stripe-checkout', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${session.access_token}`
      },
      body: JSON.stringify({ action: 'school', schoolId })
    });

    const data = await res.json();
    if (!res.ok) throw new Error(data.error || 'Checkout failed');
    window.location = data.url;
  } catch (err) {
    alert('Could not start checkout: ' + err.message);
    if (btn) {
      btn.disabled = false;
      btn.textContent = 'Purchase School Plan';
    }
  }
}

// Handle successful return from Stripe
if (new URLSearchParams(window.location.search).get('upgraded') === 'school') {
  history.replaceState(null, '', window.location.pathname);
  const banner = document.createElement('div');
  banner.style.cssText = 'position:fixed;top:0;left:0;right:0;background:var(--ink);color:var(--paper);text-align:center;padding:0.6rem;font-size:0.85rem;z-index:999;';
  banner.textContent = 'School Plan activated! All teachers at this school now have unlimited access.';
  document.body.prepend(banner);
  setTimeout(() => banner.remove(), 6000);
}

// ─── Invite Teacher ─────────────────────────────────────────────────────

function showInviteTeacherModal() {
  document.getElementById('invite-email-input').value = '';
  document.getElementById('invite-notice').classList.add('hidden');
  document.getElementById('invite-notice').textContent = '';
  document.getElementById('invite-teacher-modal').classList.remove('hidden');
  setTimeout(() => document.getElementById('invite-email-input').focus(), 100);
}

async function inviteTeacher() {
  const email = document.getElementById('invite-email-input').value.trim();
  const notice = document.getElementById('invite-notice');
  if (!email) {
    notice.textContent = 'Please enter an email address.';
    notice.className = 'notice';
    notice.classList.remove('hidden');
    return;
  }

  const btn = document.querySelector('#invite-teacher-modal .btn--primary');
  btn.disabled = true;
  btn.textContent = 'Sending…';

  try {
    await orgApi('invite-teacher', 'POST', { email });
    notice.textContent = 'Invitation sent!';
    notice.className = 'notice';
    notice.classList.remove('hidden');
    document.getElementById('invite-email-input').value = '';
    await loadTeachers();
    setTimeout(() => {
      document.getElementById('invite-teacher-modal').classList.add('hidden');
      notice.classList.add('hidden');
    }, 2000);
  } catch (err) {
    notice.textContent = 'Failed to send invitation: ' + err.message;
    notice.className = 'notice text-accent';
    notice.classList.remove('hidden');
  } finally {
    btn.disabled = false;
    btn.textContent = 'Send Invitation';
  }
}

// ─── Util ─────────────────────────────────────────────────────────────────

function escapeHtml(str) {
  if (!str) return '';
  return String(str)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/\"/g, '&quot;')
    .replace(/'/g, '&#39;');
}
