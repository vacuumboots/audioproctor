# Chrome Extension Audio Playback — Debug Log

## Environment
- **Device:** Managed Chromebook (K-12 school)
- **Chrome OS build:** 14541.0.0
- **Chrome version:** 114.0.0.0
- **Extension:** Manifest V3, loaded unpacked
- **Audio file:** MP3, ~272 seconds (4:32), uploaded via dashboard, stored in Supabase Storage

## What works
- Extension popup: code entry, validation, API call to `/api/session` — all working
- Signed URL generation: Supabase returns 200 for both the POST (create signed URL) and GET (download audio) — confirmed in Supabase logs
- Player UI: opens in fullscreen popup window, all controls render correctly
- Lockdown: keyboard blocking (Tab, Escape, F-keys, Ctrl/Alt/Meta), fullscreen re-entry on resize, Alt+Tab focus reclaim via background service worker, right-click disabled, beforeunload warning
- Exit word: hashing, verification, and window close all work
- Rewind/speed buttons: functional after fixing inline handlers

## The core problem
**Chrome OS does not produce any audio output from extension pages (`chrome-extension://` origin).** This applies to both `<audio>` elements and the Web Audio API (oscillator test). The audio element reports that it IS playing (readyState=4, paused=false, currentTime advances to 0.2) but no sound reaches the speakers. This is a Chrome OS platform restriction, not a code bug.

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
const res = await fetch(sessionData.signedUrl);  // uses host_permissions for *.supabase.co
const raw = await res.arrayBuffer();
const blob = new Blob([raw], { type: 'audio/mpeg' });
audio.src = URL.createObjectURL(blob);
audio.load();
```
- Added `*://*.supabase.co/*` to `host_permissions` in manifest.json
- **Result:** Audio loaded successfully (readyState=4, duration=272.14, no errors). Still no sound.

### 4. `async togglePlay` with `await audio.play()`
```js
async function togglePlay() {
  try {
    await audio.play();
    btn.innerHTML = '&#9646;&#9646;';
  } catch (err) {
    showError('Audio could not play: ' + err.message);
  }
}
```
- **Result:** Button stopped toggling entirely. The `await` likely caused the play() promise to hang or lose the user gesture context. Reverted to non-async `.then()/.catch()` pattern.

### 5. Non-async togglePlay with diagnostics
```js
audio.play().then(() => { ... }).catch(err => { ... });
```
- Added on-screen diagnostic showing `readyState`, `networkState`, `duration`, `currentTime`, `paused` after load and after play click.
- **Result diagnostic (before play):** `ready=4 net=1 dur=272.143673 err=none`
- **Result diagnostic (after play):** `time=0.2 paused=false ready=4`
- **Conclusion:** Audio element loads, decodes, and "plays" correctly. `currentTime` advances. But **no sound output whatsoever.**

### 6. Web Audio API — AudioContext + createMediaElementSource (on page load)
```js
audioCtx = new AudioContext();
const source = audioCtx.createMediaElementSource(audio);
source.connect(audioCtx.destination);
```
- Created during page load (no user gesture) → AudioContext starts in `suspended` state
- `createMediaElementSource` takes exclusive control of audio output
- **Result:** Made things worse — audio stopped advancing entirely. The suspended AudioContext blocked all playback through the element.

### 7. Web Audio API — AudioContext created on first play click (user gesture)
```js
// Inside togglePlay click handler:
if (!audioCtx) {
  audioCtx = new AudioContext();
  audioCtx.createMediaElementSource(audio).connect(audioCtx.destination);
}
if (audioCtx.state === 'suspended') audioCtx.resume();
```
- **Result:** Still no sound, no progress.

### 8. Web Audio API — Pure oscillator test (440Hz beep)
```js
const ctx = new AudioContext();
const osc = ctx.createOscillator();
osc.frequency.value = 440;
osc.connect(ctx.destination);
osc.start();
setTimeout(() => { osc.stop(); ctx.close(); }, 300);
```
- Created inside click handler (valid user gesture)
- **Result:** No beep heard. **This confirms Chrome OS blocks ALL audio from extension pages**, not just `<audio>` elements.

### 9. Hidden iframe audio bridge (current approach)
- Created `audio-bridge.html` at repo root (served from `audioproctor.com` by Vercel)
- Extension player.html embeds `<iframe id="audio-frame" src="https://audioproctor.com/audio-bridge.html" hidden>`
- All playback commands (play/pause/seek/rewind/speed) sent via `postMessage` to the iframe
- Bridge page creates an `<audio>` element and relays events (timeupdate, loadedmetadata, ended, error) back
- **Result:** Still no sound. Needs further investigation — the iframe may also be blocked since its parent is an extension page, or there may be a deployment/loading issue.

## Next steps to investigate

1. **Verify the iframe loads:** Open Chrome DevTools on the Chromebook (if possible) and check the Network tab to see if `audio-bridge.html` loads successfully in the iframe. Also check the Console for any errors.

2. **Test iframe audio isolation:** It's possible Chrome OS also blocks audio from iframes embedded in extension pages (the iframe's audio may be associated with the parent extension page's audio context). If so, the iframe approach won't work.

3. **Open player as a regular web page:** Instead of an extension page, navigate to `https://app.audioproctor.com/player.html?code=XXX`. The extension would:
   - Popup validates code, gets session data
   - Opens `https://app.audioproctor.com/player.html` as a regular tab/window
   - Extension injects a content script for keyboard blocking / lockdown
   - Background service worker enforces fullscreen and focus
   - Audio plays from the regular web page (which definitely has audio output on Chrome OS)
   
   This is the most likely solution if the iframe approach also fails. It requires:
   - A web-based player page with the same UI
   - A content script (`content_scripts` in manifest.json) for lockdown
   - Passing session data to the web page (via content script message, or having the page call `/api/session` itself)

4. **Chrome Enterprise kiosk mode:** For the most locked-down experience, the school's IT admin could configure the extension to run in kiosk mode. This provides OS-level lockdown (blocks Alt+Tab, system shortcuts, shelf access) that JavaScript cannot achieve.

## Key files
- `extension/player.js` — main player logic, lockdown, bridge communication
- `extension/player.html` — player UI (uses hidden iframe for audio)
- `extension/popup.js` — code entry, API call, opens player window
- `extension/background.js` — service worker for Alt+Tab focus enforcement
- `extension/manifest.json` — permissions, service worker, host_permissions
- `audio-bridge.html` — minimal audio proxy page (repo root, served by Vercel)
- `api/session.js` — serverless function that validates code and returns signed URL
