// ─── /api/admin ───────────────────────────────────────────────────
// Vercel serverless function.
// All operations require the caller to be role = 'platform_admin'.
// Uses the service role key to bypass RLS for cross-account reads.
//
// Routes (via ?action= query param):
//
//   GET  ?action=overview          — division, school, teacher counts + anomalies
//   GET  ?action=divisions         — list all divisions
//   GET  ?action=schools           — list all schools (with division name)
//   GET  ?action=teachers          — list all teachers (unattached or all)
//   POST ?action=set-tier          — body: { entityType, entityId, tier }
//   POST ?action=set-notes         — body: { entityType, entityId, notes }
//   POST ?action=invite            — body: { email, role, schoolId?, divisionId? }
//   GET  ?action=list-teacher-uploads — list all uploads with metadata (paginated)
//   GET  ?action=get-upload-content&uploadId= — signed audio URL or resolved text HTML
//   POST ?action=assign-role       — body: { teacher_id, role, school_id?, division_id? }
//   POST ?action=attach-teacher    — body: { userId, schoolId?, divisionId? }

const { createClient } = require('@supabase/supabase-js');
const crypto = require('crypto');
const Stripe = require('stripe');
const { sendEmail } = require('./_lib/email');

function formatRole(role) {
  return role.replace(/_/g, ' ').replace(/\b\w/g, c => c.toUpperCase());
}

function buildInviteEmail({ role, inviteUrl, orgName }) {
  const roleLabel = formatRole(role);
  const subject = `You've been invited to join AudioProctor`;
  let text = `You've been invited to join AudioProctor as a ${roleLabel}.`;
  if (orgName) text += `\n\nas part of ${orgName}`;
  text += `\n\nClick the link below to accept your invitation:\n${inviteUrl}\n\nThis invitation expires in 7 days.\nIf you did not expect this invitation, you can safely ignore it.`;
  let html = `<p>You've been invited to join AudioProctor as a <strong>${roleLabel}</strong>.</p>`;
  if (orgName) html += `<p>as part of <strong>${orgName}</strong></p>`;
  html += `<p>Click the link below to accept your invitation:</p><p><a href="${inviteUrl}">${inviteUrl}</a></p><p>This invitation expires in 7 days.<br>If you did not expect this invitation, you can safely ignore it.</p>`;
  return { subject, text, html };
}

