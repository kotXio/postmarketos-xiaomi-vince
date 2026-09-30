# SDR++ for Vince

Package: `sdrpp-vince-1.3.0_git20260704-r3`, `aarch64`, postmarketOS
`v26.06` / Alpine `3.24`. It includes 14 SDR++ modules, Codec2 `1.2.0`
for M17 and a private Wayland-only GLFW `3.4` with touch support.

For installation and everyday use, see the [SDR++ guide](../../fixes/sdrpp.md).

## Source and patches

The base is SDR++ commit
[`8c9f5ee8`](https://github.com/AlexandreRouma/SDRPlusPlus/tree/8c9f5ee8fe405775bfcd62c8c8f8c0fc928a64af).
The [APKBUILD](APKBUILD) applies these changes:

| File | Change |
| --- | --- |
| [dab-volk-3.1-pointer.patch](dab-volk-3.1-pointer.patch) | Adapt the DAB rotator call to VOLK 3.1 and later. |
| [sdrpp-vince-runtime.patch](sdrpp-vince-runtime.patch) | Stop reception before unloading modules, so normal exit releases the USB device. |
| [decoder-compat.patch](decoder-compat.patch) | Adapt the KG-SSTV and weather modules to the current DSP API and restore their older NOAA helpers. |
| [glfw-wayland-touch.patch](glfw-wayland-touch.patch) | Translate Wayland touch events to pointer input and give the private library a separate name. Applied to GLFW, not SDR++. |

The recipe also adds `--autostart` to the desktop launcher. The private
`libglfw-vince.so.3` does not replace `libglfw.so.3` or alter other applications.

## Build

Use a native `aarch64` Alpine `3.24` build environment with `abuild` configured
for an ordinary build user, your packager identity and your own signing key.
The reference toolchain
was GCC `15.2.0-r5`, musl `1.2.6-r2`, CMake `4.2.3-r0` and abuild `3.17.0-r0`.
All build dependencies are listed in the recipe.

Extract `sdrpp-vince-1.3.0_git20260704-r3-sources.tar.gz` from the release.
Its `sdrpp-vince/` directory contains this recipe, the patches and all three
unchanged source archives:

- `sdrpp-vince-1.3.0_git20260704.tar.gz`;
- `codec2-1.2.0.tar.gz`;
- `glfw-3.4.tar.gz`.

From that directory, run:

```sh
export SOURCE_DATE_EPOCH=1789485518
export CMAKE_BUILD_PARALLEL_LEVEL=4
export MAKEFLAGS=-j4
abuild clean
SRCDEST="$PWD" abuild -r
```

`abuild` checks the source hashes from the recipe before building. Your APK signature
will differ when signed with your own key.

## Credits and licences

SDR++ and its modules are upstream work by Alexandre Rouma (Ryzerth) and
contributors. The NOAA helpers adapt the earlier SDR++ files pinned in
[SOURCES.md](../../SOURCES.md#sdr-with-a-usb-receiver); they are not newly
authored decoder implementations.

The recipe and local SDR++ compatibility changes are by Kostiantyn Andriiuk
<konstantin@andriyuk.com>, under GPL-3.0-only. The GLFW patch uses GLFW's Zlib
licence. Codec2 is by David Rowe and contributors under LGPL-2.1; its library
is shipped separately as a shared object, not statically folded into SDR++.

Upstream notices remain in the source archives. Copies of the
[SDR++ GPL](licenses/GPL-3.0.txt), [Codec2 LGPL](licenses/LGPL-2.1.txt),
[GLFW Zlib notice](licenses/GLFW-Zlib.txt) and the bundled
[libcorrect BSD notice](licenses/libcorrect-BSD.txt) accompany the source.
