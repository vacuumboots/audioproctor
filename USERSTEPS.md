# USERSTEPS.md — AudioProctor

Manual steps for the human operator. AI agents add items here when something requires
hands-on action (Supabase console, Google Cloud, Stripe dashboard, etc.).
Check off items as you complete them.

---

## Pending

- [ ] **Set up separate Supabase dev project** — currently dev and prod share one
  Supabase project. Create a second project (`audioproctor-dev`), replicate the
  schema with the same migration files, point `.env.local` at it. See AGENTS.md
  pitfall #3 for rationale.
- [ ] **Create Stripe Products and Prices** for School and Division Plans in
  Stripe Dashboard. The unified `stripe-checkout.js` endpoint inspects the caller's
  profile to determine pricing. Price IDs for division bands go in the
  `division_pricing` DB table.
- [ ] **Configure Stripe webhook endpoint** in Stripe Dashboard to point at
  `https://app.audioproctor.com/api/stripe-webhook` with events:
  `checkout.session.completed`, `customer.subscription.deleted`,
  `customer.subscription.updated`, `invoice.payment_succeeded`.
- [ ] **Chrome Web Store store assets** — screenshots, promo tiles, and demo video.
  See `store-assets/README.md` for specs. Upload manually via Developer Dashboard.
- [ ] **Purge `store-assets/README.md` placeholders** when actual assets are added.
- [ ] **Run migration 027** (`add_lang_to_profiles`) in Supabase SQL Editor — adds `lang` column to `profiles` table with default `'en'`

## Completed

- [x] Deploy to Vercel (pushed to main)
- [x] Run migration 020 (`image_count` column) in Supabase SQL Editor
- [x] Run migration 021 (RLS policies for assessment-images) in Supabase SQL Editor
- [x] Create `assessment-images` bucket in Supabase Storage (private, 2 MB file size limit)
- [x] Set up Chrome Web Store automation secrets
- [x] Publish extension v1.2.2 via automated workflow
- [x] Run migration 022 (`stripe_school_division`) in Supabase SQL Editor
- [x] Run migration 023 (`audio_normalization`) in Supabase SQL Editor
- [x] Run migration 024 (`onboarding_emails`) in Supabase SQL Editor
- [x] Run migration 025 (`platform_admin_rls`) in Supabase SQL Editor
- [x] Run migration 026 (`alberta_schools`) in Supabase SQL Editor — 91 divisions + 2,318 schools
- [x] Rotate Supabase `service_role` key after credential leak (2026-05-09)
- [x] Update `SUPABASE_SERVICE_ROLE_KEY` in Vercel env vars (all 3 environments)
- [x] Update `.env.local` with new service role key
- [x] Redeploy Vercel to pick up new env var
- [x] Verify admin dashboard loads correctly

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

## Bilingual testing checklist

Run through every item in both English and French after any i18n-related deployment.
The English baseline should be tested first; then toggle to French and repeat.
Check off each item once it passes in both languages.

### 1. Auth flows

- [ ] **EN:** Login page loads at /login.html — Google sign-in button renders correctly
- [ ] **FR:** Login page loads at /login.html with lang=fr — all strings in French (Connexion, Se connecter avec Google, Enseignants seulement, etc.)
- [ ] **EN:** Google OAuth redirects to app.audioproctor.com/dashboard.html after sign-in
- [ ] **FR:** Google OAuth redirects correctly regardless of lang param
- [ ] **EN:** First-login modal appears with org selector — "What division or school do you work for?"
- [ ] **FR:** First-login modal appears in French — "Pour quelle division ou école travaillez-vous?"
- [ ] **EN:** Accept invitation page at /accept-invite.html shows English strings
- [ ] **FR:** Accept invitation page at /accept-invite.html?lang=fr shows French strings
- [ ] **EN:** Invitation acceptance redirects to dashboard with welcome message in English
- [ ] **FR:** Invitation acceptance redirects to dashboard with welcome message in French
- [ ] **EN:** Session expiry banner appears correctly in English ("Your session has expired")
- [ ] **FR:** Session expiry banner appears correctly in French ("Votre session a expiré")
- [ ] **EN:** Account deactivation message in English ("This account has been deactivated")
- [ ] **FR:** Account deactivation message in French ("Ce compte a été désactivé")
- [ ] **EN:** Email-not-allowed error on sign-in shows English message
- [ ] **FR:** Email-not-allowed error on sign-in shows French message when Accept-Language: fr
- [ ] **EN:** Sign-out confirmation modal button text in English
- [ ] **FR:** Sign-out confirmation modal button text in French

