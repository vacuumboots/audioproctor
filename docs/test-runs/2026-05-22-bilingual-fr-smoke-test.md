# Bilingual FR Manual Smoke Test — May 22, 2026

Programmatic checks passed (locale key parity, API messages, em dashes). This covers the visual/manual surfaces only. Estimated 45 minutes.

Start at https://app.audioproctor.com/dashboard.html — already signed in.

---

## 1. Teacher Dashboard (10 min)

Toggle EN|FR in the top bar. After each toggle, check:

- [ ] Page title in browser tab: "AudioProctor — Dashboard" / "AudioProctor — Tableau de bord"
- [ ] Tier badge: "Free" / "Gratuit"
- [ ] Upload panel heading: "Create Assessment" / "Créer une évaluation"
- [ ] Label hint: "e.g. Grade 4 Reading, May 2026" / "p. ex. Lecture 4e année, Mai 2026"
- [ ] Audio tab: drag-and-drop text, "Max 50 MB · MP3 or WAV" / "Max 50 Mo · MP3 ou WAV"
- [ ] Text tab (click Text toggle): editor placeholder in French
- [ ] Access code: "Standard (ABC-123)" label, "Custom" label in both languages
- [ ] Exit word: "Exit Word" section title and "Randomly assigned" label
- [ ] Expiry: "Expires in 7 days" / "Expire dans 7 jours"
- [ ] Table headers: Assessment, Access Code, Exit Word, Expires, Label / Évaluation, Code d'accès, Mot de sortie, Expire, Nom
- [ ] Empty state (if no uploads): 3-step guide in French
- [ ] Rename modal: click rename on an upload → "Rename Assessment" / "Renommer l'évaluation"
- [ ] Delete modal: click delete → "Delete this assessment?" / "Supprimer cette évaluation?"
- [ ] Insights (if you have session data): "Total Sessions" / "Total des sessions", "Completion Rate" / "Taux d'achèvement"
- [ ] CSV export button: "Export CSV" / "Exporter en CSV"

### Quota & billing (check both languages)

- [ ] Trial banner (if trial active): "Trial ends in X days" / "L'essai se termine dans X jours"
- [ ] CTA at limit: "You're on the Free plan — 3 uploads/month" / "Vous êtes sur le forfait Gratuit — 3 téléversements/mois"
- [ ] Upgrade button: "Upgrade to Premium →" / "Passer à Premium →"
- [ ] Request access modal (click "Request Access" in CTA): "Request Access" / "Demander l'accès"

### Onboarding tutorial (if you have 0 uploads)

- [ ] Wizard appears after login (or click "Tutorial" in header with 0 uploads)
- [ ] All 5 steps render in French: "Bienvenue dans AudioProctor", steps about creating assessments, sharing codes, student flow
- [ ] Keyboard navigation (arrows/Escape) works in both languages

### First-login division gate (create a fresh account to test, or check existing)

- [ ] Modal title: "What division or school do you work for?" / "Pour quelle division ou école travaillez-vous?"
- [ ] TOS/privacy agreement text in French
- [ ] Autocomplete dropdown works (type a division name)

---

## 2. Settings Page (3 min)

Go to /settings.html

- [ ] Toggle to FR
- [ ] "Profile" / "Profil" section header
- [ ] "Subscription" / "Abonnement" section
- [ ] Tier display: "You're on the Free tier" / "Vous êtes sur le forfait Gratuit"
- [ ] "Delete Account" / "Supprimer le compte" section (scroll down)
- [ ] Delete warning text, "Type DELETE to confirm" / "Tapez SUPPRIMER pour confirmer"
- [ ] "Leaving a school?" / "Vous quittez une école?" hint text

---

## 3. Auth Flows (5 min)

Open an incognito window for a clean session.

- [ ] /login.html?lang=fr — "Connexion", "Se connecter avec Google", "Enseignants seulement"
- [ ] Sign in with Google → dashboard loads in French (since lang=fr was in URL)
- [ ] /accept-invite.html?lang=fr — "Accepter l'invitation" (if you have a valid token; otherwise just verify the page renders)

---

## 4. Platform Admin (5 min)

Go to /admin.html

- [ ] Toggle to FR, verify all tabs: "Aperçu", "Anomalies", "Divisions", "Écoles", "Enseignants", "Analytique", "Demandes", "Invitations", "Démo", "Contenu"
- [ ] Overview tab: stats labels in French ("Divisions", "Écoles", "Enseignants", "Total des sessions")
- [ ] Divisions tab: table headers "Nom", "Taille", "Forfait", "Expire"
- [ ] Teachers tab: "Filtrer par courriel ou division…", "Courriel", "Rôle", "Pays"
- [ ] Tier dropdown: "Gratuit", "Premium", "École", "Division"
- [ ] Role dropdown: "Enseignant", "Administrateur scolaire", "Administrateur de division"
- [ ] Content browser: "Tous les téléversements des enseignants" heading

