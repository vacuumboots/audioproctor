// ─── CJS Mock for @supabase/supabase-js ─────────────────────────────
// Used in vi.mock factories in test files via require:
//   vi.mock('@supabase/supabase-js', () => {
//     const m = require('../tests/mock-supabase.cjs');
//     return m;
//   });

function buildMakeChain(global) {
  return function makeChain(rows) {
    const c = {};
    c.then = (cb) => cb({ data: rows, error: null });
    c.single = () => rows.length > 0
      ? { data: rows[0], error: null }
      : { data: null, error: { message: 'no rows' } };
    c.maybeSingle = () => ({ data: rows[0] || null, error: null });
    c.eq = (k, v) => makeChain(rows.filter(r => r[k] === v));
    c.gte = () => makeChain(rows);
    c.lt = () => makeChain(rows);
    c.in = (k, vals) => makeChain(rows.filter(r => vals.includes(r[k])));
    c.neq = (k, v) => makeChain(rows.filter(r => r[k] !== v));
    c.not = (k, op, v) => makeChain(rows.filter(r => r[k] !== v));
    c.or = () => makeChain(rows);
    c.ilike = () => makeChain(rows);
    c.is = (k, v) => makeChain(rows.filter(r => r[k] === null || r[k] === undefined));
    c.select = (f, qo) => {
      if (qo && qo.count === 'exact') {
        const ch = makeChain(rows);
        ch.then = (cb) => cb({ data: rows, error: null, count: rows.length });
        return ch;
      }
      return makeChain(rows);
    };
    c.order = () => makeChain(rows);
    c.limit = () => makeChain(rows);
    c.range = () => makeChain(rows);
    c.insert = (d) => {
      if (global.__testDb) global.__testDb.inserts.push(d);
      return {
        then: (cb) => cb({ data: null, error: null }),
        select: () => ({
          single: () => ({ data: Array.isArray(d) ? d[0] : d, error: null }),
          then: (cb) => cb({ data: Array.isArray(d) ? d : [d], error: null }),
        }),
      };
    };
    c.upsert = (d, conf) => {
      if (global.__testDb) global.__testDb.inserts.push({ _upsert: true, data: d, conf });
      return { then: (cb) => cb({ data: null, error: null }) };
    };
    c.update = (f) => ({
      eq: () => ({ then: (cb) => cb({ data: null, error: null }) }),
      in: () => ({ then: (cb) => cb({ data: null, error: null }) }),
    });
    c.delete = () => ({
      lt: () => ({ then: (cb) => cb({ error: null }) }),
      eq: () => ({ then: (cb) => cb({ error: null }) }),
      in: () => ({ then: (cb) => cb({ error: null }) }),
      ilike: () => makeChain(rows),
    });
    c.filter = () => c;
    return c;
  };
}

function createSupabaseMock(global) {
  const makeChain = buildMakeChain(global);

  const authState = {
    authUser: { id: 'admin-1', email: 'admin@test.com' },
    authError: null,
    adminListUsersResult: null,
    adminGetUserByIdResult: null,
    signedUrlResult: null,
    signError: false,
  };

  const client = {
    from: (table) => {
      const db = global.__testDb || { tables: {} };
      if (!db.tables[table]) db.tables[table] = [];
      return makeChain(db.tables[table]);
    },
    storage: {
      from: () => ({
        createSignedUrl: (path) => authState.signError
          ? { then: (cb) => cb({ data: null, error: { message: 'sign error' } }) }
          : {
              then: (cb) => cb({
                data: authState.signedUrlResult || { signedUrl: `https://storage.test${path}?s=1` },
                error: null,
              }),
            },
        remove: () => Promise.resolve({ data: null, error: null }),
      }),
    },
    auth: {
      getUser: () => authState.authError
        ? Promise.resolve({ data: null, error: authState.authError })
        : Promise.resolve({ data: { user: authState.authUser }, error: null }),
      admin: {
        getUserById: (uid) => {
          if (authState.adminGetUserByIdResult) return Promise.resolve(authState.adminGetUserByIdResult);
          return Promise.resolve({ data: { user: { id: uid, email: 'target@test.com' } }, error: null });
        },
        deleteUser: () => Promise.resolve({ data: null, error: null }),
        createUser: (params) => Promise.resolve({ data: { user: { id: 'new-user-' + Date.now() } }, error: null }),
        generateLink: (params) => Promise.resolve({
          data: { properties: { action_link: 'https://test/link' } },
          error: null,
        }),
        listUsers: (params) => {
          if (authState.adminListUsersResult) return Promise.resolve(authState.adminListUsersResult);
          return Promise.resolve({ data: { users: [] }, error: null });
        },
      },
    },
    rpc: () => Promise.resolve({ data: null, error: null }),
    __setAuthError: (e) => { authState.authError = e; },
    __setAuthUser: (u) => { authState.authUser = u; },
    __setAdminListUsersResult: (r) => { authState.adminListUsersResult = r; },
    __setAdminGetUserByIdResult: (r) => { authState.adminGetUserByIdResult = r; },
    __setSignError: (v) => { authState.signError = v; },
    __setSignedUrlResult: (r) => { authState.signedUrlResult = r; },
  };

  // Expose globally for admin.test.js compatibility
  global.__mockClient = client;

  return client;
}

// Build the singleton client
var singleton = createSupabaseMock(globalThis);

module.exports = {
  createClient: function() { return singleton; },
  __resetAuth: function() {
    singleton.__setAuthError(null);
    singleton.__setAuthUser({ id: 'admin-1', email: 'admin@test.com' });
    singleton.__setAdminListUsersResult(null);
    singleton.__setAdminGetUserByIdResult(null);
    singleton.__setSignedUrlResult(null);
    singleton.__setSignError(false);
  },
};
