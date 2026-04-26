-- ─── Dev Seed: Fake Requests & Invitations ─────────────────────────────
-- Run this in the Supabase SQL Editor for your dev/staging project.
-- Safe to run multiple times (it cleans up old seed data first).
--
-- Generates:
--   6 fake teacher_requests (mix of pending, approved, rejected)
--   4 fake invitations (mix of active and expired)

-- Clean up previous seed data (identified by seed emails)
DELETE FROM teacher_requests WHERE email LIKE 'seed-%@example.com';
DELETE FROM invitations WHERE email LIKE 'seed-%@example.com';

-- ─── Fake Teacher Requests ─────────────────────────────────────────────

INSERT INTO teacher_requests (name, email, school, division, message, status, request_type, created_at)
VALUES
  ('Alice Tremblay', 'seed-alice@example.com', 'École Secondaire Laurier', 'FrancoSud', 'I teach ELA 30-1 and need audio support for oral reading assessments. Would love to try the premium features.', 'pending', 'premium_trial', now() - interval '2 days'),
  ('Bob Singh', 'seed-bob@example.com', 'William Aberhart High', 'Calgary Board of Education', 'Our special-ed department heard about AudioProctor at the ATA conference. Requesting a school plan pilot.', 'pending', 'school_plan', now() - interval '5 days'),
  ('Carla Nguyen', 'seed-carla@example.com', 'Ross Sheppard High', 'Edmonton Public Schools', NULL, 'pending', 'access', now() - interval '1 day'),
  ('David Okafor', 'seed-david@example.com', 'Lester B. Pearson High', 'Calgary Board of Education', 'Currently using a manual CD player system. This would save me 20 minutes per assessment.', 'approved', 'premium_trial', now() - interval '10 days'),
  ('Emma Larsson', 'seed-emma@example.com', 'Queen Elizabeth High', NULL, 'I am an independent tutor working with 12 students. Is there a solo teacher plan?', 'rejected', 'premium_trial', now() - interval '14 days'),
  ('Frank Deluca', 'seed-frank@example.com', 'Bishop Carroll High', 'Calgary Catholic School District', 'Division-wide interest. Happy to schedule a 15-min demo call.', 'pending', 'division_plan', now() - interval '3 days');

-- ─── Fake Invitations ──────────────────────────────────────────────────

INSERT INTO invitations (email, role, school_id, division_id, expires_at, created_at)
VALUES
  ('seed-invite-1@example.com', 'teacher', NULL, NULL, now() + interval '5 days', now() - interval '2 days'),
  ('seed-invite-2@example.com', 'school_admin', (SELECT id FROM schools ORDER BY random() LIMIT 1), NULL, now() + interval '7 days', now() - interval '1 day'),
  ('seed-invite-3@example.com', 'teacher', NULL, (SELECT id FROM divisions ORDER BY random() LIMIT 1), now() - interval '3 days', now() - interval '10 days'),
  ('seed-invite-4@example.com', 'teacher', NULL, NULL, now() + interval '1 day', now() - interval '6 days');

-- Note: invitations 3 has an expired expires_at. The admin UI separates active vs expired.
