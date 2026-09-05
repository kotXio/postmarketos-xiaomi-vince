# postmarketOS on Xiaomi Redmi 5 Plus (`vince`)

Unofficial, reproducible fixes and hardware-enablement work for the Xiaomi
Redmi 5 Plus, device codename `vince`, running postmarketOS.

Official device information:
[Xiaomi Redmi 5 Plus (`xiaomi-vince`) on the postmarketOS wiki](https://wiki.postmarketos.org/wiki/Xiaomi_Redmi_5_Plus_%28xiaomi-vince%29).

This is a small DIY pet project, not a postmarketOS fork or an official
postmarketOS repository. The aim is to make one real phone more useful while
leaving enough evidence, source and rollback information for another owner to
repeat the work safely.

## At a glance

- [Current hardware and software status](STATUS.md)
- [Chronological project history](HISTORY.md)
- [Verified fixes and experiments](fixes/README.md)
- [Package sources](packages/README.md)
- [Kernel and pmaports patch series](patches/README.md)
- [Pinned source revisions and provenance](SOURCES.md)

## Verified improvements

- TAS2557 bottom speaker with a conservative, physically tested `-28 dB`
  hardware gain.
- Clean default microphone route: `Mic2 -> INP3 -> ADC2 -> DEC1`, analog
  `ADC2 Volume=8`, digital source volume `100%`.
- OV12A10 rear camera support with five tested sensor modes.
- DW9763 lens movement, parking and bounded manual-focus control.
- Rear one-shot contrast autofocus integrated with libcamera and Plasma
  Camera, including rapid-switch teardown guards.
- RMI4 failed-suspend safety guard. This protects touch after one known suspend
  error path; it is not a complete suspend/resume fix.
- Stable Angelfish launcher workaround that keeps GPU composition and Canvas
  while disabling the two unstable Chromium paths.

## Known gaps

- Qt WebEngine does not use the working Qualcomm Venus hardware decoder.
- Suspend/resume is not reliable, although the RMI4 guard protects touch after
  one known failure path.
- Autofocus is one-shot at rear-camera session start; continuous AF,
  touch-to-focus and calibrated focus distance are not implemented.
- Plasma Camera encoded video remains slow and timestamp-imperfect and has no
  audio on the tested stack; this is separate from the working autofocus path.
- The Hall sensor and SIM-dependent telephony/GPS paths remain unverified.

## Releases

The base physically tested binary set is available as
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

Read the exact compatibility, checksum, manual installation and rollback
instructions in [`packages/README.md`](packages/README.md) before using the
APKs. Do not install them on a different device, postmarketOS baseline or
kernel.

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
