# TAS2557 UCM profile

This aport installs the physically verified Xiaomi Redmi 5 Plus (`vince`)
speaker and microphone profile without modifying the UCM file shared by other
MSM8953 devices.

The tested configuration uses:

- TAS2557 Speaker on Quinary MI2S;
- conservative `Speaker Playback Volume=0` (`-28 dB`);
- `Mic2 -> INP3 -> ADC2 -> DEC1`;
- analog `ADC2 Volume=8` and digital capture volume `100%`.

Copy this directory to
`device/community/alsa-ucm-conf-xiaomi-vince-tas2557` in the pinned pmaports
tree, then build it with pmbootstrap.

The profile requires the locally built firmware package described in
[`../firmware-xiaomi-vince-tas2557-local`](../firmware-xiaomi-vince-tas2557-local/README.md).
The firmware binary is not part of this repository and must not be
redistributed.
