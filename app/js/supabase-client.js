// ─── Supabase Client ─────────────────────────────────────────────
// The URL and anon key are safe to include in frontend code.
// They are NOT secrets. Only the service role key must stay server-side.
//
// SETUP: Replace the placeholder values below with your real project credentials.
// Find them in: Supabase Dashboard → Project Settings → API

const SUPABASE_URL      = 'https://rtdzqhgsxyrfstldojjr.supabase.co';
const SUPABASE_ANON_KEY = 'sb_publishable_DlFia01vmDaS-eQUlOXrdg_J0NoAuN_';

const { createClient } = supabase; // `supabase` loaded from CDN before this script
const supabaseClient = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
