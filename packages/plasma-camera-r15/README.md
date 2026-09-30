# Plasma Camera recording build

This recipe produces Plasma Camera and language packages `2.1.1-r15` from the
official KDE `2.1.1` archive and the two
[application patches](../../patches/plasma-camera/README.md). It adds
rear video recording with a lighter 5 fps preview, full-resolution still
capture and tap-to-refocus to the earlier one-shot autofocus build.

The tested runtime uses [Qt Multimedia `6.11.1-r7`](../qt6-qtmultimedia-r7/README.md)
and libcamera/IPA `99991.7.1-r3`. The patches match the source used in phone
tests. The recipe includes the same build options and CTest checks, but has
not been build-tested in this archive-plus-patches form.

Build in an `aarch64` Alpine/postmarketOS `v26.06` packaging environment with
the matching libcamera development package. Keep the repository layout:
patch paths in `APKBUILD` are relative to this directory. Run `abuild -r`
here, using your own signing key. If moving the aport elsewhere, copy the two
patches with it and adjust `source` and checksum paths.

Keep Camera and its language split together when upgrading or reverting.
Save the previous packages, simulate the local APK transaction and continue
only if no unrelated package is changed or removed. The existing autofocus
release uses the [older r6 recipe](../plasma-camera/README.md).

See [setup and limitations](../../fixes/plasma-camera-video.md) for the required
launcher flags and the 720p recording mode.