### 2. Teacher Dashboard

- [ ] **EN:** Dashboard loads at /dashboard.html — all UI text in English
- [ ] **FR:** Dashboard loads at /dashboard.html?lang=fr — "Tableau de bord", "Téléverser une évaluation", etc.
- [ ] **EN:** Upload panel — label, hint text, placeholder all in English
- [ ] **FR:** Upload panel — "Nom de l'évaluation", "p. ex. Lecture 4e année, Mai 2026" in French
- [ ] **EN:** Audio upload: drag-and-drop hint, file requirements (Max 50 MB · MP3 or WAV) correct
- [ ] **FR:** Audio upload: "Glissez-déposez ou cliquez" and "Max 50 Mo · MP3 ou WAV" in French
- [ ] **EN:** Text assessment editor: placeholder, character count, image limits in English
- [ ] **FR:** Text assessment editor: "Collez le passage ou le texte de l'évaluation ici…" in French
- [ ] **EN:** Access code fields: standard format label, custom code label, exit word labels in English
- [ ] **FR:** Access code fields: "Code d'accès", "Mot de sortie", "Personnalisé — Je vais le taper moi-même" in French
- [ ] **EN:** Expiry date picker labels in English ("Expiry", "Extend 7 Days", etc.)
- [ ] **FR:** Expiry date picker labels in French ("Expiration", "Prolonger de 7 jours", etc.)
- [ ] **EN:** Uploads table headers: Assessment, Access Code, Exit Word, Expires, Label, Actions
- [ ] **FR:** Uploads table headers: "Évaluation", "Code d'accès", "Mot de sortie", "Expire", "Nom", "Actions"
- [ ] **EN:** Rename modal — title, label, placeholder in English
- [ ] **FR:** Rename modal — "Renommer l'évaluation", "Nom", "Entrez un nouveau nom" in French
- [ ] **EN:** Extend expiry modal — "Edit Expiry", date field, preset buttons in English
- [ ] **FR:** Extend expiry modal — "Modifier l'expiration", "Prolonger de 7 jours", etc. in French
- [ ] **EN:** Delete confirmation in English ("Delete this assessment? Students will lose access immediately.")
- [ ] **FR:** Delete confirmation in French ("Supprimer cette évaluation? Les élèves perdront immédiatement l'accès.")
- [ ] **EN:** CSV export: filename prefix "audioproctor-sessions", column headers in English
- [ ] **FR:** CSV export: filename prefix "audioproctor-sessions" (kept in English), exports successfully
- [ ] **EN:** Insights panel: "Total Sessions", "Completion Rate", "Total Replays", "Avg Duration"
- [ ] **FR:** Insights panel: "Total des sessions", "Taux d'achèvement", "Total des réécoutes", "Durée moyenne"
- [ ] **EN:** Empty state: 3-step guide text all in English
- [ ] **FR:** Empty state: "Téléversez votre première évaluation" and steps in French
- [ ] **EN:** "Normalizing…" / "Failed" / "Text" badges in English
- [ ] **FR:** "Normalisation…" / "Échec" / "Texte" badges in French

### 3. Quota & Billing

