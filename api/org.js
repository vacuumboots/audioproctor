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
//   GET  ?action=school-uploads           — list uploads for teachers in caller's school (paginated)
//   GET  ?action=division-uploads        — list uploads for all teachers in caller's division (paginated)
//   POST ?action=detach-teacher           — body: { userId } — remove teacher from school
//   POST ?action=detach-school            — body: { schoolId } — remove school from division
//   POST ?action=remove-school-admin      — body: { userId } — revert school_admin role to teacher
//   POST ?action=invite-teacher           — body: { email } — create invitation + send email
//   POST ?action=attach-school            — body: { schoolId } — attach school to division (with proration)

const { createClient } = require('@supabase/supabase-js');
const Stripe = require('stripe');
const { Resend }       = require('resend');
const { sendEmail }    = require('./_lib/email');

// ─── Shared: return signed audio URL or resolved text HTML for a single upload ──
async function handleGetUploadContent(uploadId, supabase, res) {
  const { data: upload, error: fetchErr } = await supabase
    .from('uploads')
    .select('id, teacher_id, storage_path, access_code, assessment_type, text_content, image_count')
    .eq('id', uploadId)
    .single();

  if (fetchErr || !upload) {
    return res.status(404).json({ error: 'Upload not found' });
  }

  if (upload.assessment_type === 'audio') {
    const { data: signed, error: signErr } = await supabase
      .storage.from('audio-files')
      .createSignedUrl(upload.storage_path, 3600);
    if (signErr || !signed) {
      return res.status(500).json({ error: 'Could not generate audio link' });
    }
    return res.status(200).json({ assessment_type: 'audio', signed_url: signed.signedUrl });
  }

  // Text assessment — resolve inline image placeholders
  let resolvedHtml = upload.text_content || '';
  if (upload.image_count > 0) {
    const teacherId  = upload.teacher_id;
    const accessCode = upload.access_code;
    const signedUrls = [];
    for (let i = 0; i < upload.image_count; i++) {
      let found = false;
      for (const ext of ['png', 'jpg', 'webp']) {
        const imgPath = `${teacherId}/${accessCode}/img_${i}.${ext}`;
        const { data: signed, error: signErr } = await supabase
          .storage.from('assessment-images')
          .createSignedUrl(imgPath, 3600);
        if (!signErr && signed) { signedUrls[i] = signed.signedUrl; found = true; break; }
      }
      if (!found) signedUrls[i] = '';
    }
    resolvedHtml = resolvedHtml.replace(
      /<img[^>]*data-apimg-idx="(\d+)"[^>]*>/g,
      (match, idx) => {
        const url = signedUrls[parseInt(idx)] || '';
        if (!url) return '';
        return `<img src="${url.replace(/&/g,'&amp;').replace(/"/g,'&quot;')}" style="max-width:100%;height:auto;">`;
      }
    );
  }
  return res.status(200).json({ assessment_type: 'text', text_content: resolvedHtml });
}

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
    if (!teacherIds.length) return {
      uploadCountMap: {}, sessionCountMap: {}, completionCountMap: {},
      replayCountMap: {}, avgListenMap: {}, lastActiveMap: {},
    };

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

    const sessionCountMap    = {};
    const completionCountMap = {};
    const replayCountMap     = {};
    const avgListenAcc       = {};
    const lastActiveMap      = {};

    if (allUploadIds.length) {
      const { data: sums } = await supabase
        .from('upload_summaries')
        .select('upload_id, total_sessions, completions, replays, avg_listen_seconds, last_used_at')
        .in('upload_id', allUploadIds);

      (sums || []).forEach(s => {
        const tid = uploadToTeacher[s.upload_id];
        if (!tid) return;
        sessionCountMap[tid]    = (sessionCountMap[tid] || 0) + (s.total_sessions || 0);
        completionCountMap[tid] = (completionCountMap[tid] || 0) + (s.completions || 0);
        replayCountMap[tid]     = (replayCountMap[tid] || 0) + (s.replays || 0);
        if (s.avg_listen_seconds) {
          if (!avgListenAcc[tid]) avgListenAcc[tid] = { sum: 0, count: 0 };
          avgListenAcc[tid].sum   += s.avg_listen_seconds;
          avgListenAcc[tid].count += 1;
        }
        if (!lastActiveMap[tid] || s.last_used_at > lastActiveMap[tid]) {
          lastActiveMap[tid] = s.last_used_at;
        }
      });
    }

    const avgListenMap = {};
    Object.entries(avgListenAcc).forEach(([tid, acc]) => {
      avgListenMap[tid] = acc.count > 0 ? Math.round(acc.sum / acc.count) : null;
    });

    return { uploadCountMap, sessionCountMap, completionCountMap, replayCountMap, avgListenMap, lastActiveMap };
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
      if (error) {
        console.error('school-teachers query failed:', error.message);
        return res.status(500).json({ error: 'Could not load teachers' });
      }

      const emailMap = await getAllUserEmails(supabase);

      const teacherIds = (teachers || []).map(t => t.id);
      const { uploadCountMap, sessionCountMap, completionCountMap, replayCountMap, avgListenMap, lastActiveMap } = await getTeacherSessionStats(teacherIds);

      return res.status(200).json(
        (teachers || []).map(t => ({
          ...t,
          email:            emailMap[t.id] || null,
          upload_count:     uploadCountMap[t.id]  || 0,
          session_count:    sessionCountMap[t.id] || 0,
          completion_count: completionCountMap[t.id] || 0,
          completion_rate:  (sessionCountMap[t.id] || 0) > 0 ? Math.round((completionCountMap[t.id] || 0) / sessionCountMap[t.id] * 100) : null,
          replays:          replayCountMap[t.id] || 0,
          avg_listen_seconds: avgListenMap[t.id] || null,
          last_active:      lastActiveMap[t.id]   || null,
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

      const emailMap = await getAllUserEmails(supabase);

      const teacherIds = (teachers || []).map(t => t.id);
      const { uploadCountMap, sessionCountMap, completionCountMap, replayCountMap, avgListenMap, lastActiveMap } = await getTeacherSessionStats(teacherIds);

      return res.status(200).json({
        school,
        teachers: (teachers || []).map(t => ({
          ...t,
          email:            emailMap[t.id] || null,
          upload_count:     uploadCountMap[t.id]  || 0,
          session_count:    sessionCountMap[t.id] || 0,
          completion_count: completionCountMap[t.id] || 0,
          completion_rate:  (sessionCountMap[t.id] || 0) > 0 ? Math.round((completionCountMap[t.id] || 0) / sessionCountMap[t.id] * 100) : null,
          replays:          replayCountMap[t.id] || 0,
          avg_listen_seconds: avgListenMap[t.id] || null,
          last_active:      lastActiveMap[t.id]   || null,
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
      if (error) {
        console.error('division-schools query failed:', error.message);
        return res.status(500).json({ error: 'Could not load schools' });
      }

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
        ? await supabase.from('upload_summaries').select('upload_id, total_sessions, completions, replays').in('upload_id', allUploadIds)
        : { data: [] };

      const sessionsBySchool = {};
      const completionsBySchool = {};
      const replaysBySchool = {};
      (sums || []).forEach(s => {
        const tid = uploadToTeacher[s.upload_id];
        const sid = teacherToSchool[tid];
        if (sid) {
          sessionsBySchool[sid]    = (sessionsBySchool[sid] || 0) + (s.total_sessions || 0);
          completionsBySchool[sid] = (completionsBySchool[sid] || 0) + (s.completions || 0);
          replaysBySchool[sid]     = (replaysBySchool[sid] || 0) + (s.replays || 0);
        }
      });

      return res.status(200).json(
        (schools || []).map(s => ({
          ...s,
          teacher_count:    (teachersBySchool[s.id] || []).length,
          total_sessions:   sessionsBySchool[s.id] || 0,
          completions:      completionsBySchool[s.id] || 0,
          completion_rate:  sessionsBySchool[s.id] > 0 ? Math.round((completionsBySchool[s.id] || 0) / sessionsBySchool[s.id] * 100) : null,
          replays:          replaysBySchool[s.id] || 0,
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

    if (action === 'school-uploads') {
      if (!isSchoolAdmin) return res.status(403).json({ error: 'Forbidden' });
      const schoolId = profile.school_id;
      if (!schoolId) return res.status(400).json({ error: 'Not attached to a school' });

      const { uploadId, type, limit, offset } = req.query;

      // If uploadId provided, return single upload content (signed URL or text HTML)
      if (uploadId) {
        return await handleGetUploadContent(uploadId, supabase, res);
      }

      const pageLimit = Math.min(parseInt(limit) || 50, 200);
      const pageOffset = parseInt(offset) || 0;

      // Get teacher IDs in this school
      const { data: schoolTeachers } = await supabase
        .from('profiles')
        .select('id')
        .eq('school_id', schoolId);

      const teacherIds = (schoolTeachers || []).map(t => t.id);
      if (!teacherIds.length) return res.status(200).json({ uploads: [], total: 0, offset: 0, limit: pageLimit });

      // Fetch teacher emails
      let teacherEmails = {};
      try {
        const { data: authUsers } = await supabase.auth.admin.listUsers({ perPage: 1000 });
        if (authUsers?.users) {
          authUsers.users.forEach(u => { teacherEmails[u.id] = u.email; });
        }
      } catch (_) { /* non-fatal */ }

      let query = supabase
        .from('uploads')
        .select('id, teacher_id, access_code, filename, label, assessment_type, file_size_mb, processing_status, created_at, expires_at', { count: 'exact' })
        .in('teacher_id', teacherIds)
        .order('created_at', { ascending: false })
        .range(pageOffset, pageOffset + pageLimit - 1);

      if (type) query = query.eq('assessment_type', type);

      const { data: uploads, count: total, error } = await query;
      if (error) return res.status(500).json({ error: 'Could not load uploads' });

      // Enrich with teacher email
      const enriched = (uploads || []).map(u => ({
        ...u,
        teacher_email: teacherEmails[u.teacher_id] || null,
      }));

      return res.status(200).json({ uploads: enriched, total, offset: pageOffset, limit: pageLimit });
    }

    if (action === 'division-uploads') {
      if (!isDivisionAdmin) return res.status(403).json({ error: 'Forbidden' });
      const divisionId = profile.division_id;
      if (!divisionId) return res.status(400).json({ error: 'Not attached to a division' });

      const { uploadId, type, limit, offset } = req.query;

      // If uploadId provided, return single upload content
      if (uploadId) {
        return await handleGetUploadContent(uploadId, supabase, res);
      }

      const pageLimit = Math.min(parseInt(limit) || 50, 200);
      const pageOffset = parseInt(offset) || 0;

      // Get schools in this division, then teachers in those schools
      const { data: divSchools } = await supabase
        .from('schools')
        .select('id, name')
        .eq('division_id', divisionId);
      const schoolIds = (divSchools || []).map(s => s.id);

      // Build school name map
      const schoolNameMap = {};
      (divSchools || []).forEach(s => { schoolNameMap[s.id] = s.name; });

      // Teachers in division schools OR directly in division
      const { data: divTeachers } = await supabase
        .from('profiles')
        .select('id, school_id')
        .or(`division_id.eq.${divisionId}${schoolIds.length ? ',school_id.in.(' + schoolIds.join(',') + ')' : ''}`);

      const teacherIds = (divTeachers || []).map(t => t.id);
      if (!teacherIds.length) return res.status(200).json({ uploads: [], total: 0, offset: 0, limit: pageLimit });

      // Map teacher_id -> school_id
      const teacherSchoolMap = {};
      (divTeachers || []).forEach(t => { teacherSchoolMap[t.id] = t.school_id; });

      // Fetch teacher emails
      let teacherEmails = {};
      try {
        const { data: authUsers } = await supabase.auth.admin.listUsers({ perPage: 1000 });
        if (authUsers?.users) {
          authUsers.users.forEach(u => { teacherEmails[u.id] = u.email; });
        }
      } catch (_) { /* non-fatal */ }

      let query = supabase
        .from('uploads')
        .select('id, teacher_id, access_code, filename, label, assessment_type, file_size_mb, processing_status, created_at, expires_at', { count: 'exact' })
        .in('teacher_id', teacherIds)
        .order('created_at', { ascending: false })
        .range(pageOffset, pageOffset + pageLimit - 1);

      if (type) query = query.eq('assessment_type', type);

      const { data: uploads, count: total, error } = await query;
      if (error) return res.status(500).json({ error: 'Could not load uploads' });

      // Enrich with teacher email and school name
      const enriched = (uploads || []).map(u => {
        const tSchoolId = teacherSchoolMap[u.teacher_id];
        return {
          ...u,
          teacher_email: teacherEmails[u.teacher_id] || null,
          school_name: schoolNameMap[tSchoolId] || null,
        };
      });

      return res.status(200).json({ uploads: enriched, total, offset: pageOffset, limit: pageLimit });
    }

    return res.status(400).json({ error: 'Unknown action' });
  }

  // ─── POST routes ───────────────────────────────────────────────────────

  if (req.method === 'POST') {
    const body = req.body || {};

    // ── detach-teacher ─────────────────────────────────────────────────
    if (action === 'detach-teacher') {
      if (!isSchoolAdmin && !isDivisionAdmin) return res.status(403).json({ error: 'Forbidden' });
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

      // Division admin can only detach teachers from schools in their division
      // or teachers directly assigned to their division
      if (profile.role === 'division_admin') {
        const { data: target } = await supabase
          .from('profiles').select('school_id, division_id').eq('id', userId).single();
        let allowed = false;
        if (target?.division_id === profile.division_id) allowed = true;
        else if (target?.school_id) {
          const { data: school } = await supabase
            .from('schools').select('division_id').eq('id', target.school_id).single();
          if (school?.division_id === profile.division_id) allowed = true;
        }
        if (!allowed) return res.status(403).json({ error: 'Forbidden' });
      }

      // Fetch teacher's email before detaching so we can notify them
      const { data: authUser } = await supabase.auth.admin.getUserById(userId);
      const teacherEmail = authUser?.user?.email;

      const { data: prevProfile } = await supabase.from('profiles').select('school_id, division_id').eq('id', userId).single();
      const { error } = await supabase
        .from('profiles')
        .update({ school_id: null, division_id: null, role: 'teacher' })
        .eq('id', userId);
      if (error) {
        console.error('detach-teacher failed:', error.message);
        return res.status(500).json({ error: 'Could not detach teacher' });
      }
      audit(supabase, user.id, 'detach_teacher', 'teacher', userId,
        { school_id: prevProfile?.school_id, division_id: prevProfile?.division_id },
        { school_id: null, division_id: null });

      // Notify the teacher — fire-and-forget, don't fail the request if email fails
      if (teacherEmail) {
        sendTierChangeEmail(teacherEmail, 'school').catch(err =>
          console.error('tier-change email failed:', err.message)
        );
      }

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

      // Collect teacher emails for all teachers in this school before detaching
      const { data: affectedTeachers } = await supabase
        .from('profiles').select('id').eq('school_id', schoolId);
      const affectedIds = (affectedTeachers || []).map(t => t.id);

      const { error } = await supabase
        .from('schools').update({ division_id: null }).eq('id', schoolId);
      if (error) {
        console.error('detach-school failed:', error.message);
        return res.status(500).json({ error: 'Could not detach school' });
      }
      audit(supabase, user.id, 'detach_school', 'school', schoolId,
        { division_id: profile.division_id }, { division_id: null });

      // Notify all affected teachers — fire-and-forget
      if (affectedIds.length) {
        const emailMap = await getAllUserEmails(supabase);
        affectedIds.forEach(tid => {
          const email = emailMap[tid];
          if (email) {
            sendTierChangeEmail(email, 'division').catch(err =>
              console.error('tier-change email failed:', err.message)
            );
          }
        });
      }

      return res.status(200).json({ ok: true });
    }

    // ── attach-school ───────────────────────────────────────────────────
    // Attaches a school to this division, with automatic proration:
    // if the school has an active School Plan Stripe subscription, cancel it
    // with `proration_behavior: 'create_prorations'` so the unused portion
    // credits to the division customer's balance.
    if (action === 'attach-school') {
      if (!isDivisionAdmin) return res.status(403).json({ error: 'Forbidden' });
      const { schoolId } = body;
      if (!schoolId) return res.status(400).json({ error: 'schoolId required' });

      const divisionId = profile.division_id;
      if (!divisionId) return res.status(400).json({ error: 'No division_id' });

      // Verify the school isn't already in a division
      const { data: school } = await supabase
        .from('schools').select('id, name, tier, stripe_subscription_id, stripe_customer_id, division_id')
        .eq('id', schoolId)
        .single();

      if (!school) return res.status(404).json({ error: 'School not found' });
      if (school.division_id === divisionId) {
        return res.status(400).json({ error: 'School is already in this division' });
      }
      if (school.division_id) {
        return res.status(400).json({ error: 'School belongs to another division. Detach it first.' });
      }

      // ── Proration: cancel school subscription if active ──────────────
      if (school.stripe_subscription_id && school.tier === 'school') {
        const stripe = Stripe(process.env.STRIPE_SECRET_KEY);
        try {
          await stripe.subscriptions.update(school.stripe_subscription_id, {
            cancellation_details: { comment: `School joined division ${divisionId} — cancelling with proration` },
            proration_behavior: 'create_prorations',
          });
          console.log(`[proration] cancelled school sub ${school.stripe_subscription_id} with proration`);

          await supabase.from('schools').update({
            tier:                      'free',
            stripe_subscription_status: 'canceled',
            cancelled_at:               new Date().toISOString()
          }).eq('id', schoolId);

        } catch (err) {
          console.error('attach-school proration failed:', err.message);
          // Non-fatal — continue with the attachment even if Stripe fails
        }
      }

      // ── Attach school to division ────────────────────────────────────
      const { error } = await supabase
        .from('schools').update({ division_id: divisionId }).eq('id', schoolId);

      if (error) {
        console.error('attach-school failed:', error.message);
        return res.status(500).json({ error: 'Could not attach school to division' });
      }

      audit(supabase, user.id, 'attach_school', 'school', schoolId,
        { division_id: school.division_id }, { division_id: divisionId });

      return res.status(200).json({ ok: true, prorated: !!school.stripe_subscription_id });
    }

    // ── remove-school-admin ────────────────────────────────────────────
    if (action === 'remove-school-admin') {
      if (!isDivisionAdmin) return res.status(403).json({ error: 'Forbidden' });
      const { userId } = body;
      if (!userId) return res.status(400).json({ error: 'userId required' });

      // Division admin can only demote school admins within their own division
      if (profile.role === 'division_admin') {
        const { data: target } = await supabase
          .from('profiles')
          .select('school_id')
          .eq('id', userId)
          .eq('role', 'school_admin')
          .single();
        if (!target || !target.school_id) {
          return res.status(403).json({ error: 'Forbidden' });
        }
        const { data: school } = await supabase
          .from('schools')
          .select('division_id')
          .eq('id', target.school_id)
          .single();
        if (!school || school.division_id !== profile.division_id) {
          return res.status(403).json({ error: 'Forbidden' });
        }
      }

      const { error } = await supabase
        .from('profiles')
        .update({ role: 'teacher' })
        .eq('id', userId)
        .eq('role', 'school_admin');
      if (error) {
        console.error('remove-school-admin failed:', error.message);
        return res.status(500).json({ error: 'Could not remove school admin role' });
      }
      return res.status(200).json({ ok: true });
    }

    // ── invite-teacher ──────────────────────────────────────────────────
    if (action === 'invite-teacher') {
      // This endpoint is for school admins and division admins only.
      // Platform admins use the invite action in api/admin.js.
      if (!['school_admin', 'division_admin'].includes(profile.role)) {
        return res.status(403).json({ error: 'Forbidden' });
      }

      const { email } = body;
      if (!email) return res.status(400).json({ error: 'email required' });

      // School admins must be assigned to a school; division admins to a division.
      if (profile.role === 'school_admin' && !profile.school_id) {
        return res.status(400).json({ error: 'You are not assigned to a school' });
      }
      if (profile.role === 'division_admin' && !profile.division_id) {
        return res.status(400).json({ error: 'You are not assigned to a division' });
      }

      // Resolve org name for the invitation email
      let orgName = null;
      if (profile.school_id) {
        const { data: school } = await supabase
          .from('schools').select('name').eq('id', profile.school_id).single();
        orgName = school?.name || null;
      } else if (profile.division_id) {
        const { data: division } = await supabase
          .from('divisions').select('name').eq('id', profile.division_id).single();
        orgName = division?.name || null;
      }

      const { data: invite, error: invErr } = await supabase
        .from('invitations')
        .insert({
          email,
          role: 'teacher',
          school_id:   body.schoolId || profile.school_id || null,
          division_id: profile.division_id || null,
        })
        .select('id, token')
        .single();
      if (invErr) return res.status(500).json({ error: 'Could not create invitation' });

      const inviteUrl = `https://app.audioproctor.com/accept-invite.html?token=${invite.token}`;

      let emailOk = true;
      let emailError = null;
      try {
        const { subject, text, html } = buildInviteEmail({ role: 'teacher', inviteUrl, orgName });
        const emailResult = await sendEmail({ to: email, subject, text, html });
        if (!emailResult.ok) {
          emailOk = false;
          emailError = emailResult.error;
        }
      } catch (err) {
        emailOk = false;
        emailError = err.message;
      }

      logInviteEmail(supabase, invite.id, 'invite', emailOk, emailError);

      audit(supabase, user.id, 'invite_teacher', 'invitation', invite.token, null,
        { email, role: 'teacher', emailOk, orgName });

      return res.status(200).json({ ok: true, inviteUrl, token: invite.token, emailOk, emailError });
    }

    return res.status(400).json({ error: 'Unknown action' });
  }

  return res.status(405).json({ error: 'Method not allowed' });
};

// ─── Invite email helper ───────────────────────────────────────────────────

function formatRole(role) {
  return role.replace(/_/g, ' ').replace(/\b\w/g, c => c.toUpperCase());
}

function buildInviteEmail({ role, inviteUrl, orgName }) {
  const roleLabel = formatRole(role);
  const subject   = `You've been invited to join AudioProctor`;
  let text = `You've been invited to join AudioProctor as a ${roleLabel}.`;
  if (orgName) text += `\n\nas part of ${orgName}`;
  text += `\n\nClick the link below to accept your invitation:\n${inviteUrl}\n\nThis invitation expires in 7 days.\nIf you did not expect this invitation, you can safely ignore it.`;
  let html = `<p>You've been invited to join AudioProctor as a <strong>${roleLabel}</strong>.</p>`;
  if (orgName) html += `<p>as part of <strong>${orgName}</strong></p>`;
  html += `<p>Click the link below to accept your invitation:</p><p><a href="${inviteUrl}">${inviteUrl}</a></p><p>This invitation expires in 7 days.<br>If you did not expect this invitation, you can safely ignore it.</p>`;
  return { subject, text, html };
}

function logInviteEmail(supabase, invitationId, action, emailOk, errorMessage) {
  supabase.from('invite_email_log').insert({
    invitation_id:  invitationId ?? null,
    action,
    email_ok:       emailOk ?? null,
    error_message:  errorMessage ?? null,
  }).then(({ error }) => {
    if (error) console.error('invite email log insert failed:', error.message);
  });
}

// ─── Audit log helper ─────────────────────────────────────────────────────

function audit(supabase, actorId, action, targetType, targetId, before, after) {
  supabase.from('admin_audit_log').insert({
    actor_id:     actorId,
    action,
    target_type:  targetType,
    target_id:    targetId,
    before_value: before ?? null,
    after_value:  after  ?? null,
  }).then(({ error }) => {
    if (error) console.error('audit log insert failed:', error.message);
  });
}

// ─── Paginated user email fetch ───────────────────────────────────────────
// Supabase admin.listUsers has a maximum perPage of 1000. This function
// paginates through all pages and returns a map of { userId: email }.

async function getAllUserEmails(supabase) {
  const emailMap = {};
  let page = 1;
  const perPage = 1000;

  while (true) {
    const { data, error } = await supabase.auth.admin.listUsers({ page, perPage });
    if (error || !data?.users?.length) break;
    data.users.forEach(u => { emailMap[u.id] = u.email; });
    if (data.users.length < perPage) break;
    page++;
  }

  return emailMap;
}

// ─── Email helper ──────────────────────────────────────────────────────────
// Notifies a teacher that their plan tier has changed due to detachment.
// 'detachedFrom' is 'school' or 'division' — describes what they were removed from.
// Called fire-and-forget; errors are logged but not surfaced to the caller.

async function sendTierChangeEmail(teacherEmail, detachedFrom) {
  const resend = new Resend(process.env.RESEND_API_KEY);
  const orgLabel = detachedFrom === 'division' ? 'division' : 'school';

  await resend.emails.send({
    from:    'AudioProctor <hello@audioproctor.com>',
    to:      teacherEmail,
    subject: 'Your AudioProctor plan has changed',
    text: [
      `Hi,`,
      ``,
      `Your account has been removed from your ${orgLabel} on AudioProctor.`,
      ``,
      `Your account and all of your uploaded assessments are still intact, but your plan has`,
      `reverted to the Free tier. This means you are now limited to 3 uploads per calendar`,
      `month and 50 MB of storage. Existing access codes will continue to work until they expire.`,
      ``,
      `If you believe this was done in error, please contact your ${orgLabel} administrator`,
      `or reply to this email.`,
      ``,
      `— AudioProctor`,
    ].join('\n'),
  });
}

