# Qt Multimedia recording patches

Target: the official Qt Multimedia `6.11.1` release archive. These patches
support Venus H.264 recording in Plasma Camera and Mic2 capture in both
Camera and KRecorder; they do not change Qt WebEngine browser playback.

Apply the files in [`series`](series) order with `git apply` from the extracted
source directory, or use the [APKBUILD](../../packages/qt6-qtmultimedia-r7/APKBUILD).

| Patch | Purpose |
| --- | --- |
| `0001` | Alpine's `sys/select.h` include fix, with context refreshed for 6.11.1. |
| `0002` | Opt-in FFmpeg V4L2 M2M encoding and pixel-format fallback. |
| `0003–0004` | Copy encoded packet data before muxing and defer one capture-buffer release. |
| `0005` | Audio-flow diagnostics retained from the tested build. |
| `0006` | Optional PulseAudio latency control; not enabled by the recommended launchers. |
| `0007` | Opt-in server-default PulseAudio capture queue size. |
| `0008` | Apply the requested video bitrate or Qt's quality-based estimate to H.264 V4L2 M2M. |

These patches match the source used for Qt Multimedia `6.11.1-r7`: commit
`215420a9e57b979a208010294bd0174e2d5d816c` plus Alpine's include fix. Some
diagnostic messages remain enabled. Encoder utility tests are included.

The functional opt-ins are `QT_FFMPEG_ENABLE_V4L2M2M_ENCODING=1` and
`QT_PULSEAUDIO_RECORD_USE_SERVER_MAXLENGTH=1`. KRecorder needs only the latter,
with `QT_MEDIA_BACKEND=ffmpeg`. Neither launcher enables
`QT_PULSEAUDIO_RECORD_DISABLE_ADJUST_LATENCY`.

Patches `0002–0008` are by Kostiantyn Andriiuk <konstantin@andriyuk.com>.
Upstream Qt notices remain intact; `0001` retains its Alpine provenance.
See [sources and references](../../SOURCES.md#plasma-camera-recording-and-krecorder)
and [patch checksums](../SHA256SUMS).
