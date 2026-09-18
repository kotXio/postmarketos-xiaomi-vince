# Optional LTR579 patch series

Target: [`msm8953-mainline/linux`](https://github.com/msm8953-mainline/linux),
branch `7.0.9/main`, base commit
`5be94b504b80d032481b90d533ee350ee13850f2` (`v7.0.9-r0`).

This is a separate, optional series for a Redmi 5 Plus hardware variant whose
stock Android sensor inventory identifies the device at I2C address `0x53` as
an LTR579. It is deliberately excluded from the generic cumulative `vince`
series because another tested handset has an LTRF216A at the same address.

Both parts report ID `0xb1`, so the kernel cannot distinguish them from that
register alone. Apply the Device Tree patch only after confirming LTR579 from
stock sensor information or equally strong board-specific evidence. The eMMC
models observed on the two project handsets are useful local guards, not a
universal sensor-identification rule.

## Patch order

| Patch | Purpose |
| --- | --- |
| `0001` | Add the `liteon,ltr579` binding and optional secondary I/O supply. |
| `0002` | Add an LTR579 variant to `ltrf216a` with ambient light and polled 11-bit raw proximity. |
| `0003` | Select `liteon,ltr579` in the Vince Device Tree for a confirmed LTR579 handset. |

The first two patches are driver infrastructure. The third is a board choice
and must not be placed in an image intended for every `vince` handset.

Apply the files in lexical order, either to the pinned base or after the
current public `patches/kernel/` series:

```sh
for patch in patches/ltr579/*.patch; do
  git -C linux-vince apply --check "$patch" || exit 1
  git -C linux-vince apply "$patch" || exit 1
done
```

Build and boot the resulting kernel temporarily before installing its package.
The physically tested package used a larger private cumulative baseline, so
this repository does not publish that binary as a clean LTR579 release.

See the [test result and limitations](../../fixes/ltr579-proximity.md).
