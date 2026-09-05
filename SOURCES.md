# Sources and provenance

This page records the external material actually used for the tested Vince
work. Directly reused code, adapted code, device facts and reference-only
material are kept separate. Project-authored mail patches use
`Kostiantyn Andriiuk <konstantin@andriyuk.com>`.

## Pinned baselines

- Linux: [`msm8953-mainline/linux`](https://github.com/msm8953-mainline/linux),
  branch `7.0.9/main`, commit
  `5be94b504b80d032481b90d533ee350ee13850f2` (`v7.0.9-r0`).
- pmaports: [`postmarketOS/pmaports`](https://gitlab.postmarketos.org/postmarketOS/pmaports),
  branch `v26.06`, commit
  `2b7f90ea7c2ae4d42ae187dc0b528dc163767b04`.
- pmbootstrap: `3.11.1`, commit
  `130b89d3c391596a1de9c12997b228b1e8a1f692`.

The kernel series applies to the pinned Linux fork. The pmaports series is a
set of direct diffs against the pinned official recipes and device files; its
new Vince-only aports are project-authored.

## TAS2557 speaker and UCM

Kernel patches `0001`-`0004` are the immutable commits from
[`msm8953-mainline/linux#252`](https://github.com/msm8953-mainline/linux/pull/252):

1. `43261695e3f7584d84fb714476fdcfed6721d8d4`
2. `7b74e5ed9ea296bf9a6e632aaf0c3ed95c56f876`
3. `aa59117667a1291c486802987dce3e6c7954bc57`
4. `67526b7ad6eac87dac859eb6ff0de143f2231abe`

They retain Gianluca Boiano's authorship and `Signed-off-by`. The later
[Linux-sound v3 series](https://lore.kernel.org/linux-sound/20260717233402.414326-1-morf3089@gmail.com/)
was used to confirm the physical Vince feedback, not added as a duplicate
series.

The public UCM profile is derived from
[`msm8953-mainline/alsa-ucm-conf#17`](https://github.com/msm8953-mainline/alsa-ucm-conf/pull/17),
head `8c096deeda47052d077f2ac704a6c97e442521e2`. This project retained its
TAS2557 Speaker route, isolated it to a Vince-only filename, changed initial
gain from `0 dB` to `-28 dB`, and replaced the generic Mic2 include with the
physically verified `INP3 -> ADC2 -> DEC1`, `ADC2 Volume=8` route.

The local `400 kHz` patch is project-authored from PR review feedback and the
[TAS2557](https://www.ti.com/lit/ds/symlink/tas2557.pdf) and
[AW2013](https://www.awinic.com/jp/productDetail/AW2013DNR) interface limits.
The VBAT patch is a project-authored correction from the live regulator
topology. A downstream
[`vince` DTS change](https://github.com/imren0x/kernel_devicetree_xiaomi-msm8953/commit/553b2e51b8fd2fa5034f5065517ab043eca3f254)
was used to corroborate the amplifier address, GPIOs and audio format.

The proprietary firmware path is recorded by the
[Lineage extraction list](https://github.com/xiaomi-msm8953-devs/android_device_xiaomi_vince/blob/lineage-18.1/proprietary-files.txt#L14-L15).
The tested file corresponds to Xiaomi build `V11.0.2.0.OEGMIXM`, mirrored by
The Muppets at last-file commit
[`904b303d`](https://gitlab.com/the-muppets/proprietary_vendor_xiaomi/-/commit/904b303d8cacb6e41f4b7b130d70b20685db45f6).
The firmware and APK containing it are not distributed here.

The modified UCM was regression-tested with ALSA
[`ucm-validator2`](https://github.com/alsa-project/alsa-tests/tree/53d34b67078540273899e15544e01c6d996f5240/python/ucm-validator).

## RMI4 touch guard

Patch `0007` is project-authored after matching the failure to
[`msm8953-mainline/linux#167`](https://github.com/msm8953-mainline/linux/issues/167)
and reviewing the pinned Linux
[`rmi_driver.c`](https://github.com/msm8953-mainline/linux/blob/5be94b504b80d032481b90d533ee350ee13850f2/drivers/input/rmi4/rmi_driver.c)
and
[`rmi_i2c.c`](https://github.com/msm8953-mainline/linux/blob/5be94b504b80d032481b90d533ee350ee13850f2/drivers/input/rmi4/rmi_i2c.c).
It is not copied from an existing patch. Later diagnostic RMI4/panel variants
v3-v9 did not become part of the published kernel.

## OV12A10 rear camera

No ready Linux OV12A10 driver was found or copied. Patches `0008`-`0011` are a
new GPL Linux driver, binding and Vince integration built from these inputs:

- register, timing, power and mode data statically decoded from
  `libmmcamera_vince_ov12a10_sunny.so`, SHA-256
  `d4bbeb843107df6f804be995108551b97ac01f2e2cd9f921ce4648ac15e81764`,
  obtained from the pinned public
  [`vince` vendor tree](https://github.com/Project-Nightcord/proprietary_vendor_xiaomi_vince/tree/d99cce529de356802826156f02865caf4a365d59);
- its exact Camera SDK 2.12.0 layout from
  [`99degree/chromatix_demo`](https://github.com/99degree/chromatix_demo/tree/3e1f5de1729253dffd623a09924c4a2228c88c96);
- board wiring and power order from the pinned downstream
  [`vince-camera.dtsi`](https://github.com/xiaomi-msm8953-devs/android_kernel_xiaomi_msm8953/blob/dcaf331bd84a5faf23b8641ff195e4833a5c47bc/arch/arm64/boot/dts/qcom/xiaomi/vince/vince-camera.dtsi);
- final `1.2 V` VDIG and `24 MHz` MCLK corroboration from Android 4.19 commits
  [`28dd53d5`](https://github.com/imren0x/kernel_techpack_xiaomi-titanium/commit/28dd53d5e5acaf89cc80bc88b4b64d8436697d18)
  and
  [`b6def223`](https://github.com/imren0x/kernel_techpack_xiaomi-titanium/commit/b6def223ab663b66b240ccbd022865251660e3dd);
- Linux 7.0 [`ov13b10`](https://github.com/torvalds/linux/blob/v7.0/drivers/media/i2c/ov13b10.c),
  [`ov5675`](https://github.com/torvalds/linux/blob/v7.0/drivers/media/i2c/ov5675.c)
  and [`imx219`](https://github.com/torvalds/linux/blob/v7.0/drivers/media/i2c/imx219.c)
  as V4L2, timing and runtime-PM structural references only.

The stock blob was statically inspected, never executed, and is not
redistributed. Its mode tables supplied interoperability data, but no Android
kernel driver was copied. The production module identity was independently
corroborated by a
[real Vince stock log](https://gist.github.com/dattebayorob/c05db5c30874b47716e501c9314d93d0).

Selection geometry came from the same decoded metadata. Rotation was corrected
using the official [libcamera Rotation definition](https://docs.libcamera.org/master/internal-api/namespacelibcamera_1_1properties.html),
the matching [Plasma Camera 2.1.1](https://apps.kde.org/plasma.camera/) source
and a physical A/B test.

[`msm8953-mainline/linux#257`](https://github.com/msm8953-mainline/linux/pull/257)
provided a useful MSM8953 camera workflow and test ladder, but its driver was
not copied. PR [`#239`](https://github.com/msm8953-mainline/linux/pull/239) was
used only to confirm the OV12A10 driver gap.

## DW9763 lens

Patch `0012` directly extends the pinned Linux
[`dw9768.c`](https://github.com/msm8953-mainline/linux/blob/5be94b504b80d032481b90d533ee350ee13850f2/drivers/media/i2c/dw9768.c)
and its existing binding, preserving DW9768/GT9769 behavior while adding
per-compatible DW9763 data.

The address, single `2.85 V` VAF supply, initialization values, default and
conservative range came from static analysis of
`libactuator_vince_dw9763_sunny.so`, SHA-256
`f9c74f4aa390780987eaa1fa2d8cf1bdf6848a439173016c001bf45ba3da7576`,
using the same pinned vendor tree, Camera SDK and downstream DTS above.
Mainline [`dw9714.c`](https://github.com/torvalds/linux/blob/v7.0/drivers/media/i2c/dw9714.c)
was inspected and rejected as protocol-incompatible.

## OV12A10 one-shot autofocus

The libcamera series targets the exact upstream
[`v0.7.1`](https://gitlab.freedesktop.org/camera/libcamera/-/tree/v0.7.1)
commit `183e37362f57ff3ce7493abf0bc6f1b57b931f55`. The implementation follows the
official [`AfMode`, `AfTrigger`, `AfState` and `LensPosition` contract](https://docs.libcamera.org/master/public-api/namespacelibcamera_1_1controls.html)
and extends the pinned
[Simple algorithms](https://gitlab.freedesktop.org/camera/libcamera/-/tree/v0.7.1/src/ipa/simple/algorithms),
[`SwIspStats`](https://gitlab.freedesktop.org/camera/libcamera/-/blob/v0.7.1/include/libcamera/internal/software_isp/swisp_stats.h)
and [CPU statistics implementation](https://gitlab.freedesktop.org/camera/libcamera/-/blob/v0.7.1/src/libcamera/software_isp/swstats_cpu.cpp).

The review-stage [Simple focus-control patch and discussion](https://patchwork.libcamera.org/patch/26241/)
and Pavel Machek's experimental
[`millicam_af_6`](https://gitlab.com/tui/libcamera/-/tree/millicam_af_6)
[two-phase prototype](https://gitlab.com/tui/libcamera/-/commit/da42da564afa50ef938a230253ac930551bd414b)
were design references for plumbing, a central Bayer metric, settling and
two-phase search. They were not applied unchanged: their raw `0..100` position
model and state behavior do not meet the standard control contract or the
handset's bounded acceptance criteria.

The application patch targets the exact
[Plasma Camera `v2.1.1` source](https://invent.kde.org/plasma-mobile/plasma-camera/-/tree/v2.1.1).
It uses only standard libcamera controls and sends one explicit rear-session
trigger; it does not drive V4L2 subdevices or calculate focus itself.

Two phone-discovered teardown failures were compared with upstream discussion.
The invalid delayed-control class matches the
[libcamera-devel report](https://lists.libcamera.org/pipermail/libcamera-devel/2025-September/053345.html)
and [Patchwork 24468](https://patchwork.libcamera.org/patch/24468/). The related
[SoftwareIsp stop discussion](https://lists.libcamera.org/pipermail/libcamera-devel/2025-July/051424.html)
and [earlier stop cleanup](https://patchwork.libcamera.org/patch/21719/)
explain why queued SoftISP messages are drained during teardown. The project
guards are locally authored and retain libcamera's generic type assertion.

The final tested source heads are
`3a6c4602cb797e7418ad67bcf790c08f54799e2a` for libcamera and
`c43aef4dd36fbc70528869ad7d30ce01252a045f` for Plasma Camera. The derived
`242..726` tuning endpoints came from checksum-valid EEPROM data on the single
test handset. The raw EEPROM is not published, and the values are not claimed
to be universal for every `vince`.

## IPA and camera policy

The project-authored `blackLevel: 4096` tuning comes from the stock RAW10
pedestal `64` and the
[libcamera 0.7.1 Simple IPA](https://gitlab.freedesktop.org/camera/libcamera/-/tree/v0.7.1/src/ipa/simple)
BlackLevel representation: `64 << (16 - 10) = 4096`. No libcamera source code
is copied into the data-only package.

The project-authored WirePlumber fragment follows the official 0.5
[profile feature syntax](https://pipewire.pages.freedesktop.org/wireplumber/daemon/configuration/components_and_profiles.html),
[fragment rules](https://pipewire.pages.freedesktop.org/wireplumber/daemon/configuration/modifying_configuration.html)
and
[video monitor relationship](https://pipewire.pages.freedesktop.org/wireplumber/daemon/configuration/video.html).
It disables only `monitor.libcamera`, retaining V4L2 and the rest of the
`main` profile.

## PMI8950 rear torch

Kernel patch `0014` is a project-authored, continuous-torch-only backend for
the legacy PMI8950 two-channel subtype. Register definitions and applicable
protection sequencing were adapted from Xiaomi/Qualcomm's GPLv2
[`leds-qpnp-flash.c`](https://github.com/xiaomi-msm8953-devs/android_kernel_xiaomi_msm8953/blob/dcaf331bd84a5faf23b8641ff195e4833a5c47bc/drivers/leds/leds-qpnp-flash.c)
and the pinned downstream
[`pmi8950.dtsi`](https://android.googlesource.com/kernel/msm/+/f492c5d87df6daa7c010dd4d14a7f34da06d9757/arch/arm64/boot/dts/qcom/pmi8950.dtsi).
The public source retains the applicable Linux Foundation attribution and GPL
license notice.

The user interface follows the standard Linux
[multicolor LED class](https://docs.kernel.org/leds/leds-class-multicolor.html).
Plasma compatibility was checked against the current
[flashlight quick-setting implementation](https://github.com/KDE/plasma-mobile/blob/master/quicksettings/flashlight/flashlightutil.cpp),
which discovers `*:torch`/`*:flash` LED-class devices and toggles their normal
brightness attribute.

The `50 mA` per-channel cap and channel order `0=cool 1=warm` are project test
results from one physical handset. They were established through separate
minimum-current channel tests before combined and live-reconfiguration tests.
The published patch does not copy the roughly 2700-line downstream driver and
does not implement its private trigger interface.

## Angelfish and hardware video

The Angelfish launcher workaround is project-authored from controlled A/B
testing, not copied configuration. The interpretation used official
[Qt WebEngine](https://doc.qt.io/qt-6/qtwebengine-features.html),
[Mesa Freedreno](https://docs.mesa3d.org/drivers/freedreno.html) and
[Chromium VA-API](https://chromium.googlesource.com/chromium/src/+/refs/heads/main/docs/gpu/vaapi.md)
documentation.

The final browser package targets Alpine aports `3.24-stable` commit
`3ca62a2571378ee35a0e149a0e91454b57240737`, its
[`qt6-qtwebengine` recipe](https://github.com/alpinelinux/aports/blob/3ca62a2571378ee35a0e149a0e91454b57240737/community/qt6-qtwebengine/APKBUILD),
Qt WebEngine `6.11.1` and bundled Chromium commit
[`37b6aeaa3ef9bf7e1901aa02a317a2707557709d`](https://github.com/qt/qtwebengine-chromium/tree/37b6aeaa3ef9bf7e1901aa02a317a2707557709d/chromium).
The cumulative aport diff and all source patches are published under
[`patches/qtwebengine/`](patches/qtwebengine/).

Three source changes directly derive from external code:

- `vince-qtwebengine-h264-access-units.patch` retains Alexandros Frantzis's
  Collabora authorship and adapts the six-line Chromium 142 refresh carried by
  [TI meta-arago commit `30a611f5`](https://git.ti.com/cgit/arago-project/meta-arago/commit/meta-arago-distro?id=30a611f56a4bd74d421e36ecddf705b956c01648)
  to the pinned Chromium 140 tree;
- `vince-qtwebengine-mt21-neon-types.patch` adapts the same two strict vector
  type corrections from the
  [openSUSE Electron patch](https://src.opensuse.org/rpm/nodejs-electron/src/commit/d74ae9ab235156a9c62c9bdc6e4fadae35888f0b3a8e0a40b41c50667213da91/mt21_util-flax-vector-conversions.patch);
- `vince-qtwebengine-multiplanar-native-pixmap.patch` is the exact Qt 6.11
  backport commit
  [`ae6991d950bb343accad96b96047fe605c17bcc3`](https://github.com/qt/qtwebengine/commit/ae6991d950bb343accad96b96047fe605c17bcc3)
  by Peter Varga for `QTBUG-145344`, with its original review and cherry-pick
  metadata retained.

The V4L2 Qt/CMake plumbing, public musl `timeval` types, Linux per-plane NV12
selection and cumulative Alpine recipe integration are project-authored. They
were developed against the pinned trees using Chromium's
[standard-Linux V4L2 enablement](https://chromium.googlesource.com/chromium/src/+/149471b4a55327f34b1130a71bb85aff4d35d487%5E%21/)
and exact
[MailboxVideoFrameConverter](https://chromium.googlesource.com/chromium/src/media/+/37fc505397bdffdd90ace984c520d96c6657ce88/gpu/chromeos/mailbox_video_frame_converter.cc)
as references. The Linux
[stateful V4L2 decoder API](https://docs.kernel.org/userspace-api/media/v4l/dev-decoder.html),
[GStreamer hardware-decode guidance](https://gstreamer.freedesktop.org/documentation/tutorials/playback/hardware-accelerated-video-decoding.html),
and [FFmpeg V4L2 mem2mem implementation](https://ffmpeg.org/doxygen/trunk/v4l2__m2m__dec_8c.html)
were used to validate the already working Qualcomm Venus decoder independently
before changing Qt WebEngine.

## Explicit non-sources

- `ov02a10.c` was only a structural comparison; none of its sensor registers
  or tables were reused.
- The Android OV12A10 `36.61 MHz` MCLK experiment was rejected in favor of the
  later `24 MHz` value.
- The review-stage autofocus patches above were not applied unchanged. The
  public autofocus series is the separately tested project implementation;
  raw EEPROM contents remain excluded.
- High-current photo flash, V4L2/sensor strobe integration and
  `libva-v4l2-request` are not part of the current public source or release.
- TI's other device-path, sandbox and OUTPUT-queue V4L2 patches were diagnostic
  comparisons only and are not present in the final Qt WebEngine source.
- qutebrowser and Falkon reports were symptom comparisons, not code sources.
- Proprietary firmware, camera blobs, EEPROM dumps, photos and recordings are
  not redistributed by this project.
