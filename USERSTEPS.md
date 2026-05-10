# USERSTEPS.md — AudioProctor

Manual steps for the human operator. AI agents add items here when something requires
hands-on action (Supabase console, Google Cloud, Stripe dashboard, etc.).
Check off items as you complete them.

---

## Pending

*nothing yet*

## Completed

- [x] Deploy to Vercel (pushed to main)
- [x] Run migration 020 (`image_count` column) in Supabase SQL Editor
- [x] Run migration 021 (RLS policies for assessment-images) in Supabase SQL Editor
- [x] Create `assessment-images` bucket in Supabase Storage (private, 2 MB file size limit)
- [x] Set up Chrome Web Store automation secrets (see below)
- [x] Publish extension v1.2.2 via automated workflow (upload + publish succeeded; git push failed on first run due to workflow permissions — fixed)

---

## Chrome Web Store automation

Workflow exists at `.github/workflows/publish-extension.yml`. Trigger from GitHub → Actions → Publish Extension → Run workflow. It bumps the version, zips the extension, uploads to Chrome Web Store, publishes (submits for review), and commits the version bump.

### One-time setup (human steps)

This project uses **two separate** Google OAuth clients in the same project:
- **"AudioProctor Web"** (Web application) — for teacher app Google login via Supabase Auth. Already existed.
- **"AudioProctor Publish"** (Desktop app) — specifically for Chrome Web Store API access. Created below.

