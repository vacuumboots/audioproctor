// ─── Analytics ────────────────────────────────────────────────────

async function loadAnalytics() {
  try {
    const data = await adminApi('platform-analytics');

    document.getElementById('pa-sessions').textContent    = data.totalSessions;
    document.getElementById('pa-completions').textContent = data.totalCompletions;
    document.getElementById('pa-rate').textContent        = data.completionRate != null ? data.completionRate + '%' : '—';
    document.getElementById('pa-replays').textContent     = data.totalReplays;
    document.getElementById('pa-listen').textContent      = data.avgListenSeconds != null
      ? `${Math.floor(data.avgListenSeconds / 60)}:${String(data.avgListenSeconds % 60).padStart(2, '0')}`
      : '—';

    renderPlatformActivityChart(data.weeklyActivity, document.getElementById('pa-activity-chart'));
    renderPlatformDivisionTable(data.divisions, document.getElementById('pa-divisions-container'));
  } catch (err) {
    console.error('platform-analytics failed:', err);
    document.getElementById('pa-activity-chart').innerHTML = `<p class="label text-accent">${t('admin.analytics.loadActivityError')}</p>`;
    document.getElementById('pa-divisions-container').innerHTML = `<p class="label text-accent">${t('admin.analytics.loadDivisionError')}</p>`;
  }
}

function renderPlatformActivityChart(data, container) {
  if (!data || data.length === 0 || data.every(d => d.sessions === 0)) {
    container.innerHTML = `<p style="font-size:0.85rem; color:var(--muted); padding:0.5rem 0;">${t('admin.analytics.noSessionData')}</p>`;
    return;
  }

  const maxSessions = Math.max(...data.map(d => d.sessions), 1);
  const barW     = 38;
  const gap      = 6;
  const chartH   = 80;
  const labelH   = 20;
  const totalW   = data.length * (barW + gap);

  const bars = data.map((d, i) => {
    const barH  = Math.max(Math.round((d.sessions / maxSessions) * chartH), d.sessions > 0 ? 2 : 0);
    const x     = i * (barW + gap);
    const y     = chartH - barH;
    const date  = new Date(d.week + 'T00:00:00Z');
    const label = date.toLocaleDateString('en-CA', { month: 'short', day: 'numeric', timeZone: 'UTC' });
    return `
      <rect x="${x}" y="${y}" width="${barW}" height="${barH}" fill="var(--ink)" opacity="0.75"/>
      <text x="${x + barW / 2}" y="${chartH + 13}" text-anchor="middle" font-size="8" fill="var(--muted)" font-family="'DM Sans',sans-serif">${label}</text>
      ${d.sessions > 0 ? `<text x="${x + barW / 2}" y="${y - 3}" text-anchor="middle" font-size="8" fill="var(--ink)" font-family="'DM Sans',sans-serif">${d.sessions}</text>` : ''}
    `;
  }).join('');

  container.innerHTML = `
    <div class="chart-container">
      <svg width="${totalW}" height="${chartH + labelH}" viewBox="0 0 ${totalW} ${chartH + labelH}" style="display:block;">
        ${bars}
      </svg>
    </div>
    <p style="font-size:0.75rem; color:var(--muted); margin-top:0.5rem;">${t('admin.analytics.sessionsPerWeek')}</p>
  `;
}

function renderPlatformDivisionTable(divisions, container) {
  if (!divisions || !divisions.length) {
    container.innerHTML = `<div class="empty-state"><p class="label">${t('admin.analytics.noDivisionData')}</p></div>`;
    return;
  }

  const rows = divisions.map(d => `
    <tr>
      <td><strong>${escapeHtml(d.name)}</strong></td>
      <td style="text-align:center;">${d.uploads}</td>
      <td style="text-align:center;">${d.sessions}</td>
      <td style="text-align:center;">${d.completionRate != null ? d.completionRate + '%' : '—'}</td>
      <td style="text-align:center;">${d.replays}</td>
    </tr>
  `).join('');

  container.innerHTML = `
    <table class="admin-table">
      <thead>
        <tr>
          <th>${t('admin.analytics.tableHeaders.division')}</th>
          <th style="text-align:center;">${t('admin.analytics.tableHeaders.uploads')}</th>
          <th style="text-align:center;">${t('admin.analytics.tableHeaders.sessions')}</th>
          <th style="text-align:center;">${t('admin.analytics.tableHeaders.completion')}</th>
          <th style="text-align:center;">${t('admin.analytics.tableHeaders.replays')}</th>
        </tr>
      </thead>
      <tbody>${rows}</tbody>
    </table>`;
}
