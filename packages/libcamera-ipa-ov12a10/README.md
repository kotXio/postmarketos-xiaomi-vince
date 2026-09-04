# OV12A10 Simple IPA tuning

This data-only aport installs the tested libcamera Simple IPA tuning for the
rear OV12A10 sensor. Its only calibrated setting is:

```yaml
blackLevel: 4096
```

The change removed the severe lifted-black/colour-cast problem on the physical
phone. It does not claim complete per-unit colour, lens-shading or autofocus
calibration.

The tested package depends on exact `libcamera-ipa=99990.7.1-r0`. Recheck and
rebuild the tuning package when using a different postmarketOS/libcamera
baseline.
