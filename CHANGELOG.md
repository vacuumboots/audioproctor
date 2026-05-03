# Changelog

All notable changes to AudioProctor are documented in this file.

## [1.2.1] - 2026-05-02

Feature release adding inline image support in text assessments.

### Added
- Inline images in text assessments: teachers can paste images (PNG/JPEG/WebP, max 2 MB each) directly into the text editor.
- Contenteditable editor replaces plain textarea — supports rich text paste with images appearing inline.
- Images uploaded to new `assessment-images` Supabase Storage bucket at `{teacher_id}/{access_code}/img_N.ext`.
- Session API resolves image placeholders to signed URLs, embedded in returned HTML.
- Extension player renders HTML with inline images; TTS read-aloud silently skips image-only paragraphs.
- Minimal HTML sanitizer (`extension/lib/sanitize.js`) for safe rendering of assessment HTML.
- Image cleanup on upload delete (best-effort removal from `assessment-images` bucket).
- Image duplication support — copying a text assessment copies its images to new storage paths.
- Database migration 020: `image_count` column on uploads.
- Database migration 021: RLS policies for `assessment-images` bucket.

### Changed
- Dashboard upload form: text input hint updated to "Paste text and images · Max 2 MB per image".
- Extension player card widened from 720px to 800px to accommodate inline images.
- `file_size_mb` now includes image storage bytes for text assessments (RLS quota enforcement).
- Dashboard uploads table continues to show assessment type badges (Audio/Text) — unchanged.

### Manual deployment steps
- Run migrations 020 and 021 in Supabase SQL Editor.
- Create `assessment-images` bucket in Supabase Dashboard (Storage → New Bucket, private, 2 MB file size limit).
- Deploy to Vercel.
- Bump extension to v1.2.1 and publish to Chrome Web Store.

## [1.1.0] - 2026-04-28

Feature release adding text assessment support — teachers can now create either audio or text assessments from the same dashboard.

### Added
- Text assessment type: teachers can paste plain text (up to 25,000 chars) as an alternative to audio uploads.
- Assessment type selector in the teacher dashboard upload form.
- Text reader mode in the Chrome extension — fullscreen locked view with paragraph structure.
- Built-in Read Aloud via `chrome.tts` with play/pause, prev/next paragraph, and speed control.
- Keyboard controls for text reader: Space (play/pause), Left/Right arrows (navigate paragraphs).
- Display settings for text reader: font size +/- and full width toggle.
- Dual-mode session API: `/api/session` returns typed payload (audio gets signed URL, text gets content).
- Database migrations 018–019: `assessment_type`, `text_content`, `text_char_count` columns; text session event types.
- Text-safe delete and duplicate in the dashboard — text rows skip storage cleanup.
- FAQ on use cases page explaining the difference between audio and text assessments.

### Changed
- Extension bumped to v1.1.0 with `tts` permission added to manifest.
- Dashboard uploads table shows assessment type badges (Audio/Text).
- Dashboard copy updated: "Create Assessment" replaces "Upload Audio".
- Dashboard assessment type selector replaced with segmented toggle (Audio/Text), moved above label field.
- Assessment label hint now indicates it's shown to students in the extension.
- Landing page, use cases, and about page updated to describe both audio and text accommodation.

## [1.0.1] - 2026-04-27

Extension patch release for managed Chromebook validation and Chrome Web Store promotion.

### Changed
- Extension popup/session fetch flow now permits the live `www.audioproctor.com` redirect target in manifest host permissions and CSP `connect-src`.
- Extension version bumped from `1.0.0` to `1.0.1`.

### Security / privacy hardening
- Removed Google Fonts dependency from extension UI pages.
- Added an explicit Manifest V3 content security policy for extension pages.
- Added `no-referrer` fetch policy on extension network calls.

### Validation
- Chromebook retest confirmed the popup/session flow works after the CSP host allowlist update.

## [0.100.0] - 2026-04-26

Milestone release for demo readiness, extension open-source visibility, and repo doc hygiene.

### Added
- WAV upload support with client-side WAV -> MP3 conversion in the teacher dashboard upload flow.
- Public extension repository synchronization workflow from private `extension/` subtree to `vacuumboots/audioproctor-extension`.
- Public, audit-focused extension README at `extension/README.md`.
- Manual sync trigger for extension mirror workflow (`workflow_dispatch`).
- This changelog file.
- Security disclosure policy file (`SECURITY.md`).
- Operational release checklist (`docs/release-checklist.md`).

### Changed
- Upload cap aligned to infrastructure constraint: 50 MB max file size.
- Dashboard/UI copy aligned to MP3 or WAV support and 50 MB limit.
- Upload filename behavior aligned so converted WAV uploads are recorded/displayed as `.mp3` in dashboard history.

### Internal documentation maintenance
- `.hermes` status-note sweep completed and stale progress text corrected.
- Historical status markers clarified where plans had drifted from current repo state.

### Completed checklist (requested)
- [x] `.hermes` status-note sweep completed and inaccuracies corrected.
- [x] Changelog milestone entry added.
- [x] Security disclosure documentation added.
- [x] Release checklist documentation added.
