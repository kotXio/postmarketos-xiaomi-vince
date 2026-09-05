# DW9763 bounded manual focus

Status: movement and power-down parking physically verified.

## Problem

The OV12A10 module's DW9763 voice-coil actuator was not described or supported
by the tested mainline stack, leaving the rear lens at a fixed position.

## Solution

Kernel patch [`0012-dw9763-series.patch`](../patches/kernel/0012-dw9763-series.patch)
adds the compatible binding/driver path, the `0x0c` Device Tree node, the
`2.85 V` VAF supply and the media-controller link to OV12A10. The matching
[pmaports patch](../patches/pmaports/0005-enable-dw9763-on-vince.patch) builds
and loads `dw9768`, the shared driver module.

The first conservative stage exposed `0..517`, step `1`, with default position
`214`. The later [one-shot autofocus work](ov12a10-autofocus.md) raised the
kernel maximum to the test handset's checksum-validated macro endpoint `726`.
The actuator setup uses AAC mode `5`, timing `0x38` and prescaler `1`.

The optional
[`device-xiaomi-vince-camera-policy`](../packages/device-xiaomi-vince-camera-policy/README.md)
package prevents idle WirePlumber discovery from keeping the linked lens
powered away from its parked state. Direct libcamera and Plasma Camera access
remain available.

The adapted mainline DW9768 base and statically recovered DW9763 inputs are
credited in [`SOURCES.md`](../SOURCES.md#dw9763-lens); the WirePlumber policy
references are recorded under [IPA and camera policy](../SOURCES.md#ipa-and-camera-policy).

## Limitations

The `242..726` autofocus interval is physically verified only on the test
handset and is not calibrated near/far distance for every phone. Manual
movement, one-shot autofocus and parking work; continuous AF and calibrated
manual distance do not.