- [ ] **EN:** Free tier badge shows "Free" on the dashboard
- [ ] **FR:** Free tier badge shows "Gratuit" when lang=fr
- [ ] **EN:** Trial banner in English: "Trial ends in X days — Upgrade to keep unlimited uploads..."
- [ ] **FR:** Trial banner in French: "L'essai se termine dans X jours — Mettez à niveau pour conserver..."
- [ ] **EN:** Expired trial banner: "Your trial has expired — You're back on the Free plan."
- [ ] **FR:** Expired trial banner: "Votre essai a expiré — Vous êtes de retour au forfait Gratuit."
- [ ] **EN:** CTA text: "You're on the Free plan — 3 uploads/month, 50 MB storage, 32kbps audio."
- [ ] **FR:** CTA text: "Vous êtes sur le forfait Gratuit — 3 téléversements/mois, 50 Mo de stockage, audio 32 kbps."
- [ ] **EN:** Premium trial CTA: "Premium trial expires in X days."
- [ ] **FR:** Premium trial CTA: "L'essai Premium expire dans X jours."
- [ ] **EN:** School plan CTA: "Your school is on a plan."
- [ ] **FR:** School plan CTA: "Votre école a un forfait."
- [ ] **EN:** Division plan CTA: "Your division is on a plan."
- [ ] **FR:** Division plan CTA: "Votre division a un forfait."
- [ ] **EN:** "Upgrade to Premium →" button text in English
- [ ] **FR:** "Passer à Premium →" button text in French
- [ ] **EN:** Stripe Checkout redirects with English Stripe page
- [ ] **FR:** Stripe Checkout redirects correctly after lang toggle (Stripe locale auto-detects)
- [ ] **EN:** Quota display: "{used} of {limit} uploads used this month · Resets {date}"
- [ ] **FR:** Quota display: "{used} sur {limit} téléversements utilisés ce mois · Réinitialisation le {date}"
- [ ] **EN:** Request Access modal: titles, types (Premium Trial, School Plan, Division Plan), submit
- [ ] **FR:** Request Access modal: "Demander l'accès", "Prolongation de l'essai Premium", "Forfait École", "Forfait Division", "Soumettre la demande"
- [ ] **EN:** Request Access success message in English
- [ ] **FR:** Request Access success message in French ("Demande soumise. Vous serez averti par courriel...")
- [ ] **EN:** First-login org prompt: "Search for your division or school…" + TOS/privacy agreement
- [ ] **FR:** First-login org prompt: "Recherchez votre division ou école…" + conditions d'utilisation + confidentialité

### 4. Platform Admin

- [ ] **EN:** Admin panel at /admin.html — title "Platform Admin", all tab labels in English
- [ ] **FR:** Admin panel at /admin.html?lang=fr — title "Administration", tab labels in French
- [ ] **EN:** Overview tab: stats (Divisions, Schools, Teachers, Total Sessions, Completions, etc.)
- [ ] **FR:** Overview tab: "Divisions", "Écoles", "Enseignants", "Total des sessions", "Achèvements", etc.
- [ ] **EN:** Anomalies tab: "Accounts flagged for review", description, table headers
- [ ] **FR:** Anomalies tab: "Comptes signalés pour examen", description in French, table headers in French
- [ ] **EN:** Divisions tab: "All Divisions", "+ New Division", table headers (Name, Size, Tier, Expires, Notes / Flags)
- [ ] **FR:** Divisions tab: "Toutes les divisions", "+ Nouvelle division", "Nom", "Taille", "Forfait", "Expire", "Notes / Indicateurs"
- [ ] **EN:** Create division modal: name required, success/error messages in English
- [ ] **FR:** Create division modal: "Le nom de la division est requis." in French
- [ ] **EN:** Schools tab: "All Schools", "+ New School", table headers (Name, Division, Tier, Notes / Flags)
- [ ] **FR:** Schools tab: "Toutes les écoles", "+ Nouvelle école", "Nom", "Division", "Forfait", "Notes / Indicateurs"
- [ ] **EN:** Teachers tab: "All Teachers", filter placeholder, table headers (Email, School/Division, Tier Override, Trial, Role, Country, Notes / Flags)
- [ ] **FR:** Teachers tab: "Tous les enseignants", "Filtrer par courriel ou division…", "Courriel", "École / Division", "Forfait personnalisé", "Rôle", "Pays"
- [ ] **EN:** Tier dropdown options: Free, Premium, School, Division — in English
- [ ] **FR:** Tier dropdown options: "Gratuit", "Premium", "École", "Division" — in French
- [ ] **EN:** Role dropdown: Teacher, School Admin, Division Admin, Platform Admin — in English
- [ ] **FR:** Role dropdown: "Enseignant", "Administrateur scolaire", "Administrateur de division", "Administrateur de la plateforme"
- [ ] **EN:** Teacher actions: deactivate/reactivate/delete/reassign confirmation dialogs in English
- [ ] **FR:** Teacher actions: "Désactiver", "Réactiver", "Supprimer", "Réaffecter" — confirmations in French
- [ ] **EN:** Analytics tab: "Platform Activity", "Per-Division Breakdown", chart labels in English
- [ ] **FR:** Analytics tab: "Activité de la plateforme", "Répartition par division", "Sessions par semaine" in French
- [ ] **EN:** Requests tab: "Teacher Access Requests", table headers, approve/reject actions in English
- [ ] **FR:** Requests tab: "Demandes d'accès des enseignants", "Approuver", "Rejeter" in French
- [ ] **EN:** Invitations tab: "Pending Invitations", resend, table headers in English
- [ ] **FR:** Invitations tab: "Invitations en attente", "Renvoyer", table headers in French
- [ ] **EN:** Demo tab: title, description, seed button, view-as modal in English
- [ ] **FR:** Demo tab: "Comptes de démonstration", seed button "Générer / Actualiser", view-as modal in French
- [ ] **EN:** Content browser: "All Teacher Uploads", search, filters, pagination in English
- [ ] **FR:** Content browser: "Tous les téléversements des enseignants", "Rechercher par nom d'enseignant…", pagination in French
- [ ] **EN:** Audit log: "Audit Log" title
- [ ] **FR:** Audit log: "Journal d'audit" title
- [ ] **EN:** Cancel subscription confirmation in English
- [ ] **FR:** Cancel subscription confirmation in French ("Annuler l'abonnement")
- [ ] **EN:** Enrolment band selector labels in English (Small, Medium, Large, Metro)
- [ ] **FR:** Enrolment band selector labels in French ("Petit (moins de 2 000)", "Moyen (2 000–8 000)", etc.)