---

## 5. School Admin (3 min)

Go to /school-admin.html (must have school_admin role or view-as from admin panel)

- [ ] Toggle to FR: "Admin scolaire", nav tabs in French
- [ ] Overview stats: "Enseignants", "Total des téléversements", "Total des sessions"
- [ ] Teachers table: "Courriel", "Téléversements", "Sessions", "Achèvement"
- [ ] Invite teacher modal: "Inviter un enseignant", "Envoyer l'invitation"

---

## 6. Division Admin (3 min)

Go to /division-admin.html (must have division_admin role or view-as)

- [ ] Toggle to FR: "Admin. de division"
- [ ] Overview: "Écoles", "Enseignants", "Actifs cette année", "Total des sessions"
- [ ] Activity chart: "Activité des évaluations", "Sessions par semaine"
- [ ] Schools table: "École", "Enseignants", "Sessions"

---

## 7. Chrome Extension (10 min)

Load unpacked from chrome://extensions (point at extension/ folder).

### Popup

- [ ] Popup opens, shows EN|FR toggle in footer
- [ ] Click FR → "Code d'accès", input placeholder, submit button in French
- [ ] Enter an invalid code → "Code d'accès invalide." error in French
- [ ] Toggle back to EN → verify strings switch back

### Audio player

- [ ] Enter a valid audio assessment code → player opens fullscreen
- [ ] Player shows "Access Code: ABC-123" / "Code d'accès : ABC-123"
- [ ] Play/pause controls visible
- [ ] Exit word prompt: "Enter the exit word to complete" / "Saisissez le mot de sortie pour terminer"

### Text assessment player

- [ ] Enter a valid text assessment code → reader opens
- [ ] "Read Aloud" / "Lire à voix haute" button
- [ ] Voice selector: "Voice" / "Voix", "Speed" / "Vitesse"
- [ ] Paragraph navigation: "Paragraph X of Y" / "Paragraphe X sur Y"
- [ ] Font controls: +A / -A work regardless of language
- [ ] Inline images render (data-apimg-idx placeholders resolved)
- [ ] Exit word prompt in French

---

## 8. Language Toggle Persistence (5 min)

- [ ] Set to FR on dashboard, refresh page → stays FR
- [ ] Navigate dashboard → settings → dashboard → stays FR
- [ ] Set to FR, sign out, sign back in → dashboard loads in FR
- [ ] Set to FR in extension popup, close popup, reopen → stays FR
- [ ] Set to EN in app, toggle does not cause layout shift or broken CSS

---

## 9. Date & Number Formatting — French Mode (5 min)

- [ ] Upload expiry dates: DD/MM/YYYY format (e.g. 25/06/2026)
- [ ] Trial end date: "Expire le 25/06/2026"
- [ ] Session counts: "1 234 sessions" (non-breaking thin space, not comma)
- [ ] File sizes: "50 Mo" not "50 MB"
- [ ] Percentages: "75 %" (space before %)
- [ ] Duration: "Moy. 2 min 30 s"

---

## 10. Marketing Site (5 min)

Visit https://audioproctor.com

- [ ] Homepage: append ?lang=fr → hero, features, pricing in French
- [ ] /about?lang=fr → "À propos d'AudioProctor"
- [ ] /contact?lang=fr → form labels, "Envoyer" button
- [ ] /use-cases?lang=fr → use case cards in French
- [ ] /privacy?lang=fr → privacy policy renders (machine translation acceptable)
- [ ] /terms?lang=fr → terms render
- [ ] Language toggle on marketing nav persists across page navigation

---

## Notes

If you find a bug: note the page, the string that's wrong, and whether it's missing entirely (English showing in French mode) or mistranslated. Missing keys usually mean the `t()` call uses a key that doesn't exist in `fr.json`. English showing in French mode usually means a hardcoded string somewhere.

The three API bugs found and fixed during this sweep (missing_auth/missing_param falling through to raw key names) suggest there may be similar issues in the browser-side `t()` calls — if a translation key is missing, the `t()` function likely returns the key name as fallback, just like `apiMessage()` does. Watch for raw dotted keys showing in the UI (e.g. "dashboard.upload.createAssessment") — those are missing from fr.json.
