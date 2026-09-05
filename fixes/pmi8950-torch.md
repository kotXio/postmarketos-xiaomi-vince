# PMI8950 dual-colour rear torch

Status: working through native Linux controls and the Plasma Mobile flashlight
quick setting, including after a normal reboot.

## Problem

The Redmi 5 Plus uses the legacy two-channel PMI8950 flash peripheral at SPMI
base `0xd300`, subtype `0x01`. The current mainline Qualcomm flash driver
supports newer three- and four-channel layouts and cannot bind this hardware.

## Solution

Kernel patch
[`0014-pmi8950-dual-color-torch.patch`](../patches/kernel/0014-pmi8950-dual-color-torch.patch)
adds a small continuous-torch-only backend and enables it only for `vince` with
a hard `50000 uA` per-channel Device Tree cap. It exposes one standard Linux
multicolor LED at `/sys/class/leds/white:torch`:

- `brightness=0..4` selects off or approximately
  `12.5/25/37.5/50 mA` per enabled channel;
- `multi_intensity` is ordered `[cool warm]`;
- `4 4` is balanced, `4 0` is cool-only and `0 4` is warm-only;
- Plasma Mobile can use the ordinary `white:torch` interface without a custom
  application or service.

The driver retains the applicable PMI8950 thermal derating, VPH-droop,
headroom, current-ramp, clamp and fault handling. Any observed I/O error or
fault, suspend, shutdown or driver removal takes the fail-closed off path.

## Tested

The torch works in Plasma Mobile and through standard Linux LED controls. Both
LEDs, all four brightness levels and separate cool/warm controls were tested.
It switches off cleanly and continues to work after reboot.

## Compatibility and boundary

The binary is an incremental update for the exact postmarketOS `v26.06`
`v2026.09.05-autofocus` baseline documented in
[`packages/README.md`](../packages/README.md). Always verify checksums and the
simulated APK transaction before installation.

This implementation provides continuous torch only. High-current photo flash,
V4L2 flash controls and sensor-synchronised strobe are deliberately excluded
and deferred. The project does not claim this local legacy backend is ready for
upstream inclusion unchanged.
