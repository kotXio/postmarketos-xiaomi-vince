# TAS2557 and FM UCM profiles

This aport installs the physically verified Xiaomi Redmi 5 Plus (`vince`)
speaker and microphone profile without modifying the UCM file shared by other
MSM8953 devices. Revision `r3` also adds the physically tested native FM
capture route.

Its upstream UCM lineage and local changes are documented in
[`SOURCES.md`](../../SOURCES.md#tas2557-speaker-and-ucm).

The tested configuration uses:

- TAS2557 Speaker on Quinary MI2S;
- conservative `Speaker Playback Volume=0` (`-28 dB`);
- `Mic2 -> INP3 -> ADC2 -> DEC1`;
- analog `ADC2 Volume=8` and digital capture volume `100%`.
- exclusive FM capture through `INTERNAL_FM_TX`, 48 kHz stereo;
- explicit FM output profiles for wired headphones and the TAS2557 speaker.

Copy this directory to
`device/community/alsa-ucm-conf-xiaomi-vince-tas2557` in the pinned pmaports
tree, then build it with pmbootstrap.

The profile requires the locally built firmware package described in
[`../firmware-xiaomi-vince-tas2557-local`](../firmware-xiaomi-vince-tas2557-local/README.md).
The firmware binary is not part of this repository and must not be
redistributed.

The exact tested `r3` UCM APK is included in Release `v2026.09.25-r16`.
Install it only with the verified local firmware package and the matching
kernel/device set described in the [package index](../README.md). FM controls
and module integration are documented under
[`config/vince-fm`](../../config/vince-fm/README.md).
