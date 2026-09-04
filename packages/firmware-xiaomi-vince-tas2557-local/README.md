# Local TAS2557 firmware package

The TAS2557 requires board-specific speaker-protection firmware. The aport
recipe is distributable, but its input `tas2557_uCDSP.bin` and the resulting
APK are proprietary local artifacts and must not be redistributed.

The stock build, extraction manifest and mirror provenance are recorded in
[`SOURCES.md`](../../SOURCES.md#tas2557-speaker-and-ucm).

Neither artifact is included in public Release
[`v2026.09.04`](https://github.com/kotXio/postmarketos-xiaomi-vince/releases/tag/v2026.09.04).
Build and verify this local package before installing the released TAS2557 UCM
profile; the UCM package alone cannot make the speaker operational.

## Required stock source

Use the matching Xiaomi stock build:

```text
vince-user 8.1.0 OPM1.171019.019 V11.0.2.0.OEGMIXM release-keys
```

The file is `vendor/firmware/tas2557_uCDSP.bin`, or
`/firmware/tas2557_uCDSP.bin` inside an extracted `vendor.img` filesystem.
For an Android sparse ext4 image, convert it with `simg2img` and extract the
file read-only with `debugfs`:

```sh
simg2img vendor.img vendor.raw.img
debugfs -R 'dump /firmware/tas2557_uCDSP.bin tas2557_uCDSP.bin' vendor.raw.img
```

If `vendor.img` is already raw ext4, use it directly with `debugfs`. Obtain the
stock image legally yourself; do not substitute firmware from another phone,
even if it also contains a TAS2557.

## Verify before building

```text
size      24165 bytes
SHA-256   199bff6abc81e17cfec65d04022f9db5fa6341694fa017fd389fe078157aa5e3
SHA-512   a82024742252fcd3c64aa3e93296b1c3f505a360f5e151705f27ad4fc82f064d3dea50d1dc183ad542df01a730989461a2b86e9a37eefd370d897a5858133467
magic     35 35 35 32 (ASCII `5552`)
```

Place the verified file beside `APKBUILD` only in a private pmaports/build
tree. Build `firmware-xiaomi-vince-tas2557-local` locally and do not commit or
redistribute the firmware file or resulting APK.
