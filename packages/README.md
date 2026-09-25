# Package sources

This directory contains the reviewed Alpine/postmarketOS package sources used
for the Vince configuration:

- [`linux-postmarketos-qcom-msm8953-r16`](linux-postmarketos-qcom-msm8953-r16/README.md);
- [`postmarketos-vince-fm-radio`](postmarketos-vince-fm-radio/README.md);
- [`alsa-ucm-conf-xiaomi-vince-tas2557`](alsa-ucm-conf-xiaomi-vince-tas2557/README.md);
- [`firmware-xiaomi-vince-tas2557-local`](firmware-xiaomi-vince-tas2557-local/README.md);
- [`libcamera-ipa-ov12a10`](libcamera-ipa-ov12a10/README.md);
- [`libcamera`](libcamera/README.md);
- [`plasma-camera`](plasma-camera/README.md);
- [`device-xiaomi-vince-camera-policy`](device-xiaomi-vince-camera-policy/README.md).

Compiled APKs are not stored in this repository. Package compatibility is tied
to the exact device and postmarketOS baseline documented by each source.

Qt WebEngine is an existing Alpine package rather than a Vince-only aport, so
its cumulative recipe diff and source patches are kept under
[`../patches/qtwebengine/`](../patches/qtwebengine/) instead of duplicating the
entire upstream package directory here.

The TAS2557 firmware package is the special case: its proprietary blob must be
extracted from a legally obtained stock image and built locally. Neither the
blob nor the resulting APK may be redistributed.

## Public installation order

The kernel updates are cumulative but their accompanying userspace packages
are released in stages:

1. Start with a clean Xiaomi Redmi 5 Plus (`vince`) postmarketOS `v26.06`
   installation.
