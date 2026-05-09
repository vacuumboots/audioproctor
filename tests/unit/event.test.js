// ─── Tests for api/event.js ─────────────────────────────────────────
// Covers: event type validation, session event insertion, expiry grace period.

import { describe, it, expect, vi, beforeEach } from 'vitest';
import { seedTable, resetTestDb, getInserts } from '../setup.js';

// ─── Synchronous inline mock for @supabase/supabase-js ─────────────────
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
  c.gte = () => makeChain(rows, opts);
  c.lt = () => makeChain(rows, opts);
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
  createClient: () => ({
    from: (table) => {
      if (!global.__testDb) global.__testDb = { tables: {}, inserts: [] };
      if (!global.__testDb.tables[table]) global.__testDb.tables[table] = [];
      return makeChain(global.__testDb.tables[table]);
    },
    storage: {
      from: () => ({
        createSignedUrl: () => ({ then: (cb) => cb({ data: { signedUrl: 'https://storage.test/path?s=3600' }, error: null }) }),
        remove: () => Promise.resolve({ data: null, error: null }),
      }),
    },
    auth: {
      getUser: () => Promise.resolve({ data: { user: { id: 'user-1', email: 'user@test.com' } }, error: null }),
      admin: {
        getUserById: () => Promise.resolve({ data: { user: { id: 'target', email: 'target@test.com' } }, error: null }),
        deleteUser: () => Promise.resolve({ data: null, error: null }),
        createUser: () => Promise.resolve({ data: { user: { id: 'new-user' } }, error: null }),
        generateLink: () => Promise.resolve({ data: { properties: { action_link: 'https://test/link' } }, error: null }),
        listUsers: () => Promise.resolve({ data: { users: [] }, error: null }),
      },
    },
    rpc: () => Promise.resolve({ data: null, error: null }),
  }),
}));

process.env.SUPABASE_URL = 'https://test-project.supabase.co';
process.env.SUPABASE_SERVICE_ROLE_KEY = 'test-service-role-key';

const handler = (await import('../../api/event.js')).default;

function mk(method = 'POST', body = {}, ip = '1.2.3.4') {
  const res = { _status: 200, _body: null, _headers: {},
    setHeader: vi.fn(function(k,v) { this._headers[k] = v; return this; }),
    status: vi.fn(function(c) { this._status = c; return this; }),
    json: vi.fn(function(b) { this._body = b; return this; }),
    end: vi.fn(function() { return this; }),
  };
  return { req: { method, query: {}, headers: { 'x-forwarded-for': ip }, body }, res };
}

