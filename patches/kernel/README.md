# Kernel patch series

Target: [`msm8953-mainline/linux`](https://github.com/msm8953-mainline/linux),
branch `7.0.9/main`, base commit
`5be94b504b80d032481b90d533ee350ee13850f2` (`v7.0.9-r0`).

This directory is the concise cumulative series through the public `r13`
release. For the exact `r16` build order, configuration and APKBUILD, use
[`packages/linux-postmarketos-qcom-msm8953-r16`](../../packages/linux-postmarketos-qcom-msm8953-r16/README.md).

Apply files `0001`-`0016` in lexical order with `git apply --unidiff-zero` when
reproducing the earlier concise series.
That command accepts both the mail-formatted patches and compact plain diffs;
the original authorship remains recorded in the patch files. See the
[build instructions](../BUILDING.md) for a complete source-build example.

## Patch order

| Patch | Purpose |
| --- | --- |
| `0001` | TAS2557 Device Tree binding. |
| `0002` | TAS2557 ASoC codec driver. |
| `0003` | Enable TAS2557 in the MSM8953 defconfig. |
| `0004` | Add the TAS2557 speaker to the `vince` Device Tree. |
| `0005` | Run the amplifier's I2C bus at the tested `400 kHz`. |
| `0006` | Connect TAS2557 `vbat-supply` to `vph_pwr`. |
| `0007` | Preserve RMI4 IRQ/regulator state when suspend fails. |
| `0008` | Add the OV12A10 sensor driver and initial `vince` wiring. |
| `0009` | Report the real sensor crop and correct the rotation. |
| `0010` | Add the physically tested stock sensor modes. |
| `0011` | Cap unstable 1080p `90 fps` mode near `75 fps`. |
| `0012` | Add DW9763-compatible lens control and link it to OV12A10. |
| `0013` | Extend the DW9763 maximum to this handset's tested macro endpoint `726`. |
| `0014` | Add the legacy PMI8950 continuous dual-colour torch with a Vince-only `50 mA` per-channel cap. |
| `0015` | Add Vince-only reset-aware RMI4 recovery for system sleep. |
| `0016` | Avoid the unnecessary initial USB-role transition that caused a reboot during resume. |

## Test boundary

The cumulative kernel was temporarily booted through `lk2nd`/`fastboot` before
persistent installation. Speaker output, touch across normal boots, five rear
camera modes and bounded lens movement/parking were physically checked.

`0007` is the earlier failed-suspend safety guard. Patches `0015` and `0016`
complete the working [suspend/resume update](../../fixes/suspend-resume.md).
`0013` is required by the separately published one-shot autofocus stack. Its
maximum came from one checksum-valid handset EEPROM and is not claimed to be a
universal calibration for every `vince`.

`0014` exposes four global brightness levels and separate cool/warm intensity
through one standard `white:torch` multicolor LED. It is physically verified
on the test handset. Photo flash and V4L2/sensor strobe support are deliberately
not part of the patch.

The cumulative `r13` kernel passed Power-button wake. Overnight use of the
suspend/resume fix also passed with normal battery behaviour. Recoverable
RMI4 warnings and delayed Wi-Fi
reconnection can still occur. Project-authored patches `0015` and `0016` use
`Kostiantyn Andriiuk <konstantin@andriyuk.com>`; source credits are in
[`SOURCES.md`](../../SOURCES.md#suspendresume).
