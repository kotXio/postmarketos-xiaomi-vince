# Kernel patch series

Target: [`msm8953-mainline/linux`](https://github.com/msm8953-mainline/linux),
branch `7.0.9/main`, base commit
`5be94b504b80d032481b90d533ee350ee13850f2` (`v7.0.9-r0`).

Apply the files in lexical order. Use `git am` for mail-formatted patches
`0001`-`0004` and `0010`-`0012`. Use `git apply --unidiff-zero` for plain
diffs `0005`-`0009`, then commit that group before continuing with `git am`.
The `--unidiff-zero` flag is required by the intentionally compact
zero-context TAS2557/RMI4 diffs. The mixed format preserves the original
upstream TAS2557 authorship and the exact locally tested changes.

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

## Test boundary

The cumulative kernel was temporarily booted through `lk2nd`/`fastboot` before
persistent installation. Speaker output, touch across normal boots, five rear
camera modes and bounded lens movement/parking were physically checked.

`0007` is a failed-suspend safety guard, not a complete suspend/resume fix.
`0012` exposes bounded manual focus; automatic-focus integration is not part of
this published set.
