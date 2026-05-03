# USERSTEPS.md — AudioProctor

Manual steps for the human operator. AI agents add items here when something requires
hands-on action (Supabase console, Google Cloud, Stripe dashboard, etc.).
Check off items as you complete them.

---

## Pending — v1.2.1 Inline Images release

- [ ] Set up Chrome Web Store automation secrets (see below) so future publishes are one-click
- [ ] Publish extension v1.2.1 to Chrome Web Store manually (last manual publish before automation)

## Completed

- [x] Deploy to Vercel (pushed to main)
- [x] Run migration 020 (`image_count` column) in Supabase SQL Editor
- [x] Run migration 021 (RLS policies for assessment-images) in Supabase SQL Editor
- [x] Create `assessment-images` bucket in Supabase Storage (private, 2 MB file size limit)

---

## Chrome Web Store automation

Workflow exists at `.github/workflows/publish-extension.yml`. Trigger from GitHub → Actions → Publish Extension → Run workflow. It bumps the version, zips the extension, uploads to Chrome Web Store, publishes (submits for review), and commits the version bump.

### One-time setup (human steps)

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
   - Name: AudioProctor Publish
   - Save the Client ID and Client Secret
5. Generate a refresh token:
   ```bash
   npx chrome-webstore-upload-cli@latest
   ```
   It opens a browser for auth, then prints the refresh token.
6. Find your **Chrome Web Store Extension ID** — the 32-char ID from your Developer Dashboard URL (not from `chrome://extensions`)
7. Add these secrets to GitHub (repo → Settings → Secrets and variables → Actions):
   - `CHROME_EXTENSION_ID`
   - `CHROME_CLIENT_ID`
   - `CHROME_CLIENT_SECRET`
   - `CHROME_REFRESH_TOKEN`

### Usage

After setup, publish a new version from GitHub Actions in ~2 minutes:
1. Go to repo → Actions → Publish Extension → Run workflow
2. Select bump type (patch/minor/major)
3. Click Run

The workflow bumps the version, zips, uploads, submits for review, and commits the version bump back to `main`. Vercel auto-deploys on the commit.

---

## Future: Other manual infrastructure

*nothing yet*
