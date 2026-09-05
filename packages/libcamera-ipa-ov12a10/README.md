# OV12A10 Simple IPA tuning

This data-only aport installs the tested libcamera Simple IPA tuning for the
rear OV12A10 sensor. It retains the black-level correction:

```yaml
blackLevel: 4096
```

It also supplies the bounded one-shot autofocus policy for the project's
patched Simple IPA. The tested actuator interval is `242..726`, with coarse
step `48`, fine step `8`, two settling frames and the median of three valid
metric frames.

The black-level change removed the severe lifted-black/colour-cast problem on
the physical phone. The AF policy produced repeatable focus and clean lens
parking on the same handset.

The stock pedestal and libcamera representation used to derive `4096` are
documented in [`SOURCES.md`](../../SOURCES.md#ipa-and-camera-policy). Autofocus
design and provenance are recorded separately under
[OV12A10 one-shot autofocus](../../SOURCES.md#ov12a10-one-shot-autofocus).

The tested package depends on exact `libcamera-ipa=99991.7.1-r3`. Recheck and
rebuild the tuning package when using a different postmarketOS/libcamera
baseline.

The derived endpoints are specific to the checksum-valid Sunny module EEPROM
on the test handset. They are not a universal calibration for every `vince`;
raw EEPROM data is not published. See the
[autofocus guide](../../fixes/ov12a10-autofocus.md) for the exact boundary.

The exact tested APK is included in Release
[`v2026.09.05-autofocus`](https://github.com/kotXio/postmarketos-xiaomi-vince/releases/tag/v2026.09.05-autofocus).
See the [package index](../README.md) for compatibility, installation and
rollback information.
