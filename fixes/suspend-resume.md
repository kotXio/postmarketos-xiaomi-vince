# Suspend/resume and touch recovery

The Redmi 5 Plus now enters suspend-to-idle and wakes with the power button,
with the display and touchscreen working normally. Overnight testing passed
with normal battery behaviour on the test phone.

## What changed

Two separate problems were involved: the touchscreen controller could become
temporarily unavailable during sleep transitions, and the charger driver
could trigger a reboot by writing an unnecessary initial USB role.

The update adds Vince-only reset-aware RMI4 recovery and applies the detected
USB role once when the role-switch handle is first acquired. Touch recovery
retries only resume-time target NACKs, every `20 ms` within a shared `200 ms`
limit. The earlier [failed-suspend guard](rmi4-touch-guard.md) remains in place.

No extra daemon, sleep-policy override or global asynchronous-PM workaround
is needed. The cumulative `r13` kernel keeps the earlier audio, camera,
autofocus and torch improvements.

## Install

Use the [release instructions](../releases/v2026.09.12-suspend.md) for the
`aarch64` postmarketOS `v26.06` / `7.0.9-msm8953` stack. This is a kernel-only
update over the previous public torch setup; it does not replace the audio
or camera userspace packages.

## Notes

Wi-Fi can take tens of seconds to reconnect after wake. Recoverable RMI4 I2C
warnings can still appear in the log, although the touchscreen works.
The tested sleep state is `s2idle`, not deep suspend-to-RAM.

## Source

- [RMI4 system-sleep recovery](../patches/kernel/0015-rmi4-system-sleep-recovery.patch)
- [SMBCHG USB-role acquisition](../patches/kernel/0016-smbchg-usb-role-acquisition.patch)
- [Kernel package update](../patches/pmaports/0011-package-suspend-kernel-r13.patch)
- [Source credits](../SOURCES.md#suspendresume)
