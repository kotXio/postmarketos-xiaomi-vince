# Qt WebEngine hardware-video patches

These files enable Chromium's standard-Linux stateful V4L2 decoder inside Qt
WebEngine `6.11.1` and make its multi-planar NV12 output usable through Qt's
external Ozone backend.

Target revisions:

- Alpine aports `3.24-stable`, commit
  `3ca62a2571378ee35a0e149a0e91454b57240737`;
- Qt WebEngine `6.11.1`;
- bundled Chromium commit
  `37b6aeaa3ef9bf7e1901aa02a317a2707557709d`;
- `aarch64`, musl and `use_v4l2_codec=true`.

Apply
[`vince-qtwebengine-v4l2-aport-r10.patch`](vince-qtwebengine-v4l2-aport-r10.patch)
to the pinned aports checkout with `git apply`. It adds the six source patches,
sets `pkgrel=10`, enables V4L2, disables VA-API and retains the four-job build
guard used for the verified package.

| Patch | Purpose | Provenance |
| --- | --- | --- |
| `vince-qtwebengine-v4l2.patch` | Add the Qt/CMake switch which passes `use_v4l2_codec` to Chromium. | Project-authored integration. |
| `vince-qtwebengine-h264-access-units.patch` | Join SPS/PPS and the first slice into a complete H.264 access unit. | Alexandros Frantzis/Collabora patch, adapted from the TI-maintained Chromium 142 refresh to the pinned Chromium 140 tree. |
| `vince-qtwebengine-nv12-per-plane.patch` | Keep Linux multi-planar NV12 per-plane instead of requesting the ChromeOS external-sampler preference. | Project-authored integration by Kostiantyn Andriiuk. |
| `vince-qtwebengine-multiplanar-native-pixmap.patch` | Permit importing an existing multi-planar decoder DMA-BUF while guarding unsupported allocation paths. | Exact Qt `ae6991d950bb343accad96b96047fe605c17bcc3` backport by Peter Varga for `QTBUG-145344`. |
| `vince-qtwebengine-mt21-neon-types.patch` | Correct strict ARM NEON vector types. | Adapted from the matching openSUSE Electron build patch. |
| `vince-qtwebengine-musl-timeval-types.patch` | Use public `time_t` and `suseconds_t` types on musl. | Project-authored build compatibility change. |

The cumulative diff preserves the original Collabora and Qt commit headers.
Additional source links and the distinction between derived code and diagnostic
references are recorded in [`../../SOURCES.md`](../../SOURCES.md).

## Test boundary

The `r10` package completed a fixed H.264 path with `120/120` decoded and
displayed frames. Normal Angelfish then kept Venus active throughout a
15-second YouTube sample and used about `51%` less CPU than the same launcher
without `AcceleratedVideoDecoder`. The exact YouTube codec was not captured.

A later fullscreen test logged two automatically recovered Venus firmware
errors. Angelfish stayed open and playback remained visually normal. The
hardware-video path works, but long sessions and stream transitions remain
experimental.