### 5. School Admin

- [ ] **EN:** School admin at /school-admin.html — title "School Admin", nav labels in English
- [ ] **FR:** School admin at /school-admin.html?lang=fr — "Admin scolaire", nav labels in French
- [ ] **EN:** Overview tab: stats (Teachers, Total Uploads, Total Sessions, Completion Rate)
- [ ] **FR:** Overview tab: "Enseignants", "Total des téléversements", "Total des sessions", "Taux d'achèvement"
- [ ] **EN:** Billing section: "School Plan", purchase button, billing labels in English
- [ ] **FR:** Billing section: "Forfait École", "Acheter le forfait École", "Facturé annuellement", etc.
- [ ] **EN:** Teachers tab: table headers (Email, Uploads, Sessions, Completion, Replays, Avg Listen, Last Active)
- [ ] **FR:** Teachers tab: "Courriel", "Téléversements", "Sessions", "Achèvement", "Réécoutes", "Écoute moyenne", "Dernière activité"
- [ ] **EN:** Remove teacher confirmation: "Remove {email} from this school?" in English
- [ ] **FR:** Remove teacher confirmation: "Retirer {email} de cette école?" in French
- [ ] **EN:** Invite teacher modal: title, description, email label, send button in English
- [ ] **FR:** Invite teacher modal: "Inviter un enseignant", "Courriel de l'enseignant", "Envoyer l'invitation" in French
- [ ] **EN:** Content browser: "School Teacher Uploads", search, filters in English
- [ ] **FR:** Content browser: "Téléversements des enseignants de l'école" in French
- [ ] **EN:** Access denied message for non-school-admin: "This page requires the School Admin role."
- [ ] **FR:** Access denied message: "Cette page nécessite le rôle d'administrateur scolaire."

### 6. Division Admin

