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
//   POST ?action=attach-teacher    — body: { userId, schoolId?, divisionId? }

const { createClient } = require('@supabase/supabase-js');

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
        { data: anomalies },
      ] = await Promise.all([
        supabase.from('divisions').select('id', { count: 'exact', head: true }),
        supabase.from('schools').select('id', { count: 'exact', head: true }),
        supabase.from('profiles').select('id', { count: 'exact', head: true }),
        // Anomalies: non-CA country_code or very high upload count
        supabase
          .from('profiles')
          .select('id, country_code, division_name, role, notes')
          .not('country_code', 'in', '("CA","","null")')
          .is('country_code', null)
          .limit(0), // placeholder — real anomaly query below
      ]);

      // Anomaly: profiles where country_code is not CA (and not null/empty)
      const { data: foreignAccounts } = await supabase
        .from('profiles')
        .select('id, country_code, division_name')
        .not('country_code', 'in', '("CA")')
        .not('country_code', 'is', null)
        .neq('country_code', '');

      return res.status(200).json({
        divisionCount:  divCount  || 0,
        schoolCount:    schoolCount || 0,
        teacherCount:   teacherCount || 0,
        anomalies:      foreignAccounts || [],
      });
    }

    if (action === 'divisions') {
      const { data, error } = await supabase
        .from('divisions')
        .select('id, name, enrolment_band, tier, admin_email, notes, expires_at, created_at')
        .order('created_at', { ascending: false });
      if (error) return res.status(500).json({ error: error.message });
      return res.status(200).json(data);
    }

    if (action === 'schools') {
      const { data, error } = await supabase
        .from('schools')
        .select('id, name, tier, admin_email, notes, expires_at, created_at, divisions(name)')
        .order('created_at', { ascending: false });
      if (error) return res.status(500).json({ error: error.message });
      return res.status(200).json(data);
    }

    if (action === 'teachers') {
      const { data, error } = await supabase
        .from('profiles')
        .select(`
          id, role, tier, tier_override, country_code, division_name, notes, school_id, division_id,
          schools(name), divisions(name)
        `)
        .order('id', { ascending: true });
      if (error) return res.status(500).json({ error: error.message });

      // Merge auth.users email — requires a separate call with service role
      const { data: authUsers } = await supabase.auth.admin.listUsers({ perPage: 1000 });
      const emailMap = {};
      (authUsers?.users || []).forEach(u => { emailMap[u.id] = u.email; });

      const teachers = (data || []).map(p => ({
        ...p,
        email: emailMap[p.id] || null,
        school_name:   p.schools?.name   || null,
        division_name_org: p.divisions?.name || null,
      }));

      return res.status(200).json(teachers);
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
      if (error) return res.status(500).json({ error: error.message });
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
      if (error) return res.status(500).json({ error: error.message });
      return res.status(200).json({ ok: true });
    }

    if (action === 'attach-teacher') {
      const { userId, schoolId, divisionId } = body;
      if (!userId) return res.status(400).json({ error: 'userId required' });
      const { error } = await supabase
        .from('profiles')
        .update({
          school_id:   schoolId   || null,
          division_id: divisionId || null,
        })
        .eq('id', userId);
      if (error) return res.status(500).json({ error: error.message });
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
      if (error) return res.status(500).json({ error: error.message });
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
      if (error) return res.status(500).json({ error: error.message });
      return res.status(200).json(data);
    }

    return res.status(400).json({ error: 'Unknown action' });
  }

  return res.status(405).json({ error: 'Method not allowed' });
};
