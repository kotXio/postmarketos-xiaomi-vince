# OV12A10 Simple IPA tuning

This data-only aport installs the tested libcamera Simple IPA tuning for the
rear OV12A10 sensor. Its only calibrated setting is:

```yaml
blackLevel: 4096
```

The change removed the severe lifted-black/colour-cast problem on the physical
phone. It does not claim complete per-unit colour, lens-shading or autofocus
calibration.

The stock pedestal and libcamera representation used to derive `4096` are
documented in [`SOURCES.md`](../../SOURCES.md#ipa-and-camera-policy).

The tested package depends on exact `libcamera-ipa=99990.7.1-r0`. Recheck and
rebuild the tuning package when using a different postmarketOS/libcamera
baseline.

The exact tested APK is included in Release
[`v2026.09.04`](https://github.com/kotXio/postmarketos-xiaomi-vince/releases/tag/v2026.09.04).
See the [package index](../README.md) for the matching kernel/device set,
installation and rollback instructions.
