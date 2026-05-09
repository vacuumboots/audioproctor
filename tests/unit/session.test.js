// ─── Tests for api/session.js ───────────────────────────────────────
// Covers: access code validation, expiry, rate limiting, typed response
// for audio vs text assessments.

import { describe, it, expect, vi, beforeEach } from 'vitest';
import crypto from 'crypto';
import { seedTable, resetTestDb, getInserts } from '../setup.js';

// ─── Synchronous inline mock for @supabase/supabase-js ─────────────────
// IMPORTANT: This must be synchronous so the mock is available before any
// module-level code that requires it (including dynamically imported CJS modules).
function makeChain(rows, opts = {}) {
  const c = {};
  c.then = (cb) => {
    if (opts.withCount) return cb({ data: rows, error: null, count: rows.length });
    return cb({ data: rows, error: null });
  };
  c.single = () => rows.length === 0
    ? { data: null, error: { message: 'no rows' } }
    : { data: rows[0], error: null };
  c.maybeSingle = () => ({ data: rows[0] || null, error: null });
  c.eq = (k, v) => makeChain(rows.filter(r => r[k] === v), opts);
  c.gte = (k, v) => makeChain(rows.filter(r => r[k] >= v), opts);
  c.lt = (k, v) => makeChain(rows.filter(r => r[k] < v), opts);
  c.select = (fields, qo) => {
    if (qo && qo.count === 'exact') return makeChain(rows, { ...opts, withCount: true });
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
  c.filter = () => c;
  return c;
}

vi.mock('@supabase/supabase-js', () => ({
  createClient: (url, key, options) => ({
    from: (table) => {
      if (!global.__testDb) global.__testDb = { tables: {}, inserts: [] };
      if (!global.__testDb.tables[table]) global.__testDb.tables[table] = [];
      return makeChain(global.__testDb.tables[table]);
    },
    storage: {
      from: () => ({
        createSignedUrl: (path, exp) => ({
          then: (cb) => cb({ data: { signedUrl: `https://storage.test${path}?s=${exp}` }, error: null }),
        }),
        remove: () => Promise.resolve({ data: null, error: null }),
      }),
    },
    auth: {
      getUser: () => Promise.resolve({ data: { user: { id: 'user-1', email: 'user@test.com' } }, error: null }),
      admin: {
        getUserById: (uid) => Promise.resolve({ data: { user: { id: uid, email: 'target@test.com' } }, error: null }),
        deleteUser: () => Promise.resolve({ data: null, error: null }),
        createUser: (params) => Promise.resolve({ data: { user: { id: 'new-user-' + Date.now() } }, error: null }),
        generateLink: (params) => Promise.resolve({ data: { properties: { action_link: 'https://test/link' } }, error: null }),
        listUsers: (params) => Promise.resolve({ data: { users: [] }, error: null }),
      },
    },
    rpc: () => Promise.resolve({ data: null, error: null }),
  }),
}));

process.env.SUPABASE_URL = 'https://test-project.supabase.co';
process.env.SUPABASE_SERVICE_ROLE_KEY = 'test-service-role-key';
process.env.SUPABASE_ANON_KEY = 'test-anon-key';

const handler = (await import('../../api/session.js')).default;

function mkReq(method, query, ip) {
  const res = { _status: 200, _body: null, _headers: {},
    setHeader: vi.fn(function(k,v) { this._headers[k] = v; return this; }),
    status: vi.fn(function(c) { this._status = c; return this; }),
    json: vi.fn(function(b) { this._body = b; return this; }),
    end: vi.fn(function() { return this; }),
  };
  return { req: { method, query, headers: { 'x-forwarded-for': ip || '127.0.0.1' }, body: {} }, res };
}

describe('api/session.js', () => {
  beforeEach(() => {
    resetTestDb();
  });

  // ── Validation ────────────────────────────────────────────────

  it('rejects missing code', async () => {
    const { req, res } = mkReq('GET', {});
    await handler(req, res);
    expect(res._status).toBe(400);
    expect(res._body.error).toBe('Missing code parameter');
  });

  it('rejects bad code format', async () => {
    const { req, res } = mkReq('GET', { code: 'AB!' });
    await handler(req, res);
    expect(res._status).toBe(400);
    expect(res._body.error).toBe('Invalid code format');
  });

  it('rejects non-string code', async () => {
    const { req, res } = mkReq('GET', { code: 123 });
    await handler(req, res);
    expect(res._status).toBe(400);
    expect(res._body.error).toBe('Invalid code format');
  });

  it('rejects code over 20 characters', async () => {
    const { req, res } = mkReq('GET', { code: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' });
    await handler(req, res);
    expect(res._status).toBe(400);
    expect(res._body.error).toBe('Invalid code format');
  });

  it('rejects single character code', async () => {
    const { req, res } = mkReq('GET', { code: 'A' });
    await handler(req, res);
    expect(res._status).toBe(400);
    expect(res._body.error).toBe('Invalid code format');
  });

  it('handles OPTIONS', async () => {
    const res = { _status: 200, _ended: false,
      setHeader: vi.fn(() => res), status: vi.fn((c) => { res._status = c; return res; }),
      json: vi.fn(() => res), end: vi.fn(() => { res._ended = true; return res; }),
    };
    await handler({ method: 'OPTIONS', query: {}, headers: {}, body: {} }, res);
    expect(res._status).toBe(200);
    expect(res._ended).toBe(true);
  });

  it('rejects non-GET methods', async () => {
    const { req, res } = mkReq('POST', {});
    await handler(req, res);
    expect(res._status).toBe(405);
    expect(res._body.error).toBe('Method not allowed');
  });

  // ── Access code lookup ────────────────────────────────────────

  it('returns 200 for audio assessment', async () => {
    const future = new Date(Date.now() + 3600000).toISOString();
    const h = crypto.createHash('sha256').update('x').digest('hex');
    seedTable('uploads', [{
      id: 'u1', filename: 't.mp3', storage_path: 't1/t.mp3',
      access_code: 'ABC-123', exit_word_hash: h,
      expires_at: future, teacher_id: 't1', assessment_type: 'audio',
      label: 'L', text_content: null, text_char_count: null, image_count: 0,
    }]);
    seedTable('rate_limit_log', []);
    seedTable('profiles', [{ id: 't1', is_deactivated: false }]);

    const { req, res } = mkReq('GET', { code: 'ABC-123' });
    await handler(req, res);
    expect(res._status).toBe(200);
    expect(res._body.assessmentType).toBe('audio');
    expect(res._body.signedUrl).toContain('https://');
    expect(res._body.exitWordHash).toBe(h);
  });

  it('returns 200 for text assessment', async () => {
    const future = new Date(Date.now() + 3600000).toISOString();
    seedTable('uploads', [{
      id: 'u1', filename: null, storage_path: null,
      access_code: 'TXT-01', exit_word_hash: 'h',
      expires_at: future, teacher_id: 't1', assessment_type: 'text',
      label: 'T', text_content: '<p>Hello</p>', text_char_count: 5, image_count: 0,
    }]);
    seedTable('rate_limit_log', []);
    seedTable('profiles', [{ id: 't1', is_deactivated: false }]);
    const { req, res } = mkReq('GET', { code: 'TXT-01' });
    await handler(req, res);
    expect(res._status).toBe(200);
    expect(res._body.assessmentType).toBe('text');
    expect(res._body.textContent).toBe('<p>Hello</p>');
  });

  it('returns 410 for expired assessment', async () => {
    const past = new Date(Date.now() - 3600000).toISOString();
    seedTable('uploads', [{
      id: 'u1', filename: 't.mp3', storage_path: 't1/t.mp3',
      access_code: 'EXP-01', exit_word_hash: 'h',
      expires_at: past, teacher_id: 't1', assessment_type: 'audio',
      label: null, text_content: null, text_char_count: null, image_count: 0,
    }]);
    seedTable('rate_limit_log', []);
    const { req, res } = mkReq('GET', { code: 'EXP-01' });
    await handler(req, res);
    expect(res._status).toBe(410);
    expect(res._body.error).toBe('This assessment has expired');
  });

  it('returns 403 for deactivated teacher', async () => {
    const future = new Date(Date.now() + 3600000).toISOString();
    seedTable('uploads', [{
      id: 'u1', filename: 't.mp3', storage_path: 't1/t.mp3',
      access_code: 'DE-001', exit_word_hash: 'h',
      expires_at: future, teacher_id: 'dt1', assessment_type: 'audio',
      label: null, text_content: null, text_char_count: null, image_count: 0,
    }]);
    seedTable('rate_limit_log', []);
    seedTable('profiles', [{ id: 'dt1', is_deactivated: true }]);
    const { req, res } = mkReq('GET', { code: 'DE-001' });
    await handler(req, res);
    expect(res._status).toBe(403);
    expect(res._body.error).toBe('This assessment is no longer available');
  });

  it('returns 404 for unknown code', async () => {
    seedTable('uploads', []);
    seedTable('rate_limit_log', []);
    const { req, res } = mkReq('GET', { code: 'ZZZ-999' });
    await handler(req, res);
    expect(res._status).toBe(404);
    expect(res._body.error).toBe('Access code not found');
  });

  it('handles case-insensitive code lookup', async () => {
    const future = new Date(Date.now() + 3600000).toISOString();
    seedTable('uploads', [{
      id: 'u1', filename: 't.mp3', storage_path: 't1/t.mp3',
      access_code: 'CASE-001', exit_word_hash: 'h',
      expires_at: future, teacher_id: 't1', assessment_type: 'audio',
      label: null, text_content: null, text_char_count: null, image_count: 0,
    }]);
    seedTable('rate_limit_log', []);
    seedTable('profiles', [{ id: 't1', is_deactivated: false }]);
    const { req, res } = mkReq('GET', { code: 'case-001' });
    await handler(req, res);
    expect(res._status).toBe(200);
  });

  // ── Rate limiting ─────────────────────────────────────────────

  it('allows requests under the rate limit', async () => {
    const future = new Date(Date.now() + 3600000).toISOString();
    seedTable('uploads', [{
      id: 'u1', filename: 't.mp3', storage_path: 't1/t.mp3',
      access_code: 'RL-OKAY', exit_word_hash: 'h',
      expires_at: future, teacher_id: 't1', assessment_type: 'audio',
      label: null, text_content: null, text_char_count: null, image_count: 0,
    }]);
    seedTable('rate_limit_log', [
      { ip: '127.0.0.1', attempted_at: new Date(Date.now() - 30000).toISOString() },
      { ip: '127.0.0.1', attempted_at: new Date(Date.now() - 20000).toISOString() },
      { ip: '127.0.0.1', attempted_at: new Date(Date.now() - 10000).toISOString() },
    ]);
    seedTable('profiles', [{ id: 't1', is_deactivated: false }]);
    const { req, res } = mkReq('GET', { code: 'RL-OKAY' }, '127.0.0.1');
    await handler(req, res);
    expect(res._status).toBe(200);
  });

  it('blocks requests exceeding the rate limit', async () => {
    const recent = [];
    for (let i = 0; i < 10; i++) {
      recent.push({ ip: '127.0.0.1', attempted_at: new Date(Date.now() - i * 1000).toISOString() });
    }
    seedTable('rate_limit_log', recent);
    const { req, res } = mkReq('GET', { code: 'RL-BAD' }, '127.0.0.1');
    await handler(req, res);
    expect(res._status).toBe(429);
    expect(res._body.error).toBe('Too many attempts. Try again later.');
  });

  it('rate limits by IP independently', async () => {
    const recent = [];
    for (let i = 0; i < 10; i++) {
      recent.push({ ip: '10.0.0.1', attempted_at: new Date(Date.now() - i * 1000).toISOString() });
    }
    seedTable('rate_limit_log', recent);
    const future = new Date(Date.now() + 3600000).toISOString();
    seedTable('uploads', [{
      id: 'u1', filename: 't.mp3', storage_path: 't1/t.mp3',
      access_code: 'RL-DIFF', exit_word_hash: 'h',
      expires_at: future, teacher_id: 't1', assessment_type: 'audio',
      label: null, text_content: null, text_char_count: null, image_count: 0,
    }]);
    seedTable('profiles', [{ id: 't1', is_deactivated: false }]);
    const { req, res } = mkReq('GET', { code: 'RL-DIFF' }, '10.0.0.2');
    await handler(req, res);
    expect(res._status).toBe(200);
  });

  it('does not count successful lookups against rate limit', async () => {
    const recent = [];
    for (let i = 0; i < 9; i++) {
      recent.push({ ip: '127.0.0.1', attempted_at: new Date(Date.now() - i * 1000).toISOString() });
    }
    seedTable('rate_limit_log', recent);
    const future = new Date(Date.now() + 3600000).toISOString();
    seedTable('uploads', [{
      id: 'u1', filename: 't.mp3', storage_path: 't1/t.mp3',
      access_code: 'RL-SUCC', exit_word_hash: 'h',
      expires_at: future, teacher_id: 't1', assessment_type: 'audio',
      label: null, text_content: null, text_char_count: null, image_count: 0,
    }]);
    seedTable('profiles', [{ id: 't1', is_deactivated: false }]);
    const { req, res } = mkReq('GET', { code: 'RL-SUCC' }, '127.0.0.1');
    await handler(req, res);
    expect(res._status).toBe(200);
  });

  it('rate limits expire after the window', async () => {
    const old = [];
    for (let i = 0; i < 10; i++) {
      old.push({ ip: '127.0.0.1', attempted_at: new Date(Date.now() - 120 * 60 * 1000).toISOString() });
    }
    seedTable('rate_limit_log', old);
    const future = new Date(Date.now() + 3600000).toISOString();
    seedTable('uploads', [{
      id: 'u1', filename: 't.mp3', storage_path: 't1/t.mp3',
      access_code: 'RL-OLD', exit_word_hash: 'h',
      expires_at: future, teacher_id: 't1', assessment_type: 'audio',
      label: null, text_content: null, text_char_count: null, image_count: 0,
    }]);
    seedTable('profiles', [{ id: 't1', is_deactivated: false }]);
    const { req, res } = mkReq('GET', { code: 'RL-OLD' }, '127.0.0.1');
    await handler(req, res);
    expect(res._status).toBe(200);
  });

  // ── Event logging ─────────────────────────────────────────────

  it('logs code_entered on success', async () => {
    const future = new Date(Date.now() + 3600000).toISOString();
    seedTable('uploads', [{
      id: 'u-event', filename: 't.mp3', storage_path: 't1/t.mp3',
      access_code: 'EVT-01', exit_word_hash: 'h',
      expires_at: future, teacher_id: 't1', assessment_type: 'audio',
      label: null, text_content: null, text_char_count: null, image_count: 0,
    }]);
    seedTable('rate_limit_log', []);
    seedTable('profiles', [{ id: 't1', is_deactivated: false }]);
    const { req, res } = mkReq('GET', { code: 'EVT-01' });
    await handler(req, res);
    expect(res._status).toBe(200);
    const events = getInserts().filter(i => i.event_type === 'code_entered');
    expect(events.length).toBeGreaterThan(0);
    expect(events[0].upload_id).toBe('u-event');
  });

  // ── CORS ──────────────────────────────────────────────────────

  it('sets CORS headers', async () => {
    seedTable('uploads', []);
    seedTable('rate_limit_log', []);
    const { req, res } = mkReq('GET', { code: 'AAAA-01' });
    await handler(req, res);
    expect(res._headers['Access-Control-Allow-Origin']).toBe('*');
    expect(res._headers['Access-Control-Allow-Methods']).toBe('GET, OPTIONS');
    expect(res._headers['Access-Control-Allow-Headers']).toBe('Content-Type');
  });
});
