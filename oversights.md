
  ---
  1. CORS bug in api/event.js (silent analytics failure)

  The extension's player.js calls /api/event from a chrome-extension:// origin, not from app.audioproctor.com. If api/event.js uses the same restrictive Access-Control-Allow-Origin: https://app.audioproctor.com header that the other APIs
  use, every analytics event logged by the extension is silently failing right now. It should use * since this endpoint takes no credentials. Worth checking the actual header in that file.

  ---
  2. No RLS on divisions and schools tables

  Migration 005 creates these tables but adds no ALTER TABLE ... ENABLE ROW LEVEL SECURITY or policies. In Supabase, if RLS is disabled on a table, all authenticated users can read and write everything. The settings page queries schools
  and divisions client-side — that works, but so does any authenticated user querying any school or division directly. Depending on what Supabase's default is for your project, this is either a data exposure risk or a silent breakage.

  ---
  3. No way to assign school_admin or division_admin roles

  The platform admin dashboard has no UI to promote a teacher to school_admin or division_admin. It's manual SQL only. This blocks the entire School/Division Admin UI from being usable in a real pilot — you can't hand a principal a login
  without running a SQL command first. This feels like it belongs in Stage 4/5 but it's nowhere in the roadmap.

  ---
  4. The "notified by email on detachment" promise is broken

  The Detach and Fallback Rule says: "The teacher is notified by email at the moment of detachment that their tier has changed." That's the roadmap's own language — it's not a Stage 6 thing, it's presented as part of the tier transition
  behavior. Nothing sends that email. A teacher removed from a school would silently lose access to analytics and unlimited uploads with no warning. That's a trust issue in a school environment.

  ---
  5. upload_summaries is empty after migration 004 until the cron job fires

  After you run migration 004, the materialized view has no data. The first cron job runs up to 15 minutes later. Until then, Insights shows nothing and all analytics stats are zero, even for accounts with real sessions. There should be a
  REFRESH MATERIALIZED VIEW upload_summaries; line at the bottom of the migration — a one-time seed — and the Insights card should show "Data refreshes every 15 minutes" so teachers don't think it's broken.

  ---
  6. Privacy Policy update is still unchecked

  session_events is actively collecting data (if the migration has been run). You're recording student behaviour — even anonymously — without having updated the Privacy Policy. For a K-12 product selling to Alberta divisions, this needs to
   be resolved before any pilot. FOIPPA scrutiny from a division's privacy officer will land on this immediately.

  ---
  7. No Terms of Service acceptance

  Teachers sign in with Google and land directly on the dashboard. There's no ToS acceptance step. For a paid B2B product in schools, a division's procurement process will ask for evidence that users have agreed to terms. The first-login
  modal (currently only asking for division name) is the natural place to add this.

  ---
  8. First-login division name has no validation

  When a teacher types their division name in the first-login modal, it's stored as freetext in profiles.division_name — completely disconnected from the actual divisions table. So you could have 40 teachers all typing slightly different
  versions of "Foothills School Division No. 38" and none of them matching the actual division record. There's no autocomplete, no fuzzy match, no lookup. The data you're collecting is mostly useless for the platform admin's anomaly
  review.

  ---
  9. admin.listUsers() has a hard 1000-user cap

  Both api/admin.js and api/org.js call supabase.auth.admin.listUsers({ perPage: 1000 }) to build the email map. If you ever exceed 1000 teachers, emails silently go missing from the teacher list. The Supabase admin API supports
  pagination; this should use it. Not urgent now, but it's the kind of thing that breaks quietly in production.

  ---
  10. No audit log for admin actions

  When a platform admin flips a tier, detaches a teacher, or changes notes — nothing is logged. If a pilot division asks "why did our tier change last Tuesday?" or a teacher asks "who removed me from my school?" — there's no answer. This
  matters especially because tier changes affect billing and access. A simple admin_audit_log table (actor, action, target_id, target_type, before_value, after_value, timestamp) would cover it.

  ---
  11. No rollup for the teacher's own "this is my division" link

  A teacher attached to a school is only linked via profiles.school_id. Their division_id is null. But get_effective_tier() correctly resolves through the school. The problem: the settings page checks profile.division_id to show "Your
  division is on a plan" — but it won't fire for a teacher attached to a school that's attached to a division. The settings page subscription logic has this gap. Worth verifying.

  ---
  12. No deactivation — only deletion

  The roadmap has account deletion (Stage 6). But there's no deactivation. The realistic scenario in a school context is: a teacher leaves the school district. You want to suspend their access without deleting their data (their class may
  still have active codes; you may need the session records for IEP documentation). Deletion is irreversible and immediate; deactivation preserves data with a grace period. This is documented in Stage 6 as "Account Lifecycle" but the
  distinction between deactivation and deletion deserves sharper treatment.

  ---
  13. The extension's API_BASE is hardcoded to production

  extension/player.js has const API_BASE = 'https://audioproctor.com'. There's no way to test event logging locally. During development, you can verify the extension UI but you can never confirm analytics events are landing correctly
  without deploying. Worth at least a localhost switch even if it's a manual comment.

  ---
  ---
  14. Monolithic JS files are getting unwieldy

  app/js/dashboard.js is 1,786 lines. app/js/admin.js is 1,214 lines. Both mix UI rendering, API calls, event handlers, validation, and state management in a single file with no module boundaries. Without a bundler you can't use ES modules,
  but splitting into multiple <script> tags with clear responsibility boundaries (e.g. dashboard-upload.js, dashboard-table.js, dashboard-quota.js) would make these maintainable. Every new feature adds 50-200 lines to an already-large file.

  ---
  15. Google Fonts loaded from Google's CDN on the web app

  app/css/styles.css imports Playfair Display and DM Sans from fonts.googleapis.com. The extension already removed this dependency for privacy reasons (Manifest V3 CSP). The web app still loads them on every page. For a K-12 product handling
  student assessment data, loading fonts from a third-party CDN is a privacy consideration — Google receives the request including the page URL and IP. Self-hosting the fonts would close this.

  ---
  16. WAV-to-MP3 conversion is entirely client-side

  dashboard.js converts WAV files to MP3 in the browser using the Web Audio API + MediaRecorder. This works in Chrome but has browser compatibility risks, memory pressure for large files, and no fallback. A teacher on Firefox or an older
  Chromebook could hit silent failures. Server-side transcoding (e.g. Supabase Edge Function + ffmpeg) would be more reliable and is partially covered by the "Audio normalization" item in the ROADMAP.

  ---
  The two I'd prioritize before any pilot:
  - #3 (no way to assign admin roles) — blocks the entire multi-org feature
  - #6 (Privacy Policy) — will be the first question from any division's privacy officer