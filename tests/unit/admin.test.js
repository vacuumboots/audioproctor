// ─── Tests for api/admin.js ─────────────────────────────────────────
// Covers: role checks, service role boundary, CRUD operations.
//
// Admin.js uses CJS require('@supabase/supabase-js'), which the setup.js
// Module.prototype.require hook intercepts, returning a singleton mock
// (global.__mockSupabaseClient) with control methods __setAuthUser/__setAuthError.
// We drive auth state through those methods rather than vi.mock.

import { describe, it, expect, vi, beforeEach } from 'vitest';
import { seedTable, resetTestDb, getInserts } from '../setup.js';

process.env.SUPABASE_URL = 'https://test-project.supabase.co';
process.env.SUPABASE_SERVICE_ROLE_KEY = 'test-service-role-key';
process.env.SUPABASE_ANON_KEY = 'test-anon-key';
process.env.STRIPE_SECRET_KEY = '***';
process.env.RESEND_API_KEY = '***';
process.env.STRIPE_WEBHOOK_SECRET = '***';

vi.mock('stripe', () => vi.fn(() => ({
  subscriptions: { update: vi.fn(() => Promise.resolve({ id: 'sub_mock' })) },
})));

vi.mock('../../api/_lib/email', () => ({
  sendEmail: vi.fn(() => Promise.resolve({ ok: true })),
}));

vi.mock('../../api/_lib/schedule-onboarding', () => ({
  scheduleDivisionOnboarding: vi.fn(() => Promise.resolve()),
}));

const handler = (await import('../../api/admin.js')).default;

// Singleton mock client — the CJS require hook in setup.js always returns this
const $mock = () => global.__mockSupabaseClient;

function mk(method = 'GET', query = {}, body = {}, auth = 'Bearer valid-jwt') {
  const res = { _status: 200, _body: null, _headers: {},
    setHeader: vi.fn(function(k, v) { this._headers[k] = v; return this; }),
    status: vi.fn(function(c) { this._status = c; return this; }),
    json: vi.fn(function(b) { this._body = b; return this; }),
    end: vi.fn(function() { return this; }),
  };
  return { req: { method, query, headers: { authorization: auth }, body }, res };
}

function seedAdmin() {
  seedTable('profiles', [{ id: 'admin-1', role: 'platform_admin', email: 'admin@test.com' }]);
}

