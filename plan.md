# Project: Accessible Audio Test Player (working title: "audioproctor")

## What this is
A simple SaaS tool for K-12 schools that allows teachers to upload spoken audio 
tracks (MP3) for accessibility purposes during assessments. Students on managed 
Chromebooks use a Chrome extension to access and play the audio in a locked-down 
environment.

## The problem it solves
Provincial assessments in Alberta are now delivered as MP3 links. Google Forms 
quizzes (used for lockdown on Chromebooks) will not play MP3 files. Schools 
previously used cassettes/CDs and a boombox. There is no good modern solution.

## Users
- Teachers (admin interface, Google login)
- Students (Chrome extension on managed Chromebooks, no login)

## Core user flows

### Teacher flow
1. Log in with Google account (restricted to school domain eventually, open for now)
2. Upload an MP3 file
3. System generates a short access code (6 chars, human-readable, e.g. "TK4-92A")
4. Teacher sees list of uploads with their codes and a separate exit password per upload
5. Teacher shares the code with a student verbally or on paper
6. When test is done, teacher tells student the exit password to unlock the extension

### Student flow
1. Opens Chrome extension on managed Chromebook
2. Enters the access code
3. Extension launches a fullscreen locked window with a simple audio player
4. Student plays the audio track (can replay, pause, scrub)
5. Student cannot navigate away or close the window
6. Student enters exit password given by teacher to close the lockdown

## Tech stack decisions already made
- Frontend + API: Vanilla HTML/CSS/JS (NOT Next.js or React — keep it simple)
- Auth: Supabase Auth with Google OAuth
- Database: Supabase Postgres
- File storage: Supabase Storage
- Hosting: Vercel (deploy from GitHub)
- Chrome Extension: Manifest V3, vanilla JS
- Payments: deferred — not in MVP

## Key technical constraints
- Must work on managed ChromeOS devices (Google Workspace for Education)
- Extension will be force-installed via Google Admin Console (not Chrome Web Store)
- Audio must play natively in a Chromebook browser — MP3 only for now
- No student login — access is purely code-based
- Exit password is per-upload, stored as a hash, checked client-side in the extension

## MVP scope (build this first, nothing else)
- Supabase project setup (auth, storage bucket, uploads table)
- Teacher admin: login page, upload page, uploads list with codes + exit passwords
- Simple player page: takes a code param, fetches and plays the audio
- Chrome extension: code entry screen, lockdown audio player window, password exit
- Vercel deploy from GitHub

## Out of scope for MVP
- Domain restriction on Google login
- Multiple school/division accounts
- Analytics or playback tracking
- Payments or subscriptions
- Any mobile or non-Chromebook support

## Folder structure preference
Keep it flat and simple. No framework. Static HTML files + a /api folder if 
Vercel serverless functions are needed. Chrome extension in its own /extension 
subfolder.

## My background
Comfortable with HTML/CSS/JS, PowerShell, CLI, Git/GitHub. 
New to Supabase and Vercel but familiar with reading docs.
Prefer explicit, readable code over clever abstractions.

