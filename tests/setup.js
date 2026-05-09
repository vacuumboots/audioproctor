import { vi } from 'vitest';

// ─── Shared mutable state ────────────────────────────────────────────
// This is the SINGLE source of truth for all mock data across test files.
global.__testDb = { tables: {}, inserts: [] };

export function resetTestDb() {
  global.__testDb = { tables: {}, inserts: [] };
}

export function seedTable(table, rows) {
  global.__testDb.tables[table] = rows;
}

export function getInserts() {
  return [...(global.__testDb.inserts || [])];
}

// ─── Chain builder ───────────────────────────────────────────────────
// Replicates the Supabase query builder chain pattern.
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

  c.gte = (k, v) => makeChain(rows.filter(r => r[k] >= v), opts);
  c.lt = (k, v) => makeChain(rows.filter(r => r[k] < v), opts);

  c.select = (fields, queryOpts) => {
    if (queryOpts && (queryOpts.count === 'exact')) {
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
    global.__testDb.inserts.push(data);
    return {
      then: (cb) => cb({ data: null, error: null }),
      select: () => ({
        single: () => ({ data: Array.isArray(data) ? data[0] : data, error: null }),
        then: (cb) => cb({ data: Array.isArray(data) ? data : [data], error: null }),
      }),
    };
  };

  c.upsert = (data, conf) => {
    global.__testDb.inserts.push({ _upsert: true, data, conf });
    return { then: (cb) => cb({ data: null, error: null }) };
  };

  c.update = (fields) => ({
    eq: () => ({ then: (cb) => cb({ data: null, error: null }) }),
    in: () => ({ then: (cb) => cb({ data: null, error: null }) }),
  });

  c.filter = () => c;
  return c;
}

// ─── Mutable auth/opts state (module-scoped) ────────────────────────
let _mockOpts = {
  authUser: { id: 'user-1', email: 'user@test.com' },
  authError: null,
  adminListUsersResult: null,
  adminGetUserByIdResult: null,
  signedUrlResult: null,
  signError: false,
};

// ─── Build a fresh mock client ───────────────────────────────────────
// Returns a new mock client each call, wired to global.__testDb.
export function createMockClient() {
  return {
    from: (table) => {
      if (!global.__testDb) global.__testDb = { tables: {}, inserts: [] };
      if (!global.__testDb.tables[table]) global.__testDb.tables[table] = [];
      return makeChain(global.__testDb.tables[table]);
    },
    storage: {
      from: () => ({
        createSignedUrl: (path) => _mockOpts.signError
          ? { then: (cb) => cb({ data: null, error: { message: 'sign error' } }) }
          : {
              then: (cb) => cb({
                data: _mockOpts.signedUrlResult || { signedUrl: `https://storage.test${path}?s=1` },
                error: null,
              }),
            },
        remove: () => Promise.resolve({ data: null, error: null }),
      }),
    },
    auth: {
      getUser: () => _mockOpts.authError
        ? Promise.resolve({ data: { user: null }, error: _mockOpts.authError })
        : Promise.resolve({ data: { user: _mockOpts.authUser }, error: null }),
      admin: {
        getUserById: (uid) => {
          if (_mockOpts.adminGetUserByIdResult) return Promise.resolve(_mockOpts.adminGetUserByIdResult);
          return Promise.resolve({ data: { user: { id: uid, email: 'target@test.com' } }, error: null });
        },
        deleteUser: () => Promise.resolve({ data: null, error: null }),
        createUser: (params) => Promise.resolve({ data: { user: { id: 'new-user-' + Date.now() } }, error: null }),
        generateLink: (params) => Promise.resolve({
          data: { properties: { action_link: 'https://test/link' } },
          error: null,
        }),
        listUsers: (params) => {
          if (_mockOpts.adminListUsersResult) return Promise.resolve(_mockOpts.adminListUsersResult);
          return Promise.resolve({ data: { users: [] }, error: null });
        },
      },
    },
    rpc: () => Promise.resolve({ data: null, error: null }),
    __seed: (table, rows) => { if (global.__testDb) global.__testDb.tables[table] = rows; },
    __reset: () => {
      resetTestDb();
      _mockOpts.authUser = { id: 'user-1', email: 'user@test.com' };
      _mockOpts.authError = null;
      _mockOpts.adminListUsersResult = null;
      _mockOpts.adminGetUserByIdResult = null;
      _mockOpts.signedUrlResult = null;
      _mockOpts.signError = false;
    },
    __setAuthUser: (u) => { _mockOpts.authUser = u; },
    __setAuthError: (e) => { _mockOpts.authError = e; },
    __setAdminListUsersResult: (r) => { _mockOpts.adminListUsersResult = r; },
    __setSignedUrlResult: (r) => { _mockOpts.signedUrlResult = r; },
    __setSignError: (e) => { _mockOpts.signError = e; },
    __setAdminGetUserByIdResult: (r) => { _mockOpts.adminGetUserByIdResult = r; },
  };
}

// ─── Pre-built singleton for CJS require patching ─────────────────────
// Used by the Module.prototype.require hook below.
const _singletonClient = createMockClient();
global.__mockSupabaseClient = _singletonClient;

// ─── CJS require hook ────────────────────────────────────────────────
// API handler files use CJS require('@supabase/supabase-js'), which
// vitest's vi.mock does NOT intercept. We patch Module.prototype.require
// to return our mock when the supabase module is requested.
import Module from 'module';
const __origRequire = Module.prototype.require;
Module.prototype.require = function (id) {
  if (id === '@supabase/supabase-js') {
    return { createClient: () => global.__mockSupabaseClient };
  }
  return __origRequire.apply(this, arguments);
};
