# TAS2557 speaker and clean microphone

Status: physically verified; source and local firmware recipe available.

## Problem

The bottom TAS2557 loudspeaker did not produce sound on the original
postmarketOS baseline. Early microphone tests also selected a noisy path and
incorrectly attributed gain changes to ADC3.

## Solution summary

- Enable the board TAS2557 path in the kernel/device configuration.
- Provide the matching locally extracted `tas2557_uCDSP.bin` through a private
  local firmware package.
- Add a `vince`-specific UCM profile for the speaker and microphone routes.
- Use the physically tested conservative speaker hardware gain of `-28 dB`.
- Select `Mic2 -> INP3 -> ADC2 -> DEC1` with `ADC2 Volume=8` and digital source
  volume `100%` for both speaker and earpiece profiles.

## Result

Physical testing confirmed clean speaker output at the tested level and clean
Mic2 recordings without the digital noise heard on other routes.

Source commits, the adapted UCM profile, hardware references and private
firmware provenance are listed in
[`SOURCES.md`](../SOURCES.md#tas2557-speaker-and-ucm).

## Reproduce

Apply kernel patches
[`0001` through `0006`](../patches/kernel/README.md#patch-order), then build the
matching pmaports changes and the public
[`alsa-ucm-conf-xiaomi-vince-tas2557`](../packages/alsa-ucm-conf-xiaomi-vince-tas2557/README.md)
source. Build the firmware package locally from the separately obtained stock
file by following
[`firmware-xiaomi-vince-tas2557-local`](../packages/firmware-xiaomi-vince-tas2557-local/README.md).

Test an experimental kernel through `lk2nd`/`fastboot boot` before installing
it persistently. Begin speaker validation at the documented `-28 dB` hardware
gain and a low-amplitude waveform; do not infer a safe amplifier setting from
another MSM8953 phone.

## Firmware redistribution

The stock firmware blob and any APK containing it are proprietary local
artifacts and must not be redistributed.