1. Go to [Google Cloud Console](https://console.cloud.google.com), create or select a project
2. Enable **Chrome Web Store API** (APIs & Services → Library → search "Chrome Web Store")
3. Configure **OAuth consent screen** (APIs & Services → OAuth consent screen):
   - User type: External
   - App name: AudioProctor
   - User support email: your email
   - Developer contact: your email
   - Add yourself as a test user under "Test users" (**required** — the OAuth flow will fail with 403 otherwise)
4. Create **OAuth 2.0 credentials** (APIs & Services → Credentials → Create Credentials → OAuth client ID):
   - Application type: **Desktop app**
   - Name: AudioProctor Publish
   - Save the Client ID and Client Secret
   - **Important:** Keep this separate from any existing "Web application" client used for Supabase auth
5. Generate a refresh token (choose one method):
   - **Preferred — `chrome-webstore-upload-keys` CLI** (automated browser flow):
     ```bash
     npx chrome-webstore-upload-keys@latest
     ```
     Starts a local server, opens browser for OAuth, prints the refresh token.
   - **Fallback — Google OAuth Playground** (manual):
     1. Go to https://developers.google.com/oauthplayground/
     2. Click gear icon → check "Use your own OAuth credentials"
     3. Enter AudioProctor Publish Client ID and Client Secret
     4. In Step 1, find "Chrome Web Store API" → check `https://www.googleapis.com/auth/chromewebstore`
     5. Click "Authorize APIs" — if you get `redirect_uri_mismatch`, use the CLI method instead (Desktop app clients don't accept the Playground's redirect URI)
     6. In Step 2, click "Exchange authorization code for tokens"
     7. Copy the Refresh token
6. Find your **Chrome Web Store Extension ID** — the 32-char ID from your Developer Dashboard URL (not from `chrome://extensions`).
   Current: `fcphbkffopenkinliokmlopfnglbcfdj`
7. Add these secrets to GitHub (repo → Settings → Secrets and variables → Actions):
   - `CHROME_EXTENSION_ID`
   - `CHROME_CLIENT_ID`
   - `CHROME_CLIENT_SECRET`
   - `CHROME_REFRESH_TOKEN`
8. Enable Actions write access (repo → Settings → Actions → General):
   - **Workflow permissions:** "Read and write permissions"
   - **Allow GitHub Actions to create and approve pull requests:** checked
   - Without this, the workflow can upload/publish but can't push the version bump commit.

### Usage

After setup, publish a new version from GitHub Actions in ~2 minutes:
1. Go to repo → Actions → Publish Extension → Run workflow
2. Select bump type (patch/minor/major)
3. Click Run

The workflow bumps the version, zips, uploads, submits for review, and commits the version bump back to `main`. Vercel auto-deploys on the commit.

### Common pitfalls

- **`refreshToken is required` error:** `chrome-webstore-upload-cli` only consumes refresh tokens — it does not generate them. Use `chrome-webstore-upload-keys` or the OAuth Playground to get an initial refresh token.
- **"The OAuth client was not found" (401):** Client ID is wrong, typo'd, or hasn't propagated yet (can take minutes to hours after creation).
- **"access_denied" (403) / "has not completed the Google verification process":** Your email isn't added as a test user on the OAuth consent screen. Add it under "Test users."
- **"redirect_uri_mismatch" (400):** Desktop app clients only accept `http://localhost` redirects. The OAuth Playground uses a different URI. Use the `chrome-webstore-upload-keys` method instead.
- **`fatal: unable to access ... 403` at the commit step:** GitHub Actions doesn't have write permissions. Fix in repo Settings → Actions → General → Workflow permissions.

---

## Store listing assets

Screenshots, promo tiles, and demo video for the Chrome Web Store listing live at:

```
store-assets/
  screenshots/     — 1-5 screenshots (1280x800 PNG/JPEG, max 2 MB each)
  tiles/           — promo tiles (marquee 440x280, icon 128x128)
  video/           — demo/promo video (MP4, max 60s, max 256 MB)
```

See `store-assets/README.md` for full specs and naming conventions.

These are uploaded manually via the Chrome Web Store Developer Dashboard — they are NOT part of the extension package that the automated publish workflow zips. The workflow only zips `extension/`.

**Flow for a release:**
1. Run "Publish Extension" from GitHub Actions — this submits the code for review
2. While under review, update listing assets in `store-assets/` and upload via Developer Dashboard
3. Submit the listing update from the dashboard separately

---

## Pending

*no pending user steps*

---

## Pending

- [ ] **Run migration 025** in Supabase SQL Editor (`025_platform_admin_rls.sql` — adds platform_admin all-access policies on `divisions`, `schools`, and `division_pricing` tables)

### Migration 025 verification

1. In Supabase SQL Editor, paste and run the contents of `supabase/migrations/025_platform_admin_rls.sql`
2. After running, verify policies exist by running:
   ```sql
   SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual
   FROM pg_policies
   WHERE tablename IN ('divisions', 'schools', 'division_pricing')
   ORDER BY tablename, policyname;
   ```
   You should see `platform_admin_divisions_all`, `platform_admin_schools_all`, `read_pricing_authenticated`, and `platform_admin_pricing_all` alongside the existing policies from migration 007.

---

## Stripe billing for School & Division Plans

- [x] Run migration 022 (`stripe_school_division`) in Supabase SQL Editor — **completed**
- [x] Run migration 023 (`audio_normalization`) in Supabase SQL Editor — **completed**
- [ ] Create Stripe Products and Prices for School Plan and Division Plans:
  - **School Plan**: Create a product "School Plan" with a recurring annual price (e.g., $500/year). Save the Price ID as `STRIPE_SCHOOL_PRICE_ID` in Vercel env vars.
  - **Division Plans**: Create products for each enrolment band (Small $250, Medium $500, Large $1,000, Metro $2,000/year). Save each Price ID in the `division_pricing` table — update the seed data in migration 022 with actual Stripe Price IDs after creation.
- [ ] Add `STRIPE_SCHOOL_PRICE_ID` to Vercel environment variables (both Preview and Production)
- [ ] Configure Stripe webhook endpoint in Stripe Dashboard to point at `https://app.audioproctor.com/api/stripe-webhook` with these events:
  - `checkout.session.completed`
  - `customer.subscription.deleted`
  - `customer.subscription.updated`
  - `invoice.payment_succeeded`
- [ ] Test the full flow: log in as a school admin → purchase School Plan → verify tier upgrade → check Stripe dashboard for subscription
