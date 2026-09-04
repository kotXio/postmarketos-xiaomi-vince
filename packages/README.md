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

## Tested binary release

Release
[`v2026.09.04`](https://github.com/kotXio/postmarketos-xiaomi-vince/releases/tag/v2026.09.04)
contains these physically tested public packages:

| Package | Purpose |
| --- | --- |
| `linux-postmarketos-qcom-msm8953-7.0.9_p20260902163513-r3.apk` | Cumulative kernel. |
| `device-qcom-msm8953-13-r2.apk` | Matching MSM8953 device package. |
| `device-qcom-msm8953-udev-13-r2.apk` | Matching udev subpackage. |
| `device-xiaomi-vince-camera-policy-1-r0.apk` | Vince-only WirePlumber camera policy. |
| `libcamera-ipa-ov12a10-1.0-r0.apk` | OV12A10 Simple IPA tuning. |
| `alsa-ucm-conf-xiaomi-vince-tas2557-1.0-r1.apk` | TAS2557 speaker and Mic2 UCM profile. |

Exact compatibility:

- Xiaomi Redmi 5 Plus (`xiaomi,vince`), `aarch64`;
- postmarketOS `v26.06`, tested with Plasma Mobile;
- Linux runtime ABI `7.0.9-msm8953`;
- kernel and pmaports bases pinned in [`../SOURCES.md`](../SOURCES.md);
- exact `libcamera-ipa=99990.7.1-r0` for the tuning package.

The project handset originally used the postmarketOS `v26.06` core packages
`linux-postmarketos-qcom-msm8953-7.0.9-r0`,
`device-qcom-msm8953-13-r0`, `device-qcom-msm8953-udev-13-r0` and
`soc-qcom-msm8953-ucm-19-r0`. It reached the released cumulative set through
controlled incremental installs. A complete one-shot installation has not
been repeated on a second handset, so always run the simulated transaction
first.

## Before installation

Keep a working recovery path and obtain copies of the exact kernel, device,
udev and MSM8953 UCM APK versions currently installed. They are required for
rollback and are not included in this Release. If the installed baseline
differs from the versions above, do not continue without rebuilding or
reviewing the packages.

Download all six APKs and `SHA256SUMS` from the Release into one empty
directory, then verify the downloaded bytes:

```sh
sha256sum -c SHA256SUMS
```

Confirm the device before installing anything:

```sh
tr '\0' '\n' < /sys/firmware/devicetree/base/compatible | grep -Fx xiaomi,vince
uname -m
uname -r
```

The expected output includes `xiaomi,vince`, `aarch64` and
`7.0.9-msm8953`.

## Manual installation

First build and verify the local proprietary
[`firmware-xiaomi-vince-tas2557-local`](firmware-xiaomi-vince-tas2557-local/README.md)
APK. Set `firmware_apk` to its absolute path. The firmware APK is installed in
the same transaction but is not a public Release asset.

Simulate the complete transaction:

```sh
firmware_apk=/absolute/path/to/firmware-xiaomi-vince-tas2557-local-11.0.2.0-r0.apk

sudo apk add --simulate --allow-untrusted \
  ./linux-postmarketos-qcom-msm8953-7.0.9_p20260902163513-r3.apk \
  ./device-qcom-msm8953-13-r2.apk \
  ./device-qcom-msm8953-udev-13-r2.apk \
  ./device-xiaomi-vince-camera-policy-1-r0.apk \
  ./libcamera-ipa-ov12a10-1.0-r0.apk \
  ./alsa-ucm-conf-xiaomi-vince-tas2557-1.0-r1.apk \
  "$firmware_apk"
```

Review the proposed package changes. If the simulation is clean, repeat the
same command without `--simulate`, verify the installed package versions, and
reboot. `--allow-untrusted` is necessary because these are locally signed
builds; it is safe only after the attached checksums have passed.

## Manual rollback

Use the exact pre-install APKs saved from your own baseline. For the documented
stock `v26.06` starting point they are:

- `linux-postmarketos-qcom-msm8953-7.0.9-r0.apk`;
- `device-qcom-msm8953-13-r0.apk`;
- `device-qcom-msm8953-udev-13-r0.apk`;
- `soc-qcom-msm8953-ucm-19-r0.apk`.

Simulate removal of the added packages, repair of the stock UCM provider and
installation of the three saved core APKs before performing the corresponding
real operations. Run each command below once with `--simulate` immediately
after `fix`, `del` or `add`; review all proposed changes before running it
without that option. A complete rollback follows this order:

```sh
sudo apk fix --allow-untrusted --force-overwrite \
  ./rollback/soc-qcom-msm8953-ucm-19-r0.apk

sudo apk del \
  alsa-ucm-conf-xiaomi-vince-tas2557 \
  firmware-xiaomi-vince-tas2557-local \
  device-xiaomi-vince-camera-policy \
  libcamera-ipa-ov12a10

sudo apk fix --allow-untrusted --force-overwrite \
  ./rollback/soc-qcom-msm8953-ucm-19-r0.apk

sudo apk add --allow-untrusted \
  ./rollback/linux-postmarketos-qcom-msm8953-7.0.9-r0.apk \
  ./rollback/device-qcom-msm8953-13-r0.apk \
  ./rollback/device-qcom-msm8953-udev-13-r0.apk

sudo reboot
```

Omit an added package from `apk del` if it was not installed. If the phone can
no longer boot normally, use the recovery path and saved packages rather than
attempting a partial live rollback.