2. Install [`v2026.09.04`](https://github.com/kotXio/postmarketos-xiaomi-vince/releases/tag/v2026.09.04).
3. Install [`v2026.09.05-autofocus`](https://github.com/kotXio/postmarketos-xiaomi-vince/releases/tag/v2026.09.05-autofocus).
4. Install [`v2026.09.05-torch`](https://github.com/kotXio/postmarketos-xiaomi-vince/releases/tag/v2026.09.05-torch).
5. Install [`v2026.09.12-suspend`](https://github.com/kotXio/postmarketos-xiaomi-vince/releases/tag/v2026.09.12-suspend).
6. Install the cumulative
   [`v2026.09.25-r16`](https://github.com/kotXio/postmarketos-xiaomi-vince/releases/tag/v2026.09.25-r16)
   update.

The WebEngine update is separate from that kernel sequence. It requires the
official Qt WebEngine `6.11.1-r3` package as its starting version and was tested
with the cumulative torch kernel.

## Tested binary release

Release
[`v2026.09.04`](https://github.com/kotXio/postmarketos-xiaomi-vince/releases/tag/v2026.09.04)
contains these physically tested public packages:

| Package | Purpose |
| --- | --- |
| `linux-postmarketos-qcom-msm8953-7.0.9_p20260902163513-r3.apk` | Cumulative kernel. |
| `device-qcom-msm8953-13-r2.apk` | Matching MSM8953 device package. |
| `device-qcom-msm8953-udev-13-r2.apk` | Matching udev subpackage. |
| `device-xiaomi-vince-camera-policy-1-r0.apk` | Vince-only WirePlumber camera policy. |
| `libcamera-ipa-ov12a10-1.0-r0.apk` | OV12A10 Simple IPA tuning. |
| `alsa-ucm-conf-xiaomi-vince-tas2557-1.0-r1.apk` | TAS2557 speaker and Mic2 UCM profile. |

Exact compatibility:

- Xiaomi Redmi 5 Plus (`xiaomi,vince`), `aarch64`;
- postmarketOS `v26.06`, tested with Plasma Mobile;
- Linux runtime ABI `7.0.9-msm8953`;
- kernel and pmaports bases pinned in [`../SOURCES.md`](../SOURCES.md);
- exact `libcamera-ipa=99990.7.1-r0` for the tuning package.

The supported starting point uses the postmarketOS `v26.06` core packages
`linux-postmarketos-qcom-msm8953-7.0.9-r0`,
`device-qcom-msm8953-13-r0`, `device-qcom-msm8953-udev-13-r0` and
`soc-qcom-msm8953-ucm-19-r0`. Always run the simulated transaction first.

## Experimental autofocus release

Release
[`v2026.09.05-autofocus`](https://github.com/kotXio/postmarketos-xiaomi-vince/releases/tag/v2026.09.05-autofocus)
is an incremental update over the exact tested `v2026.09.04` state:

| Package | Purpose |
| --- | --- |
| `linux-postmarketos-qcom-msm8953-7.0.9_p20260903161811-r4.apk` | Cumulative kernel with the handset-tested DW9763 maximum `726`. |
| `libcamera-99991.7.1-r3.apk` | Simple-pipeline lens plumbing and AF runtime. |
| `libcamera-ipa-99991.7.1-r3.apk` | Matching signed Simple IPA. |
| `libcamera-ipa-ov12a10-1.1-r3.apk` | Black level and handset-local AF policy. |
| `plasma-camera-2.1.1-r6.apk` | One rear-session AF trigger. |
| `plasma-camera-lang-2.1.1-r6.apk` | Matching language split. |
| `libpisp-1.5.0-r0.apk` | Unmodified Alpine compatibility package retained by the transaction. |

The required starting versions are cumulative kernel r3, device and udev r2,
camera policy r0, libcamera/IPA `99990.7.1-r0`, OV12A10 tuning `1.0-r0`, Plasma
Camera/language `2.1.1-r2` and `libpisp-1.5.0-r0`. Check the exact installed
versions with `apk info -v` before continuing. Do not use this Release on a
different package baseline without rebuilding or reviewing the transaction.

This binary is physically verified only on one `vince` with the Sunny OV12A10
plus DW9763 module. Its `242..726` endpoints came from that handset's
checksum-valid EEPROM and are not claimed to be universal.

### Install the autofocus update

Install the complete public `v2026.09.04` set first. Close Plasma Camera, then
download all seven autofocus assets and `SHA256SUMS` into one empty directory:

```sh
sha256sum -c SHA256SUMS

sudo sh -c '
umask 022
apk add --simulate --allow-untrusted \
  ./linux-postmarketos-qcom-msm8953-7.0.9_p20260903161811-r4.apk \
  ./libcamera-99991.7.1-r3.apk \
  ./libcamera-ipa-99991.7.1-r3.apk \
  ./libcamera-ipa-ov12a10-1.1-r3.apk \
  ./plasma-camera-2.1.1-r6.apk \
  ./plasma-camera-lang-2.1.1-r6.apk \
  ./libpisp-1.5.0-r0.apk
'
```

The simulation must show exactly six upgrades, keep `libpisp` and remove
nothing. If it does, repeat the same command without `--simulate`, then verify:

```sh
stat -c '%a %U:%G' /usr/share/libcamera/ipa/simple/ov12a10.yaml
sudo reboot
```

The expected file mode and owner are `644 root:root`. After reboot, check rear
autofocus, rapid rear/front switching and one still from each camera. A flat
scene may validly finish as `AfStateFailed`.

### Roll back the autofocus update

Return to the public `v2026.09.04` kernel and OV12A10 tuning assets, and restore
the official postmarketOS `v26.06` libcamera/IPA `99990.7.1-r0` and Plasma
Camera/language `2.1.1-r2` packages from the configured repositories. Simulate
the complete downgrade first and continue only if it keeps `libpisp` and
changes no unrelated package. If those exact official versions are no longer
available, reinstall the matching postmarketOS image rather than mixing
package baselines.

## Incremental torch release

Release
[`v2026.09.05-torch`](https://github.com/kotXio/postmarketos-xiaomi-vince/releases/tag/v2026.09.05-torch)
contains one incremental asset for the public autofocus Release:

| Package | Purpose |
| --- | --- |
| `linux-postmarketos-qcom-msm8953-7.0.9_p20260905194220-r7.apk` | Cumulative kernel with the PMI8950 dual-colour continuous torch. |

The APK was built from the reviewed public patch series and preserves the
cumulative TAS2557/Mic2, RMI4, OV12A10, DW9763 and autofocus changes.

Install the complete
[`v2026.09.05-autofocus`](https://github.com/kotXio/postmarketos-xiaomi-vince/releases/tag/v2026.09.05-autofocus)
set first. Download this Release's APK and `SHA256SUMS` into an empty directory,
then verify and simulate the kernel upgrade:

```sh
sha256sum -c SHA256SUMS

sudo apk add --simulate --allow-untrusted \
  ./linux-postmarketos-qcom-msm8953-7.0.9_p20260905194220-r7.apk
```

Continue only if no package is removed and no package other than
`linux-postmarketos-qcom-msm8953` changes. Repeat without `--simulate`, reboot,
then test the normal Plasma Mobile flashlight control and confirm that the
torch switches fully off. Advanced cool/warm controls are available through
`/sys/class/leds/white:torch`.

For rollback, download the `r4` kernel APK and `SHA256SUMS` from the public
autofocus Release. Verify the checksum, simulate the one-package downgrade,
install it and reboot. Photo flash and V4L2/sensor strobe integration are
deliberately deferred.

## Suspend/resume kernel update

`linux-postmarketos-qcom-msm8953-7.0.9_p20260912095627-r13.apk` replaces the
public `r7` torch kernel on `vince`, `aarch64`, postmarketOS `v26.06`, Linux
`7.0.9-msm8953`. It restores working suspend-to-idle and Power-button wake
while keeping the earlier hardware fixes. Overnight testing passed with
normal battery behaviour.

This update changes only the kernel package. Keep the existing device, UCM,
firmware, libcamera/IPA, tuning and Plasma Camera packages. Installation,
checksums and the public `r7` fallback are documented in the
[release notes](../releases/v2026.09.12-suspend.md).

## Cumulative r16 hardware update

Release `v2026.09.25-r16` upgrades the public `r13` state with the following
packages and supporting FM configuration:

| Package | Purpose |
| --- | --- |
| `linux-postmarketos-qcom-msm8953-7.0.9_p20260914105626-r16.apk` | Cumulative kernel with the front light, rc-core infrared and native V4L2 FM receiver. |
| `alsa-ucm-conf-xiaomi-vince-tas2557-1.0-r3.apk` | Retains the TAS2557/Mic2 routes and adds the 48 kHz stereo FM route. |
| `qv4l2-1.32.0-r1.apk` | Unmodified Alpine V4L2 tuning and mute control. |
| `postmarketos-vince-fm-radio-1.0.0-r1.apk` | Optional lightweight FM application with scanning, saved stations and headphone/speaker launchers. |

The three small files under [`../config/vince-fm`](../config/vince-fm/README.md)
provide module loading, `/dev/radio0` access and the Plasma launcher. The exact
kernel APKBUILD, configuration, changed-source manifest and 43-patch series are
under
[`linux-postmarketos-qcom-msm8953-r16`](linux-postmarketos-qcom-msm8953-r16/README.md).
The FM application's reproducible aport and GPL licence are under
[`postmarketos-vince-fm-radio`](postmarketos-vince-fm-radio/README.md).
Usage and limitations are summarized in the
[FM radio guide](../fixes/fm-radio.md).

See the [release notes](../releases/v2026.09.25-r16.md) for the exact
compatibility, checksums, installation and rollback instructions.

## Experimental WebEngine hardware-video release

Release
[`v2026.09.05-webengine`](https://github.com/kotXio/postmarketos-xiaomi-vince/releases/tag/v2026.09.05-webengine)
contains one cumulative userspace package:

| Package | Purpose |
| --- | --- |
| `qt6-qtwebengine-6.11.1-r10.apk` | Enable Chromium's standard-Linux stateful V4L2 path and complete H.264/NV12 import through Qt Ozone. |

It targets Xiaomi Redmi 5 Plus (`xiaomi,vince`), `aarch64`, postmarketOS
`v26.06`, Qt WebEngine `6.11.1-r3` ancestry and bundled Chromium commit
`37b6aeaa3ef9bf7e1901aa02a317a2707557709d`. It was tested with the
cumulative `7.0.9-msm8953` `r7` kernel, but changes no kernel, firmware,
service or camera/audio package.

The package was tested on one handset. Confirm that the installed starting
version is the official `qt6-qtwebengine-6.11.1-r3`; this Release does not
replace any other package.

Download the r10 APK and `SHA256SUMS` into one empty directory and verify one
package upgrade:

```sh
sha256sum -c SHA256SUMS

sudo apk add --simulate --allow-untrusted \
  ./qt6-qtwebengine-6.11.1-r10.apk
```

Continue only if `qt6-qtwebengine` is the sole changed package and nothing is
added or removed. Repeat without `--simulate`; no reboot is required:

```sh
sudo apk add --allow-untrusted \
  ./qt6-qtwebengine-6.11.1-r10.apk
```

The APK does not enable the browser feature by itself. Copy the system desktop
entry to the per-user application directory if needed, then use this exact
`Exec=` line:

```text
Exec=/usr/bin/env QTWEBENGINE_CHROMIUM_FLAGS="--disable-gpu-rasterization --disable-webgl --enable-features=AcceleratedVideoDecoder" /usr/bin/angelfish %u
```

Fully stop the previous Angelfish process and start it again from the Plasma
Mobile icon. A normal playback check should show the dynamically resolved
`qcom-venus-decoder` runtime status as `active`; it must return to `suspended`
after playback stops. Keep the two rendering-stability flags: hardware video
does not replace them.

To disable hardware video, remove only
`--enable-features=AcceleratedVideoDecoder` from the launcher while retaining
the two stability flags, then fully restart Angelfish. For a complete package
rollback, use the configured postmarketOS `v26.06` repositories to simulate and
restore `qt6-qtwebengine=6.11.1-r3`. Continue only if it is the sole changed
package. Reboot is not required.

Hardware decoding and smooth YouTube playback were confirmed. In an A/B test,
browser CPU use was about half that of software decoding. Two Venus firmware
errors recovered automatically during a longer fullscreen test without a
visible playback problem, so extended playback remains experimental; see
[`../fixes/hardware-video.md`](../fixes/hardware-video.md).

## Installing base Release v2026.09.04

Install the base set only on the exact postmarketOS `v26.06` starting versions
listed above. If the installed baseline differs, rebuild the packages or use a
matching postmarketOS image.

Download all six APKs and `SHA256SUMS` from the Release into one empty
directory, then verify the downloaded bytes:

```sh
sha256sum -c SHA256SUMS
```

Confirm the device before installing anything:

```sh
tr '\0' '\n' < /sys/firmware/devicetree/base/compatible | grep -Fx xiaomi,vince
uname -m
uname -r
```

The expected output includes `xiaomi,vince`, `aarch64` and
`7.0.9-msm8953`.

### Manual installation

First build and verify the local proprietary
[`firmware-xiaomi-vince-tas2557-local`](firmware-xiaomi-vince-tas2557-local/README.md)
APK and place it beside the six downloaded public APKs. The firmware APK is
installed in the same transaction but is not a public Release asset.

Simulate the complete transaction:

```sh
sudo apk add --simulate --allow-untrusted \
  ./linux-postmarketos-qcom-msm8953-7.0.9_p20260902163513-r3.apk \
  ./device-qcom-msm8953-13-r2.apk \
  ./device-qcom-msm8953-udev-13-r2.apk \
  ./device-xiaomi-vince-camera-policy-1-r0.apk \
  ./libcamera-ipa-ov12a10-1.0-r0.apk \
  ./alsa-ucm-conf-xiaomi-vince-tas2557-1.0-r1.apk \
  ./firmware-xiaomi-vince-tas2557-local-11.0.2.0-r0.apk
```

Review the proposed package changes. If the simulation is clean, repeat the
same command without `--simulate`, verify the installed package versions, and
reboot. `--allow-untrusted` is necessary because these are locally signed
builds; it is safe only after the attached checksums have passed.

### Manual rollback

This Release changes the kernel, device integration and audio-provider layout,
and its proprietary firmware package cannot be distributed. A universal
package-only rollback bundle is therefore not available. The reliable public
rollback is to reinstall the official postmarketOS `v26.06` image for
`xiaomi-vince`, then restore user data from backup.
