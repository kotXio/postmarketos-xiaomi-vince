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
- RMI4 failed-suspend safety guard. This protects touch after one known suspend
  error path; it is not a complete suspend/resume fix.
- Stable Angelfish launcher workaround that keeps GPU composition and Canvas
  while disabling the two unstable Chromium paths.

## Known gaps

- Qt WebEngine does not use the working Qualcomm Venus hardware decoder.
- Suspend/resume is not reliable, although the RMI4 guard protects touch after
  one known failure path.
- Rear-camera autofocus is not integrated with libcamera or Plasma Mobile.
- The Hall sensor and SIM-dependent telephony/GPS paths remain unverified.

## Releases

No pre-built APK release is currently available. The reproducible package
sources and patches are included in this repository. Do not install packages
built for a different device, postmarketOS baseline or kernel.

TAS2557 proprietary firmware is not distributed by this project. The public
repository contains only a local package recipe and instructions for
extracting the matching file from a legally obtained stock image.

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
