# Chrome Extension Audio Playback — Debug Log

## Environment
- **Device:** Managed Chromebook (K-12 school)
- **Chrome OS build:** 14541.0.0
- **Chrome version:** 146.0.0.0
- **Extension:** Manifest V3, loaded unpacked
- **Audio file:** MP3, ~272 seconds (4:32), uploaded via dashboard, stored in Supabase Storage

---

## ✅ RESOLVED — 2026-04-18

**Final working architecture:** `chrome.offscreen` document with `AUDIO_PLAYBACK` reason.

The audio element lives in `extension/offscreen.html`, managed by `extension/offscreen.js`. The player window sends commands (`load`, `play`, `pause`, `seek`, `rewind`, `speed`) via `chrome.runtime.sendMessage({ target: 'offscreen', ... })`. Events (`loadedmetadata`, `timeupdate`, `ended`, `error`) come back the same way with `{ target: 'player', ... }`.

A critical additional fix was required: the popup must await background confirmation that the offscreen document is fully initialized before opening the player window, otherwise `player.js` sends the `load` message before anyone is listening and audio never starts. This was solved by having popup.js send a `prepare_session` message and waiting for the background to respond after `ensureOffscreen()` completes.

**Verified on Chrome OS 146 (build 14541.0.0):**
- Audio plays from a private Supabase Storage signed URL
- Play/pause, rewind 10s, and speed controls all work
- Escape, F-keys, Ctrl/Alt/Meta combos, Tab — all blocked
- System close button (Chrome OS title bar X) reopens the player window automatically
- Cannot navigate away or open another window while session is active
- Exit word (SHA-256 verified) is the only way out
- Audio does not pause, restart, or glitch during lockdown attempts

---

## The core problem (historical)

**Chrome OS does not produce any audio output from extension pages (`chrome-extension://` origin).** This applies to both `<audio>` elements and the Web Audio API. The audio element reports that it IS playing (`readyState=4`, `paused=false`, `currentTime` advances) but no sound reaches the speakers. This is a Chrome OS platform restriction, not a code bug.

## Attempts (chronological)

### 1. Direct signed URL on `<audio>` element (original code)
```js
audio.src = sessionData.signedUrl;
```
- **Result:** No sound. Button toggled play/pause but no audio heard. Also had CSP errors from inline event handlers masking other issues.

### 2. Inline event handler fix
- Removed `onclick="rewind()"`, `onchange="changeSpeed(this.value)"`, `onclick="attemptExit()"` from player.html
- Wired all controls via `addEventListener` in player.js
- **Result:** CSP errors resolved. Rewind/speed/exit buttons now work. Audio still silent.

### 3. Fetch as blob + forced MIME type
```js
const res = await fetch(sessionData.signedUrl);
const raw = await res.arrayBuffer();
const blob = new Blob([raw], { type: 'audio/mpeg' });
audio.src = URL.createObjectURL(blob);
audio.load();
```
- Added `*://*.supabase.co/*` to `host_permissions` in manifest.json
- **Result:** Audio loaded successfully (`readyState=4`, `duration=272.14`, no errors). Still no sound.

### 4. `async togglePlay` with `await audio.play()`
- **Result:** Button stopped toggling entirely. Reverted to `.then()/.catch()` pattern.

### 5. Non-async togglePlay with diagnostics
- Added on-screen diagnostic showing `readyState`, `networkState`, `duration`, `currentTime`, `paused`
- **Result:** `ready=4 net=1 dur=272.14 time=0.2 paused=false` — loads and "plays" with no sound
- **Conclusion:** Chrome OS blocks audio output at the platform level for extension pages.

### 6–7. Web Audio API — AudioContext + createMediaElementSource
- Tried both on page load and inside user gesture handler
- **Result:** Still no sound.

### 8. Web Audio API — Pure oscillator test (440 Hz)
```js
const ctx = new AudioContext();
const osc = ctx.createOscillator();
osc.connect(ctx.destination);
osc.start();
```
- Created inside click handler (valid user gesture)
- **Result:** No beep. **Confirmed Chrome OS blocks ALL audio from extension pages**, not just `<audio>` elements.

### 9. Hidden iframe audio bridge
- `audio-bridge.html` served from `audioproctor.com`, embedded as a hidden `<iframe>` in player.html
- Commands sent via `postMessage`; events relayed back
- **Result:** Still no sound. Chrome OS also blocks audio from iframes whose parent is an extension page.

### 10. `chrome.offscreen` document with `AUDIO_PLAYBACK` reason ✅
- Created `extension/offscreen.html` + `extension/offscreen.js`
- Background service worker manages the document lifecycle (`ensureOffscreen()` / `chrome.offscreen.closeDocument()`)
- `<audio>` element lives in the offscreen document, which Chrome OS treats as a privileged background context with real audio output
- Player window communicates via `chrome.runtime.sendMessage`
- **Result:** Full audio playback on Chrome OS 146. This is the solution.

**Race condition fix (additional):** `popup.js` sends `prepare_session` to the background and awaits confirmation before creating the player window. This guarantees the offscreen document's `onMessage` listener is registered before `player.js` sends the first `load` command.

## Final file structure

| File | Role |
|------|------|
| `extension/popup.js` | Code entry, `/api/session` call, opens player window |
| `extension/background.js` | Service worker: offscreen lifecycle, fullscreen enforcement, unauthorized-close recovery |
| `extension/player.html` / `player.js` | Fullscreen lockdown UI, sends commands to offscreen |
| `extension/offscreen.html` / `offscreen.js` | `<audio>` element lives here; relays events to player |
| `extension/manifest.json` | `"offscreen"` permission + `AUDIO_PLAYBACK` reason |
| `api/session.js` | Validates access code, returns 1-hour signed URL + exit word hash |
