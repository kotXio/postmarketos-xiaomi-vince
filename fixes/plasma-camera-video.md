# Plasma Camera video with sound

Plasma Camera can record rear-camera video at about **30 fps**, with Mic2
audio and Qualcomm Venus H.264 encoding. The viewfinder updates at about
**5 fps while recording** so that drawing the preview does not slow down the
saved video. Saving finishes promptly and the normal preview returns.

This experimental update is available as source patches and build recipes.
It is not included in the older autofocus release.

## What changed

- 720p recording without upscaling the preview, with corrected frame delivery
  and timestamps.
- Hardware H.264 encoding with working quality/bitrate settings.
- A PulseAudio capture fix shared with [KRecorder](krecorder.md).
- The earlier 540p preview, full-resolution still capture and tap-to-refocus
  changes are included. Tapping starts another autofocus scan; it does not
  focus on a selected region.

Short rear-camera recordings ran at about 30 fps with sound, without the
earlier recurring stalls. After libcamera processing, the image is `1272x720`;
the encoded file reports `1280x736` because of Venus alignment requirements.
Higher resolutions still use the scaled preview rather than a native 1080p
recording path.

## Packages

The tested setup is Xiaomi Redmi 5 Plus (`vince`), `aarch64`, postmarketOS
`v26.06` with Plasma Mobile and the project's OV12A10/DW9763 and Mic2 support.

| Component | Version / source |
| --- | --- |
| Plasma Camera and its language package | [`2.1.1-r15`](../packages/plasma-camera-r15/README.md) |
| Qt Multimedia, FFmpeg and GStreamer packages | [`6.11.1-r7`](../packages/qt6-qtmultimedia-r7/README.md) |
| libcamera and matching IPA | `99991.7.1-r3`, from the [autofocus update](ov12a10-autofocus.md) |
| OV12A10 tuning | `libcamera-ipa-ov12a10=1.1-r3` |

Keep all three Qt runtime packages at the same version. Installing only the
FFmpeg plugin does not fix audio capture: that change is in the base library.
The [Qt recipe guide](../packages/qt6-qtmultimedia-r7/README.md) explains the
source build and package upgrade.

## Start from the normal icon

After installing the matching builds, close Plasma Camera. As your Plasma
user, copy `/usr/share/applications/org.kde.plasma.camera.desktop` into
`~/.local/share/applications/` if a user copy does not already exist. Create
the directory if needed, keep a backup of any existing override, and change
only the main `Exec=` line:

```ini
Exec=env QT_MEDIA_BACKEND=ffmpeg QT_FFMPEG_ENABLE_V4L2M2M_ENCODING=1 QT_PULSEAUDIO_RECORD_USE_SERVER_MAXLENGTH=1 plasma-camera
```

Run `kbuildsycoca6 --noincremental` as that same user, then open the ordinary
Camera icon. Select the rear camera and **720p / 30 fps**, and make sure Mic2
is selected and unmuted in the audio settings. The two opt-in flags above are
provided by these patches; they do not enable these fixes in stock Qt.

## Limits

- The recording preview runs at about 5 fps even when the saved video is
  smooth. Occasional gaps between frames remain; long recordings have not
  been validated.
- A Venus timeout occurred during testing, followed by slow software encoding
  until a reboot. If saving hangs or recording becomes unusually slow, stop
  and check whether the hardware encoder is still working.
- Check Mic2 mute after reboot. Quiet or distant speech can still be quiet;
  this fix does not add digital gain or change the audio profile.

To undo the launcher change, restore your previous user desktop entry, or
remove the copy if you created it only for this fix, then refresh the cache.
For package rollback, restore your saved Camera/language pair and the matching
Qt runtime set together; simulate the transaction before applying it.

Source details: [Camera patches](../patches/plasma-camera/README.md),
[Qt Multimedia patches](../patches/qtmultimedia/README.md) and
[credits and references](../SOURCES.md#plasma-camera-recording-and-krecorder).
