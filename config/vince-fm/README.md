# Native FM integration

These three files accompany cumulative kernel `r16` and UCM profile `r3`:

- `vince-fm.conf` loads the receive-only native FM module at boot;
- `90-vince-fm.rules` gives the active desktop user access to `/dev/radio0`;
- `vince-fm.desktop` opens the unmodified qv4l2 tuner and mute controls.

There is no automatic tuning, playback or background service. Wired headphones
must remain connected as the antenna even when audio is sent to the main
speaker. qv4l2 controls reception; the FM UCM profile provides the separate
48 kHz stereo audio path. Select `FM (FM, Headphones)` or
`FM (FM, Speaker)` and route the FM source to the matching output; qv4l2 does
not start an audio stream itself.

The separate
[`postmarketos-vince-fm-radio`](../../packages/postmarketos-vince-fm-radio/)
package automates tuning and audio routing and provides dedicated headphone
and speaker launchers. The qv4l2 launcher remains useful for lower-level
receiver control.

The files are also attached individually to the matching GitHub Release so
users do not need this repository checkout during installation.
