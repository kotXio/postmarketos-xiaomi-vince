# RMI4 failed-suspend touch guard

This earlier safety guard is retained in the cumulative kernel. Working
suspend/resume is covered by the [later update](suspend-resume.md).

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

The guard alone did not fix complete suspend/resume or an initial probe
failure. The later update adds reset-aware touch recovery and fixes the
automatic reboot during resume. The original safety change is
[`0007-rmi4-suspend-error-guard.patch`](../patches/kernel/0007-rmi4-suspend-error-guard.patch).
