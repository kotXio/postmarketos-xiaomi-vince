# Plasma Camera one-shot autofocus build

This aport rebuilds Plasma Camera `2.1.1` against the matching Vince libcamera
packages. The patch submits `AfModeAuto` and exactly one `AfTriggerStart` at
the beginning of a rear-camera session when the controls are advertised.

The trigger is cleared after the first request, is not sent again for every
frame and is never sent for the front OV5675 camera. Contrast search and lens
movement remain in libcamera and the kernel actuator driver.

See the [application patch](../../patches/plasma-camera/README.md) and
[autofocus guide](../../fixes/ov12a10-autofocus.md).
