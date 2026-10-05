# Angelfish Mesa MSAA correction

`vince-angelfish-mesa-msaa 26.1.6-r0` supplies a corrected Freedreno library
and the Angelfish launcher that loads it. It depends on these exact packages:

- `mesa-dri-gallium=26.1.6-r0`;
- `qt6-qtwebengine=6.11.1-r10`;
- `angelfish=26.04.2-r0`.

The target is Xiaomi Redmi 5 Plus (`vince`), `aarch64`, postmarketOS `v26.06`
with Alpine `3.24` packages. The launcher checks the library hashes before
starting the browser. Installation is in the [Angelfish guide](../../fixes/angelfish-rendering.md).

## Build from source

Use a native Alpine `3.24` aarch64 build environment with the dependencies
listed at the top of [build-mesa.sh](build-mesa.sh). Download
[Mesa 26.1.6](https://mesa.freedesktop.org/archive/mesa-26.1.6.tar.xz),
SHA-256 `5296b88a0f1e012e2cb9ada150a2bbadf728ca81e5a4fb2ab43c83a4d2158606`.

Run from this directory with a fresh absolute output path:

```sh
sh build-mesa.sh /input/mesa-26.1.6.tar.xz /build/vince-mesa-msaa
```

The script applies [Alpine's patch and the Freedreno correction](../../patches/mesa/README.md),
then stages a Freedreno-only Gallium build with Wayland/X11/EGL/GL/GBM.
The original [Alpine recipe](mesa-Alpine-26.1.6-r0-APKBUILD) is retained for
comparison; the build script records the options used for the tested library.

Copy the staged `libgallium-26.1.6.so` beside [APKBUILD](APKBUILD) and run
`abuild -r`. The recipe pins the existing payload's SHA-512. A new build may
differ: update the recipe checksum and launcher's library guard together,
then test it on the target handset.

[Mesa's license notices](mesa-license.rst) are retained. Local build and
launcher code is by Kostiantyn Andriiuk <konstantin@andriyuk.com> under MIT;
see [LICENSE](LICENSE) and [credits](../../SOURCES.md#freedreno-msaa-fix).
