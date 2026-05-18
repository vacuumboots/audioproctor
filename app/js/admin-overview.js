// ─── Overview stats ───────────────────────────────────────────────

async function loadOverview() {
  try {
    const overview = await adminApi('overview');
    document.getElementById('stat-divisions').textContent = overview.divisionCount;
    document.getElementById('stat-schools').textContent   = overview.schoolCount;
    document.getElementById('stat-teachers').textContent  = overview.teacherCount;

    // Badge anomaly tab if there are flagged accounts
    if (overview.anomalies?.length > 0) {
      document.getElementById('anomaly-tab').textContent =
        t('admin.tabs.anomaliesWithCount', { count: overview.anomalies.length });
      renderAnomalies(overview.anomalies);
    } else {
      document.getElementById('anomalies-container').innerHTML =
        `<div class="empty-state"><p class="label">${t('admin.anomalies.noFlags')}</p></div>`;
    }
  } catch (err) {
    console.error('overview failed:', err);
  }
}

// ─── Anomalies ────────────────────────────────────────────────────

function renderAnomalies(anomalies) {
  const container = document.getElementById('anomalies-container');

  const rows = anomalies.map(a => `
    <tr>
      <td>${escapeHtml(a.id)}</td>
      <td><span class="anomaly-flag">${escapeHtml(a.country_code || '?')}</span></td>
      <td style="color:var(--muted); font-size:0.85rem;">${escapeHtml(a.division_name || '—')}</td>
    </tr>`).join('');

  container.innerHTML = `
    <p style="font-size:0.85rem; color:var(--muted); margin-bottom:1rem;">
      ${t('admin.anomalies.description')}
    </p>
    <table class="admin-table">
      <thead>
        <tr>
          <th>${t('admin.anomalies.tableHeaders.userId')}</th>
          <th>${t('admin.anomalies.tableHeaders.country')}</th>
          <th>${t('admin.anomalies.tableHeaders.division')}</th>
        </tr>
      </thead>
      <tbody>${rows}</tbody>
    </table>`;
}
