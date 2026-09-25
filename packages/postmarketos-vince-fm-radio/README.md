# Vince FM Radio

`postmarketos-vince-fm-radio` is a small terminal radio application for the
Xiaomi Redmi 5 Plus (`vince`) native V4L2 FM receiver. It integrates the GPL
`fmtools` tuner with the Vince UCM r3 routes and PulseAudio transport.

## Requirements

- Vince cumulative kernel r16 or later with `radio-qcom-fm` version `0.4`;
- Vince UCM r3 profiles;
- wired headphones connected as the antenna, including speaker playback;
- the Plasma user must be a member of the `video` group.

The package does not install a service and does not start at boot. Use either
Plasma launcher:

- **FM Radio (Headphones)**;
- **FM Radio (Speaker)**.

The same modes are available from a terminal:

```sh
vince-fm-radio headphones
vince-fm-radio speaker
```

Press `h` in the application for the command list. `s` scans the European
87.5–108.0 MHz band in 100 kHz steps and stores discovered frequencies under
`~/.config/vince-fm-radio/stations`. `q` exits the radio controller and restores
normal audio. QMLKonsole can remain at a shell prompt afterward and can be
closed separately.

## Signal limitation

Vince currently reports `VIDIOC_G_TUNER.signal` as a binary service indication:
`0` means no service and `0xffff` means service detected. Scan results are
therefore useful station candidates, but displayed percentages are not measured
RSSI and must not be interpreted as reception strength.

## Audio safety and restoration

The speaker launcher refuses to start unless `Speaker Playback Volume` is at
the accepted TAS2557 minimum (`values=0`, corresponding to the safe `-28 dB`
hardware setting). The program also refuses to take over while another capture
or playback stream is active.

At startup it records the active HiFi profile, default source and sink, their
volumes and mute states, and the complete ALSA mixer. On normal exit or a caught
signal it stops FM, restores the previous HiFi state and verifies that the ALSA
mixer is byte-identical. If restoration fails, diagnostics remain in the path
printed by the application.

An uncatchable process kill or power loss can bypass cleanup. In that case,
reboot before starting normal audio or run the known-good Vince audio rollback
procedure from the cumulative release documentation.

## Source and build

The aport downloads the official fmtools `2.0.8` archive and checks its SHA-512
digest before applying
[`0001-vince-fast-binary-service-scan.patch`](0001-vince-fast-binary-service-scan.patch).
The patch shortens scanning for Vince's binary service indication and makes the
scan mute state explicit. It does not replace the generic fmtools interface.

The remaining source files provide the Vince controller, two Plasma launchers
and an offline regression test for first-run station-list handling. Build the
package from this directory in an Alpine `aarch64` abuild environment:

```sh
abuild -r
```

The accepted package is
`postmarketos-vince-fm-radio-1.0.0-r1.apk`, SHA-256
`d86190e0666163fb381720af3ab0492541f37ad01a7a93433cc06a14da47c795`.
It is `26,916` bytes and installs no service or boot hook. The first full-band
scan on the reference phone found 19 location-dependent station candidates.

## Licensing

The built `fm` and `fmscan` programs derive from fmtools 2.0.8 by Ben Pfaff and
Russell Kroll, licensed under GPL version 2 or later. The Vince integration is
by Kostiantyn Andriiuk <konstantin@andriyuk.com> and is licensed under
GPL-2.0-only. The combined package is distributed under GPL-2.0-only and
installs the complete GPL text provided as [`LICENSE`](LICENSE).

Exact upstream links, release hashes and authorship are recorded in the
project-wide [`SOURCES.md`](../../SOURCES.md#fm-radio-application).
