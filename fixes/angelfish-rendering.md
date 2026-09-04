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

Use this exact launcher command:

```text
Exec=/usr/bin/env QTWEBENGINE_CHROMIUM_FLAGS="--disable-gpu-rasterization --disable-webgl" /usr/bin/angelfish %u
```

This keeps ANGLE/OpenGL, native Wayland composition, Canvas and the desktop's
hardware GPU rendering. It disables Chromium GPU rasterization and WebGL/WebGL2,
the two paths implicated by the tested regressions.

## Result

Physical testing confirmed responsive pages and smooth YouTube playback from
the persistent launcher. Smooth playback is a usability result, not evidence of
hardware video decode: Chromium still reports software-only video decoding.

After relaunching Angelfish, verify the running process contains both flags:

```sh
tr '\0' ' ' </proc/$(pgrep -n angelfish)/cmdline
```

To roll back, remove only the per-user override and relaunch Angelfish:

```sh
rm ~/.local/share/applications/org.kde.angelfish.desktop
```