- [ ] **EN:** Division admin at /division-admin.html — title "Division Admin" in English
- [ ] **FR:** Division admin at /division-admin.html?lang=fr — "Admin. de division" in French
- [ ] **EN:** Overview tab: stats (Schools, Teachers, Active This Year, Total Sessions)
- [ ] **FR:** Overview tab: "Écoles", "Enseignants", "Actifs cette année", "Total des sessions"
- [ ] **EN:** Billing section: "Division Plan", band selector, purchase button, invoice link in English
- [ ] **FR:** Billing section: "Forfait Division", "Sélectionnez la tranche d'effectifs", "Acheter le forfait Division" in French
- [ ] **EN:** Activity section: "Assessment Activity", chart labels in English
- [ ] **FR:** Activity section: "Activité des évaluations", "Sessions par semaine" in French
- [ ] **EN:** Schools tab: table headers (School, Teachers, Sessions, Completion, Replays)
- [ ] **FR:** Schools tab: "École", "Enseignants", "Sessions", "Achèvement", "Réécoutes"
- [ ] **EN:** Remove school from division confirmation: "Remove \"{name}\" from this division?" in English
- [ ] **FR:** Remove school from division confirmation: "Retirer «{name}» de cette division?" in French
- [ ] **EN:** School drill-down: "← Back to Schools", teacher table headers (Email, Uploads, Sessions, Completion, Replays, Avg Listen, Last Active)
- [ ] **FR:** School drill-down: "← Retour aux écoles", teacher table in French
- [ ] **EN:** Detach teacher: confirmation in English ("Detach {email}? They will be removed from their school and division...")
- [ ] **FR:** Detach teacher: "Dissocier {email}? Il/elle sera retiré(e) de son école..." in French
- [ ] **EN:** Remove admin role confirmation in English
- [ ] **FR:** Remove admin role confirmation: "Retirer le rôle d'administrateur scolaire de {email}?" in French
- [ ] **EN:** Invite teacher modal: school label ("optional — leave blank for division-wide"), send button
- [ ] **FR:** Invite teacher modal: "École (facultatif — laissez vide pour toute la division)", "Envoyer l'invitation"
- [ ] **EN:** CSV export: button text, headers in English ("School", "Teachers", "Total Sessions")
- [ ] **FR:** CSV export: button "Exporter en CSV", headers in French ("École", "Enseignants", "Total des sessions")
- [ ] **EN:** Content browser: "Division Teacher Uploads", search, filters, pagination in English
- [ ] **FR:** Content browser: "Téléversements des enseignants de la division" in French
- [ ] **EN:** Access denied: "This page requires the Division Admin role."
- [ ] **FR:** Access denied: "Cette page nécessite le rôle d'administrateur de division."

### 7. Extension (popup + player)

