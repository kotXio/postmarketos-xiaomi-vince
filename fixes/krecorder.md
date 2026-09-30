# KRecorder: recording from the normal icon

KRecorder now starts recording, advances its timer and saves Mic2 audio when
opened from the ordinary Plasma icon. **No custom KRecorder APK is needed**:
the fix uses the same patched Qt Multimedia as
[Plasma Camera video](plasma-camera-video.md), plus a per-user launcher change.

## Requirements

The tested combination is postmarketOS `v26.06`, `aarch64`, KRecorder
`26.04.2-r0` and all three Qt Multimedia runtime packages at `6.11.1-r7`:
`qt6-qtmultimedia`, `qt6-qtmultimedia-ffmpeg` and
`qt6-qtmultimedia-gstreamer`.

Use the [Qt Multimedia recipe and patches](../packages/qt6-qtmultimedia-r7/README.md)
and the [Mic2 audio profile](tas2557-audio.md). Build the patched Qt packages
first; changing the launcher alone will not fix recording on stock Qt.

## Launcher change

Close KRecorder. As your Plasma user, copy
`/usr/share/applications/org.kde.krecorder.desktop` into
`~/.local/share/applications/` if a user copy does not already exist. Create
the directory if needed; keep a backup of any existing override. Leave the
other desktop-entry fields unchanged and replace the main `Exec=` line with:

```ini
Exec=env QT_MEDIA_BACKEND=ffmpeg QT_PULSEAUDIO_RECORD_USE_SERVER_MAXLENGTH=1 krecorder
```

Run `kbuildsycoca6 --noincremental` as that same user, then open Recorder from
its normal icon. Select Mic2, check that it is unmuted, and try a short FLAC
recording. The timer should advance and the recording should save promptly.
No reboot, system-wide environment setting or UCM change is required.

Recording and playback through the TAS2557 speaker work when Recorder is
opened from the app launcher. Quiet or distant speech can still produce a
very quiet file; the fix does not change microphone gain or normalize recordings.

## Why it works

On this setup, Qt's small PulseAudio capture queue delivered audio in tiny
chunks and KRecorder stayed at `0:00:00`. The opt-in patch lets the server
choose the queue's maximum length, restoring normal audio delivery. The
change is in Qt Multimedia, not KRecorder.

To undo the launcher change, restore your previous user desktop entry, or
remove the copy if you created it only for this fix, then run
`kbuildsycoca6 --noincremental` again. Shared Qt package rollback is described
in the [package guide](../packages/qt6-qtmultimedia-r7/README.md).

See the [patch series](../patches/qtmultimedia/README.md) and
[credits and references](../SOURCES.md#plasma-camera-recording-and-krecorder).
