# Angelfish GPU rasterization and WebGL

Angelfish no longer needs GPU rasterization or WebGL disabled on the tested
Vince stack. A small Mesa/Freedreno correction fixes the depth/stencil MSAA
memory calculation that caused hangs during scrolling and WebGL rendering.
The corrected library passed scrolling and WebGL1/2 shader tests on two phones.

Hardware H.264 video decoding uses the existing Qt WebEngine `6.11.1-r10`
build and Qualcomm Venus. The application itself remains Angelfish `26.04.2-r0`.

## Compatibility

Use this package set with Xiaomi Redmi 5 Plus (`vince`), `aarch64`,
postmarketOS `v26.06` / Alpine `3.24`, Mesa `26.1.6-r0` and
Angelfish `26.04.2-r0`. Qt WebEngine starts at `6.11.1-r3` or the matching
project `6.11.1-r10`. The Mesa launcher checks the exact library hashes.

The existing short-clip end-of-stream/loop issue and extended-video
limitations are separate; see [hardware video](hardware-video.md).

## Install

Close Angelfish. Put the three APKs listed in the
[package notes](../releases/v2026.10.05-angelfish.md) and their `SHA256SUMS`
in one directory. Check the files and preview the transaction:

```sh
sha256sum -c SHA256SUMS
apk info -v angelfish mesa-dri-gallium qt6-qtwebengine
sudo apk add --simulate --allow-untrusted --no-network \
  ./qt6-qtwebengine-6.11.1-r10.apk \
  ./vince-angelfish-mesa-msaa-26.1.6-r0.apk
```

The transaction should add only the Mesa correction package and, if needed,
upgrade Qt from `r3` to `r10`. Repeat without `--simulate` to install.
`--allow-untrusted` permits these community APKs.

Save any existing user launcher at
`~/.local/share/applications/org.kde.angelfish.desktop` before editing.
If none exists, create `~/.local/share/applications` with `mkdir -p` and copy
`/usr/share/applications/org.kde.angelfish.desktop` there. Set the main
`[Desktop Entry]` section's `Exec=` line to:

```ini
Exec=/usr/lib/vince-angelfish-mesa-msaa/angelfish %u
```

Refresh the application menu with `kbuildsycoca6 --noincremental`, then open
Angelfish from its icon. The wrapper enables hardware video and loads the
corrected Mesa library for the browser. GPU rasterization and WebGL remain
enabled. Check scrolling, a WebGL page and video playback.

## Roll back

Close Angelfish and restore the saved launcher, or remove the user override
if you created it during installation. Refresh the menu, then preview and
remove the Mesa correction:

```sh
sudo apk del --simulate vince-angelfish-mesa-msaa
sudo apk del vince-angelfish-mesa-msaa
```

Continue only if that is the sole removed package. If you also upgraded Qt,
use the included original APK to preview its downgrade:

```sh
sudo apk add --simulate --allow-untrusted --no-network \
  ./qt6-qtwebengine-6.11.1-r3.apk
```

Repeat without `--simulate` if only Qt changes. Use the earlier workaround
below with the uncorrected system Mesa.

## Earlier workaround

With the uncorrected system Mesa, the earlier launcher remains available:

```ini
Exec=/usr/bin/env QTWEBENGINE_CHROMIUM_FLAGS="--disable-gpu-rasterization --disable-webgl --enable-features=AcceleratedVideoDecoder" /usr/bin/angelfish %u
```

It keeps composition and hardware video but disables GPU rasterization and
WebGL. Remove `AcceleratedVideoDecoder` from that line when reverting Qt to `r3`.

The [Mesa patch](../patches/mesa/README.md),
[package recipe](../packages/vince-angelfish-mesa-msaa/README.md) and
[credits](../SOURCES.md#freedreno-msaa-fix) describe the correction.
