# Package sources

This directory contains the reviewed Alpine/postmarketOS package source used
by the tested device configuration:

- [`alsa-ucm-conf-xiaomi-vince-tas2557`](alsa-ucm-conf-xiaomi-vince-tas2557/README.md);
- [`firmware-xiaomi-vince-tas2557-local`](firmware-xiaomi-vince-tas2557-local/README.md);
- [`libcamera-ipa-ov12a10`](libcamera-ipa-ov12a10/README.md);
- [`device-xiaomi-vince-camera-policy`](device-xiaomi-vince-camera-policy/README.md).

Compiled APKs are not stored in this repository. Package compatibility is tied
to the exact device and postmarketOS baseline documented by each source.

The TAS2557 firmware package is the special case: its proprietary blob must be
extracted from a legally obtained stock image and built locally. Neither the
blob nor the resulting APK may be redistributed.
