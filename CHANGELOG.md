# Changelog

All notable changes to AudioProctor are documented in this file.

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
