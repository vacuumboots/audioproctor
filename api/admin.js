     1|     1|// ─── /api/admin ───────────────────────────────────────────────────
     2|     2|// Vercel serverless function.
     3|     3|// All operations require the caller to be role = 'platform_admin'.
     4|     4|// Uses the service role key to bypass RLS for cross-account reads.
     5|     5|//
     6|     6|// Routes (via ?action= query param):
     7|     7|//
     8|     8|//   GET  ?action=overview          — division, school, teacher counts + anomalies
     9|     9|//   GET  ?action=divisions         — list all divisions
    10|    10|//   GET  ?action=schools           — list all schools (with division name)
    11|    11|//   GET  ?action=teachers          — list all teachers (unattached or all)
    12|    12|//   POST ?action=set-tier          — body: { entityType, entityId, tier }
    13|    13|//   POST ?action=set-notes         — body: { entityType, entityId, notes }
    14|    14|//   POST ?action=invite            — body: { email, role, schoolId?, divisionId? }
    15|    15|//   GET  ?action=list-teacher-uploads — list all uploads with metadata (paginated)
    16|    16|//   GET  ?action=get-upload-content&uploadId= — signed audio URL or resolved text HTML
    17|    17|//   POST ?action=assign-role       — body: { teacher_id, role, school_id?, division_id? }
    18|    18|//   POST ?action=attach-teacher    — body: { userId, schoolId?, divisionId? }
    19|    19|
    20|    20|const { createClient } = require('@supabase/supabase-js');
    21|    21|const crypto = require('crypto');
    22|    22|const Stripe = require('stripe');
    23|    23|const { sendEmail } = require('./_lib/email');
    24|    24|const { getRequestLanguage, apiMessage } = require('./_lib/i18n');
    25|    25|
    26|    26|function formatRole(role) {
    27|    27|  return role.replace(/_/g, ' ').replace(/\b\w/g, c => c.toUpperCase());
    28|    28|}
    29|    29|
    30|    30|function buildInviteEmail({ role, inviteUrl, orgName, lang }) {
    31|    31|  const roleLabel = formatRole(role);
    32|    32|  const isFr = lang === 'fr';
    33|    33|  const subject = isFr ? 'Vous avez été invité à rejoindre AudioProctor' : `You've been invited to join AudioProctor`;
    34|    34|  let text = isFr
    35|    35|    ? `Bonjour,\n\nVous avez été invité à rejoindre AudioProctor en tant que ${roleLabel}.`
    36|    36|    : `You've been invited to join AudioProctor as a ${roleLabel}.`;
    37|    37|  if (orgName) text += isFr ? `\n\nau sein de ${orgName}` : `\n\nas part of ${orgName}`;
    38|    38|  text += isFr
    39|    39|    ? `\n\nCliquez sur le lien ci-dessous pour accepter votre invitation :\n${inviteUrl}\n\nCette invitation expire dans 7 jours.\nSi vous n'avez pas demandé cette invitation, vous pouvez l'ignorer.`
    40|    40|    : `\n\nClick the link below to accept your invitation:\n${inviteUrl}\n\nThis invitation expires in 7 days.\nIf you did not expect this invitation, you can safely ignore it.`;
    41|    41|  let html = isFr
    42|    42|    ? `<p>Bonjour,</p><p>Vous avez été invité à rejoindre AudioProctor en tant que <strong>${roleLabel}</strong>.</p>`
    43|    43|    : `<p>You've been invited to join AudioProctor as a <strong>${roleLabel}</strong>.</p>`;
    44|    44|  if (orgName) html += isFr
    45|    45|    ? `<p>au sein de <strong>${orgName}</strong></p>`
    46|    46|    : `<p>as part of <strong>${orgName}</strong></p>`;
    47|    47|  html += isFr
    48|    48|    ? `<p>Cliquez sur le lien ci-dessous pour accepter votre invitation :</p><p><a href="${inviteUrl}">${inviteUrl}</a></p><p>Cette invitation expire dans 7 jours.<br>Si vous n'avez pas demandé cette invitation, vous pouvez l'ignorer.</p>`
    49|    49|    : `<p>Click the link below to accept your invitation:</p><p><a href="${inviteUrl}">${inviteUrl}</a></p><p>This invitation expires in 7 days.<br>If you did not expect this invitation, you can safely ignore it.</p>`;
    50|    50|  return { subject, text, html };
    51|    51|}
    52|    52|
    53|    53|module.exports = async (req, res) => {
    54|    54|  res.setHeader('Access-Control-Allow-Origin',  'https://app.audioproctor.com');
    55|    55|  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
    56|    56|  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');
    57|    57|
    58|    58|  if (req.method === 'OPTIONS') return res.status(200).end();
    59|    59|
    60|    60|  const lang = getRequestLanguage(req);
    61|    61|
    62|    62|  // ─── Auth check ─────────────────────────────────────────────────
    63|    63|  // The caller passes their Supabase JWT in the Authorization header.
    64|    64|  // We verify it using the anon client, then check role = platform_admin.
    65|    65|  const authHeader = req.headers['authorization'] || '';
    66|    66|  const jwt = authHeader.startsWith('Bearer ') ? authHeader.slice(7) : null;
    67|    67|  if (!jwt) return res.status(401).json({ error: apiMessage('unauthorized', lang) });
    68|    68|
    69|    69|  const anonClient = createClient(
    70|    70|    process.env.SUPABASE_URL,
    71|    71|    process.env.SUPABASE_ANON_KEY,
    72|    72|    { global: { headers: { Authorization: `Bearer ${jwt}` } } }
    73|    73|  );
    74|    74|
    75|    75|  const { data: { user }, error: authErr } = await anonClient.auth.getUser();
    76|    76|  if (authErr || !user) return res.status(401).json({ error: apiMessage('invalidToken', lang) });
    77|    77|
    78|    78|  // Service role client for all data operations
    79|    79|  const supabase = createClient(
    80|    80|    process.env.SUPABASE_URL,
    81|    81|    process.env.SUPABASE_SERVICE_ROLE_KEY
    82|    82|  );
    83|    83|
    84|    84|  // Check role
    85|    85|  const { data: profile, error: profileErr } = await supabase
    86|    86|    .from('profiles')
    87|    87|    .select('role')
    88|    88|    .eq('id', user.id)
    89|    89|    .single();
    90|    90|
    91|    91|  if (profileErr || !profile || profile.role !== 'platform_admin') {
    92|    92|    return res.status(403).json({ error: apiMessage('forbidden', lang) });
    93|    93|  }
    94|    94|
    95|    95|  const action = req.query.action;
    96|    96|
    97|    97|  // ─── GET routes ──────────────────────────────────────────────────
    98|    98|
    99|    99|  if (req.method === 'GET') {
   100|   100|
   101|   101|    if (action === 'overview') {
   102|   102|      const [
   103|   103|        { count: divCount },
   104|   104|        { count: schoolCount },
   105|   105|        { count: teacherCount },
   106|   106|        { data: foreignAccounts },
   107|   107|      ] = await Promise.all([
   108|   108|        supabase.from('divisions').select('id', { count: 'exact', head: true }),
   109|   109|        supabase.from('schools').select('id', { count: 'exact', head: true }),
   110|   110|        supabase.from('profiles').select('id', { count: 'exact', head: true }).or('role.eq.teacher,role.is.null'),
   111|   111|        // Anomaly: profiles where country_code is not CA (and not null/empty)
   112|   112|        supabase
   113|   113|          .from('profiles')
   114|   114|          .select('id, country_code, division_name')
   115|   115|          .not('country_code', 'eq', 'CA')
   116|   116|          .not('country_code', 'is', null)
   117|   117|          .neq('country_code', ''),
   118|   118|      ]);
   119|   119|
   120|   120|      return res.status(200).json({
   121|   121|        divisionCount: divCount  || 0,
   122|   122|        schoolCount:   schoolCount || 0,
   123|   123|        teacherCount:  teacherCount || 0,
   124|   124|        anomalies:     foreignAccounts || [],
   125|   125|      });
   126|   126|    }
   127|   127|
   128|   128|    if (action === 'divisions') {
   129|   129|      const { data, error } = await supabase
   130|   130|        .from('divisions')
   131|   131|        .select('id, name, enrolment_band, tier, admin_email, notes, expires_at, created_at')
   132|   132|        .order('created_at', { ascending: false })
   133|   133|        .limit(500);
   134|   134|      if (error) {
   135|   135|        console.error('admin divisions query failed:', error.message);
   136|   136|        return res.status(500).json({ error: apiMessage('serverError', lang) });
   137|   137|      }
   138|   138|      return res.status(200).json(data);
   139|   139|    }
   140|   140|
   141|   141|    if (action === 'schools') {
   142|   142|      const { data, error } = await supabase
   143|   143|        .from('schools')
   144|   144|        .select('id, name, tier, admin_email, notes, expires_at, created_at, divisions(name)')
   145|   145|        .order('created_at', { ascending: false })
   146|   146|        .limit(500);
   147|   147|      if (error) {
   148|   148|        console.error('admin schools query failed:', error.message);
   149|   149|        return res.status(500).json({ error: apiMessage('serverError', lang) });
   150|   150|      }
   151|   151|      return res.status(200).json(data);
   152|   152|    }
   153|   153|
   154|   154|    if (action === 'teachers') {
   155|   155|      const { data, error } = await supabase
   156|   156|        .from('profiles')
   157|   157|        .select(`
   158|   158|          id, role, tier, tier_override, expires_at, country_code, division_name, notes, school_id, division_id, is_deactivated,
   159|   159|          schools(name), divisions(name)
   160|   160|        `)
   161|   161|        .order('id', { ascending: true })
   162|   162|        .limit(1000);
   163|   163|      if (error) {
   164|   164|        console.error('admin teachers query failed:', error.message);
   165|   165|        return res.status(500).json({ error: apiMessage('serverError', lang) });
   166|   166|      }
   167|   167|
   168|   168|      // Merge auth.users email — paginated to handle >1000 users
   169|   169|      const emailMap = await getAllUserEmails(supabase);
   170|   170|
   171|   171|      const teachers = (data || []).map(p => ({
   172|   172|        ...p,
   173|   173|        email: emailMap[p.id] || null,
   174|   174|        school_name:   p.schools?.name   || null,
   175|   175|        division_name_org: p.divisions?.name || null,
   176|   176|      }));
   177|   177|
   178|   178|      return res.status(200).json(teachers);
   179|   179|    }
   180|   180|
   181|   181|    if (action === 'audit-log') {
   182|   182|      const limit  = Math.min(parseInt(req.query.limit  || '100', 10), 500);
   183|   183|      const offset = parseInt(req.query.offset || '0',   10);
   184|   184|      const { data, error } = await supabase
   185|   185|        .from('admin_audit_log')
   186|   186|        .select('*')
   187|   187|        .order('occurred_at', { ascending: false })
   188|   188|        .range(offset, offset + limit - 1);
   189|   189|      if (error) return res.status(500).json({ error: apiMessage('serverError', lang) });
   190|   190|      return res.status(200).json(data);
   191|   191|    }
   192|   192|
   193|   193|    if (action === 'login-link') {
   194|   194|      const { userId: targetId } = req.query;
   195|   195|      if (!targetId) return res.status(400).json({ error: apiMessage('missingParam', lang, { param: 'userId' }) });
   196|   196|
   197|   197|      const { data: { user: targetUser }, error: userErr } = await supabase.auth.admin.getUserById(targetId);
   198|   198|      if (userErr || !targetUser) return res.status(404).json({ error: apiMessage('not_found', lang) });
   199|   199|
   200|   200|      const { data: targetProfile } = await supabase
   201|   201|        .from('profiles').select('role, display_name').eq('id', targetId).maybeSingle();
   202|   202|
   203|   203|      // Always redirect to login.html — it's in the Supabase allowlist and
   204|   204|      // routes to the correct page for each role after the session is established.
   205|   205|      const redirectTo = 'https://app.audioproctor.com/login.html';
   206|   206|
   207|   207|      const { data: linkData, error: linkErr } = await supabase.auth.admin.generateLink({
   208|   208|        type: 'magiclink',
   209|   209|        email: targetUser.email,
   210|   210|        options: { redirectTo },
   211|   211|      });
   212|   212|      if (linkErr) {
   213|   213|        console.error('login-link generation failed:', linkErr.message);
   214|   214|        return res.status(500).json({ error: apiMessage('serverError', lang) });
   215|   215|      }
   216|   216|
   217|   217|      return res.status(200).json({
   218|   218|        link:       linkData.properties.action_link,
   219|   219|        email:      targetUser.email,
   220|   220|        name:       targetProfile?.display_name || targetUser.email,
   221|   221|        role:       targetProfile?.role || 'teacher',
   222|   222|        redirectTo,
   223|   223|      });
   224|   224|    }
   225|   225|
   226|   226|    if (action === 'list-invitations') {
   227|   227|      const { data, error } = await supabase
   228|   228|        .from('invitations')
   229|   229|        .select('id, email, role, school_id, division_id, token, expires_at, accepted_at, created_at, schools(name), divisions(name)')
   230|   230|        .is('accepted_at', null)
   231|   231|        .order('created_at', { ascending: false })
   232|   232|        .limit(200);
   233|   233|      if (error) {
   234|   234|        console.error('admin list-invitations failed:', error.message);
   235|   235|        return res.status(500).json({ error: apiMessage('serverError', lang) });
   236|   236|      }
   237|   237|
   238|   238|      // Merge latest email send status per invitation
   239|   239|      const invitationIds = (data || []).map(i => i.id);
   240|   240|      let lastEmailMap = {};
   241|   241|      if (invitationIds.length > 0) {
   242|   242|        const { data: logs } = await supabase
   243|   243|          .from('invite_email_log')
   244|   244|          .select('invitation_id, email_ok, created_at')
   245|   245|          .in('invitation_id', invitationIds)
   246|   246|          .in('action', ['approve_request', 'invite', 'resend'])
   247|   247|          .order('created_at', { ascending: false })
   248|   248|          .limit(500);
   249|   249|        logs?.forEach(l => {
   250|   250|          if (!lastEmailMap[l.invitation_id]) lastEmailMap[l.invitation_id] = l;
   251|   251|        });
   252|   252|      }
   253|   253|
   254|   254|      const enriched = (data || []).map(inv => ({
   255|   255|        ...inv,
   256|   256|        lastEmailOk: lastEmailMap[inv.id]?.email_ok ?? null,
   257|   257|      }));
   258|   258|
   259|   259|      return res.status(200).json(enriched);
   260|   260|    }
   261|   261|
   262|   262|    if (action === 'list-requests') {
   263|   263|      const { data, error } = await supabase
   264|   264|        .from('teacher_requests')
   265|   265|        .select('id, name, email, school, division, message, status, notes, created_at, teacher_id, request_type')
   266|   266|        .order('created_at', { ascending: false })
   267|   267|        .limit(200);
   268|   268|      if (error) return res.status(500).json({ error: apiMessage('serverError', lang) });
   269|   269|      return res.status(200).json(data);
   270|   270|    }
   271|   271|
   272|   272|    if (action === 'platform-analytics') {
   273|   273|      // 1. Platform totals from upload_summaries
   274|   274|      const { data: allSums } = await supabase
   275|   275|        .from('upload_summaries')
   276|   276|        .select('total_sessions, completions, replays, avg_listen_seconds');
   277|   277|
   278|   278|      let totalSessions = 0, totalCompletions = 0, totalReplays = 0;
   279|   279|      let avgListenSum = 0, avgListenCount = 0;
   280|   280|      (allSums || []).forEach(s => {
   281|   281|        totalSessions    += s.total_sessions || 0;
   282|   282|        totalCompletions += s.completions    || 0;
   283|   283|        totalReplays     += s.replays        || 0;
   284|   284|        if (s.avg_listen_seconds) {
   285|   285|          avgListenSum   += s.avg_listen_seconds;
   286|   286|          avgListenCount += 1;
   287|   287|        }
   288|   288|      });
   289|   289|
   290|   290|      // 2. Per-division breakdown
   291|   291|      const [{ data: divisions }, { data: allSchools }, { data: allProfiles }, { data: allUploads }] = await Promise.all([
   292|   292|        supabase.from('divisions').select('id, name'),
   293|   293|        supabase.from('schools').select('id, division_id'),
   294|   294|        supabase.from('profiles').select('id, division_id, school_id'),
   295|   295|        supabase.from('uploads').select('id, teacher_id'),
   296|   296|      ]);
   297|   297|
   298|   298|      const schoolToDivision = {};
   299|   299|      (allSchools || []).forEach(s => { schoolToDivision[s.id] = s.division_id; });
   300|   300|
   301|   301|      const teacherToDivision = {};
   302|   302|      (allProfiles || []).forEach(p => {
   303|   303|        teacherToDivision[p.id] = p.division_id || schoolToDivision[p.school_id] || null;
   304|   304|      });
   305|   305|
   306|   306|      const uploadToTeacher = {};
   307|   307|      (allUploads || []).forEach(u => { uploadToTeacher[u.id] = u.teacher_id; });
   308|   308|
   309|   309|      const divStats = {};
   310|   310|      (divisions || []).forEach(d => {
   311|   311|        divStats[d.id] = { id: d.id, name: d.name, sessions: 0, completions: 0, replays: 0, uploads: 0 };
   312|   312|      });
   313|   313|
   314|   314|      // Count uploads per division
   315|   315|      (allUploads || []).forEach(u => {
   316|   316|        const did = teacherToDivision[u.teacher_id];
   317|   317|        if (did && divStats[did]) divStats[did].uploads += 1;
   318|   318|      });
   319|   319|
   320|   320|      // Aggregate summaries per division
   321|   321|      (allSums || []).forEach(s => {
   322|   322|        const tid = uploadToTeacher[s.upload_id];
   323|   323|        const did = teacherToDivision[tid];
   324|   324|        if (did && divStats[did]) {
   325|   325|          divStats[did].sessions    += s.total_sessions || 0;
   326|   326|          divStats[did].completions += s.completions    || 0;
   327|   327|          divStats[did].replays     += s.replays        || 0;
   328|   328|        }
   329|   329|      });
   330|   330|
   331|   331|      // 3. Weekly activity (last 12 weeks)
   332|   332|      const twelveWeeksAgo = new Date(Date.now() - 12 * 7 * 24 * 60 * 60 * 1000).toISOString();
   333|   333|      const { data: events } = await supabase
   334|   334|        .from('session_events')
   335|   335|        .select('event_type, occurred_at')
   336|   336|        .in('event_type', ['code_entered', 'playback_completed'])
   337|   337|        .gte('occurred_at', twelveWeeksAgo);
   338|   338|
   339|   339|      const weeklyData = {};
   340|   340|      (events || []).forEach(e => {
   341|   341|        const d   = new Date(e.occurred_at);
   342|   342|        const day = d.getUTCDay();
   343|   343|        const diff = d.getUTCDate() - day + (day === 0 ? -6 : 1);
   344|   344|        const wkStart = new Date(Date.UTC(d.getUTCFullYear(), d.getUTCMonth(), diff));
   345|   345|        const key = wkStart.toISOString().slice(0, 10);
   346|   346|        if (!weeklyData[key]) weeklyData[key] = { week: key, sessions: 0, completions: 0 };
   347|   347|        if (e.event_type === 'code_entered')       weeklyData[key].sessions++;
   348|   348|        if (e.event_type === 'playback_completed') weeklyData[key].completions++;
   349|   349|      });
   350|   350|
   351|   351|      const weeklyActivity = [];
   352|   352|      for (let i = 11; i >= 0; i--) {
   353|   353|        const base = new Date();
   354|   354|        const day  = base.getUTCDay();
   355|   355|        const diff = base.getUTCDate() - day + (day === 0 ? -6 : 1) - i * 7;
   356|   356|        const wkStart = new Date(Date.UTC(base.getUTCFullYear(), base.getUTCMonth(), diff));
   357|   357|        const key = wkStart.toISOString().slice(0, 10);
   358|   358|        weeklyActivity.push(weeklyData[key] || { week: key, sessions: 0, completions: 0 });
   359|   359|      }
   360|   360|
   361|   361|      return res.status(200).json({
   362|   362|        totalSessions,
   363|   363|        totalCompletions,
   364|   364|        completionRate:   totalSessions > 0 ? Math.round(totalCompletions / totalSessions * 100) : null,
   365|   365|        totalReplays,
   366|   366|        avgListenSeconds: avgListenCount > 0 ? Math.round(avgListenSum / avgListenCount) : null,
   367|   367|        divisions: Object.values(divStats)
   368|   368|          .map(d => ({
   369|   369|            ...d,
   370|   370|            completionRate: d.sessions > 0 ? Math.round(d.completions / d.sessions * 100) : null,
   371|   371|          }))
   372|   372|          .sort((a, b) => b.sessions - a.sessions),
   373|   373|        weeklyActivity,
   374|   374|      });
   375|   375|    }
   376|   376|
   377|   377|    if (action === 'list-teacher-uploads') {
   378|   378|      // ─── List all teacher uploads with metadata ────────────────
   379|   379|      const { teacherId, schoolId, divisionId, type, limit, offset } = req.query;
   380|   380|      const pageLimit = Math.min(parseInt(limit) || 50, 200);
   381|   381|      const pageOffset = parseInt(offset) || 0;
   382|   382|
   383|   383|      let query = supabase
   384|   384|        .from('uploads')
   385|   385|        .select(`
   386|   386|          id, teacher_id, access_code, filename, label, assessment_type,
   387|   387|          file_size_mb, storage_path, text_content, text_char_count, image_count,
   388|   388|          processing_status, created_at, expires_at
   389|   389|        `, { count: 'exact' })
   390|   390|        .order('created_at', { ascending: false })
   391|   391|        .range(pageOffset, pageOffset + pageLimit - 1);
   392|   392|
   393|   393|      if (teacherId)  query = query.eq('teacher_id', teacherId);
   394|   394|      if (type)       query = query.eq('assessment_type', type);
   395|   395|
   396|   396|      const { data: uploads, count: total, error } = await query;
   397|   397|      if (error) return res.status(500).json({ error: apiMessage('serverError', lang) });
   398|   398|
   399|   399|      const teacherIds = [...new Set((uploads || []).map(u => u.teacher_id))];
   400|   400|      const { data: teachers } = await supabase
   401|   401|        .from('profiles')
   402|   402|        .select('id, school_id, division_id')
   403|   403|        .in('id', teacherIds.length ? teacherIds : ['none']);
   404|   404|
   405|   405|      // Fetch teacher emails from auth
   406|   406|      let teacherEmails = {};
   407|   407|      if (teacherIds.length) {
   408|   408|        try {
   409|   409|          const { data: authUsers } = await supabase.auth.admin.listUsers({ perPage: 1000 });
   410|   410|          if (authUsers?.users) {
   411|   411|            authUsers.users.forEach(u => { teacherEmails[u.id] = u.email; });
   412|   412|          }
   413|   413|        } catch (_) { /* non-fatal — email column will show '—' */ }
   414|   414|      }
   415|   415|
   416|   416|      const teacherMap = {};
   417|   417|      (teachers || []).forEach(t => { teacherMap[t.id] = t; });
   418|   418|
   419|   419|      const schoolIds = [...new Set((teachers || []).map(t => t.school_id).filter(Boolean))];
   420|   420|      const divisionIds = [...new Set((teachers || []).map(t => t.division_id).filter(Boolean))];
   421|   421|
   422|   422|      const [{ data: schools }, { data: divisions }] = await Promise.all([
   423|   423|        schoolIds.length ? supabase.from('schools').select('id, name').in('id', schoolIds) : { data: [] },
   424|   424|        divisionIds.length ? supabase.from('divisions').select('id, name').in('id', divisionIds) : { data: [] },
   425|   425|      ]);
   426|   426|
   427|   427|      const schoolMap = {}; (schools || []).forEach(s => { schoolMap[s.id]  = s.name; });
   428|   428|      const divMap    = {}; (divisions || []).forEach(d => { divMap[d.id]    = d.name; });
   429|   429|
   430|   430|      const rows = (uploads || []).map(u => {
   431|   431|        const t = teacherMap[u.teacher_id] || {};
   432|   432|        return {
   433|   433|          id:               u.id,
   434|   434|          teacher_id:       u.teacher_id,
   435|   435|          teacher_email:    teacherEmails[u.teacher_id] || null,
   436|   436|          school_name:      schoolMap[t.school_id] || null,
   437|   437|          division_name:    divMap[t.division_id] || null,
   438|   438|          access_code:      u.access_code,
   439|   439|          filename:         u.filename,
   440|   440|          label:            u.label,
   441|   441|          assessment_type:  u.assessment_type,
   442|   442|          file_size_mb:     u.file_size_mb,
   443|   443|          text_char_count:  u.text_char_count,
   444|   444|          image_count:      u.image_count,
   445|   445|          processing_status: u.processing_status,
   446|   446|          created_at:       u.created_at,
   447|   447|          expires_at:       u.expires_at,
   448|   448|        };
   449|   449|      });
   450|   450|
   451|   451|      let filtered = rows;
   452|   452|      if (schoolId) {
   453|   453|        filtered = rows.filter(r => {
   454|   454|          const t = teacherMap[r.teacher_id] || {};
   455|   455|          return t.school_id === schoolId;
   456|   456|        });
   457|   457|      }
   458|   458|      if (divisionId) {
   459|   459|        filtered = rows.filter(r => {
   460|   460|          const t = teacherMap[r.teacher_id] || {};
   461|   461|          return t.division_id === divisionId;
   462|   462|        });
   463|   463|      }
   464|   464|      return res.status(200).json({ uploads: filtered, total, offset: pageOffset, limit: pageLimit });
   465|   465|    }
   466|   466|
   467|   467|    if (action === 'get-upload-content') {
   468|   468|      const { uploadId } = req.query;
   469|   469|      if (!uploadId) return res.status(400).json({ error: apiMessage('missingParam', lang, { param: 'uploadId' }) });
   470|   470|
   471|   471|      const { data: upload, error: fetchErr } = await supabase
   472|   472|        .from('uploads')
   473|   473|        .select('id, teacher_id, storage_path, access_code, assessment_type, text_content, image_count')
   474|   474|        .eq('id', uploadId)
   475|   475|        .single();
   476|   476|
   477|   477|      if (fetchErr || !upload) return res.status(404).json({ error: apiMessage('not_found', lang) });
   478|   478|
   479|   479|      if (upload.assessment_type === 'audio') {
   480|   480|        const { data: signed, error: signErr } = await supabase
   481|   481|          .storage.from('audio-files')
   482|   482|          .createSignedUrl(upload.storage_path, 3600);
   483|   483|        if (signErr || !signed) return res.status(500).json({ error: apiMessage('serverError', lang) });
   484|   484|        return res.status(200).json({ assessment_type: 'audio', signed_url: signed.signedUrl });
   485|   485|      }
   486|   486|
   487|   487|      let resolvedHtml = upload.text_content || '';
   488|   488|      if (upload.image_count > 0) {
   489|   489|        const teacherId  = upload.teacher_id;
   490|   490|        const accessCode = upload.access_code;
   491|   491|        const signedUrls = [];
   492|   492|        for (let i = 0; i < upload.image_count; i++) {
   493|   493|          let found = false;
   494|   494|          for (const ext of ['png', 'jpg', 'webp']) {
   495|   495|            const imgPath = `${teacherId}/${accessCode}/img_${i}.${ext}`;
   496|   496|            const { data: signed, error: signErr } = await supabase
   497|   497|              .storage.from('assessment-images')
   498|   498|              .createSignedUrl(imgPath, 3600);
   499|   499|            if (!signErr && signed) { signedUrls[i] = signed.signedUrl; found = true; break; }
   500|   500|          }
   501|   501|          if (!found) signedUrls[i] = '';
   502|   502|        }
   503|   503|        resolvedHtml = resolvedHtml.replace(
   504|   504|          /<img[^>]*data-apimg-idx="(\d+)"[^>]*>/g,
   505|   505|          (match, idx) => {
   506|   506|            const url = signedUrls[parseInt(idx)] || '';
   507|   507|            if (!url) return '';
   508|   508|            return `<img src="${url.replace(/&/g,'&amp;').replace(/"/g,'&quot;')}" style="max-width:100%;height:auto;">`;
   509|   509|          }
   510|   510|        );
   511|   511|      }
   512|   512|      return res.status(200).json({ assessment_type: 'text', text_content: resolvedHtml });
   513|   513|    }
   514|   514|
   515|   515|    return res.status(400).json({ error: apiMessage('bad_request', lang) });
   516|   516|  }
   517|   517|
   518|   518|  // ─── POST routes ─────────────────────────────────────────────────
   519|   519|
   520|   520|  if (req.method === 'POST') {
   521|   521|    const body = req.body || {};
   522|   522|
   523|   523|    if (action === 'set-tier') {
   524|   524|      const { entityType, entityId, tier } = body;
   525|   525|      const validTiers = ['free','premium','school','division'];
   526|   526|      if (!validTiers.includes(tier)) return res.status(400).json({ error: apiMessage('invalid_param', lang, { param: 'tier' }) });
   527|   527|
   528|   528|      let error;
   529|   529|      if (entityType === 'division') {
   530|   530|        ({ error } = await supabase.from('divisions').update({ tier }).eq('id', entityId));
   531|   531|      } else if (entityType === 'school') {
   532|   532|        ({ error } = await supabase.from('schools').update({ tier }).eq('id', entityId));
   533|   533|      } else if (entityType === 'teacher') {
   534|   534|        // For teachers, set tier_override (preserves their own tier column)
   535|   535|        ({ error } = await supabase.from('profiles').update({ tier_override: tier === 'free' ? null : tier }).eq('id', entityId));
   536|   536|      } else {
   537|   537|        return res.status(400).json({ error: apiMessage('invalid_param', lang, { param: 'entityType' }) });
   538|   538|      }
   539|   539|      if (error) {
   540|   540|        console.error('set-tier failed:', error.message);
   541|   541|        return res.status(500).json({ error: apiMessage('action_failed', lang, { action: 'Update tier', reason: error.message }) });
   542|   542|      }
   543|   543|      audit(supabase, user.id, 'set_tier', entityType, entityId, null, { tier });
   544|   544|      return res.status(200).json({ ok: true });
   545|   545|    }
   546|   546|
   547|   547|    if (action === 'set-expires') {
   548|   548|      const { entityType, entityId, expiresAt } = body;
   549|   549|      if (!entityType || !entityId) return res.status(400).json({ error: apiMessage('missingParam', lang, { param: 'entityType and entityId' }) });
   550|   550|
   551|   551|      let error;
   552|   552|      const expiry = expiresAt || null;
   553|   553|      if (entityType === 'division') {
   554|   554|        ({ error } = await supabase.from('divisions').update({ expires_at: expiry }).eq('id', entityId));
   555|   555|      } else if (entityType === 'school') {
   556|   556|        ({ error } = await supabase.from('schools').update({ expires_at: expiry }).eq('id', entityId));
   557|   557|      } else if (entityType === 'teacher') {
   558|   558|        ({ error } = await supabase.from('profiles').update({ expires_at: expiry }).eq('id', entityId));
   559|   559|      } else {\n        return res.status(400).json({ error: apiMessage('invalid_param', lang, { param: 'entityType' }) });\n      }\n      if (error) {\n        console.error('set-expires failed:', error.message);\n        return res.status(500).json({ error: apiMessage('action_failed', lang, { action: 'Update expiry', reason: error.message }) });\n      }
   560|   560|      audit(supabase, user.id, 'set_expires', entityType, entityId, null, { expires_at: expiry });
   561|   561|      return res.status(200).json({ ok: true });
   562|   562|    }
   563|   563|
   564|   564|    if (action === 'set-notes') {
   565|   565|      const { entityType, entityId, notes } = body;
   566|   566|      if (typeof notes !== 'string') return res.status(400).json({ error: apiMessage('invalid_param', lang, { param: 'notes' }) });
   567|   567|
   568|   568|      let error;
   569|   569|      if (entityType === 'division') {
   570|   570|        ({ error } = await supabase.from('divisions').update({ notes }).eq('id', entityId));
   571|   571|      } else if (entityType === 'school') {
   572|   572|        ({ error } = await supabase.from('schools').update({ notes }).eq('id', entityId));
   573|   573|      } else if (entityType === 'teacher') {
   574|   574|        ({ error } = await supabase.from('profiles').update({ notes }).eq('id', entityId));
   575|   575|      } else {\n        return res.status(400).json({ error: apiMessage('invalid_param', lang, { param: 'entityType' }) });\n      }\n      if (error) {\n        console.error('set-notes failed:', error.message);\n        return res.status(500).json({ error: apiMessage('action_failed', lang, { action: 'Update notes', reason: error.message }) });\n      }
   576|   576|      return res.status(200).json({ ok: true });
   577|   577|    }
   578|   578|
   579|   579|    if (action === 'set-role') {
   580|   580|      const { userId, role } = body;
   581|   581|      const validRoles = ['teacher', 'school_admin', 'division_admin', 'platform_admin'];
   582|   582|      if (!userId) return res.status(400).json({ error: apiMessage('userId_required', lang) });
   583|   583|      if (!validRoles.includes(role)) return res.status(400).json({ error: apiMessage('invalid_role', lang) });
   584|   584|      const { data: prevProfile } = await supabase.from('profiles').select('role').eq('id', userId).single();
   585|   585|      const { error } = await supabase.from('profiles').update({ role }).eq('id', userId);
   586|   586|      if (error) {
   587|   587|        console.error('set-role failed:', error.message);
   588|   588|        return res.status(500).json({ error: apiMessage('could_not_update_role', lang) });
   589|   589|      }
   590|   590|      audit(supabase, user.id, 'set_role', 'teacher', userId, { role: prevProfile?.role }, { role });
   591|   591|      return res.status(200).json({ ok: true });
   592|   592|    }
   593|   593|
   594|   594|    if (action === 'assign-role') {
   595|   595|      const { teacher_id, role, school_id, division_id } = body;
   596|   596|      const validRoles = ['teacher', 'school_admin', 'division_admin', 'platform_admin'];
   597|   597|      if (!teacher_id) return res.status(400).json({ error: apiMessage('teacher_id_required', lang) });
   598|   598|      if (!validRoles.includes(role)) return res.status(400).json({ error: apiMessage('invalid_role', lang) });
   599|   599|      if (role === 'school_admin' && !school_id) return res.status(400).json({ error: apiMessage('school_id_required', lang) });
   600|   600|      if (role === 'division_admin' && !division_id) return res.status(400).json({ error: apiMessage('division_id_required', lang) });
   601|   601|
   602|   602|      const { data: prevProfile } = await supabase
   603|   603|        .from('profiles').select('role, school_id, division_id').eq('id', teacher_id).single();
   604|   604|
   605|   605|      const updateFields = { role };
   606|   606|
   607|   607|      if (role === 'school_admin') {
   608|   608|        updateFields.school_id = school_id;
   609|   609|        updateFields.division_id = null;
   610|   610|      } else if (role === 'division_admin') {
   611|   611|        updateFields.division_id = division_id;
   612|   612|        updateFields.school_id = null;
   613|   613|      } else if (role === 'platform_admin') {
   614|   614|        updateFields.school_id = null;
   615|   615|        updateFields.division_id = null;
   616|   616|      } else {
   617|   617|        updateFields.school_id = school_id || null;
   618|   618|        updateFields.division_id = division_id || null;
   619|   619|      }
   620|   620|
   621|   621|      const { error } = await supabase
   622|   622|        .from('profiles')
   623|   623|        .update(updateFields)
   624|   624|        .eq('id', teacher_id);
   625|   625|
   626|   626|      if (error) {
   627|   627|        console.error('assign-role failed:', error.message);
   628|   628|        return res.status(500).json({ error: apiMessage('could_not_assign_role', lang) });
   629|   629|      }
   630|   630|
   631|   631|      audit(supabase, user.id, 'assign_role', 'teacher', teacher_id,
   632|   632|        { role: prevProfile?.role, school_id: prevProfile?.school_id, division_id: prevProfile?.division_id },
   633|   633|        updateFields);
   634|   634|
   635|   635|      return res.status(200).json({ ok: true });
   636|   636|    }
   637|   637|
   638|   638|    if (action === 'attach-teacher') {
   639|   639|      const { userId, schoolId, divisionId } = body;
   640|   640|      if (!userId) return res.status(400).json({ error: apiMessage('userId_required', lang) });
   641|   641|      const { data: prevProfile } = await supabase.from('profiles').select('school_id, division_id').eq('id', userId).single();
   642|   642|      const { error } = await supabase
   643|   643|        .from('profiles')
   644|   644|        .update({
   645|   645|          school_id:   schoolId   || null,
   646|   646|          division_id: divisionId || null,
   647|   647|        })
   648|   648|        .eq('id', userId);
   649|   649|      if (error) {
   650|   650|        console.error('attach-teacher failed:', error.message);
   651|   651|        return res.status(500).json({ error: apiMessage('could_not_attach_teacher', lang) });
   652|   652|      }
   653|   653|      audit(supabase, user.id, 'attach_teacher', 'teacher', userId,
   654|   654|        { school_id: prevProfile?.school_id, division_id: prevProfile?.division_id },
   655|   655|        { school_id: schoolId || null, division_id: divisionId || null });
   656|   656|      return res.status(200).json({ ok: true });
   657|   657|    }
   658|   658|
   659|   659|    if (action === 'reassign-teacher') {
   660|   660|      const { userId, schoolId, divisionId } = body;
   661|   661|      if (!userId) return res.status(400).json({ error: apiMessage('userId_required', lang) });
   662|   662|
   663|   663|      const { data: prevProfile } = await supabase
   664|   664|        .from('profiles').select('school_id, division_id').eq('id', userId).single();
   665|   665|
   666|   666|      const { error } = await supabase
   667|   667|        .from('profiles')
   668|   668|        .update({
   669|   669|          school_id:   schoolId   === undefined ? prevProfile?.school_id   : (schoolId   || null),
   670|   670|          division_id: divisionId === undefined ? prevProfile?.division_id : (divisionId || null),
   671|   671|        })
   672|   672|        .eq('id', userId);
   673|   673|      if (error) {
   674|   674|        console.error('reassign-teacher failed:', error.message);
   675|   675|        return res.status(500).json({ error: apiMessage('could_not_reassign_teacher', lang) });
   676|   676|      }
   677|   677|
   678|   678|      // Fetch names for the notification email
   679|   679|      let newSchoolName = null, newDivName = null;
   680|   680|      if (schoolId) {
   681|   681|        const { data: s } = await supabase.from('schools').select('name').eq('id', schoolId).single();
   682|   682|        newSchoolName = s?.name || null;
   683|   683|      }
   684|   684|      if (divisionId) {
   685|   685|        const { data: d } = await supabase.from('divisions').select('name').eq('id', divisionId).single();
   686|   686|        newDivName = d?.name || null;
   687|   687|      }
   688|   688|
   689|   689|      // Notify the teacher — fire-and-forget
   690|   690|      const { data: authUser } = await supabase.auth.admin.getUserById(userId);
   691|   691|      const teacherEmail = authUser?.user?.email;
   692|   692|      if (teacherEmail) {
   693|   693|        sendReassignmentEmail(teacherEmail, newSchoolName, newDivName, lang).catch(err =>
   694|   694|          console.error('reassignment email failed:', err.message)
   695|   695|        );
   696|   696|      }
   697|   697|
   698|   698|      audit(supabase, user.id, 'reassign_teacher', 'teacher', userId,
   699|   699|        { school_id: prevProfile?.school_id, division_id: prevProfile?.division_id },
   700|   700|        { school_id: schoolId === undefined ? prevProfile?.school_id : (schoolId || null),
   701|   701|          division_id: divisionId === undefined ? prevProfile?.division_id : (divisionId || null) });
   702|   702|      return res.status(200).json({ ok: true });
   703|   703|    }
   704|   704|
   705|   705|    if (action === 'create-division') {
   706|   706|      const { name, enrolmentBand, adminEmail, tier } = body;
   707|   707|      if (!name) return res.status(400).json({ error: apiMessage('name_required', lang) });
   708|   708|      const { data, error } = await supabase
   709|   709|        .from('divisions')
   710|   710|        .insert({ name, enrolment_band: enrolmentBand || null, admin_email: adminEmail || null, tier: tier || 'free' })
   711|   711|        .select()
   712|   712|        .single();
   713|   713|      if (error) {
   714|   714|        console.error('create-division failed:', error.message);
   715|   715|        return res.status(500).json({ error: apiMessage('could_not_create_division', lang) });
   716|   716|      }
   717|   717|      return res.status(200).json(data);
   718|   718|    }
   719|   719|
   720|   720|    if (action === 'create-school') {
   721|   721|      const { name, divisionId, adminEmail, tier } = body;
   722|   722|      if (!name) return res.status(400).json({ error: apiMessage('name_required', lang) });
   723|   723|      const { data, error } = await supabase
   724|   724|        .from('schools')
   725|   725|        .insert({ name, division_id: divisionId || null, admin_email: adminEmail || null, tier: tier || 'free' })
   726|   726|        .select()
   727|   727|        .single();
   728|   728|      if (error) {
   729|   729|        console.error('create-school failed:', error.message);
   730|   730|        return res.status(500).json({ error: apiMessage('could_not_create_school', lang) });
   731|   731|      }
   732|   732|      return res.status(200).json(data);
   733|   733|    }
   734|   734|
   735|   735|    if (action === 'approve-request') {
   736|   736|      const { requestId, schoolId, divisionId } = body;
   737|   737|      if (!requestId) return res.status(400).json({ error: apiMessage('requestId_required', lang) });
   738|   738|
   739|   739|      const { data: req, error: reqErr } = await supabase
   740|   740|        .from('teacher_requests').select('email, teacher_id, request_type').eq('id', requestId).single();
   741|   741|      if (reqErr || !req) return res.status(404).json({ error: apiMessage('request_not_found', lang) });
   742|   742|
   743|   743|      // In-app request from an existing teacher — update profile directly
   744|   744|      if (req.teacher_id) {
   745|   745|        const updatePayload = {};
   746|   746|        const newExpires = new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toISOString();
   747|   747|
   748|   748|        if (req.request_type === 'premium_trial') {
   749|   749|          updatePayload.tier = 'premium';
   750|   750|          updatePayload.expires_at = newExpires;
   751|   751|        } else if (req.request_type === 'school_plan') {
   752|   752|          updatePayload.school_id = schoolId || null;
   753|   753|        } else if (req.request_type === 'division_plan') {
   754|   754|          updatePayload.division_id = divisionId || null;
   755|   755|        }
   756|   756|
   757|   757|        const { error: updErr } = await supabase
   758|   758|          .from('profiles').update(updatePayload).eq('id', req.teacher_id);
   759|   759|        if (updErr) {
   760|   760|          console.error('approve-request profile update failed:', updErr.message);
   761|   761|          return res.status(500).json({ error: apiMessage('could_not_update_profile', lang) });
   762|   762|        }
   763|   763|
   764|   764|        await supabase.from('teacher_requests').update({
   765|   765|          status:      'approved',
   766|   766|          reviewed_at: new Date().toISOString(),
   767|   767|          reviewed_by: user.id,
   768|   768|        }).eq('id', requestId);
   769|   769|
   770|   770|        audit(supabase, user.id, 'approve_request', 'teacher_request', requestId, null,
   771|   771|          { email: req.email, teacher_id: req.teacher_id, request_type: req.request_type });
   772|   772|
   773|   773|        return res.status(200).json({ ok: true });
   774|   774|      }
   775|   775|
   776|   776|      // External access request — create invitation (existing behaviour)
   777|   777|      const { data: invite, error: invErr } = await supabase
   778|   778|        .from('invitations')
   779|   779|        .insert({
   780|   780|          email:       req.email,
   781|   781|          role:        'teacher',
   782|   782|          school_id:   schoolId   || null,
   783|   783|          division_id: divisionId || null,
   784|   784|        })
   785|   785|        .select('id, token')
   786|   786|        .single();
   787|   787|      if (invErr) return res.status(500).json({ error: apiMessage('serverError', lang) });
   788|   788|
   789|   789|      // Mark request approved
   790|   790|      await supabase.from('teacher_requests').update({
   791|   791|        status:      'approved',
   792|   792|        reviewed_at: new Date().toISOString(),
   793|   793|        reviewed_by: user.id,
   794|   794|      }).eq('id', requestId);
   795|   795|
   796|   796|      audit(supabase, user.id, 'approve_request', 'teacher_request', requestId, null, { email: req.email });
   797|   797|
   798|   798|      const inviteUrl = `https://app.audioproctor.com/accept-invite.html?token=***
   799|   799|
   800|   800|      // Send invitation email
   801|   801|      let emailOk = true;
   802|   802|      let emailError = null;
   803|   803|      try {
   804|   804|        const { subject, text, html } = buildInviteEmail({ role: 'teacher', inviteUrl, lang });
   805|   805|        const emailResult = await sendEmail({ to: req.email, subject, text, html });
   806|   806|        if (!emailResult.ok) {
   807|   807|          emailOk = false;
   808|   808|          emailError = emailResult.error;
   809|   809|        }
   810|   810|      } catch (err) {
   811|   811|        emailOk = false;
   812|   812|        emailError = err.message;
   813|   813|      }
   814|   814|
   815|   815|      logInviteEmail(supabase, invite.id, 'approve_request', emailOk, emailError);
   816|   816|
   817|   817|      return res.status(200).json({ ok: true, inviteUrl, token: invite.token, emailOk, emailError });
   818|   818|    }
   819|   819|
   820|   820|    if (action === 'invite') {
   821|   821|      const { email, role, schoolId, divisionId } = body;
   822|   822|      if (!email) return res.status(400).json({ error: apiMessage('missingParam', lang, { param: 'email' }) });
   823|   823|      if (!role) return res.status(400).json({ error: apiMessage('missingParam', lang, { param: 'role' }) });
   824|   824|
   825|   825|      const { data: invite, error: invErr } = await supabase
   826|   826|        .from('invitations')
   827|   827|        .insert({
   828|   828|          email,
   829|   829|          role,
   830|   830|          school_id:   schoolId   || null,
   831|   831|          division_id: divisionId || null,
   832|   832|        })
   833|   833|        .select('id, token')
   834|   834|        .single();
   835|   835|      if (invErr) return res.status(500).json({ error: apiMessage('serverError', lang) });
   836|   836|
   837|   837|      const inviteUrl = `https://app.audioproctor.com/accept-invite.html?token=***
   838|   838|
   839|   839|      let emailOk = true;
   840|   840|      let emailError = null;
   841|   841|      try {
   842|   842|        const { subject, text, html } = buildInviteEmail({ role, inviteUrl, lang });
   843|   843|        const emailResult = await sendEmail({ to: email, subject, text, html });
   844|   844|        if (!emailResult.ok) {
   845|   845|          emailOk = false;
   846|   846|          emailError = emailResult.error;
   847|   847|        }
   848|   848|      } catch (err) {
   849|   849|        emailOk = false;
   850|   850|        emailError = err.message;
   851|   851|      }
   852|   852|
   853|   853|      logInviteEmail(supabase, invite.id, 'invite', emailOk, emailError);
   854|   854|
   855|   855|      audit(supabase, user.id, 'invite', 'invitation', invite.token, null, { email, role, emailOk });
   856|   856|
   857|   857|      return res.status(200).json({ ok: true, inviteUrl, token: invite.token, emailOk, emailError });
   858|   858|    }
   859|   859|
   860|   860|    if (action === 'resend-invite') {
   861|   861|      const { invitationId } = body;
   862|   862|      if (!invitationId) return res.status(400).json({ error: apiMessage('missingParam', lang, { param: 'invitationId' }) });
   863|   863|
   864|   864|      const { data: invite, error: fetchErr } = await supabase
   865|   865|        .from('invitations')
   866|   866|        .select('id, email, role, school_id, division_id, token, accepted_at, schools(name), divisions(name)')
   867|   867|        .eq('id', invitationId)
   868|   868|        .single();
   869|   869|
   870|   870|      if (fetchErr || !invite) return res.status(404).json({ error: apiMessage('not_found', lang) });
   871|   871|      if (invite.accepted_at) return res.status(400).json({ error: apiMessage('bad_request', lang) });
   872|   872|
   873|   873|      const newExpires = new Date(Date.now() + 7 * 24 * 60 * 60 * 1000).toISOString();
   874|   874|      const { error: updateErr } = await supabase
   875|   875|        .from('invitations')
   876|   876|        .update({ expires_at: newExpires })
   877|   877|        .eq('id', invitationId);
   878|   878|
   879|   879|      if (updateErr) {
   880|   880|        console.error('resend-invite update failed:', updateErr.message);
   881|   881|        return res.status(500).json({ error: apiMessage('serverError', lang) });
   882|   882|      }
   883|   883|
   884|   884|      const inviteUrl = `https://app.audioproctor.com/accept-invite.html?token=***
   885|   885|      let emailOk = true;
   886|   886|      let emailError = null;
   887|   887|      try {
   888|   888|        const orgName = invite.schools?.name || invite.divisions?.name || null;
   889|   889|        const { subject, text, html } = buildInviteEmail({ role: invite.role, inviteUrl, orgName, lang });
   890|   890|        const emailResult = await sendEmail({ to: invite.email, subject, text, html });
   891|   891|        if (!emailResult.ok) {
   892|   892|          emailOk = false;
   893|   893|          emailError = emailResult.error;
   894|   894|        }
   895|   895|      } catch (err) {
   896|   896|        emailOk = false;
   897|   897|        emailError = err.message;
   898|   898|      }
   899|   899|
   900|   900|      logInviteEmail(supabase, invite.id, 'resend', emailOk, emailError);
   901|   901|
   902|   902|      audit(supabase, user.id, 'resend_invite', 'invitation', invite.token, null, { email: invite.email, role: invite.role, emailOk });
   903|   903|      return res.status(200).json({ ok: true, inviteUrl, emailOk, emailError });
   904|   904|    }
   905|   905|
   906|   906|    if (action === 'reject-request') {
   907|   907|      const { requestId, notes } = body;
   908|   908|      if (!requestId) return res.status(400).json({ error: apiMessage('missingParam', lang, { param: 'requestId' }) });
   909|   909|
   910|   910|      const { error } = await supabase.from('teacher_requests').update({
   911|   911|        status:      'rejected',
   912|   912|        notes:       notes || null,
   913|   913|        reviewed_at: new Date().toISOString(),
   914|   914|        reviewed_by: user.id,
   915|   915|      }).eq('id', requestId);
   916|   916|
   917|   917|      if (error) return res.status(500).json({ error: apiMessage('serverError', lang) });
   918|   918|
   919|   919|      audit(supabase, user.id, 'reject_request', 'teacher_request', requestId, null, { notes: notes || null });
   920|   920|      return res.status(200).json({ ok: true });
   921|   921|    }
   922|   922|
   923|   923|    if (action === 'seed-demo') {
   924|   924|      try {
   925|   925|        const result = await seedDemoData(supabase);
   926|   926|        return res.status(200).json({ ok: true, ...result });
   927|   927|      } catch (err) {
   928|   928|        console.error('seed-demo failed:', err);
   929|   929|        return res.status(500).json({ error: err.message });
   930|   930|      }
   931|   931|    }
   932|   932|
   933|   933|    if (action === 'delete-teacher') {
   934|   934|      const { userId } = body;
   935|   935|      if (!userId) return res.status(400).json({ error: apiMessage('missingParam', lang, { param: 'userId' }) });
   936|   936|      if (userId === user.id) return res.status(400).json({ error: apiMessage('bad_request', lang) });
   937|   937|
   938|   938|      const { data: targetProfile } = await supabase.from('profiles').select('role, display_name').eq('id', userId).single();
   939|   939|      if (!targetProfile) return res.status(404).json({ error: apiMessage('not_found', lang) });
   940|   940|      if (targetProfile.role === 'platform_admin') return res.status(403).json({ error: apiMessage('forbidden', lang) });
   941|   941|
   942|   942|      const { data: uploads } = await supabase.from('uploads').select('storage_path').eq('teacher_id', userId);
   943|   943|      const uniquePaths = [...new Set((uploads || []).map(u => u.storage_path))];
   944|   944|
   945|   945|      if (uniquePaths.length > 0) {
   946|   946|        await supabase.storage.from('audio-files').remove(uniquePaths);
   947|   947|      }
   948|   948|
   949|   949|      const { error: uploadsErr } = await supabase.from('uploads').delete().eq('teacher_id', userId);
   950|   950|      if (uploadsErr) {
   951|   951|        console.error('delete-teacher: uploads delete failed:', uploadsErr.message);
   952|   952|        return res.status(500).json({ error: apiMessage('serverError', lang) });
   953|   953|      }
   954|   954|
   955|   955|      const { error: profileErr } = await supabase.from('profiles').delete().eq('id', userId);
   956|   956|      if (profileErr) {
   957|   957|        console.error('delete-teacher: profile delete failed:', profileErr.message);
   958|   958|        return res.status(500).json({ error: apiMessage('serverError', lang) });
   959|   959|      }
   960|   960|
   961|   961|      audit(supabase, user.id, 'delete_teacher', 'teacher', userId,
   962|   962|        { role: targetProfile.role, display_name: targetProfile.display_name, storage_files: uniquePaths.length }, null);
   963|   963|
   964|   964|      const { error: authErr } = await supabase.auth.admin.deleteUser(userId);
   965|   965|      if (authErr) {
   966|   966|        console.error('delete-teacher: auth delete failed:', authErr.message);
   967|   967|        return res.status(500).json({ error: apiMessage('serverError', lang) });
   968|   968|      }
   969|   969|
   970|   970|      return res.status(200).json({ ok: true });
   971|   971|    }
   972|   972|
   973|   973|    if (action === 'delete-school') {
   974|   974|      const { schoolId } = body;
   975|   975|      if (!schoolId) return res.status(400).json({ error: apiMessage('missingParam', lang, { param: 'schoolId' }) });
   976|   976|
   977|   977|      const { data: school, error: schoolErr } = await supabase.from('schools').select('name').eq('id', schoolId).single();
   978|   978|      if (schoolErr || !school) return res.status(404).json({ error: apiMessage('not_found', lang) });
   979|   979|
   980|   980|      const { count: teacherCount } = await supabase.from('profiles').select('id', { count: 'exact', head: true }).eq('school_id', schoolId);
   981|   981|
   982|   982|      const { error } = await supabase.from('schools').delete().eq('id', schoolId);
   983|   983|      if (error) {
   984|   984|        console.error('delete-school failed:', error.message);
   985|   985|        return res.status(500).json({ error: apiMessage('serverError', lang) });
   986|   986|      }
   987|   987|
   988|   988|      audit(supabase, user.id, 'delete_school', 'school', schoolId,
   989|   989|        { name: school.name, attached_teachers: teacherCount || 0 }, null);
   990|   990|      return res.status(200).json({ ok: true });
   991|   991|    }
   992|   992|
   993|   993|    if (action === 'delete-division') {
   994|   994|      const { divisionId } = body;
   995|   995|      if (!divisionId) return res.status(400).json({ error: apiMessage('missingParam', lang, { param: 'divisionId' }) });
   996|   996|
   997|   997|      const { data: division, error: divErr } = await supabase.from('divisions').select('name').eq('id', divisionId).single();
   998|   998|      if (divErr || !division) return res.status(404).json({ error: apiMessage('not_found', lang) });
   999|   999|
  1000|  1000|      const { count: schoolCount } = await supabase.from('schools').select('id', { count: 'exact', head: true }).eq('division_id', divisionId);
  1001|  1001|      const { count: teacherCount } = await supabase.from('profiles').select('id', { count: 'exact', head: true }).eq('division_id', divisionId);
  1002|  1002|
  1003|  1003|      const { error } = await supabase.from('divisions').delete().eq('id', divisionId);
  1004|  1004|      if (error) {
  1005|  1005|        console.error('delete-division failed:', error.message);
  1006|  1006|        return res.status(500).json({ error: apiMessage('serverError', lang) });
  1007|  1007|      }
  1008|  1008|
  1009|  1009|      audit(supabase, user.id, 'delete_division', 'division', divisionId,
  1010|  1010|        { name: division.name, attached_schools: schoolCount || 0, attached_teachers: teacherCount || 0 }, null);
  1011|  1011|      return res.status(200).json({ ok: true });
  1012|  1012|    }
  1013|  1013|
  1014|  1014|    if (action === 'toggle-deactivation') {
  1015|  1015|      const { userId, deactivated } = body;
  1016|  1016|      if (!userId) return res.status(400).json({ error: apiMessage('missingParam', lang, { param: 'userId' }) });
  1017|  1017|      if (userId === user.id) return res.status(400).json({ error: apiMessage('bad_request', lang) });
  1018|  1018|      if (typeof deactivated !== 'boolean') return res.status(400).json({ error: apiMessage('invalid_param', lang, { param: 'deactivated' }) });
  1019|  1019|
  1020|  1020|      const { data: targetProfile } = await supabase.from('profiles').select('role, is_deactivated, display_name').eq('id', userId).single();
  1021|  1021|      if (!targetProfile) return res.status(404).json({ error: apiMessage('not_found', lang) });
  1022|  1022|      if (targetProfile.role === 'platform_admin') return res.status(403).json({ error: apiMessage('forbidden', lang) });
  1023|  1023|
  1024|  1024|      const { error } = await supabase.from('profiles').update({ is_deactivated: deactivated }).eq('id', userId);
  1025|  1025|      if (error) {
  1026|  1026|        console.error('toggle-deactivation failed:', error.message);
  1027|  1027|        return res.status(500).json({ error: apiMessage('serverError', lang) });
  1028|  1028|      }
  1029|  1029|
  1030|  1030|      audit(supabase, user.id, deactivated ? 'deactivate_teacher' : 'reactivate_teacher', 'teacher', userId,
  1031|  1031|        { is_deactivated: targetProfile.is_deactivated }, { is_deactivated: deactivated });
  1032|  1032|      return res.status(200).json({ ok: true, is_deactivated: deactivated });
  1033|  1033|    }
  1034|  1034|
  1035|  1035|    // ── cancel-subscription ────────────────────────────────────────────
  1036|  1036|    // Platform admin: cancel a school's or division's Stripe subscription
  1037|  1037|    // with proration. Proration creates credit toward the customer's balance,
  1038|  1038|    // which is useful when a school joins a division or an org is restructured.
  1039|  1039|    if (action === 'cancel-subscription') {
  1040|  1040|      const { entityType, entityId } = body;
  1041|  1041|      if (!entityType || !entityId) return res.status(400).json({ error: apiMessage('missingParam', lang, { param: 'entityType and entityId' }) });
  1042|  1042|      if (!['school', 'division'].includes(entityType)) {
  1043|  1043|        return res.status(400).json({ error: apiMessage('invalid_param', lang, { param: 'entityType' }) });
  1044|  1044|      }
  1045|  1045|
  1046|  1046|      let entity;
  1047|  1047|      if (entityType === 'school') {
  1048|  1048|        const { data: school } = await supabase.from('schools').select('id, name, stripe_subscription_id, tier').eq('id', entityId).maybeSingle();
  1049|  1049|        entity = school;
  1050|  1050|      } else {
  1051|  1051|        const { data: division } = await supabase.from('divisions').select('id, name, stripe_subscription_id, tier').eq('id', entityId).maybeSingle();
  1052|  1052|        entity = division;
  1053|  1053|      }
  1054|  1054|
  1055|  1055|      if (!entity) return res.status(404).json({ error: apiMessage('not_found', lang) });
  1056|  1056|      if (!entity.stripe_subscription_id) {
  1057|  1057|        return res.status(400).json({ error: apiMessage('bad_request', lang) });
  1058|  1058|      }
  1059|  1059|
  1060|  1060|      const stripe = Stripe(process.env.STRIPE_SECRET_KEY);
  1061|  1061|      try {
  1062|  1062|        await stripe.subscriptions.update(entity.stripe_subscription_id, {
  1063|  1063|          cancellation_details: { comment: `Canceled by platform admin (${user.id})` },
  1064|  1064|          proration_behavior: 'create_prorations',
  1065|  1065|        });
  1066|  1066|      } catch (err) {
  1067|  1067|        console.error('cancel-subscription stripe failed:', err.message);
  1068|  1068|        return res.status(500).json({ error: apiMessage('stripe_error', lang) });
  1069|  1069|      }
  1070|  1070|
  1071|  1071|      if (entityType === 'school') {
  1072|  1072|        await supabase.from('schools').update({
  1073|  1073|          tier: 'free',
  1074|  1074|          stripe_subscription_id: null,
  1075|  1075|          stripe_subscription_status: 'canceled',
  1076|  1076|          cancelled_at: new Date().toISOString()
  1077|  1077|        }).eq('id', entityId);
  1078|  1078|      } else {
  1079|  1079|        await supabase.from('divisions').update({
  1080|  1080|          tier: 'free',
  1081|  1081|          stripe_subscription_id: null,
  1082|  1082|          stripe_subscription_status: 'canceled',
  1083|  1083|          cancelled_at: new Date().toISOString()
  1084|  1084|        }).eq('id', entityId);
  1085|  1085|      }
  1086|  1086|
  1087|  1087|      audit(supabase, user.id, 'cancel_subscription', entityType, entityId, { tier: entity.tier }, { tier: 'free' });
  1088|  1088|      return res.status(200).json({ ok: true });
  1089|  1089|    }
  1090|  1090|
  1091|  1091|    return res.status(400).json({ error: apiMessage('bad_request', lang) });
  1092|  1092|  }
  1093|  1093|
  1094|  1094|  return res.status(405).json({ error: apiMessage('method_not_allowed', lang) });
  1095|  1095|};
  1096|  1096|
  1097|  1097|// ─── Demo data helpers ────────────────────────────────────────────────────
  1098|  1098|
  1099|  1099|const DEMO_PERSONAS = [
  1100|  1100|  { key: 'marcus',  email: 'm.vance@apsd.net',                    name: 'Marcus Vance',    role: 'division_admin', orgKey: 'div' },
  1101|  1101|  { key: 'elena',   email: 'e.rodriguez@silverwood.apsd.net',      name: 'Elena Rodriguez', role: 'school_admin',   orgKey: 'sil' },
  1102|  1102|  { key: 'julian',  email: 'j.thorne@silverwood.apsd.net',         name: 'Julian Thorne',   role: 'teacher',        orgKey: 'sil' },
  1103|  1103|  { key: 'sarah',   email: 's.jenkins@silverwood.apsd.net',        name: 'Sarah Jenkins',   role: 'teacher',        orgKey: 'sil' },
  1104|  1104|  { key: 'david',   email: 'd.wu@silverwood.apsd.net',             name: 'David Wu',        role: 'teacher',        orgKey: 'sil' },
  1105|  1105|  { key: 'chloe',   email: 'c.simmons@horizoncharter.org',         name: 'Chloe Simmons',   role: 'school_admin',   orgKey: 'hor' },
  1106|  1106|  { key: 'robert',  email: 'r.finch@horizoncharter.org',           name: 'Robert Finch',    role: 'teacher',        orgKey: 'hor' },
  1107|  1107|  { key: 'linda',   email: 'l.grewal@horizoncharter.org',          name: 'Linda Grewal',    role: 'teacher',        orgKey: 'hor' },
  1108|  1108|  { key: 'thomas',  email: 't.beck@horizoncharter.org',            name: 'Thomas Beck',     role: 'teacher',        orgKey: 'hor' },
  1109|  1109|];
  1110|  1110|
  1111|  1111|const DEMO_UPLOAD_SPECS = [
  1112|  1112|  // Julian Thorne — active user, 12 weeks of history
  1113|  1113|  { teacher: 'julian', code: 'THO-001', label: 'ELA 20-1 Oral Reading Component',    exit: 'submit',   fileMb: 8.2,  students: 24, completion: 0.88, replay: 0.15, weeksAgo: 12  },
  1114|  1114|  { teacher: 'julian', code: 'THO-002', label: 'Biology 20 Audio Supplement',         exit: 'done',     fileMb: 5.4,  students: 22, completion: 0.73, replay: 0.25, weeksAgo: 10  },
  1115|  1115|  { teacher: 'julian', code: 'THO-003', label: 'Science 10 Listening Assessment',     exit: 'finished', fileMb: 6.1,  students: 27, completion: 0.92, replay: 0.10, weeksAgo: 8   },
  1116|  1116|  { teacher: 'julian', code: 'THO-004', label: 'Math 20-1 Word Problems Audio',       exit: 'complete', fileMb: 11.3, students: 25, completion: 0.64, replay: 0.38, weeksAgo: 7   },
  1117|  1117|  { teacher: 'julian', code: 'THO-005', label: 'Social Studies 10-1 Audio Guide',     exit: 'exit',     fileMb: 7.8,  students: 23, completion: 0.83, replay: 0.12, weeksAgo: 5   },
  1118|  1118|  { teacher: 'julian', code: 'THO-006', label: 'Chemistry 20 Lab Instructions',       exit: 'submit',   fileMb: 9.5,  students: 20, completion: 0.90, replay: 0.20, weeksAgo: 3   },
  1119|  1119|  { teacher: 'julian', code: 'THO-007', label: 'ELA 30-1 Listening Component',        exit: 'done',     fileMb: 4.9,  students: 19, completion: 0.79, replay: 0.16, weeksAgo: 2   },
  1120|  1120|  { teacher: 'julian', code: 'THO-008', label: 'Physics 20 Audio Assessment',         exit: 'finished', fileMb: 6.7,  students: 21, completion: 0.86, replay: 0.14, weeksAgo: 1   },
  1121|  1121|  // Sarah Jenkins — 9 weeks of history
  1122|  1122|  { teacher: 'sarah',  code: 'JEN-001', label: 'English 10-1 Reading Passage',        exit: 'submit',   fileMb: 5.2,  students: 28, completion: 0.86, replay: 0.11, weeksAgo: 9   },
  1123|  1123|  { teacher: 'sarah',  code: 'JEN-002', label: 'English 20-1 Oral Assessment',        exit: 'done',     fileMb: 7.1,  students: 26, completion: 0.77, replay: 0.19, weeksAgo: 7   },
  1124|  1124|  { teacher: 'sarah',  code: 'JEN-003', label: 'Drama 10 Audio Script',               exit: 'exit',     fileMb: 3.8,  students: 18, completion: 0.94, replay: 0.08, weeksAgo: 5   },
  1125|  1125|  { teacher: 'sarah',  code: 'JEN-004', label: 'English 30-1 Comprehension',          exit: 'complete', fileMb: 8.6,  students: 24, completion: 0.71, replay: 0.27, weeksAgo: 3   },
  1126|  1126|  { teacher: 'sarah',  code: 'JEN-005', label: 'English 10-2 Listening Assessment',   exit: 'submit',   fileMb: 6.3,  students: 30, completion: 0.83, replay: 0.13, weeksAgo: 1   },
  1127|  1127|  // David Wu — 6 weeks of history
  1128|  1128|  { teacher: 'david',  code: 'WUU-001', label: 'Computer Science 20 Lab Audio',       exit: 'done',     fileMb: 4.1,  students: 22, completion: 0.91, replay: 0.09, weeksAgo: 6   },
  1129|  1129|  { teacher: 'david',  code: 'WUU-002', label: 'Math 30-1 Applications Audio',        exit: 'submit',   fileMb: 12.4, students: 19, completion: 0.68, replay: 0.32, weeksAgo: 4   },
  1130|  1130|  { teacher: 'david',  code: 'WUU-003', label: 'Pre-Calculus 20 Word Problems',       exit: 'finished', fileMb: 10.2, students: 25, completion: 0.60, replay: 0.40, weeksAgo: 2   },
  1131|  1131|  { teacher: 'david',  code: 'WUU-004', label: 'Math 20-3 Data Analysis Audio',       exit: 'exit',     fileMb: 5.8,  students: 20, completion: 0.80, replay: 0.20, weeksAgo: 0.5 },
  1132|  1132|  // Robert Finch — 5 weeks
  1133|  1133|  { teacher: 'robert', code: 'FIN-001', label: 'Social Studies 30-1 Audio Guide',     exit: 'submit',   fileMb: 9.3,  students: 20, completion: 0.85, replay: 0.15, weeksAgo: 5   },
  1134|  1134|  { teacher: 'robert', code: 'FIN-002', label: 'History 20 Audio Documentary',        exit: 'done',     fileMb: 15.7, students: 22, completion: 0.77, replay: 0.23, weeksAgo: 4   },
  1135|  1135|  { teacher: 'robert', code: 'FIN-003', label: 'Geography 20 Audio Assessment',       exit: 'complete', fileMb: 7.2,  students: 18, completion: 0.89, replay: 0.11, weeksAgo: 3   },
  1136|  1136|  { teacher: 'robert', code: 'FIN-004', label: 'Social Studies 10-2 Oral',            exit: 'exit',     fileMb: 6.4,  students: 24, completion: 0.75, replay: 0.20, weeksAgo: 2   },
  1137|  1137|  { teacher: 'robert', code: 'FIN-005', label: 'Indigenous Studies 10 Audio',         exit: 'submit',   fileMb: 8.1,  students: 21, completion: 0.90, replay: 0.10, weeksAgo: 1   },
  1138|  1138|  // Linda Grewal — 4 weeks
  1139|  1139|  { teacher: 'linda',  code: 'GRE-001', label: 'Biology 30 Lab Audio Instructions',   exit: 'done',     fileMb: 11.2, students: 16, completion: 0.88, replay: 0.19, weeksAgo: 4   },
  1140|  1140|  { teacher: 'linda',  code: 'GRE-002', label: 'Earth Science 20 Audio Notes',        exit: 'finished', fileMb: 8.5,  students: 20, completion: 0.80, replay: 0.25, weeksAgo: 2   },
  1141|  1141|  { teacher: 'linda',  code: 'GRE-003', label: 'Science 20 Listening Assessment',     exit: 'submit',   fileMb: 6.9,  students: 18, completion: 0.72, replay: 0.22, weeksAgo: 1   },
  1142|  1142|  // Thomas Beck — 2 weeks
  1143|  1143|  { teacher: 'thomas', code: 'BEC-001', label: 'Physical Education 10 Audio',         exit: 'done',     fileMb: 3.2,  students: 28, completion: 0.96, replay: 0.04, weeksAgo: 2   },
  1144|  1144|  { teacher: 'thomas', code: 'BEC-002', label: 'Health 20 Audio Assessment',          exit: 'submit',   fileMb: 5.5,  students: 25, completion: 0.88, replay: 0.12, weeksAgo: 1   },
  1145|  1145|];
  1146|  1146|
  1147|  1147|// SHA-256 hex of str (lowercased + trimmed) — same algo as browser Web Crypto
  1148|  1148|function sha256Hex(str) {
  1149|  1149|  return crypto.createHash('sha256').update(str.toLowerCase().trim()).digest('hex');
  1150|  1150|}
  1151|  1151|
  1152|  1152|// Returns a random ISO timestamp during Alberta school hours (9am–2pm MDT)
  1153|  1153|// on a weekday approximately weeksAgo weeks in the past (±2 days jitter).
  1154|  1154|function schoolTime(weeksAgo) {
  1155|  1155|  const jitter = (Math.random() - 0.5) * 4 * 24 * 60 * 60 * 1000;
  1156|  1156|  let d = new Date(Date.now() - weeksAgo * 7 * 24 * 60 * 60 * 1000 + jitter);
  1157|  1157|  while (d.getUTCDay() === 0 || d.getUTCDay() === 6) {
  1158|  1158|    d = new Date(d.getTime() + 24 * 60 * 60 * 1000);
  1159|  1159|  }
  1160|  1160|  // 9am–2pm MDT = UTC−6 → 15:00–20:00 UTC
  1161|  1161|  d.setUTCHours(15 + Math.floor(Math.random() * 5), Math.floor(Math.random() * 60), 0, 0);
  1162|  1162|  return d.toISOString();
  1163|  1163|}
  1164|  1164|
  1165|  1165|async function seedDemoData(supabase) {
  1166|  1166|  const report = { usersCreated: 0, usersFound: 0, uploads: 0, events: 0 };
  1167|  1167|
  1168|  1168|  // 1. Resolve or create all auth users
  1169|  1169|  const emailMap = await getAllUserEmails(supabase);
  1170|  1170|  const byEmail = {};
  1171|  1171|  Object.entries(emailMap).forEach(([id, email]) => { byEmail[email] = id; });
  1172|  1172|
  1173|  1173|  const userId = {}; // personaKey → uuid
  1174|  1174|  for (const p of DEMO_PERSONAS) {
  1175|  1175|    if (byEmail[p.email]) {
  1176|  1176|      userId[p.key] = byEmail[p.email];
  1177|  1177|      report.usersFound++;
  1178|  1178|    } else {
  1179|  1179|      const { data: created, error } = await supabase.auth.admin.createUser({
  1180|  1180|        email: p.email,
  1181|  1181|        email_confirm: true,
  1182|  1182|        user_metadata: { full_name: p.name },
  1183|  1183|      });
  1184|  1184|      if (error) throw new Error(`createUser ${p.email}: ${error.message}`);
  1185|  1185|      userId[p.key] = created.user.id;
  1186|  1186|      report.usersCreated++;
  1187|  1187|    }
  1188|  1188|  }
  1189|  1189|
  1190|  1190|  // 2. Find or create division
  1191|  1191|  let divisionId;
  1192|  1192|  const { data: existingDiv } = await supabase
  1193|  1193|    .from('divisions').select('id').eq('name', 'Aspen Peaks School Division').maybeSingle();
  1194|  1194|  if (existingDiv) {
  1195|  1195|    divisionId = existingDiv.id;
  1196|  1196|  } else {
  1197|  1197|    const { data: newDiv, error } = await supabase
  1198|  1198|      .from('divisions')
  1199|  1199|      .insert({ name: 'Aspen Peaks School Division', tier: 'division', admin_email: 'm.vance@apsd.net', enrolment_band: 'medium' })
  1200|  1200|      .select('id').single();
  1201|  1201|    if (error) throw new Error('create division: ' + error.message);
  1202|  1202|    divisionId = newDiv.id;
  1203|  1203|  }
  1204|  1204|
  1205|  1205|  // 3. Find or create schools
  1206|  1206|  let silverwoodId, horizonId;
  1207|  1207|  const { data: existingSil } = await supabase
  1208|  1208|    .from('schools').select('id').eq('name', 'Silverwood High').maybeSingle();
  1209|  1209|  if (existingSil) {
  1210|  1210|    silverwoodId = existingSil.id;
  1211|  1211|  } else {
  1212|  1212|    const { data: newSil, error } = await supabase
  1213|  1213|      .from('schools')
  1214|  1214|      .insert({ name: 'Silverwood High', division_id: divisionId, tier: 'division', admin_email: 'e.rodriguez@silverwood.apsd.net' })
  1215|  1215|      .select('id').single();
  1216|  1216|    if (error) throw new Error('create Silverwood High: ' + error.message);
  1217|  1217|    silverwoodId = newSil.id;
  1218|  1218|  }
  1219|  1219|  const { data: existingHor } = await supabase
  1220|  1220|    .from('schools').select('id').eq('name', 'Horizon Charter Academy').maybeSingle();
  1221|  1221|  if (existingHor) {
  1222|  1222|    horizonId = existingHor.id;
  1223|  1223|  } else {
  1224|  1224|    const { data: newHor, error } = await supabase
  1225|  1225|      .from('schools')
  1226|  1226|      .insert({ name: 'Horizon Charter Academy', tier: 'school', admin_email: 'c.simmons@horizoncharter.org' })
  1227|  1227|      .select('id').single();
  1228|  1228|    if (error) throw new Error('create Horizon Charter: ' + error.message);
  1229|  1229|    horizonId = newHor.id;
  1230|  1230|  }
  1231|  1231|
  1232|  1232|  const schoolIds = { sil: silverwoodId, hor: horizonId };
  1233|  1233|
  1234|  1234|  // 4. Upsert profiles
  1235|  1235|  const profileRows = DEMO_PERSONAS.map(p => ({
  1236|  1236|    id:              userId[p.key],
  1237|  1237|    display_name:    p.name,
  1238|  1238|    role:            p.role,
  1239|  1239|    school_id:       p.orgKey === 'div' ? null : schoolIds[p.orgKey],
  1240|  1240|    division_id:     p.orgKey === 'div' ? divisionId : null,
  1241|  1241|    tier:            'free',
  1242|  1242|    country_code:    'CA',
  1243|  1243|    storage_used_mb: 0,
  1244|  1244|  }));
  1245|  1245|  const { error: profileErr } = await supabase.from('profiles').upsert(profileRows, { onConflict: 'id' });
  1246|  1246|  if (profileErr) throw new Error('upsert profiles: ' + profileErr.message);
  1247|  1247|
  1248|  1248|  // 5. Remove existing demo uploads and their events (idempotent)
  1249|  1249|  const demoCodes = DEMO_UPLOAD_SPECS.map(s => s.code);
  1250|  1250|  const { data: oldUploads } = await supabase.from('uploads').select('id').in('access_code', demoCodes);
  1251|  1251|  if (oldUploads?.length) {
  1252|  1252|    const oldIds = oldUploads.map(u => u.id);
  1253|  1253|    await supabase.from('session_events').delete().in('upload_id', oldIds);
  1254|  1254|    await supabase.from('uploads').delete().in('id', oldIds);
  1255|  1255|  }
  1256|  1256|
  1257|  1257|  // 6. Insert uploads
  1258|  1258|  const expiresAt = new Date(Date.now() + 180 * 24 * 60 * 60 * 1000).toISOString();
  1259|  1259|  const uploadRows = DEMO_UPLOAD_SPECS.map(spec => ({
  1260|  1260|    teacher_id:      userId[spec.teacher],
  1261|  1261|    filename:        spec.code.replace('-', '').toLowerCase() + '.mp3',
  1262|  1262|    label:           spec.label,
  1263|  1263|    storage_path:    `demo/${spec.code.replace('-', '').toLowerCase()}.mp3`,
  1264|  1264|    access_code:     spec.code,
  1265|  1265|    exit_word:       spec.exit,
  1266|  1266|    exit_word_hash:  sha256Hex(spec.exit),
  1267|  1267|    expires_at:      expiresAt,
  1268|  1268|    file_size_mb:    spec.fileMb,
  1269|  1269|    created_at:      schoolTime(spec.weeksAgo + 0.5),
  1270|  1270|  }));
  1271|  1271|  const { data: insertedUploads, error: uploadErr } = await supabase
  1272|  1272|    .from('uploads').insert(uploadRows).select('id, access_code');
  1273|  1273|  if (uploadErr) throw new Error('insert uploads: ' + uploadErr.message);
  1274|  1274|  report.uploads = insertedUploads.length;
  1275|  1275|
  1276|  1276|  const uploadIdByCode = {};
  1277|  1277|  insertedUploads.forEach(u => { uploadIdByCode[u.access_code] = u.id; });
  1278|  1278|
  1279|  1279|  // Update storage_used_mb on each teacher's profile
  1280|  1280|  const storageMb = {};
  1281|  1281|  DEMO_UPLOAD_SPECS.forEach(s => { storageMb[s.teacher] = (storageMb[s.teacher] || 0) + s.fileMb; });
  1282|  1282|  for (const [key, mb] of Object.entries(storageMb)) {
  1283|  1283|    await supabase.from('profiles').update({ storage_used_mb: Math.round(mb * 10) / 10 }).eq('id', userId[key]);
  1284|  1284|  }
  1285|  1285|
  1286|  1286|  // 7. Generate session events
  1287|  1287|  const allEvents = [];
  1288|  1288|  for (const spec of DEMO_UPLOAD_SPECS) {
  1289|  1289|    const uploadId = uploadIdByCode[spec.code];
  1290|  1290|    const audioSecs = Math.round(spec.fileMb * 55); // ~1MB/min at 128kbps
  1291|  1291|
  1292|  1292|    for (let i = 0; i < spec.students; i++) {
  1293|  1293|      const base = new Date(schoolTime(spec.weeksAgo - Math.random() * 0.4));
  1294|  1294|
  1295|  1295|      allEvents.push({ upload_id: uploadId, event_type: 'code_entered', occurred_at: base.toISOString() });
  1296|  1296|
  1297|  1297|      const playDelay = 15 + Math.random() * 20;
  1298|  1298|      const playMs = base.getTime() + playDelay * 1000;
  1299|  1299|      allEvents.push({ upload_id: uploadId, event_type: 'playback_started',
  1300|  1300|        occurred_at: new Date(playMs).toISOString(), metadata: { position_seconds: 0 } });
  1301|  1301|
  1302|  1302|      // Maybe pause/resume (28% of students)
  1303|  1303|      if (Math.random() < 0.28) {
  1304|  1304|        const pausePos = Math.floor(audioSecs * (0.25 + Math.random() * 0.5));
  1305|  1305|        allEvents.push({ upload_id: uploadId, event_type: 'playback_paused',
  1306|  1306|          occurred_at: new Date(playMs + pausePos * 1000).toISOString(),
  1307|  1307|          metadata: { position_seconds: pausePos } });
  1308|  1308|        allEvents.push({ upload_id: uploadId, event_type: 'playback_resumed',
  1309|  1309|          occurred_at: new Date(playMs + pausePos * 1000 + (12 + Math.random() * 20) * 1000).toISOString(),
  1310|  1310|          metadata: { position_seconds: pausePos } });
  1311|  1311|      }
  1312|  1312|
  1313|  1313|      // Maybe replay
  1314|  1314|      if (Math.random() < spec.replay) {
  1315|  1315|        const replayPos = Math.floor(audioSecs * (0.45 + Math.random() * 0.35));
  1316|  1316|        allEvents.push({ upload_id: uploadId, event_type: 'replay_triggered',
  1317|  1317|          occurred_at: new Date(playMs + replayPos * 1000).toISOString(),
  1318|  1318|          metadata: { position_seconds: replayPos } });
  1319|  1319|      }
  1320|  1320|
  1321|  1321|      // Completion
  1322|  1322|      if (Math.random() < spec.completion) {
  1323|  1323|        allEvents.push({ upload_id: uploadId, event_type: 'playback_completed',
  1324|  1324|          occurred_at: new Date(playMs + audioSecs * 1000).toISOString(),
  1325|  1325|          metadata: { position_seconds: audioSecs } });
  1326|  1326|        allEvents.push({ upload_id: uploadId, event_type: 'exit_word_used',
  1327|  1327|          occurred_at: new Date(playMs + audioSecs * 1000 + (8 + Math.random() * 45) * 1000).toISOString() });
  1328|  1328|      }
  1329|  1329|    }
  1330|  1330|  }
  1331|  1331|
  1332|  1332|  // Bulk-insert in chunks of 500
  1333|  1333|  for (let i = 0; i < allEvents.length; i += 500) {
  1334|  1334|    const { error: evErr } = await supabase.from('session_events').insert(allEvents.slice(i, i + 500));
  1335|  1335|    if (evErr) throw new Error(`session_events chunk ${i}: ${evErr.message}`);
  1336|  1336|  }
  1337|  1337|  report.events = allEvents.length;
  1338|  1338|
  1339|  1339|  // 8. Refresh materialized view immediately (requires migration 010)
  1340|  1340|  const { error: refreshErr } = await supabase.rpc('refresh_upload_summaries');
  1341|  1341|  if (refreshErr) console.warn('refresh_upload_summaries rpc failed:', refreshErr.message);
  1342|  1342|
  1343|  1343|  // 9. Seed fake requests and invitations for dev testing
  1344|  1344|  // Clean old seed data first
  1345|  1345|  await supabase.from('teacher_requests').delete().ilike('email', 'seed-%@example.com');
  1346|  1346|  await supabase.from('invitations').delete().ilike('email', 'seed-%@example.com');
  1347|  1347|
  1348|  1348|  const { error: reqErr } = await supabase.from('teacher_requests').insert([
  1349|  1349|    { name: 'Alice Tremblay', email: 'seed-alice@example.com', school: 'École Secondaire Laurier', division: 'FrancoSud', message: 'Requesting premium trial for oral reading assessments.', status: 'pending', request_type: 'premium_trial', created_at: new Date(Date.now() - 2 * 24 * 60 * 60 * 1000).toISOString() },
  1350|  1350|    { name: 'Bob Singh', email: 'seed-bob@example.com', school: 'William Aberhart High', division: 'Calgary Board of Education', message: 'School plan pilot request.', status: 'pending', request_type: 'school_plan', created_at: new Date(Date.now() - 5 * 24 * 60 * 60 * 1000).toISOString() },
  1351|  1351|    { name: 'Carla Nguyen', email: 'seed-carla@example.com', school: 'Ross Sheppard High', division: 'Edmonton Public Schools', status: 'pending', request_type: 'access', created_at: new Date(Date.now() - 1 * 24 * 60 * 60 * 1000).toISOString() },
  1352|  1352|    { name: 'David Okafor', email: 'seed-david@example.com', school: 'Lester B. Pearson High', division: 'Calgary Board of Education', message: 'Already approved.', status: 'approved', request_type: 'premium_trial', created_at: new Date(Date.now() - 10 * 24 * 60 * 60 * 1000).toISOString() },
  1353|  1353|    { name: 'Emma Larsson', email: 'seed-emma@example.com', school: 'Queen Elizabeth High', message: 'Rejected earlier.', status: 'rejected', request_type: 'premium_trial', created_at: new Date(Date.now() - 14 * 24 * 60 * 60 * 1000).toISOString() },
  1354|  1354|    { name: 'Frank Deluca', email: 'seed-frank@example.com', school: 'Bishop Carroll High', division: 'Calgary Catholic School District', message: 'Division-wide interest.', status: 'pending', request_type: 'division_plan', created_at: new Date(Date.now() - 3 * 24 * 60 * 60 * 1000).toISOString() },
  1355|  1355|  ]);
  1356|  1356|  if (reqErr) console.warn('seed demo requests failed:', reqErr.message);
  1357|  1357|
  1358|  1358|  const [{ data: aDiv }, { data: aSchool }] = await Promise.all([
  1359|  1359|    supabase.from('divisions').select('id').limit(1).maybeSingle(),
  1360|  1360|    supabase.from('schools').select('id').limit(1).maybeSingle(),
  1361|  1361|  ]);
  1362|  1362|  const { error: invErr } = await supabase.from('invitations').insert([
  1363|  1363|    { email: 'seed-invite-1@example.com', role: 'teacher', expires_at: new Date(Date.now() + 5 * 24 * 60 * 60 * 1000).toISOString() },
  1364|  1364|    { email: 'seed-invite-2@example.com', role: 'school_admin', school_id: aSchool?.id || null, expires_at: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000).toISOString() },
  1365|  1365|    { email: 'seed-invite-3@example.com', role: 'teacher', division_id: aDiv?.id || null, expires_at: new Date(Date.now() - 3 * 24 * 60 * 60 * 1000).toISOString() },
  1366|  1366|    { email: 'seed-invite-4@example.com', role: 'teacher', expires_at: new Date(Date.now() + 1 * 24 * 60 * 60 * 1000).toISOString() },
  1367|  1367|  ]);
  1368|  1368|  if (invErr) console.warn('seed demo invitations failed:', invErr.message);
  1369|  1369|
  1370|  1370|  return report;
  1371|  1371|}
  1372|  1372|
  1373|  1373|// ─── Audit log helper ─────────────────────────────────────────────────────
  1374|  1374|// Fire-and-forget — never fails the request that triggered it.
  1375|  1375|
  1376|  1376|function audit(supabase, actorId, action, targetType, targetId, before, after) {
  1377|  1377|  supabase.from('admin_audit_log').insert({
  1378|  1378|    actor_id:    actorId,
  1379|  1379|    action,
  1380|  1380|    target_type: targetType,
  1381|  1381|    target_id:   targetId,
  1382|  1382|    before_value: before ?? null,
  1383|  1383|    after_value:  after  ?? null,
  1384|  1384|  }).then(({ error }) => {
  1385|  1385|    if (error) console.error('audit log insert failed:', error.message);
  1386|  1386|  });
  1387|  1387|}
  1388|  1388|
  1389|  1389|function logInviteEmail(supabase, invitationId, action, emailOk, errorMessage) {
  1390|  1390|  supabase.from('invite_email_log').insert({
  1391|  1391|    invitation_id: invitationId ?? null,
  1392|  1392|    action,
  1393|  1393|    email_ok:      emailOk ?? null,
  1394|  1394|    error_message: errorMessage ?? null,
  1395|  1395|  }).then(({ error }) => {
  1396|  1396|    if (error) console.error('invite email log insert failed:', error.message);
  1397|  1397|  });
  1398|  1398|}
  1399|  1399|
  1400|  1400|// ─── Email helper: teacher reassignment ───────────────────────────────────
  1401|  1401|// Notifies a teacher that they have been assigned to a new school/division.
  1402|  1402|// Names the specific organization(s) to reduce confusion.
  1403|  1403|
  1404|  1404|async function sendReassignmentEmail(teacherEmail, schoolName, divisionName, lang) {
  1405|  1405|  const { Resend } = require('resend');
  1406|  1406|  const resend = new Resend(process.env.RESEND_API_KEY);
  1407|  1407|
  1408|  1408|  const isFr = lang === 'fr';
  1409|  1409|
  1410|  1410|  let orgText = '';
  1411|  1411|  if (schoolName && divisionName) {
  1412|  1412|    orgText = isFr ? `${schoolName}, ${divisionName}` : `${schoolName}, ${divisionName}`;
  1413|  1413|  } else if (schoolName) {
  1414|  1414|    orgText = schoolName;
  1415|  1415|  } else if (divisionName) {
  1416|  1416|    orgText = divisionName;
  1417|  1417|  } else {
  1418|  1418|    orgText = isFr ? 'aucune organisation (non rattaché)' : 'no organization (unattached)';
  1419|  1419|  }
  1420|  1420|
  1421|  1421|  await resend.emails.send({
  1422|  1422|    from:    'AudioProctor <hello@audioproctor.com>',
  1423|  1423|    to:      teacherEmail,
  1424|  1424|    subject: isFr ? 'Votre organisation AudioProctor a été modifiée' : 'Your AudioProctor organization has changed',
  1425|  1425|    text: isFr
  1426|  1426|      ? [
  1427|  1427|          `Bonjour,`,
  1428|  1428|          ``,
  1429|  1429|          `Votre compte a été réaffecté à ${orgText} sur AudioProctor.`,
  1430|  1430|          ``,
  1431|  1431|          `Votre compte et toutes vos évaluations téléversées sont toujours intacts. Votre forfait`,
  1432|  1432|          `peut avoir changé en fonction de l'organisation à laquelle vous appartenez désormais.`,
  1433|  1433|          ``,
  1434|  1434|          `Si vous pensez qu'il s'agit d'une erreur, veuillez contacter votre administrateur`,
  1435|  1435|          `ou répondre à ce courriel.`,
  1436|  1436|          ``,
  1437|  1437|          `— L'équipe AudioProctor`,
  1438|  1438|        ].join('\n')
  1439|  1439|      : [
  1440|  1440|          `Hi,`,
  1441|  1441|          ``,
  1442|  1442|          `Your account has been reassigned to ${orgText} on AudioProctor.`,
  1443|  1443|          ``,
  1444|  1444|          `Your account and all of your uploaded assessments are still intact. Your plan tier`,
  1445|  1445|          `may have changed based on the organization you are now part of.`,
  1446|  1446|          ``,
  1447|  1447|          `If you believe this was done in error, please contact your administrator`,
  1448|  1448|          `or reply to this email.`,
  1449|  1449|          ``,
  1450|  1450|          `— AudioProctor`,
  1451|  1451|        ].join('\n'),
  1452|  1452|  });
  1453|  1453|}
  1454|  1454|
  1455|  1455|// ─── Paginated user email fetch ───────────────────────────────────────────
  1456|  1456|// Supabase admin.listUsers has a maximum perPage of 1000. This function
  1457|  1457|// paginates through all pages and returns a map of { userId: email }.
  1458|  1458|
  1459|  1459|async function getAllUserEmails(supabase) {
  1460|  1460|  const emailMap = {};
  1461|  1461|  let page = 1;
  1462|  1462|  const perPage = 1000;
  1463|  1463|
  1464|  1464|  while (true) {
  1465|  1465|    const { data, error } = await supabase.auth.admin.listUsers({ page, perPage });
  1466|  1466|    if (error || !data?.users?.length) break;
  1467|  1467|    data.users.forEach(u => { emailMap[u.id] = u.email; });
  1468|  1468|    if (data.users.length < perPage) break; // last page
  1469|  1469|    page++;
  1470|  1470|  }
  1471|  1471|
  1472|  1472|  return emailMap;
  1473|  1473|}
  1474|  1474|