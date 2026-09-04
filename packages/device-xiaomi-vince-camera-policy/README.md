# Vince camera discovery policy

This aport disables only WirePlumber's libcamera monitor on `vince`. Plasma
Camera and command-line libcamera applications continue to use libcamera
directly, while idle PipeWire discovery no longer keeps the linked DW9763 lens
powered away from its parked position.

The trade-off is intentional: libcamera cameras are not exposed as PipeWire
camera sources while this policy is installed. Generic V4L2 nodes are not
disabled.

The policy passed rear/front Plasma preview and still capture, direct libcamera
access, lens parking and runtime-suspend checks.