- [ ] **EN:** Popup loads at chrome-extension://... — access code input, submit button in English
- [ ] **FR:** Popup loads with lang=fr — all strings in French (code d'accès, etc.)
- [ ] **EN:** Popup shows language toggle (EN|FR buttons) in the footer
- [ ] **FR:** Popup language toggle correctly switches between EN and FR
- [ ] **EN:** Audio player page: "Access Code: ABC-123", play/pause, progress bar, volume in English
- [ ] **FR:** Audio player page: "Code d'accès : ABC-123" in French
- [ ] **EN:** Text assessment player: passage displays with TTS controls
- [ ] **FR:** Text assessment player: TTS controls (Lire à voix haute, Pause, Reprendre) in French
- [ ] **EN:** Voice selection dropdown: labels in English ("Voice", "Speed", "Paragraph")
- [ ] **FR:** Voice selection dropdown: "Voix", "Vitesse", "Paragraphe" in French
- [ ] **EN:** Exit word prompt: "Enter the exit word to complete:" + input field + submit button in English
- [ ] **FR:** Exit word prompt: "Saisissez le mot de sortie pour terminer :" in French
- [ ] **EN:** Exit word verification: success message in English, redirect
- [ ] **FR:** Exit word verification: success message in French
- [ ] **EN:** Error states: invalid code, expired code, network error — all in English
- [ ] **FR:** Error states: "Code d'accès invalide", "Expiré", "Erreur réseau" — in French
- [ ] **EN:** Loading/playing states: "Loading…", "Playing…" in English
- [ ] **FR:** Loading/playing states: "Chargement…", "Lecture en cours…" in French
- [ ] **EN:** Inline images in text assessments render correctly (data-apimg-idx)
- [ ] **FR:** Inline images render regardless of language (no language dependency)
- [ ] **EN:** Player button: font size controls (+A, -A), fullwidth toggle in English
- [ ] **FR:** Player button: font size controls, fullwidth mode labels in French
- [ ] **EN:** Offscreen document loads correctly for TTS audio handling
- [ ] **FR:** Offscreen document functions correctly regardless of language setting

### 8. Language toggle persistence

- [ ] **EN:** Language toggle button (EN|FR) is visible on every app page header
- [ ] **FR:** Clicking FR on any page immediately switches all visible strings to French
- [ ] **EN:** Clicking EN on any page immediately switches all visible strings to English
- [ ] **FR:** Language preference persists after page refresh (stored in localStorage / cookie)
- [ ] **EN:** Language preference survives navigating between pages (dashboard → admin → settings)
- [ ] **FR:** Language preference survives logout — set to French, sign out, see login page in French
- [ ] **EN:** Language preference survives login — previously set to French, sign in, dashboard is in French
- [ ] **EN:** Language preference persisted server-side (lang column in profiles table) — set to FR, close browser, reopen, still French
- [ ] **FR:** Server-side persistence works: user.lang='fr' is written to profiles table on toggle
- [ ] **EN:** Server-side lang value is read on page load before client-side override
- [ ] **EN:** Language toggle works in extension popup (not just web app)
- [ ] **FR:** Extension language toggle persists across popup open/close in chrome.storage.session

### 9. Date / number formatting (French locale)

- [ ] **FR:** Upload expiry dates displayed in DD/MM/YYYY format (e.g. "25/06/2026") not MM/DD/YYYY
- [ ] **FR:** Trial end dates shown in French: "Expire le 25/06/2026"
- [ ] **FR:** "Expires" column in uploads table uses DD/MM/YYYY format
- [ ] **FR:** Thousands separator uses narrow non-breaking space in French (e.g. "1 234" not "1,234")
- [ ] **FR:** Session counts show French formatting: "1 234 sessions"
- [ ] **FR:** File sizes in French: "50 Mo" not "50 MB"
- [ ] **FR:** Percentage values: "75 %" with space before %
- [ ] **FR:** Duration: "Moy. 2 min 30 s" in French
- [ ] **EN:** English dates remain in MM/DD/YYYY or configurable format
- [ ] **EN:** English thousands separator remains comma (e.g. "1,234")
- [ ] **EN:** File sizes remain "50 MB" in English mode
- [ ] **EN:** Duration: "Avg 2 min 30 s" in English

### 10. API — localized error messages

- [ ] **EN:** `GET /api/session?code=INVALID` returns "Invalid access code." in English (default)
- [ ] **FR:** `GET /api/session?code=INVALID` with `Accept-Language: fr` returns "Code d'accès invalide."
- [ ] **FR:** `GET /api/session?code=INVALID&lang=fr` returns French message (query param override)
- [ ] **EN:** `POST /api/event` with missing body returns "Invalid request." in English
- [ ] **FR:** `POST /api/event` with missing body + `Accept-Language: fr` returns "Requête invalide." in French
- [ ] **EN:** `POST /api/admin?action=list-teachers` without auth returns "Missing authorization header"
- [ ] **FR:** `POST /api/admin` without auth + `Accept-Language: fr` returns "En-tête d'autorisation manquant"
- [ ] **EN:** `POST /api/account` with missing userId returns "userId required" in English
- [ ] **FR:** `POST /api/account` with lang=fr returns "userId requis"
- [ ] **EN:** `POST /api/org?action=school-teachers` without auth returns English error
- [ ] **FR:** `POST /api/org?action=school-teachers` with `Accept-Language: fr` returns French error
- [ ] **EN:** `POST /api/admin?action=create-division` without name returns "name required"
- [ ] **FR:** returns "nom requis" with `Accept-Language: fr`
- [ ] **EN:** `POST /api/admin?action=set-tier` with invalid params returns English error
- [ ] **FR:** returns "Impossible de mettre à jour le forfait" in French
- [ ] **EN:** Rate-limited session endpoint: "Too many attempts. Try again later." in English
- [ ] **FR:** Rate-limited session endpoint: "Trop de tentatives. Veuillez réessayer plus tard." in French
- [ ] **EN:** Quota exceeded upload: English error message returned
- [ ] **FR:** Quota exceeded upload: "Vous avez atteint votre limite mensuelle de téléversements." in French
- [ ] **EN:** Invitation expired endpoint: "This invitation has expired." in English
- [ ] **FR:** Invitation expired endpoint: "Cette invitation a expiré." in French
- [ ] **EN:** Stripe checkout error: English message
- [ ] **FR:** Stripe checkout error: French message with lang=fr

### 11. Emails (invitation + notification)

- [ ] **EN:** Invitation email sent from admin panel has English subject and body
- [ ] **FR:** Invitation email sent while lang=fr has French subject and body (or bilingual fallback)
- [ ] **EN:** Access request notification to admin is in English
- [ ] **FR:** Access request notification to admin is in French when sender had lang=fr
- [ ] **EN:** Invitation accepted confirmation email (to invited teacher) is in English
- [ ] **FR:** Invitation accepted confirmation email is in French when teacher's lang is fr
- [ ] **EN:** Contact form submission confirmation email in English
- [ ] **FR:** Contact form submission with lang=fr sends French confirmation
- [ ] **EN:** School/Division plan purchase receipt email (via Stripe webhook) in English
- [ ] **FR:** School/Division plan purchase receipt email in French when user.lang='fr'
- [ ] **EN:** Resend invitation — re-sent email preserves English
- [ ] **FR:** Resend invitation — re-sent email preserves French
- [ ] **EN:** Email send failure shown in English toast/alert
- [ ] **FR:** Email send failure shown in French toast/alert

### 12. Marketing site (all 7 pages)

- [ ] **EN:** index.html (root) — hero text, features, CTA in English
- [ ] **FR:** index.html?lang=fr — hero text, features, CTA in French
- [ ] **EN:** /about — "About AudioProctor" in English
- [ ] **FR:** /about?lang=fr — "À propos d'AudioProctor" in French
- [ ] **EN:** /contact — form labels, submit button in English
- [ ] **FR:** /contact?lang=fr — form labels, "Envoyer" in French
- [ ] **EN:** /privacy — privacy policy in English
- [ ] **FR:** /privacy?lang=fr — privacy policy available in French (or bilingual notice)
- [ ] **EN:** /terms — terms of service in English
- [ ] **FR:** /terms?lang=fr — terms of service in French
- [ ] **EN:** /use-cases — use case descriptions in English
- [ ] **FR:** /use-cases?lang=fr — use case descriptions in French
- [ ] **EN:** /request-access — form labels, school/division fields, submit button in English
- [ ] **FR:** /request-access?lang=fr — "Demander l'accès", form labels in French
- [ ] **EN:** Marketing site nav links: "Features", "About", "Contact", "Privacy", "Terms" in English
- [ ] **FR:** Marketing site nav links in French
- [ ] **EN:** Marketing site footer: copyright notice in English
- [ ] **FR:** Marketing site footer: copyright notice with French translation of legal text
- [ ] **EN:** All 7 pages render without broken strings or missing translations
- [ ] **FR:** All 7 pages render without broken strings or missing translations — no raw English keys visible
- [ ] **EN:** Language toggle on marketing site persists across pages
- [ ] **FR:** Language toggle on marketing site persists across pages

### Cross-cutting checks

- [ ] All English strings in `app/locales/en.json` have a corresponding French translation in `fr.json`
- [ ] All French keys in `fr.json` match the exact same key structure as `en.json` (no orphaned keys)
- [ ] All i18n keys in `api/locales/api-messages.json` have both `en` and `fr` entries
- [ ] No hardcoded English strings remain in any app HTML file (all use `data-i18n` or `t()` calls)
- [ ] No hardcoded English strings remain in any app JS file (all use `t()` calls)
- [ ] No hardcoded English strings remain in extension HTML/JS files
- [ ] Language toggle does not cause layout shift or broken CSS on any page
- [ ] Language toggle does not break Supabase auth flows (OAuth redirect, session)
- [ ] Language toggle does not break Stripe Checkout redirect
- [ ] Language toggle does not break the extension popup layout
- [ ] Extension language loads correctly when chrome.storage has a saved preference
- [ ] Date formatting respects locale in all places (not just toggling string keys)

---

## Bilingual testing notes

- For web app pages, toggle language via the UI toggle in the header, or append `?lang=fr` to the URL.
- For API testing, set the `Accept-Language: fr` header in curl/Postman, or pass `?lang=fr`.
- The marketing site (`site/` pages) may not have the same language toggle as the web app — test separately with `?lang=fr`.
- Extension language is toggled within the popup itself (EN|FR buttons in the footer).
- Emails currently send in the sender's language. Test by setting your profile to French before triggering an email.
- The extension stores language preference in `chrome.storage.session` — ephemeral, resets when browser restarts. This is by design.
