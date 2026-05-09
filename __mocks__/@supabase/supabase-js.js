// Manual mock for @supabase/supabase-js.
// This is used when vi.mock('@supabase/supabase-js') is called WITHOUT a factory.
// Uses global.__testDb (shared state from tests/setup.js) so that
// seedTable/resetTestDb/getInserts work correctly.

function getDb() {
  if (!global.__testDb) {
    global.__testDb = { tables: {}, inserts: [] };
  }
  return global.__testDb;
}

function makeChain(rows, opts = {}) {
  const c = {};

  c.then = (cb) => {
    if (opts.withCount) {
      return cb({ data: rows, error: null, count: rows.length });
    }
    return cb({ data: rows, error: null });
  };

  c.single = () => {
    return rows.length === 0
      ? { data: null, error: { message: 'no rows' } }
      : { data: rows[0], error: null };
  };

  c.maybeSingle = () => ({ data: rows[0] || null, error: null });

  c.eq = (k, v) => {
    const filtered = rows.filter(r => r[k] === v);
    return makeChain(filtered, opts);
  };

  c.gte = (k, v) => makeChain(rows.filter(r => {
    const rv = r[k];
    if (rv instanceof Date) return rv >= new Date(v);
    if (typeof rv === 'number') return rv >= v;
    return rv >= v;
  }), opts);
  c.lt = (k, v) => makeChain(rows.filter(r => {
    const rv = r[k];
    if (rv instanceof Date) return rv < new Date(v);
    if (typeof rv === 'number') return rv < v;
    return rv < v;
  }), opts);
  c.select = (fields, queryOpts) => {
    if (queryOpts && (queryOpts.count === 'exact' || queryOpts.head === true)) {
      return makeChain(rows, { ...opts, withCount: true });
    }
    return makeChain(rows, opts);
  };

  c.order = () => makeChain(rows, opts);
  c.limit = () => makeChain(rows, opts);
  c.range = () => makeChain(rows, opts);
  c.in = (k, vals) => makeChain(rows.filter(r => vals.includes(r[k])), opts);
  c.neq = (k, v) => makeChain(rows.filter(r => r[k] !== v), opts);
  c.not = (k, op, v) => makeChain(rows.filter(r => r[k] !== v), opts);
  c.or = () => makeChain(rows, opts);
  c.is = (k, v) => makeChain(rows.filter(r => r[k] === null || r[k] === undefined), opts);
  c.ilike = () => makeChain(rows, opts);

  c.delete = () => ({
    lt: () => ({ then: (cb) => cb({ error: null }) }),
    eq: () => ({ then: (cb) => cb({ error: null }) }),
    in: () => ({ then: (cb) => cb({ error: null }) }),
    ilike: () => makeChain(rows, opts),
  });

  c.insert = (data) => {
    getDb().inserts.push(data);
    return {
      then: (cb) => cb({ data: null, error: null }),
      select: () => ({
        single: () => ({ data: Array.isArray(data) ? data[0] : data, error: null }),
        then: (cb) => cb({ data: Array.isArray(data) ? data : [data], error: null }),
      }),
    };
  };

  c.upsert = (data, conf) => {
    getDb().inserts.push({ _upsert: true, data, conf });
    return { then: (cb) => cb({ data: null, error: null }) };
  };

  c.update = (fields) => ({
    eq: () => ({ then: (cb) => cb({ data: null, error: null }) }),
    in: () => ({ then: (cb) => cb({ data: null, error: null }) }),
  });

  c.filter = () => c;
  return c;
}

let authUser = { id: 'admin-1', email: 'admin@test.com' };
let authError = null;
let adminListUsersResult = null;
let adminGetUserByIdResult = null;
let signedUrlResult = null;
let signError = false;

const mockClient = {
  from: (table) => {
    const db = getDb();
    if (!db.tables[table]) db.tables[table] = [];
    return makeChain(db.tables[table]);
  },
  storage: {
    from: () => ({
      createSignedUrl: (path) => {
        if (signError) {
          return { then: (cb) => cb({ data: null, error: { message: 'sign error' } }) };
        }
        return {
          then: (cb) => cb({
            data: signedUrlResult || { signedUrl: `https://storage.test${path}?s=1` },
            error: null,
          }),
        };
      },
      remove: () => Promise.resolve({ data: null, error: null }),
    }),
  },
  auth: {
    getUser: () => authError
      ? Promise.resolve({ data: null, error: authError })
      : Promise.resolve({ data: { user: authUser }, error: null }),
    admin: {
      getUserById: (uid) => {
        if (adminGetUserByIdResult) return Promise.resolve(adminGetUserByIdResult);
        return Promise.resolve({ data: { user: { id: uid, email: 'target@test.com' } }, error: null });
      },
      deleteUser: () => Promise.resolve({ data: null, error: null }),
      createUser: (params) => Promise.resolve({ data: { user: { id: 'new-user-' + Date.now() } }, error: null }),
      generateLink: (params) => Promise.resolve({
        data: { properties: { action_link: 'https://test/link' } },
        error: null,
      }),
      listUsers: (params) => {
        if (adminListUsersResult) return Promise.resolve(adminListUsersResult);
        return Promise.resolve({ data: { users: [] }, error: null });
      },
    },
  },
  rpc: () => Promise.resolve({ data: null, error: null }),
};

// Controls for test manipulation (used by admin.test.js via getMock())
mockClient.__seed = (table, rows) => {
  getDb().tables[table] = rows;
};
mockClient.__reset = () => {
  const db = getDb();
  Object.keys(db.tables).forEach(k => delete db.tables[k]);
  db.inserts.length = 0;
  authUser = { id: 'admin-1', email: 'admin@test.com' };
  authError = null;
  adminListUsersResult = null;
  adminGetUserByIdResult = null;
  signedUrlResult = null;
  signError = false;
};
mockClient.__getInserts = () => {
  return [...(getDb().inserts || [])];
};
mockClient.__setAuthUser = (u) => { authUser = u; };
mockClient.__setAuthError = (e) => { authError = e; };
mockClient.__setAdminListUsersResult = (r) => { adminListUsersResult = r; };
mockClient.__setSignedUrlResult = (r) => { signedUrlResult = r; };
mockClient.__setSignError = (e) => { signError = e; };

// Expose mockClient globally so admin.test.js's getMock() works
global.__mockSupabaseClient = mockClient;

exports.createClient = function () {
  return mockClient;
};
