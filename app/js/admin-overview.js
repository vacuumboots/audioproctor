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
        `Anomalies (${overview.anomalies.length})`;
      renderAnomalies(overview.anomalies);
    } else {
      document.getElementById('anomalies-container').innerHTML =
        `<div class="empty-state"><p class="label">No anomalies flagged</p></div>`;
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
      These accounts have a non-Canadian country code detected on sign-up.
      Review and add a note, or ignore if legitimate.
    </p>
    <table class="admin-table">
      <thead>
        <tr>
          <th>User ID</th>
          <th>Country</th>
          <th>Division (self-reported)</th>
        </tr>
      </thead>
      <tbody>${rows}</tbody>
    </table>`;
}
