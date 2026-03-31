// ─── /api/org ─────────────────────────────────────────────────────────────
// Vercel serverless function for School Admin and Division Admin operations.
// Requires role = 'school_admin', 'division_admin', or 'platform_admin'.
//
// Routes (via ?action= query param):
//
//   GET  ?action=school-teachers          — list teachers in caller's school
//   GET  ?action=school-report            — school-wide usage summary
//   GET  ?action=school-detail&schoolId=  — teacher list for a specific school (division admin)
//   GET  ?action=division-schools         — list schools in caller's division with stats
//   GET  ?action=division-report          — division-wide usage summary
//   GET  ?action=division-activity        — weekly session counts for assessment window chart
//   POST ?action=detach-teacher           — body: { userId } — remove teacher from school
//   POST ?action=detach-school            — body: { schoolId } — remove school from division
//   POST ?action=remove-school-admin      — body: { userId } — revert school_admin role to teacher

const { createClient } = require('@supabase/supabase-js');

module.exports = async (req, res) => {
  res.setHeader('Access-Control-Allow-Origin',  'https://app.audioproctor.com');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  if (req.method === 'OPTIONS') return res.status(200).end();

  // ─── Auth ──────────────────────────────────────────────────────────────
  const authHeader = req.headers['authorization'] || '';
  const jwt = authHeader.startsWith('Bearer ') ? authHeader.slice(7) : null;
  if (!jwt) return res.status(401).json({ error: 'Missing authorization' });

  const anonClient = createClient(
    process.env.SUPABASE_URL,
    process.env.SUPABASE_ANON_KEY,
    { global: { headers: { Authorization: `Bearer ${jwt}` } } }
  );

  const { data: { user }, error: authErr } = await anonClient.auth.getUser();
  if (authErr || !user) return res.status(401).json({ error: 'Invalid token' });

  const supabase = createClient(
    process.env.SUPABASE_URL,
    process.env.SUPABASE_SERVICE_ROLE_KEY
  );

  const { data: profile, error: profileErr } = await supabase
    .from('profiles')
    .select('role, school_id, division_id')
    .eq('id', user.id)
    .single();

  if (profileErr || !profile) return res.status(403).json({ error: 'Forbidden' });

  const ALLOWED_ROLES = ['school_admin', 'division_admin', 'platform_admin'];
  if (!ALLOWED_ROLES.includes(profile.role)) {
    return res.status(403).json({ error: 'Forbidden' });
  }

  const isSchoolAdmin    = ['school_admin',   'platform_admin'].includes(profile.role);
  const isDivisionAdmin  = ['division_admin', 'platform_admin'].includes(profile.role);
  const action           = req.query.action;

  // ─── Shared helpers ────────────────────────────────────────────────────

  // Build upload→teacher map and return summaries keyed by teacher_id
  async function getTeacherSessionStats(teacherIds) {
    if (!teacherIds.length) return { uploadCountMap: {}, sessionCountMap: {}, lastActiveMap: {} };

    const { data: tUploads } = await supabase
      .from('uploads')
      .select('id, teacher_id')
      .in('teacher_id', teacherIds);

    const uploadCountMap  = {};
    const uploadToTeacher = {};
    const allUploadIds    = [];

    (tUploads || []).forEach(u => {
      uploadCountMap[u.teacher_id]  = (uploadCountMap[u.teacher_id] || 0) + 1;
      uploadToTeacher[u.id]         = u.teacher_id;
      allUploadIds.push(u.id);
    });

    const sessionCountMap = {};
    const lastActiveMap   = {};

    if (allUploadIds.length) {
      const { data: sums } = await supabase
        .from('upload_summaries')
        .select('upload_id, total_sessions, last_used_at')
        .in('upload_id', allUploadIds);

      (sums || []).forEach(s => {
        const tid = uploadToTeacher[s.upload_id];
        if (!tid) return;
        sessionCountMap[tid] = (sessionCountMap[tid] || 0) + (s.total_sessions || 0);
        if (!lastActiveMap[tid] || s.last_used_at > lastActiveMap[tid]) {
          lastActiveMap[tid] = s.last_used_at;
        }
      });
    }

    return { uploadCountMap, sessionCountMap, lastActiveMap };
  }

  // ─── GET routes ────────────────────────────────────────────────────────

  if (req.method === 'GET') {

    // ── school-teachers ────────────────────────────────────────────────
    if (action === 'school-teachers') {
      if (!isSchoolAdmin) return res.status(403).json({ error: 'Forbidden' });
      const schoolId = profile.school_id || req.query.schoolId;
      if (!schoolId) return res.status(400).json({ error: 'No school_id' });

      // Division admin can only query schools in their division
      if (profile.role === 'division_admin') {
        const { data: school } = await supabase
          .from('schools').select('division_id').eq('id', schoolId).single();
        if (!school || school.division_id !== profile.division_id) {
          return res.status(403).json({ error: 'Forbidden' });
        }
      }

      const { data: teachers, error } = await supabase
        .from('profiles')
        .select('id, role, tier, tier_override')
        .eq('school_id', schoolId);
      if (error) return res.status(500).json({ error: error.message });

      const { data: authUsers } = await supabase.auth.admin.listUsers({ perPage: 1000 });
      const emailMap = {};
      (authUsers?.users || []).forEach(u => { emailMap[u.id] = u.email; });

      const teacherIds = (teachers || []).map(t => t.id);
      const { uploadCountMap, sessionCountMap, lastActiveMap } = await getTeacherSessionStats(teacherIds);

      return res.status(200).json(
        (teachers || []).map(t => ({
          ...t,
          email:         emailMap[t.id] || null,
          upload_count:  uploadCountMap[t.id]  || 0,
          session_count: sessionCountMap[t.id] || 0,
          last_active:   lastActiveMap[t.id]   || null,
        }))
      );
    }

    // ── school-report ──────────────────────────────────────────────────
    if (action === 'school-report') {
      if (!isSchoolAdmin) return res.status(403).json({ error: 'Forbidden' });
      const schoolId = profile.school_id || req.query.schoolId;
      if (!schoolId) return res.status(400).json({ error: 'No school_id' });

      const { count: teacherCount } = await supabase
        .from('profiles')
        .select('id', { count: 'exact', head: true })
        .eq('school_id', schoolId);

      const { data: schoolProfiles } = await supabase
        .from('profiles')
        .select('id, storage_used_mb')
        .eq('school_id', schoolId);

      const teacherIds   = (schoolProfiles || []).map(p => p.id);
      const totalStorage = (schoolProfiles || []).reduce((s, p) => s + (p.storage_used_mb || 0), 0);

      const { data: schoolUploads } = await supabase
        .from('uploads')
        .select('id')
        .in('teacher_id', teacherIds);
      const uploadIds = (schoolUploads || []).map(u => u.id);

      const { data: sums } = await supabase
        .from('upload_summaries')
        .select('total_sessions, completions')
        .in('upload_id', uploadIds);

      let totalSessions = 0, totalCompletions = 0;
      (sums || []).forEach(s => {
        totalSessions    += s.total_sessions || 0;
        totalCompletions += s.completions    || 0;
      });

      return res.status(200).json({
        teacherCount:   teacherCount || 0,
        uploadCount:    uploadIds.length,
        totalSessions,
        totalCompletions,
        completionRate: totalSessions > 0 ? Math.round(totalCompletions / totalSessions * 100) : null,
        totalStorageMb: Math.round(totalStorage * 10) / 10,
      });
    }

    // ── school-detail (division admin views a specific school) ─────────
    if (action === 'school-detail') {
      if (!isDivisionAdmin) return res.status(403).json({ error: 'Forbidden' });
      const schoolId = req.query.schoolId;
      if (!schoolId) return res.status(400).json({ error: 'schoolId required' });

      const { data: school } = await supabase
        .from('schools').select('id, name, division_id, tier').eq('id', schoolId).single();

      if (!school) return res.status(404).json({ error: 'School not found' });
      if (profile.role === 'division_admin' && school.division_id !== profile.division_id) {
        return res.status(403).json({ error: 'Forbidden' });
      }

      const { data: teachers } = await supabase
        .from('profiles').select('id, role, tier, tier_override').eq('school_id', schoolId);

      const { data: authUsers } = await supabase.auth.admin.listUsers({ perPage: 1000 });
      const emailMap = {};
      (authUsers?.users || []).forEach(u => { emailMap[u.id] = u.email; });

      const teacherIds = (teachers || []).map(t => t.id);
      const { uploadCountMap, sessionCountMap, lastActiveMap } = await getTeacherSessionStats(teacherIds);

      return res.status(200).json({
        school,
        teachers: (teachers || []).map(t => ({
          ...t,
          email:         emailMap[t.id] || null,
          upload_count:  uploadCountMap[t.id]  || 0,
          session_count: sessionCountMap[t.id] || 0,
          last_active:   lastActiveMap[t.id]   || null,
        })),
      });
    }

    // ── division-schools ───────────────────────────────────────────────
    if (action === 'division-schools') {
      if (!isDivisionAdmin) return res.status(403).json({ error: 'Forbidden' });
      const divisionId = profile.division_id;
      if (!divisionId) return res.status(400).json({ error: 'No division_id' });

      const { data: schools, error } = await supabase
        .from('schools')
        .select('id, name, tier, admin_email, created_at')
        .eq('division_id', divisionId)
        .order('name');
      if (error) return res.status(500).json({ error: error.message });

      const schoolIds = (schools || []).map(s => s.id);

      // Teachers per school
      const { data: schoolTeachers } = await supabase
        .from('profiles').select('id, school_id').in('school_id', schoolIds);

      const teachersBySchool = {};
      (schoolTeachers || []).forEach(t => {
        if (!teachersBySchool[t.school_id]) teachersBySchool[t.school_id] = [];
        teachersBySchool[t.school_id].push(t.id);
      });

      // Session counts per school via upload_summaries
      const allTeacherIds = (schoolTeachers || []).map(t => t.id);
      const { data: allUploads } = allTeacherIds.length
        ? await supabase.from('uploads').select('id, teacher_id').in('teacher_id', allTeacherIds)
        : { data: [] };

      const teacherToSchool = {};
      (schoolTeachers || []).forEach(t => { teacherToSchool[t.id] = t.school_id; });

      const uploadToTeacher = {};
      const allUploadIds    = [];
      (allUploads || []).forEach(u => { uploadToTeacher[u.id] = u.teacher_id; allUploadIds.push(u.id); });

      const { data: sums } = allUploadIds.length
        ? await supabase.from('upload_summaries').select('upload_id, total_sessions').in('upload_id', allUploadIds)
        : { data: [] };

      const sessionsBySchool = {};
      (sums || []).forEach(s => {
        const tid = uploadToTeacher[s.upload_id];
        const sid = teacherToSchool[tid];
        if (sid) sessionsBySchool[sid] = (sessionsBySchool[sid] || 0) + (s.total_sessions || 0);
      });

      return res.status(200).json(
        (schools || []).map(s => ({
          ...s,
          teacher_count:  (teachersBySchool[s.id] || []).length,
          total_sessions: sessionsBySchool[s.id] || 0,
        }))
      );
    }

    // ── division-report ────────────────────────────────────────────────
    if (action === 'division-report') {
      if (!isDivisionAdmin) return res.status(403).json({ error: 'Forbidden' });
      const divisionId = profile.division_id;
      if (!divisionId) return res.status(400).json({ error: 'No division_id' });

      const { data: divSchools } = await supabase
        .from('schools').select('id').eq('division_id', divisionId);
      const divSchoolIds = (divSchools || []).map(s => s.id);

      // Collect all teacher IDs: directly under division + under schools
      const [{ data: direct }, { data: viaSchool }] = await Promise.all([
        supabase.from('profiles').select('id, storage_used_mb').eq('division_id', divisionId),
        divSchoolIds.length
          ? supabase.from('profiles').select('id, storage_used_mb').in('school_id', divSchoolIds)
          : Promise.resolve({ data: [] }),
      ]);

      const allTeachersMap = {};
      [...(direct || []), ...(viaSchool || [])].forEach(t => { allTeachersMap[t.id] = t; });
      const allTeachers    = Object.values(allTeachersMap);
      const totalStorage   = allTeachers.reduce((s, t) => s + (t.storage_used_mb || 0), 0);
      const allTeacherIds  = allTeachers.map(t => t.id);

      const { data: divUploads } = allTeacherIds.length
        ? await supabase.from('uploads').select('id').in('teacher_id', allTeacherIds)
        : { data: [] };
      const divUploadIds = (divUploads || []).map(u => u.id);

      const { data: sums } = divUploadIds.length
        ? await supabase.from('upload_summaries').select('total_sessions, completions').in('upload_id', divUploadIds)
        : { data: [] };

      let totalSessions = 0, totalCompletions = 0;
      (sums || []).forEach(s => {
        totalSessions    += s.total_sessions || 0;
        totalCompletions += s.completions    || 0;
      });

      // Active teachers: at least 1 upload since start of current school year (Sep 1)
      const now      = new Date();
      const sepYear  = now.getMonth() >= 8 ? now.getFullYear() : now.getFullYear() - 1;
      const yearStart = new Date(sepYear, 8, 1).toISOString();

      const { data: activeUploads } = allTeacherIds.length
        ? await supabase.from('uploads').select('teacher_id').in('teacher_id', allTeacherIds).gte('created_at', yearStart)
        : { data: [] };
      const activeTeacherCount = new Set((activeUploads || []).map(u => u.teacher_id)).size;

      return res.status(200).json({
        schoolCount:        divSchoolIds.length,
        teacherCount:       allTeachers.length,
        activeTeacherCount,
        uploadCount:        divUploadIds.length,
        totalSessions,
        totalCompletions,
        completionRate:     totalSessions > 0 ? Math.round(totalCompletions / totalSessions * 100) : null,
        totalStorageMb:     Math.round(totalStorage * 10) / 10,
      });
    }

    // ── division-activity (weekly sessions for the chart) ──────────────
    if (action === 'division-activity') {
      if (!isDivisionAdmin) return res.status(403).json({ error: 'Forbidden' });
      const divisionId = profile.division_id;
      if (!divisionId) return res.status(400).json({ error: 'No division_id' });

      const { data: divSchools } = await supabase
        .from('schools').select('id').eq('division_id', divisionId);
      const divSchoolIds = (divSchools || []).map(s => s.id);

      const [{ data: dt1 }, { data: dt2 }] = await Promise.all([
        supabase.from('profiles').select('id').eq('division_id', divisionId),
        divSchoolIds.length
          ? supabase.from('profiles').select('id').in('school_id', divSchoolIds)
          : Promise.resolve({ data: [] }),
      ]);

      const allTeacherIds = [...new Set([...(dt1 || []), ...(dt2 || [])].map(t => t.id))];

      const { data: divUploads } = allTeacherIds.length
        ? await supabase.from('uploads').select('id').in('teacher_id', allTeacherIds)
        : { data: [] };
      const divUploadIds = (divUploads || []).map(u => u.id);

      const twelveWeeksAgo = new Date(Date.now() - 12 * 7 * 24 * 60 * 60 * 1000).toISOString();
      const { data: events } = divUploadIds.length
        ? await supabase
            .from('session_events')
            .select('event_type, occurred_at')
            .in('upload_id', divUploadIds)
            .in('event_type', ['code_entered', 'playback_completed'])
            .gte('occurred_at', twelveWeeksAgo)
        : { data: [] };

      // Group by ISO week (Monday-based)
      const weeklyData = {};
      (events || []).forEach(e => {
        const d   = new Date(e.occurred_at);
        const day = d.getUTCDay();
        const diff = d.getUTCDate() - day + (day === 0 ? -6 : 1);
        const wkStart = new Date(Date.UTC(d.getUTCFullYear(), d.getUTCMonth(), diff));
        const key = wkStart.toISOString().slice(0, 10);
        if (!weeklyData[key]) weeklyData[key] = { week: key, sessions: 0, completions: 0 };
        if (e.event_type === 'code_entered')      weeklyData[key].sessions++;
        if (e.event_type === 'playback_completed') weeklyData[key].completions++;
      });

      // Build 12-week array (most recent last)
      const result = [];
      for (let i = 11; i >= 0; i--) {
        const base = new Date();
        const day  = base.getUTCDay();
        const diff = base.getUTCDate() - day + (day === 0 ? -6 : 1) - i * 7;
        const wkStart = new Date(Date.UTC(base.getUTCFullYear(), base.getUTCMonth(), diff));
        const key = wkStart.toISOString().slice(0, 10);
        result.push(weeklyData[key] || { week: key, sessions: 0, completions: 0 });
      }

      return res.status(200).json(result);
    }

    return res.status(400).json({ error: 'Unknown action' });
  }

  // ─── POST routes ───────────────────────────────────────────────────────

  if (req.method === 'POST') {
    const body = req.body || {};

    // ── detach-teacher ─────────────────────────────────────────────────
    if (action === 'detach-teacher') {
      if (!isSchoolAdmin) return res.status(403).json({ error: 'Forbidden' });
      const { userId } = body;
      if (!userId) return res.status(400).json({ error: 'userId required' });

      // School admin can only detach teachers from their own school
      if (profile.role === 'school_admin') {
        const { data: target } = await supabase
          .from('profiles').select('school_id').eq('id', userId).single();
        if (!target || target.school_id !== profile.school_id) {
          return res.status(403).json({ error: 'Forbidden' });
        }
      }

      const { error } = await supabase
        .from('profiles')
        .update({ school_id: null, role: 'teacher' })
        .eq('id', userId);
      if (error) return res.status(500).json({ error: error.message });
      return res.status(200).json({ ok: true });
    }

    // ── detach-school ──────────────────────────────────────────────────
    if (action === 'detach-school') {
      if (!isDivisionAdmin) return res.status(403).json({ error: 'Forbidden' });
      const { schoolId } = body;
      if (!schoolId) return res.status(400).json({ error: 'schoolId required' });

      if (profile.role === 'division_admin') {
        const { data: school } = await supabase
          .from('schools').select('division_id').eq('id', schoolId).single();
        if (!school || school.division_id !== profile.division_id) {
          return res.status(403).json({ error: 'Forbidden' });
        }
      }

      const { error } = await supabase
        .from('schools').update({ division_id: null }).eq('id', schoolId);
      if (error) return res.status(500).json({ error: error.message });
      return res.status(200).json({ ok: true });
    }

    // ── remove-school-admin ────────────────────────────────────────────
    if (action === 'remove-school-admin') {
      if (!isDivisionAdmin) return res.status(403).json({ error: 'Forbidden' });
      const { userId } = body;
      if (!userId) return res.status(400).json({ error: 'userId required' });

      const { error } = await supabase
        .from('profiles')
        .update({ role: 'teacher' })
        .eq('id', userId)
        .eq('role', 'school_admin');
      if (error) return res.status(500).json({ error: error.message });
      return res.status(200).json({ ok: true });
    }

    return res.status(400).json({ error: 'Unknown action' });
  }

  return res.status(405).json({ error: 'Method not allowed' });
};
