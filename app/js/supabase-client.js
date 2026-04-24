// ─── Supabase Client ─────────────────────────────────────────────
// The URL and anon key below are the real project credentials.
// They are safe to include in frontend code — they are NOT secrets.
// Only the service role key must stay server-side.

const SUPABASE_URL      = 'https://rtdzqhgsxyrfstldojjr.supabase.co';
const SUPABASE_ANON_KEY = 'sb_publishable_DlFia01vmDaS-eQUlOXrdg_J0NoAuN_';

const { createClient } = supabase; // `supabase` loaded from CDN before this script
const supabaseClient = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
