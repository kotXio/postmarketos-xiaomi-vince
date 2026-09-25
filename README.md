# postmarketOS on Xiaomi Redmi 5 Plus (`vince`)

Unofficial, reproducible fixes and hardware-enablement work for the Xiaomi
Redmi 5 Plus, device codename `vince`, running postmarketOS.

Official device information:
[Xiaomi Redmi 5 Plus (`xiaomi-vince`) on the postmarketOS wiki](https://wiki.postmarketos.org/wiki/Xiaomi_Redmi_5_Plus_%28xiaomi-vince%29).

This is a small DIY pet project, not a postmarketOS fork or an official
postmarketOS repository. The aim is to make one real phone more useful while
documenting the sources, changes and rollback steps so another owner can repeat
the work safely.

## At a glance

- [Current hardware and software status](STATUS.md)
- [Chronological project history](HISTORY.md)
- [Fixes and experiments](fixes/README.md)
- [Package sources](packages/README.md)
- [Device configuration](config/README.md)
- [Kernel and pmaports patch series](patches/README.md)
- [Pinned source revisions and provenance](SOURCES.md)

## What works

- TAS2557 bottom speaker with a conservative `-28 dB` hardware gain.
- Clean default microphone route: `Mic2 -> INP3 -> ADC2 -> DEC1`, analog
  `ADC2 Volume=8`, digital source volume `100%`.
- OV12A10 rear camera support with five available sensor modes.
- DW9763 lens movement, parking and bounded manual-focus control.
- Rear one-shot contrast autofocus integrated with libcamera and Plasma
  Camera, including rapid-switch teardown guards.
- PMI8950 dual-colour rear torch with four hardware-backed levels, separate
  cool/warm intensity and a `50 mA` per-channel safety cap.
- Standard Linux control of the front selfie light through the binary
  `white:torch-1` LED.
- Built-in infrared transmission through rc-core and fixed-rate SPI sampling.
- Native FM radio with full-band scanning, saved stations and stereo audio
  through wired headphones or the TAS2557 speaker.
- Suspend-to-idle and power-button wake with working display and touch;
  overnight use showed normal battery behaviour.
- LTR579 ambient light plus a polled raw proximity channel on a separately
  identified second handset; automatic binding and passive far readings pass.
- Stable Angelfish launcher workaround that keeps GPU composition and Canvas
  while disabling the two unstable Chromium paths.
- Hardware video decoding in normal Angelfish through Qualcomm Venus, using a
  patched Qt WebEngine `6.11.1-r10` and the existing safe rendering flags.

## Known gaps

- Long/fullscreen Angelfish hardware-video playback remains experimental: two
  Venus firmware errors recovered automatically during an extended test with
  no visible playback problem, but their trigger is not yet isolated.
- Wi-Fi can take tens of seconds to reconnect after waking from suspend.
- Autofocus is one-shot at rear-camera session start; continuous AF,
  touch-to-focus and calibrated focus distance are not implemented.
- Plasma Camera encoded video remains slow and timestamp-imperfect and has no
  audio in the current public camera stack; this is separate from the working
  autofocus path.
- High-current photo flash and V4L2/sensor strobe integration are deliberately
  deferred; the continuous rear torch works.
- Infrared emission works, but compatibility with real appliances has not yet
  been checked.
- Wired headphones are required as the FM antenna. RDS is unavailable and the
  current driver reports service detection rather than calibrated signal
  strength.
- SIM-dependent telephony paths and an outdoor GNSS fix remain untested.
- LTR579 physical near/cover response, thresholds, interrupts and wake events
  have not yet been checked on the second hardware variant.

## Releases

The cumulative `r16` hardware update is available as
[`v2026.09.25-r16`](https://github.com/kotXio/postmarketos-xiaomi-vince/releases/tag/v2026.09.25-r16).
It adds the front selfie light, rc-core infrared transmission and native V4L2
FM radio while keeping the previously published hardware support. The optional
FM Radio package adds full-band scanning, saved stations and Plasma launchers.
See the
[`r16` release details](releases/v2026.09.25-r16.md) and
[exact kernel source recipe](packages/linux-postmarketos-qcom-msm8953-r16/README.md).

The suspend/resume update is available as
[`v2026.09.12-suspend`](https://github.com/kotXio/postmarketos-xiaomi-vince/releases/tag/v2026.09.12-suspend).
Its cumulative `r13` kernel keeps the previous audio, camera, autofocus and
torch fixes. See the
[suspend/resume release details](releases/v2026.09.12-suspend.md) for
compatibility, installation and source patches.

The base package set is available as
[`v2026.09.04`](https://github.com/kotXio/postmarketos-xiaomi-vince/releases/tag/v2026.09.04).
It contains the cumulative kernel, matching MSM8953 device/udev packages,
Vince camera policy, OV12A10 IPA tuning and TAS2557 UCM profile. The target is
Xiaomi Redmi 5 Plus (`vince`), `aarch64`, postmarketOS `v26.06`, Plasma Mobile
and Linux `7.0.9-msm8953`.

The incremental experimental autofocus set is available as
[`v2026.09.05-autofocus`](https://github.com/kotXio/postmarketos-xiaomi-vince/releases/tag/v2026.09.05-autofocus).
It updates the cumulative kernel, libcamera/IPA, OV12A10 tuning and Plasma
Camera while preserving the earlier audio, touch and camera fixes. Its
`242..726` actuator endpoints were derived from one test handset and are not
claimed to be universal for every `vince`.

The incremental torch update is available as
[`v2026.09.05-torch`](https://github.com/kotXio/postmarketos-xiaomi-vince/releases/tag/v2026.09.05-torch).
It contains one cumulative `r7` kernel APK built from the reviewed public patch
series plus its checksum manifest. Its config, Vince DTB and modules match the
published source recipe. It requires the public autofocus
Release linked above. It adds continuous torch control only; photo flash
remains deferred.

The experimental browser hardware-video update is available as
[`v2026.09.05-webengine`](https://github.com/kotXio/postmarketos-xiaomi-vince/releases/tag/v2026.09.05-webengine).
It contains one cumulative Qt WebEngine `6.11.1-r10` APK. With the documented
Angelfish launcher flag, the browser uses the Qualcomm Venus stateful V4L2
decoder while retaining the tested WebGL and GPU-rasterization stability
workaround. Fixed H.264 and normal YouTube playback work;
extended fullscreen stability is not yet claimed.

Read the compatibility and public package order in
[`packages/README.md`](packages/README.md) before using the APKs. Do not install
them on a different device, postmarketOS baseline or kernel.

TAS2557 proprietary firmware is not distributed by this project. The public
repository contains only a local package recipe and instructions for
extracting the matching file from a legally obtained stock image. The released
UCM package does not make the speaker operational without that separately
built local firmware package.

## Licensing

Original project documentation is Copyright 2026 Kostiantyn Andriiuk and is
licensed under
[Creative Commons Attribution-ShareAlike 4.0 International](LICENSE). Kernel
patches, package sources and files adapted from upstream projects retain their
own licenses and notices.

## Important

This is an unofficial community project for Xiaomi Redmi 5 Plus (`vince`).
Keep a backup and a working recovery path before installing experimental
packages.
