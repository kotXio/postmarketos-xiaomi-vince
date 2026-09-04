# RMI4 failed-suspend touch guard

Status: guard verified and installed; complete suspend/resume fix unresolved.

## Problem

During `s2idle`, an RMI4 F01 I2C write can fail with `-ENXIO`. The old error
path then disabled the touch IRQ and supplies even though device suspend had
failed. The phone could wake with the power button while touch remained dead.

## Verified guard

The guard preserves the IRQ and regulators when an RMI function fails to
suspend. A controlled `pm_test=devices` run reproduced the original failure
while touch remained responsive. The same guard was then packaged and verified
across normal persistent boots.

The matched upstream issue and exact RMI4 source files are recorded in
[`SOURCES.md`](../SOURCES.md#rmi4-touch-guard). The guard itself is
project-authored rather than copied from another patch.

## Limitations

The guard does not eliminate the underlying intermittent E700 I2C NACK, repair
an initial probe failure or make full suspend reliable. The implemented safety
change is
[`0007-rmi4-suspend-error-guard.patch`](../patches/kernel/0007-rmi4-suspend-error-guard.patch).