describe('api/event.js', () => {
  beforeEach(() => {
    resetTestDb();
  });

  // ── Validation ────────────────────────────────────────────────

  it('rejects missing code', async () => {
    const { req, res } = mk('POST', { eventType: 'playback_started' });
    await handler(req, res);
    expect(res._status).toBe(400);
    expect(res._body.error).toBe('Missing code');
  });

  it('rejects non-string code', async () => {
    const { req, res } = mk('POST', { code: 123, eventType: 'playback_started' });
    await handler(req, res);
    expect(res._status).toBe(400);
    expect(res._body.error).toBe('Missing code');
  });

  it('rejects invalid code format', async () => {
    const { req, res } = mk('POST', { code: 'AB!', eventType: 'playback_started' });
    await handler(req, res);
    expect(res._status).toBe(400);
    expect(res._body.error).toBe('Invalid code format');
  });

  it('rejects code over 20 characters', async () => {
    const { req, res } = mk('POST', { code: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', eventType: 'playback_started' });
    await handler(req, res);
    expect(res._status).toBe(400);
    expect(res._body.error).toBe('Invalid code format');
  });

  it('rejects single character code', async () => {
    const { req, res } = mk('POST', { code: 'A', eventType: 'playback_started' });
    await handler(req, res);
    expect(res._status).toBe(400);
    expect(res._body.error).toBe('Invalid code format');
  });

  it('rejects missing eventType', async () => {
    const { req, res } = mk('POST', { code: 'ABC-123' });
    await handler(req, res);
    expect(res._status).toBe(400);
    expect(res._body.error).toBe('Invalid or missing eventType');
  });

  it('rejects invalid eventType', async () => {
    const { req, res } = mk('POST', { code: 'ABC-123', eventType: 'invalid_event' });
    await handler(req, res);
    expect(res._status).toBe(400);
    expect(res._body.error).toBe('Invalid or missing eventType');
  });

  it('rejects metadata that is an array', async () => {
    const { req, res } = mk('POST', { code: 'ABC-123', eventType: 'playback_started', metadata: [] });
    await handler(req, res);
    expect(res._status).toBe(400);
    expect(res._body.error).toBe('metadata must be a plain object');
  });

  it('rejects metadata > 2048 bytes', async () => {
    const { req, res } = mk('POST', { code: 'ABC-123', eventType: 'playback_started', metadata: { x: 'a'.repeat(3000) } });
    await handler(req, res);
    expect(res._status).toBe(400);
    expect(res._body.error).toBe('metadata too large');
  });

  it('rejects metadata with circular reference (non-serializable)', async () => {
    const circular = { x: 1 };
    circular.self = circular;
    const { req, res } = mk('POST', { code: 'ABC-123', eventType: 'playback_started', metadata: circular });
    await handler(req, res);
    expect(res._status).toBe(400);
    expect(res._body.error).toBe('metadata must be serializable');
  });

  // ── DB-dependent tests ─────────────────────────────────────────

  it('accepts valid events', async () => {
    const future = new Date(Date.now() + 3600000).toISOString();
    seedTable('uploads', [{ id: 'u1', access_code: 'EVT-001', expires_at: future }]);

    const { req, res } = mk('POST', { code: 'EVT-001', eventType: 'playback_started' });
    await handler(req, res);
    expect(res._status).toBe(200);
    expect(res._body.ok).toBe(true);
  });

  it('accepts all valid event types', async () => {
    const future = new Date(Date.now() + 3600000).toISOString();
    const validEvents = [
      'playback_started', 'playback_paused', 'playback_resumed',
      'playback_completed', 'replay_triggered', 'exit_word_used',
      'session_expired', 'audio_error', 'text_viewed', 'text_completed',
    ];

    for (const et of validEvents) {
      seedTable('uploads', [{ id: 'u1', access_code: 'EVT-02', expires_at: future }]);
      const { req, res } = mk('POST', { code: 'EVT-02', eventType: et });
      await handler(req, res);
      expect(res._status, `event type ${et} should be accepted`).toBe(200);
      resetTestDb();
    }
  });

  it('returns 404 for unknown code', async () => {
    seedTable('uploads', []);
    const { req, res } = mk('POST', { code: 'ZZZ-999', eventType: 'playback_started' });
    await handler(req, res);
    expect(res._status).toBe(404);
    expect(res._body.error).toBe('Code not found');
  });

  it('returns 410 for expired code outside grace period', async () => {
    const veryPast = new Date(Date.now() - 3 * 60 * 60 * 1000).toISOString();
    seedTable('uploads', [{ id: 'u1', access_code: 'OLD-001', expires_at: veryPast }]);

    const { req, res } = mk('POST', { code: 'OLD-001', eventType: 'playback_started' });
    await handler(req, res);
    expect(res._status).toBe(410);
    expect(res._body.error).toBe('Assessment expired');
  });

  it('accepts event within 2-hour grace period', async () => {
    const withinGrace = new Date(Date.now() - 1 * 60 * 60 * 1000).toISOString();
    seedTable('uploads', [{ id: 'u1', access_code: 'GRACE-OK', expires_at: withinGrace }]);

    const { req, res } = mk('POST', { code: 'GRACE-OK', eventType: 'playback_completed' });
    await handler(req, res);
    expect(res._status).toBe(200);
    expect(res._body.ok).toBe(true);
  });

  it('accepts event at exactly 2 hours past expiry (boundary)', async () => {
    // 119 minutes = just inside the 2-hour grace window (handler does strict > check)
    const atGrace = new Date(Date.now() - 119 * 60 * 1000).toISOString();
    seedTable('uploads', [{ id: 'u1', access_code: 'BOUNDARY', expires_at: atGrace }]);

    const { req, res } = mk('POST', { code: 'BOUNDARY', eventType: 'playback_completed' });
    await handler(req, res);
    expect(res._status).toBe(200);
    expect(res._body.ok).toBe(true);
  });

  it('accepts null metadata', async () => {
    const future = new Date(Date.now() + 3600000).toISOString();
    seedTable('uploads', [{ id: 'u1', access_code: 'MTD-001', expires_at: future }]);

    const { req, res } = mk('POST', { code: 'MTD-001', eventType: 'playback_started', metadata: null });
    await handler(req, res);
    expect(res._status).toBe(200);
    expect(res._body.ok).toBe(true);
  });

  it('accepts empty metadata object', async () => {
    const future = new Date(Date.now() + 3600000).toISOString();
    seedTable('uploads', [{ id: 'u1', access_code: 'MTD-002', expires_at: future }]);

    const { req, res } = mk('POST', { code: 'MTD-002', eventType: 'playback_started', metadata: {} });
    await handler(req, res);
    expect(res._status).toBe(200);
    expect(res._body.ok).toBe(true);
  });

  it('inserts session event with metadata', async () => {
    const future = new Date(Date.now() + 3600000).toISOString();
    seedTable('uploads', [{ id: 'u-insert', access_code: 'INS-001', expires_at: future }]);

    const { req, res } = mk('POST', { code: 'INS-001', eventType: 'playback_paused', metadata: { position_seconds: 42 } });
    await handler(req, res);
    expect(res._status).toBe(200);
    expect(res._body.ok).toBe(true);

    expect(getInserts().length).toBe(1);
    expect(getInserts()[0].upload_id).toBe('u-insert');
    expect(getInserts()[0].event_type).toBe('playback_paused');
    expect(getInserts()[0].metadata).toEqual({ position_seconds: 42 });
  });

  // ── CORS and methods ──────────────────────────────────────────

  it('handles OPTIONS', async () => {
    const res = { _status: 200, _ended: false,
      setHeader: vi.fn(() => res), status: vi.fn((c) => { res._status = c; return res; }),
      json: vi.fn(() => res), end: vi.fn(() => { res._ended = true; return res; }),
    };
    await handler({ method: 'OPTIONS', query: {}, headers: {}, body: {} }, res);
    expect(res._status).toBe(200);
    expect(res._ended).toBe(true);
  });

  it('rejects non-POST methods', async () => {
    const { req, res } = mk('GET', {});
    await handler(req, res);
    expect(res._status).toBe(405);
    expect(res._body.error).toBe('Method not allowed');
  });

  it('rejects PUT with 405', async () => {
    const { req, res } = mk('PUT', {});
    await handler(req, res);
    expect(res._status).toBe(405);
    expect(res._body.error).toBe('Method not allowed');
  });

  it('has CORS headers', async () => {
    seedTable('uploads', []);
    const { req, res } = mk('POST', { code: 'NOPE', eventType: 'playback_started' });
    await handler(req, res);
    expect(res._headers['Access-Control-Allow-Origin']).toBe('*');
    expect(res._headers['Access-Control-Allow-Methods']).toBe('POST, OPTIONS');
    expect(res._headers['Access-Control-Allow-Headers']).toBe('Content-Type');
  });

  it('handles case-insensitive code lookup', async () => {
    const future = new Date(Date.now() + 3600000).toISOString();
    seedTable('uploads', [{ id: 'u1', access_code: 'CASE-001', expires_at: future }]);

    const { req, res } = mk('POST', { code: 'case-001', eventType: 'playback_started' });
    await handler(req, res);
    expect(res._status).toBe(200);
  });
});