module.exports = async (req, res) => {
  res.setHeader('Access-Control-Allow-Origin',  'https://app.audioproctor.com');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  if (req.method === 'OPTIONS') return res.status(200).end();

  // ─── Auth check ─────────────────────────────────────────────────
  // The caller passes their Supabase JWT in the Authorization header.
  // We verify it using the anon client, then check role = platform_admin.
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

  // Service role client for all data operations
  const supabase = createClient(
    process.env.SUPABASE_URL,
    process.env.SUPABASE_SERVICE_ROLE_KEY
  );

  // Check role
  const { data: profile, error: profileErr } = await supabase
    .from('profiles')
    .select('role')
    .eq('id', user.id)
    .single();

  if (profileErr || !profile || profile.role !== 'platform_admin') {
    return res.status(403).json({ error: 'Forbidden' });
  }

  const action = req.query.action;

  // ─── GET routes ──────────────────────────────────────────────────

  if (req.method === 'GET') {

    if (action === 'overview') {
      const [
        { count: divCount },
        { count: schoolCount },
        { count: teacherCount },
        { data: foreignAccounts },
      ] = await Promise.all([
        supabase.from('divisions').select('id', { count: 'exact', head: true }),
        supabase.from('schools').select('id', { count: 'exact', head: true }),
        supabase.from('profiles').select('id', { count: 'exact', head: true }).or('role.eq.teacher,role.is.null'),
        // Anomaly: profiles where country_code is not CA (and not null/empty)
        supabase
          .from('profiles')
          .select('id, country_code, division_name')
          .not('country_code', 'eq', 'CA')
          .not('country_code', 'is', null)
          .neq('country_code', ''),
      ]);

      return res.status(200).json({
        divisionCount: divCount  || 0,
        schoolCount:   schoolCount || 0,
        teacherCount:  teacherCount || 0,
        anomalies:     foreignAccounts || [],
      });
    }

    if (action === 'divisions') {
      const { data, error } = await supabase
        .from('divisions')
        .select('id, name, enrolment_band, tier, admin_email, notes, expires_at, created_at')
        .order('created_at', { ascending: false })
        .limit(500);
      if (error) {
        console.error('admin divisions query failed:', error.message);
        return res.status(500).json({ error: 'Could not load divisions' });
      }
      return res.status(200).json(data);
    }

    if (action === 'schools') {
      const { data, error } = await supabase
        .from('schools')
        .select('id, name, tier, admin_email, notes, expires_at, created_at, divisions(name)')
        .order('created_at', { ascending: false })
        .limit(500);
      if (error) {
        console.error('admin schools query failed:', error.message);
        return res.status(500).json({ error: 'Could not load schools' });
      }
      return res.status(200).json(data);
    }

    if (action === 'teachers') {
      const { data, error } = await supabase
        .from('profiles')
        .select(`
          id, role, tier, tier_override, expires_at, country_code, division_name, notes, school_id, division_id, is_deactivated,
          schools(name), divisions(name)
        `)
        .order('id', { ascending: true })
        .limit(1000);
      if (error) {
        console.error('admin teachers query failed:', error.message);
        return res.status(500).json({ error: 'Could not load teachers' });
      }

      // Merge auth.users email — paginated to handle >1000 users
      const emailMap = await getAllUserEmails(supabase);

      const teachers = (data || []).map(p => ({
        ...p,
        email: emailMap[p.id] || null,
        school_name:   p.schools?.name   || null,
        division_name_org: p.divisions?.name || null,
      }));

      return res.status(200).json(teachers);
    }

    if (action === 'audit-log') {
      const limit  = Math.min(parseInt(req.query.limit  || '100', 10), 500);
      const offset = parseInt(req.query.offset || '0',   10);
      const { data, error } = await supabase
        .from('admin_audit_log')
        .select('*')
        .order('occurred_at', { ascending: false })
        .range(offset, offset + limit - 1);
      if (error) return res.status(500).json({ error: error.message });
      return res.status(200).json(data);
    }

    if (action === 'login-link') {
      const { userId: targetId } = req.query;
      if (!targetId) return res.status(400).json({ error: 'userId required' });

      const { data: { user: targetUser }, error: userErr } = await supabase.auth.admin.getUserById(targetId);
      if (userErr || !targetUser) return res.status(404).json({ error: 'User not found' });

      const { data: targetProfile } = await supabase
        .from('profiles').select('role, display_name').eq('id', targetId).maybeSingle();

      // Always redirect to login.html — it's in the Supabase allowlist and
      // routes to the correct page for each role after the session is established.
      const redirectTo = 'https://app.audioproctor.com/login.html';

      const { data: linkData, error: linkErr } = await supabase.auth.admin.generateLink({
        type: 'magiclink',
        email: targetUser.email,
        options: { redirectTo },
      });
      if (linkErr) {
        console.error('login-link generation failed:', linkErr.message);
        return res.status(500).json({ error: 'Could not generate login link' });
      }

      return res.status(200).json({
        link:       linkData.properties.action_link,
        email:      targetUser.email,
        name:       targetProfile?.display_name || targetUser.email,
        role:       targetProfile?.role || 'teacher',
        redirectTo,
      });
    }

    if (action === 'list-invitations') {
      const { data, error } = await supabase
        .from('invitations')
        .select('id, email, role, school_id, division_id, token, expires_at, accepted_at, created_at, schools(name), divisions(name)')
        .is('accepted_at', null)
        .order('created_at', { ascending: false })
        .limit(200);
      if (error) {
        console.error('admin list-invitations failed:', error.message);
        return res.status(500).json({ error: 'Could not load invitations' });
      }

      // Merge latest email send status per invitation
      const invitationIds = (data || []).map(i => i.id);
      let lastEmailMap = {};
      if (invitationIds.length > 0) {
        const { data: logs } = await supabase
          .from('invite_email_log')
          .select('invitation_id, email_ok, created_at')
          .in('invitation_id', invitationIds)
          .in('action', ['approve_request', 'invite', 'resend'])
          .order('created_at', { ascending: false })
          .limit(500);
        logs?.forEach(l => {
          if (!lastEmailMap[l.invitation_id]) lastEmailMap[l.invitation_id] = l;
        });
      }

      const enriched = (data || []).map(inv => ({
        ...inv,
        lastEmailOk: lastEmailMap[inv.id]?.email_ok ?? null,
      }));

      return res.status(200).json(enriched);
    }

    if (action === 'list-requests') {
      const { data, error } = await supabase
        .from('teacher_requests')
        .select('id, name, email, school, division, message, status, notes, created_at, teacher_id, request_type')
        .order('created_at', { ascending: false })
        .limit(200);
      if (error) return res.status(500).json({ error: 'Could not load requests' });
      return res.status(200).json(data);
    }

    if (action === 'platform-analytics') {
      // 1. Platform totals from upload_summaries
      const { data: allSums } = await supabase
        .from('upload_summaries')
        .select('total_sessions, completions, replays, avg_listen_seconds');

      let totalSessions = 0, totalCompletions = 0, totalReplays = 0;
      let avgListenSum = 0, avgListenCount = 0;
      (allSums || []).forEach(s => {
        totalSessions    += s.total_sessions || 0;
        totalCompletions += s.completions    || 0;
        totalReplays     += s.replays        || 0;
        if (s.avg_listen_seconds) {
          avgListenSum   += s.avg_listen_seconds;
          avgListenCount += 1;
        }
      });

      // 2. Per-division breakdown
      const [{ data: divisions }, { data: allSchools }, { data: allProfiles }, { data: allUploads }] = await Promise.all([
        supabase.from('divisions').select('id, name'),
        supabase.from('schools').select('id, division_id'),
        supabase.from('profiles').select('id, division_id, school_id'),
        supabase.from('uploads').select('id, teacher_id'),
      ]);

      const schoolToDivision = {};
      (allSchools || []).forEach(s => { schoolToDivision[s.id] = s.division_id; });

      const teacherToDivision = {};
      (allProfiles || []).forEach(p => {
        teacherToDivision[p.id] = p.division_id || schoolToDivision[p.school_id] || null;
      });

      const uploadToTeacher = {};
      (allUploads || []).forEach(u => { uploadToTeacher[u.id] = u.teacher_id; });

      const divStats = {};
      (divisions || []).forEach(d => {
        divStats[d.id] = { id: d.id, name: d.name, sessions: 0, completions: 0, replays: 0, uploads: 0 };
      });

      // Count uploads per division
      (allUploads || []).forEach(u => {
        const did = teacherToDivision[u.teacher_id];
        if (did && divStats[did]) divStats[did].uploads += 1;
      });

      // Aggregate summaries per division
      (allSums || []).forEach(s => {
        const tid = uploadToTeacher[s.upload_id];
        const did = teacherToDivision[tid];
        if (did && divStats[did]) {
          divStats[did].sessions    += s.total_sessions || 0;
          divStats[did].completions += s.completions    || 0;
          divStats[did].replays     += s.replays        || 0;
        }
      });

      // 3. Weekly activity (last 12 weeks)
      const twelveWeeksAgo = new Date(Date.now() - 12 * 7 * 24 * 60 * 60 * 1000).toISOString();
      const { data: events } = await supabase
        .from('session_events')
        .select('event_type, occurred_at')
        .in('event_type', ['code_entered', 'playback_completed'])
        .gte('occurred_at', twelveWeeksAgo);

      const weeklyData = {};
      (events || []).forEach(e => {
        const d   = new Date(e.occurred_at);
        const day = d.getUTCDay();
        const diff = d.getUTCDate() - day + (day === 0 ? -6 : 1);
        const wkStart = new Date(Date.UTC(d.getUTCFullYear(), d.getUTCMonth(), diff));
        const key = wkStart.toISOString().slice(0, 10);
        if (!weeklyData[key]) weeklyData[key] = { week: key, sessions: 0, completions: 0 };
        if (e.event_type === 'code_entered')       weeklyData[key].sessions++;
        if (e.event_type === 'playback_completed') weeklyData[key].completions++;
      });

      const weeklyActivity = [];
      for (let i = 11; i >= 0; i--) {
        const base = new Date();
        const day  = base.getUTCDay();
        const diff = base.getUTCDate() - day + (day === 0 ? -6 : 1) - i * 7;
        const wkStart = new Date(Date.UTC(base.getUTCFullYear(), base.getUTCMonth(), diff));
        const key = wkStart.toISOString().slice(0, 10);
        weeklyActivity.push(weeklyData[key] || { week: key, sessions: 0, completions: 0 });
      }

      return res.status(200).json({
        totalSessions,
        totalCompletions,
        completionRate:   totalSessions > 0 ? Math.round(totalCompletions / totalSessions * 100) : null,
        totalReplays,
        avgListenSeconds: avgListenCount > 0 ? Math.round(avgListenSum / avgListenCount) : null,
        divisions: Object.values(divStats)
          .map(d => ({
            ...d,
            completionRate: d.sessions > 0 ? Math.round(d.completions / d.sessions * 100) : null,
          }))
          .sort((a, b) => b.sessions - a.sessions),
        weeklyActivity,
      });
    }

    if (action === 'list-teacher-uploads') {
      // ─── List all teacher uploads with metadata ────────────────
      const { teacherId, schoolId, divisionId, type, limit, offset } = req.query;
      const pageLimit = Math.min(parseInt(limit) || 50, 200);
      const pageOffset = parseInt(offset) || 0;

      let query = supabase
        .from('uploads')
        .select(`
          id, teacher_id, access_code, filename, label, assessment_type,
          file_size_mb, storage_path, text_content, text_char_count, image_count,
          processing_status, created_at, expires_at
        `, { count: 'exact' })
        .order('created_at', { ascending: false })
        .range(pageOffset, pageOffset + pageLimit - 1);

      if (teacherId)  query = query.eq('teacher_id', teacherId);
      if (type)       query = query.eq('assessment_type', type);

      const { data: uploads, count: total, error } = await query;
      if (error) return res.status(500).json({ error: 'Could not load uploads' });

      const teacherIds = [...new Set((uploads || []).map(u => u.teacher_id))];
      const { data: teachers } = await supabase
        .from('profiles')
        .select('id, school_id, division_id')
        .in('id', teacherIds.length ? teacherIds : ['none']);

      // Fetch teacher emails from auth
      let teacherEmails = {};
      if (teacherIds.length) {
        try {
          const { data: authUsers } = await supabase.auth.admin.listUsers({ perPage: 1000 });
          if (authUsers?.users) {
            authUsers.users.forEach(u => { teacherEmails[u.id] = u.email; });
          }
        } catch (_) { /* non-fatal — email column will show '—' */ }
      }

      const teacherMap = {};
      (teachers || []).forEach(t => { teacherMap[t.id] = t; });

      const schoolIds = [...new Set((teachers || []).map(t => t.school_id).filter(Boolean))];
      const divisionIds = [...new Set((teachers || []).map(t => t.division_id).filter(Boolean))];

      const [{ data: schools }, { data: divisions }] = await Promise.all([
        schoolIds.length ? supabase.from('schools').select('id, name').in('id', schoolIds) : { data: [] },
        divisionIds.length ? supabase.from('divisions').select('id, name').in('id', divisionIds) : { data: [] },
      ]);

      const schoolMap = {}; (schools || []).forEach(s => { schoolMap[s.id]  = s.name; });
      const divMap    = {}; (divisions || []).forEach(d => { divMap[d.id]    = d.name; });

      const rows = (uploads || []).map(u => {
        const t = teacherMap[u.teacher_id] || {};
        return {
          id:               u.id,
          teacher_id:       u.teacher_id,
          teacher_email:    teacherEmails[u.teacher_id] || null,
          school_name:      schoolMap[t.school_id] || null,
          division_name:    divMap[t.division_id] || null,
          access_code:      u.access_code,
          filename:         u.filename,
          label:            u.label,
          assessment_type:  u.assessment_type,
          file_size_mb:     u.file_size_mb,
          text_char_count:  u.text_char_count,
          image_count:      u.image_count,
          processing_status: u.processing_status,
          created_at:       u.created_at,
          expires_at:       u.expires_at,
        };
      });

      let filtered = rows;
      if (schoolId) {
        filtered = rows.filter(r => {
          const t = teacherMap[r.teacher_id] || {};
          return t.school_id === schoolId;
        });
      }
      if (divisionId) {
        filtered = rows.filter(r => {
          const t = teacherMap[r.teacher_id] || {};
          return t.division_id === divisionId;
        });
      }
      return res.status(200).json({ uploads: filtered, total, offset: pageOffset, limit: pageLimit });
    }

    if (action === 'get-upload-content') {
      const { uploadId } = req.query;
      if (!uploadId) return res.status(400).json({ error: 'Missing uploadId' });

      const { data: upload, error: fetchErr } = await supabase
        .from('uploads')
        .select('id, teacher_id, storage_path, access_code, assessment_type, text_content, image_count')
        .eq('id', uploadId)
        .single();

      if (fetchErr || !upload) return res.status(404).json({ error: 'Upload not found' });

      if (upload.assessment_type === 'audio') {
        const { data: signed, error: signErr } = await supabase
          .storage.from('audio-files')
          .createSignedUrl(upload.storage_path, 3600);
        if (signErr || !signed) return res.status(500).json({ error: 'Could not generate audio link' });
        return res.status(200).json({ assessment_type: 'audio', signed_url: signed.signedUrl });
      }

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

    return res.status(400).json({ error: 'Unknown action' });
  }

  // ─── POST routes ─────────────────────────────────────────────────

  if (req.method === 'POST') {
    const body = req.body || {};

    if (action === 'set-tier') {
      const { entityType, entityId, tier } = body;
      const validTiers = ['free','premium','school','division'];
      if (!validTiers.includes(tier)) return res.status(400).json({ error: 'Invalid tier' });

      let error;
      if (entityType === 'division') {
        ({ error } = await supabase.from('divisions').update({ tier }).eq('id', entityId));
      } else if (entityType === 'school') {
        ({ error } = await supabase.from('schools').update({ tier }).eq('id', entityId));
      } else if (entityType === 'teacher') {
        // For teachers, set tier_override (preserves their own tier column)
        ({ error } = await supabase.from('profiles').update({ tier_override: tier === 'free' ? null : tier }).eq('id', entityId));
      } else {
        return res.status(400).json({ error: 'Invalid entityType' });
      }
      if (error) {
        console.error('set-tier failed:', error.message);
        return res.status(500).json({ error: 'Could not update tier' });
      }
      audit(supabase, user.id, 'set_tier', entityType, entityId, null, { tier });
      return res.status(200).json({ ok: true });
    }

    if (action === 'set-expires') {
      const { entityType, entityId, expiresAt } = body;
      if (!entityType || !entityId) return res.status(400).json({ error: 'entityType and entityId required' });

      let error;
      const expiry = expiresAt || null;
      if (entityType === 'division') {
        ({ error } = await supabase.from('divisions').update({ expires_at: expiry }).eq('id', entityId));
      } else if (entityType === 'school') {
        ({ error } = await supabase.from('schools').update({ expires_at: expiry }).eq('id', entityId));
      } else if (entityType === 'teacher') {
        ({ error } = await supabase.from('profiles').update({ expires_at: expiry }).eq('id', entityId));
      } else {
        return res.status(400).json({ error: 'Invalid entityType' });
      }
      if (error) {
        console.error('set-expires failed:', error.message);
        return res.status(500).json({ error: 'Could not update expiry' });
      }
      audit(supabase, user.id, 'set_expires', entityType, entityId, null, { expires_at: expiry });
      return res.status(200).json({ ok: true });
    }

    if (action === 'set-notes') {
      const { entityType, entityId, notes } = body;
      if (typeof notes !== 'string') return res.status(400).json({ error: 'notes must be a string' });

      let error;
      if (entityType === 'division') {
        ({ error } = await supabase.from('divisions').update({ notes }).eq('id', entityId));
      } else if (entityType === 'school') {
        ({ error } = await supabase.from('schools').update({ notes }).eq('id', entityId));
      } else if (entityType === 'teacher') {
        ({ error } = await supabase.from('profiles').update({ notes }).eq('id', entityId));
      } else {
        return res.status(400).json({ error: 'Invalid entityType' });
      }
      if (error) {
        console.error('set-notes failed:', error.message);
        return res.status(500).json({ error: 'Could not update notes' });
      }
      return res.status(200).json({ ok: true });
    }

    if (action === 'set-role') {
      const { userId, role } = body;
      const validRoles = ['teacher', 'school_admin', 'division_admin', 'platform_admin'];
      if (!userId) return res.status(400).json({ error: 'userId required' });
      if (!validRoles.includes(role)) return res.status(400).json({ error: 'Invalid role' });
      const { data: prevProfile } = await supabase.from('profiles').select('role').eq('id', userId).single();
      const { error } = await supabase.from('profiles').update({ role }).eq('id', userId);
      if (error) {
        console.error('set-role failed:', error.message);
        return res.status(500).json({ error: 'Could not update role' });
      }
      audit(supabase, user.id, 'set_role', 'teacher', userId, { role: prevProfile?.role }, { role });
      return res.status(200).json({ ok: true });
    }

    if (action === 'assign-role') {
      const { teacher_id, role, school_id, division_id } = body;
      const validRoles = ['teacher', 'school_admin', 'division_admin', 'platform_admin'];
      if (!teacher_id) return res.status(400).json({ error: 'teacher_id required' });
      if (!validRoles.includes(role)) return res.status(400).json({ error: 'Invalid role' });
      if (role === 'school_admin' && !school_id) return res.status(400).json({ error: 'school_id required for school_admin role' });
      if (role === 'division_admin' && !division_id) return res.status(400).json({ error: 'division_id required for division_admin role' });

      const { data: prevProfile } = await supabase
        .from('profiles').select('role, school_id, division_id').eq('id', teacher_id).single();

      const updateFields = { role };

      if (role === 'school_admin') {
        updateFields.school_id = school_id;
        updateFields.division_id = null;
      } else if (role === 'division_admin') {
        updateFields.division_id = division_id;
        updateFields.school_id = null;
      } else if (role === 'platform_admin') {
        updateFields.school_id = null;
        updateFields.division_id = null;
      } else {
        updateFields.school_id = school_id || null;
        updateFields.division_id = division_id || null;
      }

      const { error } = await supabase
        .from('profiles')
        .update(updateFields)
        .eq('id', teacher_id);

      if (error) {
        console.error('assign-role failed:', error.message);
        return res.status(500).json({ error: 'Could not assign role' });
      }

      audit(supabase, user.id, 'assign_role', 'teacher', teacher_id,
        { role: prevProfile?.role, school_id: prevProfile?.school_id, division_id: prevProfile?.division_id },
        updateFields);

      return res.status(200).json({ ok: true });
    }

    if (action === 'attach-teacher') {
      const { userId, schoolId, divisionId } = body;
      if (!userId) return res.status(400).json({ error: 'userId required' });
      const { data: prevProfile } = await supabase.from('profiles').select('school_id, division_id').eq('id', userId).single();
      const { error } = await supabase
        .from('profiles')
        .update({
          school_id:   schoolId   || null,
          division_id: divisionId || null,
        })
        .eq('id', userId);
      if (error) {
        console.error('attach-teacher failed:', error.message);
        return res.status(500).json({ error: 'Could not attach teacher' });
      }
      audit(supabase, user.id, 'attach_teacher', 'teacher', userId,
        { school_id: prevProfile?.school_id, division_id: prevProfile?.division_id },
        { school_id: schoolId || null, division_id: divisionId || null });
      return res.status(200).json({ ok: true });
    }

    if (action === 'reassign-teacher') {
      const { userId, schoolId, divisionId } = body;
      if (!userId) return res.status(400).json({ error: 'userId required' });

      const { data: prevProfile } = await supabase
        .from('profiles').select('school_id, division_id').eq('id', userId).single();

      const { error } = await supabase
        .from('profiles')
        .update({
          school_id:   schoolId   === undefined ? prevProfile?.school_id   : (schoolId   || null),
          division_id: divisionId === undefined ? prevProfile?.division_id : (divisionId || null),
        })
        .eq('id', userId);
      if (error) {
        console.error('reassign-teacher failed:', error.message);
        return res.status(500).json({ error: 'Could not reassign teacher' });
      }

      // Fetch names for the notification email
      let newSchoolName = null, newDivName = null;
      if (schoolId) {
        const { data: s } = await supabase.from('schools').select('name').eq('id', schoolId).single();
        newSchoolName = s?.name || null;
      }
      if (divisionId) {
        const { data: d } = await supabase.from('divisions').select('name').eq('id', divisionId).single();
        newDivName = d?.name || null;
      }

      // Notify the teacher — fire-and-forget
      const { data: authUser } = await supabase.auth.admin.getUserById(userId);
      const teacherEmail = authUser?.user?.email;
      if (teacherEmail) {
        sendReassignmentEmail(teacherEmail, newSchoolName, newDivName).catch(err =>
          console.error('reassignment email failed:', err.message)
        );
      }

      audit(supabase, user.id, 'reassign_teacher', 'teacher', userId,
        { school_id: prevProfile?.school_id, division_id: prevProfile?.division_id },
        { school_id: schoolId === undefined ? prevProfile?.school_id : (schoolId || null),
          division_id: divisionId === undefined ? prevProfile?.division_id : (divisionId || null) });
      return res.status(200).json({ ok: true });
    }

    if (action === 'create-division') {
      const { name, enrolmentBand, adminEmail, tier } = body;
      if (!name) return res.status(400).json({ error: 'name required' });
      const { data, error } = await supabase
        .from('divisions')
        .insert({ name, enrolment_band: enrolmentBand || null, admin_email: adminEmail || null, tier: tier || 'free' })
        .select()
        .single();
      if (error) {
        console.error('create-division failed:', error.message);
        return res.status(500).json({ error: 'Could not create division' });
      }
      return res.status(200).json(data);
    }

    if (action === 'create-school') {
      const { name, divisionId, adminEmail, tier } = body;
      if (!name) return res.status(400).json({ error: 'name required' });
      const { data, error } = await supabase
        .from('schools')
        .insert({ name, division_id: divisionId || null, admin_email: adminEmail || null, tier: tier || 'free' })
        .select()
        .single();
      if (error) {
        console.error('create-school failed:', error.message);
        return res.status(500).json({ error: 'Could not create school' });
      }
      return res.status(200).json(data);
    }

    if (action === 'approve-request') {
      const { requestId, schoolId, divisionId } = body;
      if (!requestId) return res.status(400).json({ error: 'requestId required' });

      const { data: req, error: reqErr } = await supabase
        .from('teacher_requests').select('email, teacher_id, request_type').eq('id', requestId).single();
      if (reqErr || !req) return res.status(404).json({ error: 'Request not found' });

      // In-app request from an existing teacher — update profile directly
      if (req.teacher_id) {
        const updatePayload = {};
        const newExpires = new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toISOString();

        if (req.request_type === 'premium_trial') {
          updatePayload.tier = 'premium';
          updatePayload.expires_at = newExpires;
        } else if (req.request_type === 'school_plan') {
          updatePayload.school_id = schoolId || null;
        } else if (req.request_type === 'division_plan') {
          updatePayload.division_id = divisionId || null;
        }

        const { error: updErr } = await supabase
          .from('profiles').update(updatePayload).eq('id', req.teacher_id);
        if (updErr) {
          console.error('approve-request profile update failed:', updErr.message);
          return res.status(500).json({ error: 'Could not update teacher profile' });
        }

        await supabase.from('teacher_requests').update({
          status:      'approved',
          reviewed_at: new Date().toISOString(),
          reviewed_by: user.id,
        }).eq('id', requestId);

        audit(supabase, user.id, 'approve_request', 'teacher_request', requestId, null,
          { email: req.email, teacher_id: req.teacher_id, request_type: req.request_type });

        return res.status(200).json({ ok: true });
      }

      // External access request — create invitation (existing behaviour)
      const { data: invite, error: invErr } = await supabase
        .from('invitations')
        .insert({
          email:       req.email,
          role:        'teacher',
          school_id:   schoolId   || null,
          division_id: divisionId || null,
        })
        .select('id, token')
        .single();
      if (invErr) return res.status(500).json({ error: 'Could not create invitation' });

      // Mark request approved
      await supabase.from('teacher_requests').update({
        status:      'approved',
        reviewed_at: new Date().toISOString(),
        reviewed_by: user.id,
      }).eq('id', requestId);

      audit(supabase, user.id, 'approve_request', 'teacher_request', requestId, null, { email: req.email });

      const inviteUrl = `https://app.audioproctor.com/accept-invite.html?token=${invite.token}`;

      // Send invitation email
      let emailOk = true;
      let emailError = null;
      try {
        const { subject, text, html } = buildInviteEmail({ role: 'teacher', inviteUrl });
        const emailResult = await sendEmail({ to: req.email, subject, text, html });
        if (!emailResult.ok) {
          emailOk = false;
          emailError = emailResult.error;
        }
      } catch (err) {
        emailOk = false;
        emailError = err.message;
      }

      logInviteEmail(supabase, invite.id, 'approve_request', emailOk, emailError);

      return res.status(200).json({ ok: true, inviteUrl, token: invite.token, emailOk, emailError });
    }

    if (action === 'invite') {
      const { email, role, schoolId, divisionId } = body;
      if (!email) return res.status(400).json({ error: 'email required' });
      if (!role) return res.status(400).json({ error: 'role required' });

      const { data: invite, error: invErr } = await supabase
        .from('invitations')
        .insert({
          email,
          role,
          school_id:   schoolId   || null,
          division_id: divisionId || null,
        })
        .select('id, token')
        .single();
      if (invErr) return res.status(500).json({ error: 'Could not create invitation' });

      const inviteUrl = `https://app.audioproctor.com/accept-invite.html?token=${invite.token}`;

      let emailOk = true;
      let emailError = null;
      try {
        const { subject, text, html } = buildInviteEmail({ role, inviteUrl });
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

      audit(supabase, user.id, 'invite', 'invitation', invite.token, null, { email, role, emailOk });

      return res.status(200).json({ ok: true, inviteUrl, token: invite.token, emailOk, emailError });
    }

    if (action === 'resend-invite') {
      const { invitationId } = body;
      if (!invitationId) return res.status(400).json({ error: 'invitationId required' });

      const { data: invite, error: fetchErr } = await supabase
        .from('invitations')
        .select('id, email, role, school_id, division_id, token, accepted_at, schools(name), divisions(name)')
        .eq('id', invitationId)
        .single();

      if (fetchErr || !invite) return res.status(404).json({ error: 'Invitation not found' });
      if (invite.accepted_at) return res.status(400).json({ error: 'Invitation already accepted' });

      const newExpires = new Date(Date.now() + 7 * 24 * 60 * 60 * 1000).toISOString();
      const { error: updateErr } = await supabase
        .from('invitations')
        .update({ expires_at: newExpires })
        .eq('id', invitationId);

      if (updateErr) {
        console.error('resend-invite update failed:', updateErr.message);
        return res.status(500).json({ error: 'Could not update invitation' });
      }

      const inviteUrl = `https://app.audioproctor.com/accept-invite.html?token=${invite.token}`;
      let emailOk = true;
      let emailError = null;
      try {
        const orgName = invite.schools?.name || invite.divisions?.name || null;
        const { subject, text, html } = buildInviteEmail({ role: invite.role, inviteUrl, orgName });
        const emailResult = await sendEmail({ to: invite.email, subject, text, html });
        if (!emailResult.ok) {
          emailOk = false;
          emailError = emailResult.error;
        }
      } catch (err) {
        emailOk = false;
        emailError = err.message;
      }

      logInviteEmail(supabase, invite.id, 'resend', emailOk, emailError);

      audit(supabase, user.id, 'resend_invite', 'invitation', invite.token, null, { email: invite.email, role: invite.role, emailOk });
      return res.status(200).json({ ok: true, inviteUrl, emailOk, emailError });
    }

    if (action === 'reject-request') {
      const { requestId, notes } = body;
      if (!requestId) return res.status(400).json({ error: 'requestId required' });

      const { error } = await supabase.from('teacher_requests').update({
        status:      'rejected',
        notes:       notes || null,
        reviewed_at: new Date().toISOString(),
        reviewed_by: user.id,
      }).eq('id', requestId);

      if (error) return res.status(500).json({ error: 'Could not reject request' });

      audit(supabase, user.id, 'reject_request', 'teacher_request', requestId, null, { notes: notes || null });
      return res.status(200).json({ ok: true });
    }

    if (action === 'seed-demo') {
      try {
        const result = await seedDemoData(supabase);
        return res.status(200).json({ ok: true, ...result });
      } catch (err) {
        console.error('seed-demo failed:', err);
        return res.status(500).json({ error: err.message });
      }
    }

    if (action === 'delete-teacher') {
      const { userId } = body;
      if (!userId) return res.status(400).json({ error: 'userId required' });
      if (userId === user.id) return res.status(400).json({ error: 'You cannot delete your own account' });

      const { data: targetProfile } = await supabase.from('profiles').select('role, display_name').eq('id', userId).single();
      if (!targetProfile) return res.status(404).json({ error: 'Teacher not found' });
      if (targetProfile.role === 'platform_admin') return res.status(403).json({ error: 'Cannot delete platform admin accounts' });

      const { data: uploads } = await supabase.from('uploads').select('storage_path').eq('teacher_id', userId);
      const uniquePaths = [...new Set((uploads || []).map(u => u.storage_path))];

      if (uniquePaths.length > 0) {
        await supabase.storage.from('audio-files').remove(uniquePaths);
      }

      const { error: uploadsErr } = await supabase.from('uploads').delete().eq('teacher_id', userId);
      if (uploadsErr) {
        console.error('delete-teacher: uploads delete failed:', uploadsErr.message);
        return res.status(500).json({ error: 'Could not delete teacher uploads' });
      }

      const { error: profileErr } = await supabase.from('profiles').delete().eq('id', userId);
      if (profileErr) {
        console.error('delete-teacher: profile delete failed:', profileErr.message);
        return res.status(500).json({ error: 'Could not delete teacher profile' });
      }

      audit(supabase, user.id, 'delete_teacher', 'teacher', userId,
        { role: targetProfile.role, display_name: targetProfile.display_name, storage_files: uniquePaths.length }, null);

      const { error: authErr } = await supabase.auth.admin.deleteUser(userId);
      if (authErr) {
        console.error('delete-teacher: auth delete failed:', authErr.message);
        return res.status(500).json({ error: 'Could not complete teacher deletion. Teacher data was removed but auth record remains.' });
      }

      return res.status(200).json({ ok: true });
    }

    if (action === 'delete-school') {
      const { schoolId } = body;
      if (!schoolId) return res.status(400).json({ error: 'schoolId required' });

      const { data: school, error: schoolErr } = await supabase.from('schools').select('name').eq('id', schoolId).single();
      if (schoolErr || !school) return res.status(404).json({ error: 'School not found' });

      const { count: teacherCount } = await supabase.from('profiles').select('id', { count: 'exact', head: true }).eq('school_id', schoolId);

      const { error } = await supabase.from('schools').delete().eq('id', schoolId);
      if (error) {
        console.error('delete-school failed:', error.message);
        return res.status(500).json({ error: 'Could not delete school' });
      }

      audit(supabase, user.id, 'delete_school', 'school', schoolId,
        { name: school.name, attached_teachers: teacherCount || 0 }, null);
      return res.status(200).json({ ok: true });
    }

    if (action === 'delete-division') {
      const { divisionId } = body;
      if (!divisionId) return res.status(400).json({ error: 'divisionId required' });

      const { data: division, error: divErr } = await supabase.from('divisions').select('name').eq('id', divisionId).single();
      if (divErr || !division) return res.status(404).json({ error: 'Division not found' });

      const { count: schoolCount } = await supabase.from('schools').select('id', { count: 'exact', head: true }).eq('division_id', divisionId);
      const { count: teacherCount } = await supabase.from('profiles').select('id', { count: 'exact', head: true }).eq('division_id', divisionId);

      const { error } = await supabase.from('divisions').delete().eq('id', divisionId);
      if (error) {
        console.error('delete-division failed:', error.message);
        return res.status(500).json({ error: 'Could not delete division' });
      }

      audit(supabase, user.id, 'delete_division', 'division', divisionId,
        { name: division.name, attached_schools: schoolCount || 0, attached_teachers: teacherCount || 0 }, null);
      return res.status(200).json({ ok: true });
    }

    if (action === 'toggle-deactivation') {
      const { userId, deactivated } = body;
      if (!userId) return res.status(400).json({ error: 'userId required' });
      if (userId === user.id) return res.status(400).json({ error: 'You cannot deactivate your own account' });
      if (typeof deactivated !== 'boolean') return res.status(400).json({ error: 'deactivated must be a boolean' });

      const { data: targetProfile } = await supabase.from('profiles').select('role, is_deactivated, display_name').eq('id', userId).single();
      if (!targetProfile) return res.status(404).json({ error: 'Teacher not found' });
      if (targetProfile.role === 'platform_admin') return res.status(403).json({ error: 'Cannot modify platform admin accounts' });

      const { error } = await supabase.from('profiles').update({ is_deactivated: deactivated }).eq('id', userId);
      if (error) {
        console.error('toggle-deactivation failed:', error.message);
        return res.status(500).json({ error: 'Could not update deactivation status' });
      }

      audit(supabase, user.id, deactivated ? 'deactivate_teacher' : 'reactivate_teacher', 'teacher', userId,
        { is_deactivated: targetProfile.is_deactivated }, { is_deactivated: deactivated });
      return res.status(200).json({ ok: true, is_deactivated: deactivated });
    }

    // ── cancel-subscription ────────────────────────────────────────────
    // Platform admin: cancel a school's or division's Stripe subscription
    // with proration. Proration creates credit toward the customer's balance,
    // which is useful when a school joins a division or an org is restructured.
    if (action === 'cancel-subscription') {
      const { entityType, entityId } = body;
      if (!entityType || !entityId) return res.status(400).json({ error: 'entityType and entityId required' });
      if (!['school', 'division'].includes(entityType)) {
        return res.status(400).json({ error: 'entityType must be school or division' });
      }

      let entity;
      if (entityType === 'school') {
        const { data: school } = await supabase.from('schools').select('id, name, stripe_subscription_id, tier').eq('id', entityId).maybeSingle();
        entity = school;
      } else {
        const { data: division } = await supabase.from('divisions').select('id, name, stripe_subscription_id, tier').eq('id', entityId).maybeSingle();
        entity = division;
      }

      if (!entity) return res.status(404).json({ error: `${entityType} not found` });
      if (!entity.stripe_subscription_id) {
        return res.status(400).json({ error: `${entity.name} has no active subscription` });
      }

      const stripe = Stripe(process.env.STRIPE_SECRET_KEY);
      try {
        await stripe.subscriptions.update(entity.stripe_subscription_id, {
          cancellation_details: { comment: `Canceled by platform admin (${user.id})` },
          proration_behavior: 'create_prorations',
        });
      } catch (err) {
        console.error('cancel-subscription stripe failed:', err.message);
        return res.status(500).json({ error: `Stripe error: ${err.message}` });
      }

      if (entityType === 'school') {
        await supabase.from('schools').update({
          tier: 'free',
          stripe_subscription_id: null,
          stripe_subscription_status: 'canceled',
          cancelled_at: new Date().toISOString()
        }).eq('id', entityId);
      } else {
        await supabase.from('divisions').update({
          tier: 'free',
          stripe_subscription_id: null,
          stripe_subscription_status: 'canceled',
          cancelled_at: new Date().toISOString()
        }).eq('id', entityId);
      }

      audit(supabase, user.id, 'cancel_subscription', entityType, entityId, { tier: entity.tier }, { tier: 'free' });
      return res.status(200).json({ ok: true });
    }

    return res.status(400).json({ error: 'Unknown action' });
  }

  return res.status(405).json({ error: 'Method not allowed' });
};

// ─── Demo data helpers ────────────────────────────────────────────────────

const DEMO_PERSONAS = [
  { key: 'marcus',  email: 'm.vance@apsd.net',                    name: 'Marcus Vance',    role: 'division_admin', orgKey: 'div' },
  { key: 'elena',   email: 'e.rodriguez@silverwood.apsd.net',      name: 'Elena Rodriguez', role: 'school_admin',   orgKey: 'sil' },
  { key: 'julian',  email: 'j.thorne@silverwood.apsd.net',         name: 'Julian Thorne',   role: 'teacher',        orgKey: 'sil' },
  { key: 'sarah',   email: 's.jenkins@silverwood.apsd.net',        name: 'Sarah Jenkins',   role: 'teacher',        orgKey: 'sil' },
  { key: 'david',   email: 'd.wu@silverwood.apsd.net',             name: 'David Wu',        role: 'teacher',        orgKey: 'sil' },
  { key: 'chloe',   email: 'c.simmons@horizoncharter.org',         name: 'Chloe Simmons',   role: 'school_admin',   orgKey: 'hor' },
  { key: 'robert',  email: 'r.finch@horizoncharter.org',           name: 'Robert Finch',    role: 'teacher',        orgKey: 'hor' },
  { key: 'linda',   email: 'l.grewal@horizoncharter.org',          name: 'Linda Grewal',    role: 'teacher',        orgKey: 'hor' },
  { key: 'thomas',  email: 't.beck@horizoncharter.org',            name: 'Thomas Beck',     role: 'teacher',        orgKey: 'hor' },
];

const DEMO_UPLOAD_SPECS = [
  // Julian Thorne — active user, 12 weeks of history
  { teacher: 'julian', code: 'THO-001', label: 'ELA 20-1 Oral Reading Component',    exit: 'submit',   fileMb: 8.2,  students: 24, completion: 0.88, replay: 0.15, weeksAgo: 12  },
  { teacher: 'julian', code: 'THO-002', label: 'Biology 20 Audio Supplement',         exit: 'done',     fileMb: 5.4,  students: 22, completion: 0.73, replay: 0.25, weeksAgo: 10  },
  { teacher: 'julian', code: 'THO-003', label: 'Science 10 Listening Assessment',     exit: 'finished', fileMb: 6.1,  students: 27, completion: 0.92, replay: 0.10, weeksAgo: 8   },
  { teacher: 'julian', code: 'THO-004', label: 'Math 20-1 Word Problems Audio',       exit: 'complete', fileMb: 11.3, students: 25, completion: 0.64, replay: 0.38, weeksAgo: 7   },
  { teacher: 'julian', code: 'THO-005', label: 'Social Studies 10-1 Audio Guide',     exit: 'exit',     fileMb: 7.8,  students: 23, completion: 0.83, replay: 0.12, weeksAgo: 5   },
  { teacher: 'julian', code: 'THO-006', label: 'Chemistry 20 Lab Instructions',       exit: 'submit',   fileMb: 9.5,  students: 20, completion: 0.90, replay: 0.20, weeksAgo: 3   },
  { teacher: 'julian', code: 'THO-007', label: 'ELA 30-1 Listening Component',        exit: 'done',     fileMb: 4.9,  students: 19, completion: 0.79, replay: 0.16, weeksAgo: 2   },
  { teacher: 'julian', code: 'THO-008', label: 'Physics 20 Audio Assessment',         exit: 'finished', fileMb: 6.7,  students: 21, completion: 0.86, replay: 0.14, weeksAgo: 1   },
  // Sarah Jenkins — 9 weeks of history
  { teacher: 'sarah',  code: 'JEN-001', label: 'English 10-1 Reading Passage',        exit: 'submit',   fileMb: 5.2,  students: 28, completion: 0.86, replay: 0.11, weeksAgo: 9   },
  { teacher: 'sarah',  code: 'JEN-002', label: 'English 20-1 Oral Assessment',        exit: 'done',     fileMb: 7.1,  students: 26, completion: 0.77, replay: 0.19, weeksAgo: 7   },
  { teacher: 'sarah',  code: 'JEN-003', label: 'Drama 10 Audio Script',               exit: 'exit',     fileMb: 3.8,  students: 18, completion: 0.94, replay: 0.08, weeksAgo: 5   },
  { teacher: 'sarah',  code: 'JEN-004', label: 'English 30-1 Comprehension',          exit: 'complete', fileMb: 8.6,  students: 24, completion: 0.71, replay: 0.27, weeksAgo: 3   },
  { teacher: 'sarah',  code: 'JEN-005', label: 'English 10-2 Listening Assessment',   exit: 'submit',   fileMb: 6.3,  students: 30, completion: 0.83, replay: 0.13, weeksAgo: 1   },
  // David Wu — 6 weeks of history
  { teacher: 'david',  code: 'WUU-001', label: 'Computer Science 20 Lab Audio',       exit: 'done',     fileMb: 4.1,  students: 22, completion: 0.91, replay: 0.09, weeksAgo: 6   },
  { teacher: 'david',  code: 'WUU-002', label: 'Math 30-1 Applications Audio',        exit: 'submit',   fileMb: 12.4, students: 19, completion: 0.68, replay: 0.32, weeksAgo: 4   },
  { teacher: 'david',  code: 'WUU-003', label: 'Pre-Calculus 20 Word Problems',       exit: 'finished', fileMb: 10.2, students: 25, completion: 0.60, replay: 0.40, weeksAgo: 2   },
  { teacher: 'david',  code: 'WUU-004', label: 'Math 20-3 Data Analysis Audio',       exit: 'exit',     fileMb: 5.8,  students: 20, completion: 0.80, replay: 0.20, weeksAgo: 0.5 },
  // Robert Finch — 5 weeks
  { teacher: 'robert', code: 'FIN-001', label: 'Social Studies 30-1 Audio Guide',     exit: 'submit',   fileMb: 9.3,  students: 20, completion: 0.85, replay: 0.15, weeksAgo: 5   },
  { teacher: 'robert', code: 'FIN-002', label: 'History 20 Audio Documentary',        exit: 'done',     fileMb: 15.7, students: 22, completion: 0.77, replay: 0.23, weeksAgo: 4   },
  { teacher: 'robert', code: 'FIN-003', label: 'Geography 20 Audio Assessment',       exit: 'complete', fileMb: 7.2,  students: 18, completion: 0.89, replay: 0.11, weeksAgo: 3   },
  { teacher: 'robert', code: 'FIN-004', label: 'Social Studies 10-2 Oral',            exit: 'exit',     fileMb: 6.4,  students: 24, completion: 0.75, replay: 0.20, weeksAgo: 2   },
  { teacher: 'robert', code: 'FIN-005', label: 'Indigenous Studies 10 Audio',         exit: 'submit',   fileMb: 8.1,  students: 21, completion: 0.90, replay: 0.10, weeksAgo: 1   },
  // Linda Grewal — 4 weeks
  { teacher: 'linda',  code: 'GRE-001', label: 'Biology 30 Lab Audio Instructions',   exit: 'done',     fileMb: 11.2, students: 16, completion: 0.88, replay: 0.19, weeksAgo: 4   },
  { teacher: 'linda',  code: 'GRE-002', label: 'Earth Science 20 Audio Notes',        exit: 'finished', fileMb: 8.5,  students: 20, completion: 0.80, replay: 0.25, weeksAgo: 2   },
  { teacher: 'linda',  code: 'GRE-003', label: 'Science 20 Listening Assessment',     exit: 'submit',   fileMb: 6.9,  students: 18, completion: 0.72, replay: 0.22, weeksAgo: 1   },
  // Thomas Beck — 2 weeks
  { teacher: 'thomas', code: 'BEC-001', label: 'Physical Education 10 Audio',         exit: 'done',     fileMb: 3.2,  students: 28, completion: 0.96, replay: 0.04, weeksAgo: 2   },
  { teacher: 'thomas', code: 'BEC-002', label: 'Health 20 Audio Assessment',          exit: 'submit',   fileMb: 5.5,  students: 25, completion: 0.88, replay: 0.12, weeksAgo: 1   },
];

// SHA-256 hex of str (lowercased + trimmed) — same algo as browser Web Crypto
function sha256Hex(str) {
  return crypto.createHash('sha256').update(str.toLowerCase().trim()).digest('hex');
}

// Returns a random ISO timestamp during Alberta school hours (9am–2pm MDT)
// on a weekday approximately weeksAgo weeks in the past (±2 days jitter).
function schoolTime(weeksAgo) {
  const jitter = (Math.random() - 0.5) * 4 * 24 * 60 * 60 * 1000;
  let d = new Date(Date.now() - weeksAgo * 7 * 24 * 60 * 60 * 1000 + jitter);
  while (d.getUTCDay() === 0 || d.getUTCDay() === 6) {
    d = new Date(d.getTime() + 24 * 60 * 60 * 1000);
  }
  // 9am–2pm MDT = UTC−6 → 15:00–20:00 UTC
  d.setUTCHours(15 + Math.floor(Math.random() * 5), Math.floor(Math.random() * 60), 0, 0);
  return d.toISOString();
}

async function seedDemoData(supabase) {
  const report = { usersCreated: 0, usersFound: 0, uploads: 0, events: 0 };

  // 1. Resolve or create all auth users
  const emailMap = await getAllUserEmails(supabase);
  const byEmail = {};
  Object.entries(emailMap).forEach(([id, email]) => { byEmail[email] = id; });

  const userId = {}; // personaKey → uuid
  for (const p of DEMO_PERSONAS) {
    if (byEmail[p.email]) {
      userId[p.key] = byEmail[p.email];
      report.usersFound++;
    } else {
      const { data: created, error } = await supabase.auth.admin.createUser({
        email: p.email,
        email_confirm: true,
        user_metadata: { full_name: p.name },
      });
      if (error) throw new Error(`createUser ${p.email}: ${error.message}`);
      userId[p.key] = created.user.id;
      report.usersCreated++;
    }
  }

  // 2. Find or create division
  let divisionId;
  const { data: existingDiv } = await supabase
    .from('divisions').select('id').eq('name', 'Aspen Peaks School Division').maybeSingle();
  if (existingDiv) {
    divisionId = existingDiv.id;
  } else {
    const { data: newDiv, error } = await supabase
      .from('divisions')
      .insert({ name: 'Aspen Peaks School Division', tier: 'division', admin_email: 'm.vance@apsd.net', enrolment_band: 'medium' })
      .select('id').single();
    if (error) throw new Error('create division: ' + error.message);
    divisionId = newDiv.id;
  }

  // 3. Find or create schools
  let silverwoodId, horizonId;
  const { data: existingSil } = await supabase
    .from('schools').select('id').eq('name', 'Silverwood High').maybeSingle();
  if (existingSil) {
    silverwoodId = existingSil.id;
  } else {
    const { data: newSil, error } = await supabase
      .from('schools')
      .insert({ name: 'Silverwood High', division_id: divisionId, tier: 'division', admin_email: 'e.rodriguez@silverwood.apsd.net' })
      .select('id').single();
    if (error) throw new Error('create Silverwood High: ' + error.message);
    silverwoodId = newSil.id;
  }
  const { data: existingHor } = await supabase
    .from('schools').select('id').eq('name', 'Horizon Charter Academy').maybeSingle();
  if (existingHor) {
    horizonId = existingHor.id;
  } else {
    const { data: newHor, error } = await supabase
      .from('schools')
      .insert({ name: 'Horizon Charter Academy', tier: 'school', admin_email: 'c.simmons@horizoncharter.org' })
      .select('id').single();
    if (error) throw new Error('create Horizon Charter: ' + error.message);
    horizonId = newHor.id;
  }

  const schoolIds = { sil: silverwoodId, hor: horizonId };

  // 4. Upsert profiles
  const profileRows = DEMO_PERSONAS.map(p => ({
    id:              userId[p.key],
    display_name:    p.name,
    role:            p.role,
    school_id:       p.orgKey === 'div' ? null : schoolIds[p.orgKey],
    division_id:     p.orgKey === 'div' ? divisionId : null,
    tier:            'free',
    country_code:    'CA',
    storage_used_mb: 0,
  }));
  const { error: profileErr } = await supabase.from('profiles').upsert(profileRows, { onConflict: 'id' });
  if (profileErr) throw new Error('upsert profiles: ' + profileErr.message);

  // 5. Remove existing demo uploads and their events (idempotent)
  const demoCodes = DEMO_UPLOAD_SPECS.map(s => s.code);
  const { data: oldUploads } = await supabase.from('uploads').select('id').in('access_code', demoCodes);
  if (oldUploads?.length) {
    const oldIds = oldUploads.map(u => u.id);
    await supabase.from('session_events').delete().in('upload_id', oldIds);
    await supabase.from('uploads').delete().in('id', oldIds);
  }

  // 6. Insert uploads
  const expiresAt = new Date(Date.now() + 180 * 24 * 60 * 60 * 1000).toISOString();
  const uploadRows = DEMO_UPLOAD_SPECS.map(spec => ({
    teacher_id:      userId[spec.teacher],
    filename:        spec.code.replace('-', '').toLowerCase() + '.mp3',
    label:           spec.label,
    storage_path:    `demo/${spec.code.replace('-', '').toLowerCase()}.mp3`,
    access_code:     spec.code,
    exit_word:       spec.exit,
    exit_word_hash:  sha256Hex(spec.exit),
    expires_at:      expiresAt,
    file_size_mb:    spec.fileMb,
    created_at:      schoolTime(spec.weeksAgo + 0.5),
  }));
  const { data: insertedUploads, error: uploadErr } = await supabase
    .from('uploads').insert(uploadRows).select('id, access_code');
  if (uploadErr) throw new Error('insert uploads: ' + uploadErr.message);
  report.uploads = insertedUploads.length;

  const uploadIdByCode = {};
  insertedUploads.forEach(u => { uploadIdByCode[u.access_code] = u.id; });

  // Update storage_used_mb on each teacher's profile
  const storageMb = {};
  DEMO_UPLOAD_SPECS.forEach(s => { storageMb[s.teacher] = (storageMb[s.teacher] || 0) + s.fileMb; });
  for (const [key, mb] of Object.entries(storageMb)) {
    await supabase.from('profiles').update({ storage_used_mb: Math.round(mb * 10) / 10 }).eq('id', userId[key]);
  }

  // 7. Generate session events
  const allEvents = [];
  for (const spec of DEMO_UPLOAD_SPECS) {
    const uploadId = uploadIdByCode[spec.code];
    const audioSecs = Math.round(spec.fileMb * 55); // ~1MB/min at 128kbps

    for (let i = 0; i < spec.students; i++) {
      const base = new Date(schoolTime(spec.weeksAgo - Math.random() * 0.4));

      allEvents.push({ upload_id: uploadId, event_type: 'code_entered', occurred_at: base.toISOString() });

      const playDelay = 15 + Math.random() * 20;
      const playMs = base.getTime() + playDelay * 1000;
      allEvents.push({ upload_id: uploadId, event_type: 'playback_started',
        occurred_at: new Date(playMs).toISOString(), metadata: { position_seconds: 0 } });

      // Maybe pause/resume (28% of students)
      if (Math.random() < 0.28) {
        const pausePos = Math.floor(audioSecs * (0.25 + Math.random() * 0.5));
        allEvents.push({ upload_id: uploadId, event_type: 'playback_paused',
          occurred_at: new Date(playMs + pausePos * 1000).toISOString(),
          metadata: { position_seconds: pausePos } });
        allEvents.push({ upload_id: uploadId, event_type: 'playback_resumed',
          occurred_at: new Date(playMs + pausePos * 1000 + (12 + Math.random() * 20) * 1000).toISOString(),
          metadata: { position_seconds: pausePos } });
      }

      // Maybe replay
      if (Math.random() < spec.replay) {
        const replayPos = Math.floor(audioSecs * (0.45 + Math.random() * 0.35));
        allEvents.push({ upload_id: uploadId, event_type: 'replay_triggered',
          occurred_at: new Date(playMs + replayPos * 1000).toISOString(),
          metadata: { position_seconds: replayPos } });
      }

      // Completion
      if (Math.random() < spec.completion) {
        allEvents.push({ upload_id: uploadId, event_type: 'playback_completed',
          occurred_at: new Date(playMs + audioSecs * 1000).toISOString(),
          metadata: { position_seconds: audioSecs } });
        allEvents.push({ upload_id: uploadId, event_type: 'exit_word_used',
          occurred_at: new Date(playMs + audioSecs * 1000 + (8 + Math.random() * 45) * 1000).toISOString() });
      }
    }
  }

  // Bulk-insert in chunks of 500
  for (let i = 0; i < allEvents.length; i += 500) {
    const { error: evErr } = await supabase.from('session_events').insert(allEvents.slice(i, i + 500));
    if (evErr) throw new Error(`session_events chunk ${i}: ${evErr.message}`);
  }
  report.events = allEvents.length;

  // 8. Refresh materialized view immediately (requires migration 010)
  const { error: refreshErr } = await supabase.rpc('refresh_upload_summaries');
  if (refreshErr) console.warn('refresh_upload_summaries rpc failed:', refreshErr.message);

  // 9. Seed fake requests and invitations for dev testing
  // Clean old seed data first
  await supabase.from('teacher_requests').delete().ilike('email', 'seed-%@example.com');
  await supabase.from('invitations').delete().ilike('email', 'seed-%@example.com');

  const { error: reqErr } = await supabase.from('teacher_requests').insert([
    { name: 'Alice Tremblay', email: 'seed-alice@example.com', school: 'École Secondaire Laurier', division: 'FrancoSud', message: 'Requesting premium trial for oral reading assessments.', status: 'pending', request_type: 'premium_trial', created_at: new Date(Date.now() - 2 * 24 * 60 * 60 * 1000).toISOString() },
    { name: 'Bob Singh', email: 'seed-bob@example.com', school: 'William Aberhart High', division: 'Calgary Board of Education', message: 'School plan pilot request.', status: 'pending', request_type: 'school_plan', created_at: new Date(Date.now() - 5 * 24 * 60 * 60 * 1000).toISOString() },
    { name: 'Carla Nguyen', email: 'seed-carla@example.com', school: 'Ross Sheppard High', division: 'Edmonton Public Schools', status: 'pending', request_type: 'access', created_at: new Date(Date.now() - 1 * 24 * 60 * 60 * 1000).toISOString() },
    { name: 'David Okafor', email: 'seed-david@example.com', school: 'Lester B. Pearson High', division: 'Calgary Board of Education', message: 'Already approved.', status: 'approved', request_type: 'premium_trial', created_at: new Date(Date.now() - 10 * 24 * 60 * 60 * 1000).toISOString() },
    { name: 'Emma Larsson', email: 'seed-emma@example.com', school: 'Queen Elizabeth High', message: 'Rejected earlier.', status: 'rejected', request_type: 'premium_trial', created_at: new Date(Date.now() - 14 * 24 * 60 * 60 * 1000).toISOString() },
    { name: 'Frank Deluca', email: 'seed-frank@example.com', school: 'Bishop Carroll High', division: 'Calgary Catholic School District', message: 'Division-wide interest.', status: 'pending', request_type: 'division_plan', created_at: new Date(Date.now() - 3 * 24 * 60 * 60 * 1000).toISOString() },
  ]);
  if (reqErr) console.warn('seed demo requests failed:', reqErr.message);

  const [{ data: aDiv }, { data: aSchool }] = await Promise.all([
    supabase.from('divisions').select('id').limit(1).maybeSingle(),
    supabase.from('schools').select('id').limit(1).maybeSingle(),
  ]);
  const { error: invErr } = await supabase.from('invitations').insert([
    { email: 'seed-invite-1@example.com', role: 'teacher', expires_at: new Date(Date.now() + 5 * 24 * 60 * 60 * 1000).toISOString() },
    { email: 'seed-invite-2@example.com', role: 'school_admin', school_id: aSchool?.id || null, expires_at: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000).toISOString() },
    { email: 'seed-invite-3@example.com', role: 'teacher', division_id: aDiv?.id || null, expires_at: new Date(Date.now() - 3 * 24 * 60 * 60 * 1000).toISOString() },
    { email: 'seed-invite-4@example.com', role: 'teacher', expires_at: new Date(Date.now() + 1 * 24 * 60 * 60 * 1000).toISOString() },
  ]);
  if (invErr) console.warn('seed demo invitations failed:', invErr.message);

  return report;
}

// ─── Audit log helper ─────────────────────────────────────────────────────
// Fire-and-forget — never fails the request that triggered it.

function audit(supabase, actorId, action, targetType, targetId, before, after) {
  supabase.from('admin_audit_log').insert({
    actor_id:    actorId,
    action,
    target_type: targetType,
    target_id:   targetId,
    before_value: before ?? null,
    after_value:  after  ?? null,
  }).then(({ error }) => {
    if (error) console.error('audit log insert failed:', error.message);
  });
}

function logInviteEmail(supabase, invitationId, action, emailOk, errorMessage) {
  supabase.from('invite_email_log').insert({
    invitation_id: invitationId ?? null,
    action,
    email_ok:      emailOk ?? null,
    error_message: errorMessage ?? null,
  }).then(({ error }) => {
    if (error) console.error('invite email log insert failed:', error.message);
  });
}

// ─── Email helper: teacher reassignment ───────────────────────────────────
// Notifies a teacher that they have been assigned to a new school/division.
// Names the specific organization(s) to reduce confusion.

async function sendReassignmentEmail(teacherEmail, schoolName, divisionName) {
  const { Resend } = require('resend');
  const resend = new Resend(process.env.RESEND_API_KEY);

  let orgText = '';
  if (schoolName && divisionName) {
    orgText = `${schoolName}, ${divisionName}`;
  } else if (schoolName) {
    orgText = schoolName;
  } else if (divisionName) {
    orgText = divisionName;
  } else {
    orgText = 'no organization (unattached)';
  }

  await resend.emails.send({
    from:    'AudioProctor <hello@audioproctor.com>',
    to:      teacherEmail,
    subject: 'Your AudioProctor organization has changed',
    text: [
      `Hi,`,
      ``,
      `Your account has been reassigned to ${orgText} on AudioProctor.`,
      ``,
      `Your account and all of your uploaded assessments are still intact. Your plan tier`,
      `may have changed based on the organization you are now part of.`,
      ``,
      `If you believe this was done in error, please contact your administrator`,
      `or reply to this email.`,
      ``,
      `— AudioProctor`,
    ].join('\n'),
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
    if (data.users.length < perPage) break; // last page
    page++;
  }

  return emailMap;
}

