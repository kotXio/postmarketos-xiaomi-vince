# LTR579 ambient light and raw proximity

Status: the driver binding, ambient-light path, passive far proximity readings
and an ordinary persistent reboot work on a second physical Redmi 5 Plus. A
physical near/cover transition is still untested.

## Hardware-variant problem

The generic Vince Device Tree describes the sensor at I2C address `0x53` as
`liteon,ltrf216a`. That is correct for the first project handset. Stock Android
on a second `MEE7` handset identifies the fitted part as `LTR579 ALSPS`.

The existing `ltrf216a` driver can read the LTR579 ambient-light register
family, but it exposes no proximity channel. Selecting the older `ltr501`
driver or a `liteon,ltr559` compatible is incorrect because that family uses a
different register map.

LTRF216A and LTR579 both report part ID `0xb1`. A runtime part-ID check cannot
safely select the correct behavior, so the exact Device Tree compatible must
come from board-specific evidence.

## Implementation

The optional [three-patch series](../patches/ltr579/README.md):

1. adds `liteon,ltr579` to the Device Tree binding;
2. adds an explicit LTR579 variant to `drivers/iio/light/ltrf216a.c`;
3. changes the confirmed handset's node from `liteon,ltrf216a` to
   `liteon,ltr579`.

The driver keeps existing LTR308/LTRF216A behavior unchanged. Only the
explicit LTR579 variant enables its proximity converter and adds
`IIO_PROXIMITY` with `IIO_CHAN_INFO_RAW`. Reads poll the data-ready bit and
return the sensor's 11-bit value. This first version does not configure an IRQ,
write proximity thresholds or apply stock calibration.

## Identification and safety

The two tested phones demonstrate why the Device Tree change cannot be
generic:

| Project handset | Stock sensor | eMMC observed locally | Compatible |
| --- | --- | --- | --- |
| first `vince` | LTRF216A | Samsung `S0J9F8` | `liteon,ltrf216a` |
| second `vince` | LTR579 | SK hynix `HCG8a4` | `liteon,ltr579` |

The eMMC correlation is only a guard for these exact phones. It does not prove
that every handset with either eMMC model has the same optical sensor. Before
using patch `0003`, confirm `LTR579` in the stock Android sensor inventory,
vendor Device Tree or equivalent trustworthy evidence.

Do not replace the compatible on a known LTRF216A phone. Test a newly built
kernel with `lk2nd` and `fastboot boot` first, keep a tested kernel-package
rollback, and install it persistently only after display, touch, storage and
sensor checks pass.

## Validation performed

The three patches passed strict checkpatch, an `ltrf216a.o` and Vince DTB build
with `W=1`, the binding check, and targeted Vince and Tissot `dtbs_check`.
The exact signed test package was
`linux-postmarketos-qcom-msm8953-7.0.9_p20260918164400-r0.apk`, size
`30,791,625` bytes, SHA-256
`99cab0ab31257eadc5d4c9fc52a5ed649efdc2975d10933bc33983c321ce0166`.
It is recorded for provenance but not published here because it also contains
the project's later private cumulative kernel work.

The temporary boot reached Plasma Mobile with working display and touch. The
module bound I2C `0-0053`, registered the IIO name `ltr579`, retained ambient
light, and exposed `in_proximity_raw`. Thirty passive samples stayed at `3-4`
for the far state. The package was then installed through the guarded package
path and passed an ordinary reboot. The module loaded automatically and twenty
more samples again returned `3-4`; ambient light was `0.150000000 lux` in the
dark test environment.

The regression inventory retained the expected cameras, autofocus, CAMSS,
Venus codec, TAS2557, Synaptics touch, motion sensors, magnetometer, FM, IR,
haptics, LEDs, Wi-Fi, Bluetooth, charging and storage nodes. KWin remained on
hardware-accelerated Freedreno FD506. No candidate-specific kernel oops, panic
or probe failure appeared.

Find the IIO node by name instead of assuming its device number:

```sh
for dev in /sys/bus/iio/devices/iio:device*; do
  test "$(cat "$dev/name" 2>/dev/null)" = ltr579 || continue
  cat "$dev/in_illuminance_input"
  cat "$dev/in_proximity_raw"
done
```

## Remaining work

- Perform repeated uncovered/covered/uncovered readings and confirm a clear,
  stable near/far separation before calling proximity physically working.
- Derive thresholds and hysteresis from measurements rather than copying the
  stock threshold `5` or handset calibration offset `27` blindly.
- Identify the interrupt GPIO before adding IIO events or wake support. The
  current polling path makes no interrupt-routing claim.
- Build and physically test a clean package based only on the published public
  series before providing a community binary Release.
- Decide how the device package should select the sensor variant. A universal
  `xiaomi-vince` DTB cannot choose safely from part ID `0xb1` alone.

## Rollback

Keep the previous kernel APK and a `/boot` backup before installation. Simulate
the one-package downgrade with `apk add --simulate`, verify that no unrelated
package changes, install the previous kernel package, and reboot. If the exact
previous package is unavailable, restore the matching postmarketOS image
instead of mixing kernel and module versions.
