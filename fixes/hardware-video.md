# Qt WebEngine hardware video through Qualcomm Venus

Status: physically verified in normal Angelfish on one Xiaomi Redmi 5 Plus;
experimental for long/fullscreen playback.

## Result

Qualcomm Venus already provided a working stateful V4L2 H.264/HEVC decoder.
The missing part was integration between Qt WebEngine's bundled Chromium,
multi-planar NV12 DMA-BUF output and Qt's external Ozone backend.

The cumulative Qt WebEngine `6.11.1-r10` package now provides that integration:

1. Qt passes `use_v4l2_codec=true` to Chromium and leaves VA-API disabled.
2. H.264 SPS/PPS data is joined to the first slice before submission to Venus.
3. Linux requests per-plane NV12 without the ChromeOS external-sampler
   preference.
4. Qt's official `QTBUG-145344` fix permits importing an existing multi-planar
   decoder DMA-BUF while retaining guards around unsupported allocation paths.

The fixed H.264 fixture decoded and displayed all `120/120` frames without a
SharedImage rejection, missing mailbox, GPU context loss or kernel fault. In a
normal YouTube launcher A/B, Venus remained active for all `15/15` samples and
WebEngine CPU use fell from `272.2%` to `133.2%` of one core, about `51%`.
Playback was smooth during the test. The exact YouTube codec was not captured
and is not inferred from Venus activity alone.

## Required Angelfish launcher

The hardware decoder feature is not enabled by the APK alone. Use the two
required rendering-stability flags and add `AcceleratedVideoDecoder`:

```text
Exec=/usr/bin/env QTWEBENGINE_CHROMIUM_FLAGS="--disable-gpu-rasterization --disable-webgl --enable-features=AcceleratedVideoDecoder" /usr/bin/angelfish %u
```

Fully stop the old Angelfish process before relaunching it from the normal
Plasma Mobile icon. Installation and rollback are documented in
[`../packages/README.md`](../packages/README.md#experimental-webengine-hardware-video-release).

## Known limitation

A later YouTube fullscreen test logged two Venus firmware errors about nine
minutes apart. Each recovered in roughly three seconds. Angelfish remained
open and playback looked normal throughout; the errors were visible only in
the diagnostic logs. The second recovery was followed by short-lived
invalid-session errors. Venus returned to runtime suspend after playback
stopped.

The reset trigger is not isolated, so do not claim fault-free long-playback,
stream-transition, DRM or additional-codec support. The working browser decode
path and its CPU reduction remain valid results from the shorter tests.

## Sources

The exact source patches and application order are in
[`../patches/qtwebengine/`](../patches/qtwebengine/). Directly reused code,
project-authored integration and reference-only material are distinguished in
[`../SOURCES.md`](../SOURCES.md#angelfish-and-hardware-video).

`libva-v4l2-request` is not used: it targets stateless Request API decoders,
while Qualcomm Venus on this device is stateful.
