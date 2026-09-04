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

The exposed focus control is bounded to `0..517`, step `1`, with default
position `214`. The tested actuator setup uses AAC mode `5`, timing `0x38` and
prescaler `1`.

The optional
[`device-xiaomi-vince-camera-policy`](../packages/device-xiaomi-vince-camera-policy/README.md)
package prevents idle WirePlumber discovery from keeping the linked lens
powered away from its parked state. Direct libcamera and Plasma Camera access
remain available.

The adapted mainline DW9768 base and statically recovered DW9763 inputs are
credited in [`SOURCES.md`](../SOURCES.md#dw9763-lens); the WirePlumber policy
references are recorded under [IPA and camera policy](../SOURCES.md#ipa-and-camera-policy).

## Limitations

The values are safe tested bounds, not calibrated near/far endpoints for every
handset. Manual movement and parking are supported; autofocus integration is
not implemented.