describe('api/admin.js', () => {
  beforeEach(() => {
    resetTestDb();
    // Reset mock auth state to default
    if (typeof $mock().__reset === 'function') $mock().__reset();
    // Ensure default auth user is admin-1
    if (typeof $mock().__setAuthUser === 'function') {
      $mock().__setAuthUser({ id: 'admin-1', email: 'admin@test.com' });
    }
    $mock().__setAuthError(null);
  });

  // ── Auth & authorization ─────────────────────────────────────

  it('rejects missing auth header', async () => {
    const { req, res } = mk('GET', { action: 'overview' }, {}, '');
    await handler(req, res);
    expect(res._status).toBe(401);
    expect(res._body.error).toBe('Missing authorization');
  });

  it('rejects invalid token', async () => {
    seedAdmin();
    $mock().__setAuthError({ message: 'invalid token' });
    const { req, res } = mk('GET', { action: 'overview' });
    await handler(req, res);
    expect(res._status).toBe(401);
    expect(res._body.error).toBe('Invalid token');
  });

  it('rejects non-platform_admin', async () => {
    seedTable('profiles', [{ id: 'admin-1', role: 'teacher' }]);
    const { req, res } = mk('GET', { action: 'overview' });
    await handler(req, res);
    expect(res._status).toBe(403);
    expect(res._body.error).toBe('Forbidden');
  });

  it('rejects when profile not found', async () => {
    const { req, res } = mk('GET', { action: 'overview' });
    await handler(req, res);
    expect(res._status).toBe(403);
    expect(res._body.error).toBe('Forbidden');
  });

  it('allows platform_admin', async () => {
    seedAdmin();
    const { req, res } = mk('GET', { action: 'overview' });
    await handler(req, res);
    expect(res._status).toBe(200);
  });

  // ── GET actions ─────────────────────────────────────────────

  describe('GET actions', () => {
    beforeEach(() => { resetTestDb(); seedAdmin(); });

    it('returns overview counts', async () => {
      seedTable('divisions', [{ id: 'd1' }]);
      seedTable('schools', [{ id: 's1' }]);
      const { req, res } = mk('GET', { action: 'overview' });
      await handler(req, res);
      expect(res._status).toBe(200);
      expect(res._body.divisionCount).toBe(1);
      expect(res._body.schoolCount).toBe(1);
    });

    it('returns divisions', async () => {
      seedTable('divisions', [{ id: 'd1', name: 'Test Div' }]);
      const { req, res } = mk('GET', { action: 'divisions' });
      await handler(req, res);
      expect(res._status).toBe(200);
      expect(res._body.length).toBe(1);
    });

    it('returns schools', async () => {
      seedTable('schools', [{ id: 's1', name: 'Test School' }]);
      const { req, res } = mk('GET', { action: 'schools' });
      await handler(req, res);
      expect(res._status).toBe(200);
      expect(res._body.length).toBe(1);
    });

    it('returns 400 for unknown action', async () => {
      const { req, res } = mk('GET', { action: 'nonexistent' });
      await handler(req, res);
      expect(res._status).toBe(400);
    });
  });

  // ── POST actions ────────────────────────────────────────────

  describe('POST actions', () => {
    beforeEach(() => { resetTestDb(); seedAdmin(); });

    it('set-tier updates division', async () => {
      seedTable('divisions', [{ id: 'd1', tier: 'free' }]);
      const { req, res } = mk('POST', { action: 'set-tier' }, { entityType: 'division', entityId: 'd1', tier: 'premium' });
      await handler(req, res);
      expect(res._status).toBe(200);
      expect(res._body.ok).toBe(true);
    });

    it('set-tier rejects invalid tier', async () => {
      const { req, res } = mk('POST', { action: 'set-tier' }, { entityType: 'division', entityId: 'd1', tier: 'nope' });
      await handler(req, res);
      expect(res._status).toBe(400);
      expect(res._body.error).toBe('Invalid tier');
    });

    it('invite creates invitation', async () => {
      seedTable('invitations', []);
      const { req, res } = mk('POST', { action: 'invite' }, { email: 'new@test.com', role: 'teacher' });
      await handler(req, res);
      expect(res._status).toBe(200);
      expect(res._body.ok).toBe(true);
    });

    it('create-division requires name', async () => {
      const { req, res } = mk('POST', { action: 'create-division' }, {});
      await handler(req, res);
      expect(res._status).toBe(400);
      expect(res._body.error).toBe('name required');
    });

    it('set-role updates teacher role', async () => {
      seedTable('profiles', [{ id: 'admin-1', role: 'platform_admin' }, { id: 't1', role: 'teacher' }]);
      const { req, res } = mk('POST', { action: 'set-role' }, { userId: 't1', role: 'school_admin' });
      await handler(req, res);
      expect(res._status).toBe(200);
      expect(res._body.ok).toBe(true);
    });

    it('set-expires accepts valid date', async () => {
      const { req, res } = mk('POST', { action: 'set-expires' }, { entityType: 'division', entityId: 'd1', expiresAt: new Date(Date.now() + 86400000).toISOString() });
      await handler(req, res);
      expect(res._status).toBe(200);
      expect(res._body.ok).toBe(true);
    });
  });

  // ── CORS ────────────────────────────────────────────────────

  it('handles OPTIONS', async () => {
    const res = { _status: 200, _ended: false,
      setHeader: vi.fn(() => res), status: vi.fn((c) => { res._status = c; return res; }),
      json: vi.fn(() => res), end: vi.fn(() => { res._ended = true; return res; }),
    };
    await handler({ method: 'OPTIONS', query: {}, headers: {}, body: {} }, res);
    expect(res._status).toBe(200);
    expect(res._ended).toBe(true);
  });

  it('has CORS headers', async () => {
    seedAdmin();
    const { req, res } = mk('GET', { action: 'overview' });
    await handler(req, res);
    expect(res._headers['Access-Control-Allow-Origin']).toBe('https://app.audioproctor.com');
  });
});
