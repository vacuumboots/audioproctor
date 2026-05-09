// Re-exports from tests/setup.js for convenience
// Both import paths work: import from './helpers/supabase-mock.js' or via global
import { resetTestDb, seedTable, getInserts } from '../setup.js';
import { vi } from 'vitest';

export { resetTestDb, seedTable, getInserts };

export function createMockClient(opts = {}) {
  const {
    authUser = { id: 'admin-1', email: 'admin@test.com' },
    adminListUsersResult = null,
    signedUrlResult = null,
    signError = false,
  } = opts;

  // Return a fresh wrapper around the global mock with overridden auth if needed
  // Tests that use this get their own auth config but share the same __testDb tables
  const base = global.__mockSupabaseClient;

  return {
    ...base,
    auth: {
      getUser: () => Promise.resolve({ data: { user: authUser }, error: null }),
      admin: {
        ...base.auth.admin,
        listUsers: (params) => {
          if (adminListUsersResult) return Promise.resolve(adminListUsersResult);
          return Promise.resolve({ data: { users: [] }, error: null });
        },
      },
    },
    storage: base.storage,
    __seed: (table, rows) => { global.__testDb.tables[table] = rows; },
    __reset: () => { resetTestDb(); },
  };
}
