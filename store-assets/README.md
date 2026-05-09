# Chrome Web Store listing assets

This directory holds assets for the AudioProctor Chrome Web Store listing — screenshots, promo video, and tile images. These are uploaded manually via the Chrome Web Store Developer Dashboard (https://chrome.google.com/webstore/devconsole).

## What goes where

| Asset | Format | Size | Location |
|---|---|---|---|
| Screenshots (1-5) | PNG or JPEG, 1280x800 or 640x400 | Max 2 MB each | `store-assets/screenshots/` |
| Promo tile (small) | PNG, 440x280 | Max 512 KB | `store-assets/tiles/marquee.png` |
| Promo tile (large) | PNG, 920x680 | Max 512 KB | `store-assets/tiles/screenshot.png` |
| YouTube promo video URL | Link in dashboard | — | Upload to YouTube, paste URL in dashboard |
| Demo video (file) | MP4, max 60s | Max 256 MB | `store-assets/video/` |

## Relationship to the publish workflow

The automated publish workflow (`.github/workflows/publish-extension.yml`) handles version bumping, zipping, uploading, and submitting the extension package for review. It zips only the `extension/` directory — store listing assets are NOT part of the extension package.

**Process for a new listing version:**

1. Run "Publish Extension" workflow from GitHub Actions (bumps version, submits for review)
2. While under review, upload or update listing assets here, then upload them via the Developer Dashboard
3. Submit the listing update from the dashboard separately

The two tracks (extension code → automated workflow, listing assets → manual dashboard) are independent.

## File naming convention

```
store-assets/
  screenshots/
    01-player.png       # Screenshot 1 — main player view
    02-access-code.png  # Screenshot 2 — access code entry
    03-text-assessment.png  # Screenshot 3 — text assessment view
    ...
  tiles/
    marquee.png          # 440x280 promo tile
    icon.png             # 128x128 icon (matches extension/icons/icon128.png)
  video/
    demo.mp4             # Promo/demo video (max 60s)
```
