# USERSTEPS.md — AudioProctor

Manual steps for the human operator. AI agents add items here when something requires
hands-on action (Supabase console, Google Cloud, Stripe dashboard, etc.).
Check off items as you complete them.

---

## Pending — v1.2.1 Inline Images release

- [ ] Deploy to Vercel (`git push` to trigger)
- [ ] Publish extension v1.2.1 to Chrome Web Store (manual upload or automate — see Extension Automation below)

## Completed

- [x] Run migration 020 (`image_count` column) in Supabase SQL Editor
- [x] Run migration 021 (RLS policies for assessment-images) in Supabase SQL Editor
- [x] Create `assessment-images` bucket in Supabase Storage (private, 2 MB file size limit)

---

## Future: Chrome Web Store automation

Current process: zip extension manually → upload in Chrome Web Store Developer Dashboard → submit for review → wait.

### One-time setup

1. Go to [Google Cloud Console](https://console.cloud.google.com), create or select a project
2. Enable **Chrome Web Store API** (APIs & Services → Library → search "Chrome Web Store")
3. Configure **OAuth consent screen** (APIs & Services → OAuth consent screen):
   - User type: External
   - App name: AudioProctor
   - User support email: your email
   - Developer contact: your email
   - Add yourself as a test user under "Test users"
4. Create **OAuth 2.0 credentials** (APIs & Services → Credentials → Create Credentials → OAuth client ID):
   - Application type: Desktop app
   - Name: anything
   - Save the Client ID and Client Secret
5. Generate a refresh token:
   ```bash
   npx chrome-webstore-upload-cli@latest
   ```
   It opens a browser for auth, then prints the refresh token.
6. Find your **Chrome Web Store Extension ID** — the 32-char ID from your Developer Dashboard URL, not from `chrome://extensions`
7. Add these secrets to GitHub (repo → Settings → Secrets and variables → Actions):
   - `CHROME_EXTENSION_ID`
   - `CHROME_CLIENT_ID`
   - `CHROME_CLIENT_SECRET`
   - `CHROME_REFRESH_TOKEN`

### GitHub Actions workflow (to be created later)

Will live at `.github/workflows/publish-extension.yml`. Zips the extension, uploads to Chrome Web Store via API, submits for review. Review is not instant — typically a few hours for established extensions.

---

## Future: Other manual infrastructure

*nothing yet*
