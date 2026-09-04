# OV12A10 rear camera

Status: preview, still capture and five modes physically verified.

## Problem

The rear OV12A10 sensor had no usable mainline driver on the tested baseline.
Initial images also showed lifted blacks and a strong colour cast, and stock
1080p timing near `90 fps` was not stable on this hardware path.

## Solution

Kernel patches [`0008` through `0011`](../patches/kernel/README.md#patch-order)
add the sensor, correct its crop/rotation metadata, add tested modes and cap
1080p near `75 fps`. The pmaports changes build and load the module. The
[`libcamera-ipa-ov12a10`](../packages/libcamera-ipa-ov12a10/README.md) package
sets the Simple IPA black level to `4096`.

## Verified modes

| Resolution | Verified maximum rate |
| --- | ---: |
| `4096x3072` | `30.34 fps` |
| `4096x2304` | `30.34 fps` |
| `2048x1536` | `60.06 fps` |
| `1920x1080` | `74.97 fps` |
| `1280x720` | about `120 fps` |

The driver reports a `4096x3072` active crop at `(8,8)` inside the native
`4112x3088` array and a `270°` rotation.

## Limitations

The tuning contains only the verified black-level correction, not a complete
per-unit colour or lens-shading calibration. DW9763 movement works separately,
but application-level continuous autofocus is not included.
