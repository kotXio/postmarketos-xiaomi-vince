# Qt Multimedia recording fixes

This recipe builds Qt Multimedia `6.11.1-r7` for the
[Camera recording](../../fixes/plasma-camera-video.md) and
[KRecorder](../../fixes/krecorder.md) fixes. It uses the official Qt archive,
Alpine's musl include fix and the project-authored
[recording patch series](../../patches/qtmultimedia/README.md).

## Build

Use an `aarch64` Alpine/postmarketOS `v26.06` packaging environment with the
matching Qt `6.11.1` development packages. Keep this repository's layout and
run `abuild -r` in this directory, using your own signing key. If moving the
aport elsewhere, copy the eight patches with it and adjust `source` and
checksum paths.

The patches match the source used in phone tests, including Alpine's include
fix. The recipe includes the same build options and FFmpeg encoder tests, but
has not been build-tested in this archive-plus-patches form. Prebuilt r7 APKs
are not included in the public releases.

## Install your build

Keep these runtime packages together at `6.11.1-r7`:

- `qt6-qtmultimedia`
- `qt6-qtmultimedia-ffmpeg`
- `qt6-qtmultimedia-gstreamer`

Close Camera and Recorder, and retain your previous matching Qt packages
before upgrading. If Qt Multimedia development/debug splits are installed,
include their matching builds too. From the directory containing your APKs:

```sh
sudo apk add --simulate --allow-untrusted \
  ./qt6-qtmultimedia-6.11.1-r7.apk \
  ./qt6-qtmultimedia-ffmpeg-6.11.1-r7.apk \
  ./qt6-qtmultimedia-gstreamer-6.11.1-r7.apk
```

Use `--allow-untrusted` only for your own verified build, or install your public
signing key through the normal Alpine packaging workflow. Continue without
`--simulate` only if the transaction changes the intended Qt Multimedia
packages and removes nothing. The base library and plugins must not come
from different builds.

Then apply the launcher change in the [Camera](../../fixes/plasma-camera-video.md)
or [KRecorder](../../fixes/krecorder.md) guide. These opt-ins are per application;
do not set them globally. KRecorder itself does not need rebuilding.

To revert, close both applications, restore their previous launcher entries
and simulate a downgrade to your saved matching Qt package set. Reopen the
applications after restoring the set. Camera r15 has its own separate
[package pair](../plasma-camera-r15/README.md).
