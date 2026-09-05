# Angelfish rendering workaround

Status: physically verified on the normal Plasma Mobile profile.

## Problem

Angelfish could enter a high-CPU userspace hang, become unresponsive or render
pages fully black. Full Chromium GPU rasterization reproduced the fixed test
failure, while disabling all GPU support avoided the hang at a substantial CPU
and memory cost.

## Workaround

Copy the packaged desktop entry to the per-user override and replace its
`Exec=` line:

```sh
mkdir -p ~/.local/share/applications
cp /usr/share/applications/org.kde.angelfish.desktop \
  ~/.local/share/applications/org.kde.angelfish.desktop
```

With the released Qt WebEngine `r10`, use this exact launcher command:

```text
Exec=/usr/bin/env QTWEBENGINE_CHROMIUM_FLAGS="--disable-gpu-rasterization --disable-webgl --enable-features=AcceleratedVideoDecoder" /usr/bin/angelfish %u
```

This keeps ANGLE/OpenGL, native Wayland composition, Canvas and the desktop's
hardware GPU rendering. It disables Chromium GPU rasterization and WebGL/WebGL2,
the two paths implicated by the tested regressions, while enabling the verified
Qualcomm Venus hardware-video path.

## Result

Pages remained responsive and YouTube played smoothly with the persistent
launcher. With Qt WebEngine `r10`, Venus stayed active for all `15/15`
playback samples and browser CPU use was about half that of the same launcher
without `AcceleratedVideoDecoder`. The hardware decoder returned to runtime
suspend after playback stopped.

Long/fullscreen playback remains experimental because a later test logged two
automatically recovered Venus firmware errors. The browser stayed open and
playback remained visually normal. See the exact boundary in
[`hardware-video.md`](hardware-video.md).

This workaround came from project A/B testing rather than copied
configuration. The Qt WebEngine, Mesa and Chromium references are listed in
[`SOURCES.md`](../SOURCES.md#angelfish-and-hardware-video).

After relaunching Angelfish, verify the running process contains both stability
flags and `AcceleratedVideoDecoder`:

```sh
tr '\0' ' ' </proc/$(pgrep -n angelfish)/cmdline
```

To disable hardware video without re-enabling the unstable rendering paths,
remove the decoder flag and fully relaunch Angelfish:

```text
Exec=/usr/bin/env QTWEBENGINE_CHROMIUM_FLAGS="--disable-gpu-rasterization --disable-webgl" /usr/bin/angelfish %u
```

For a complete package rollback, restore
`qt6-qtwebengine=6.11.1-r3` from the configured postmarketOS `v26.06`
repositories and use the launcher line above.
