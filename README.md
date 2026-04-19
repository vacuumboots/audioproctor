# AudioProctor

Audio accommodation for provincial assessments on managed Chromebooks.

Teachers upload an MP3, generate a short access code, and hand it to the student. The student enters the code into the Chrome extension on their Chromebook. A fullscreen, locked audio player opens. When the assessment is done, the teacher reads an exit word aloud — the student types it in, the player closes, and the Chromebook returns to normal.

No student accounts. No student data. No IT ticket per assessment.

---

## Architecture

Two domains, one Vercel deployment:

| Domain | Content |
|--------|---------|
| `audioproctor.com` | Marketing site (`index.html`, `site/`) |
| `app.audioproctor.com` | Teacher app (`login.html`, `dashboard.html`, etc.) |

`vercel.json` rewrites clean URLs (`/about`, `/contact`, `/request-access`, etc.) to their `site/*.html` counterparts. No host-based routing.

**Stack:** Vanilla HTML/CSS/JS · Vercel serverless functions · Supabase (Postgres + Storage + Auth) · Stripe · Resend · Chrome Extension (Manifest V3)

---

## Local development

```bash
# Install dependencies (Stripe, Resend, Supabase client)
npm install

# Start local dev server (reads .env.local)
vercel dev
```

The extension must be loaded unpacked from `chrome://extensions` for local testing. There is no build step.

### Required environment variables

Create `.env.local` with:

```
SUPABASE_URL=
SUPABASE_ANON_KEY=
SUPABASE_SERVICE_ROLE_KEY=
RESEND_API_KEY=
CONTACT_EMAIL=
STRIPE_SECRET_KEY=
STRIPE_WEBHOOK_SECRET=
STRIPE_PRICE_ID=
```

---

## Project structure

```
/
├── index.html              # Marketing homepage
├── login.html              # Google OAuth sign-in
├── dashboard.html          # Teacher upload dashboard
├── player.html             # Web-based audio player (fallback)
├── admin.html              # Platform admin dashboard
├── school-admin.html       # School admin dashboard
├── division-admin.html     # Division admin dashboard
├── settings.html           # Teacher profile + subscription settings
├── accept-invite.html      # Invitation acceptance flow
│
├── site/                   # Marketing site pages
│   ├── about.html
│   ├── contact.html
│   ├── request-access.html # Teacher access request form
│   ├── use-cases.html
│   ├── privacy.html
│   ├── terms.html
│   ├── nav.js              # Shared nav/footer injected on every marketing page
│   └── site.css            # Marketing-only styles
│
├── api/                    # Vercel serverless functions
│   ├── session.js          # Validate access code → signed URL + exit word hash
│   ├── event.js            # Log playback events (anonymous)
│   ├── account.js          # Profile update + account deletion
│   ├── org.js              # School/division admin operations
│   ├── admin.js            # Platform admin operations (service role)
│   ├── request-access.js   # Store teacher access request + notify admin
│   ├── accept-invite.js    # Validate + accept invitation tokens
│   ├── stripe-checkout.js  # Create Stripe Checkout Session
│   ├── stripe-webhook.js   # Handle Stripe subscription events
│   └── contact.js          # Contact/demo request form handler
│
├── js/                     # Client-side JavaScript
│   ├── auth.js             # Shared auth helpers (requireAuth, ensureProfile, getEffectiveTier)
│   ├── dashboard.js        # Upload, quota, analytics, exit word generation
│   ├── admin.js            # Platform admin UI
│   ├── school-admin.js     # School admin UI
│   ├── division-admin.js   # Division admin UI
│   ├── settings.js         # Settings page
│   ├── player.js           # Web player (fallback)
│   └── supabase-client.js  # Supabase client initialisation
│
├── css/
│   └── styles.css          # Full design system (app + shared)
│
├── extension/              # Chrome Extension (Manifest V3)
│   ├── manifest.json
│   ├── popup.html/js       # Code entry UI
│   ├── player.html/js      # Fullscreen locked audio player
│   ├── background.js       # Service worker — window lifecycle + fullscreen enforcement
│   ├── offscreen.html/js   # Audio playback (Chrome offscreen document)
│   └── icons/
│
└── supabase/
    └── migrations/         # SQL migrations (run in order in Supabase SQL editor)
        ├── 001–003         # uploads, profiles, rate limiting
        ├── 004             # session_events
        ├── 005             # divisions, schools, invitations, get_effective_tier()
        ├── 006             # upload_summaries materialized view
        ├── 007             # RLS for org tables
        ├── 008             # admin audit log
        ├── 009             # account deactivation flag
        ├── 010             # demo data helpers
        ├── 011             # rate_limit_log RLS
        ├── 012             # security hardening
        ├── 013             # Stripe columns on profiles
        └── 014             # teacher_requests table
```

---

## Key flows

### Teacher upload
`dashboard.js handleUpload()` — validates quota and storage cap client-side (enforced server-side via RLS), uploads file to Supabase Storage, inserts row to `uploads`, updates `storage_used_mb` on `profiles`.

### Student access (extension)
`popup.js` → `GET /api/session?code=ABC-123` → stores `{ signedUrl, exitWordHash, filename }` in `chrome.storage.session` → opens `player.html` tab → `player.js` loads audio, locks fullscreen, verifies exit word by SHA-256 hash comparison.

### Teacher access request
Teacher submits `/request-access` form → stored in `teacher_requests` → admin notified by email → admin approves in `/admin.html` → invitation link generated → teacher clicks link → `accept-invite.html` attaches them to their org via `/api/accept-invite`.

### Stripe billing
`/api/stripe-checkout.js` creates a Checkout Session for Teacher Premium. `/api/stripe-webhook.js` handles `checkout.session.completed` (sets `tier_override = 'premium'`) and `customer.subscription.deleted` (resets to null).

### Exit word verification
Both `dashboard.js` and `extension/player.js` use identical `hashWord()` — SHA-256 via Web Crypto API, input lowercased and trimmed before hashing.

---

## Tier model

| Tier | Who | How acquired |
|------|-----|-------------|
| Free | Individual teacher | Default on sign-up |
| Teacher Premium | Individual teacher | Stripe self-serve ($75 CAD/yr) |
| School | All teachers at a school | School purchases ($200 CAD/yr) |
| Division | All teachers in a division | Division contract (from $800 CAD/yr) |

Tiers cascade: `tier_override → division.tier → school.tier → profiles.tier → free`. Resolved server-side by `get_effective_tier(user_id)` Postgres function — called via RPC so the cascade is always current.

---

## Chrome extension deployment

The extension is force-installed via **Google Admin Console** onto managed Chromebooks. IT admins reference the Chrome Web Store ID in their device policy — teachers and students never install anything manually.

For local testing: load unpacked from `extension/` in `chrome://extensions`.

---

## Design system

Editorial print aesthetic — mid-century typeset, The Economist tone.

| Token | Value |
|-------|-------|
| `--ink` | `#1a1a2e` |
| `--paper` | `#f8f5ef` |
| `--accent` | `#c0392b` |
| `--warm-mid` | `#e8e0d0` |
| `--muted` | `#6b6560` |

Fonts: **Playfair Display** (headlines) · **DM Sans 300/500** (body/labels). No border-radius, no box-shadow, no icons except `—` list bullets. Borders are `1px solid var(--ink)` — never soft gray.

---

## Roadmap

See [`roadmap.md`](roadmap.md) for the full staged plan from MVP polish through distribution and billing. See [`improvements.md`](improvements.md) for the current prioritised improvement list.
