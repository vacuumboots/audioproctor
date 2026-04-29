# Changelog

All notable changes to AudioProctor are documented in this file.

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

### Changed
- Extension bumped to v1.1.0 with `tts` permission added to manifest.
- Dashboard uploads table shows assessment type badges (Audio/Text).
- Dashboard copy updated: "Create Assessment" replaces "Upload Audio".

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
