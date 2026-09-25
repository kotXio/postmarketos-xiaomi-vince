# Lightweight FM radio application

`postmarketos-vince-fm-radio` turns the native Vince FM receiver into a small
radio application for Plasma Mobile. It runs in QMLKonsole and adds:

- a full `87.5–108.0 MHz` scan in `100 kHz` steps;
- manual tuning and a persistent station list;
- next/previous station selection and custom station names;
- mute and output-volume controls;
- playback through wired headphones or the TAS2557 main speaker;
- separate Plasma launchers for both outputs;
- restoration of the previous HiFi audio state when the application exits.

The first full-band scan found 19 station candidates. This number depends on
location, reception conditions and the connected headphones, so it is not an
expected result for another user.

## Requirements

- cumulative Vince kernel `r16` or later with `radio-qcom-fm` version `0.4`;
- Vince UCM `r3` with the headphone and speaker FM profiles;
- wired headphones connected as the antenna, including speaker playback;
- membership of the Plasma user in the `video` group.

The package installs no service and makes no boot-time change. It does not
replace the kernel, firmware or UCM configuration.

## Install on an existing r16 system

Download the APK and the updated `SHA256SUMS` from
[`v2026.09.25-r16`](https://github.com/kotXio/postmarketos-xiaomi-vince/releases/tag/v2026.09.25-r16)
into the same directory. Verify only the application entry and preview the
package transaction:

```sh
grep '  postmarketos-vince-fm-radio-1.0.0-r1.apk$' SHA256SUMS | sha256sum -c -
sudo apk add --simulate --allow-untrusted \
  ./postmarketos-vince-fm-radio-1.0.0-r1.apk
```

Continue if nothing is removed and additions are limited to the FM application
and its declared Alpine dependencies. Repeat the command without `--simulate`;
no reboot is required. Then connect wired headphones and run this as the Plasma
user:

```sh
vince-fm-radio --check
```

## Use

Close qv4l2 and other applications that are recording or playing audio, then
open **FM Radio (Headphones)** or **FM Radio (Speaker)** from Plasma Mobile.
The same modes can be started from a terminal:

```sh
vince-fm-radio headphones
vince-fm-radio speaker
```

Press `h` for the command list, `s` to scan and `q` to stop the radio and
restore normal audio. Saved stations are ordinary UTF-8 text under
`~/.config/vince-fm-radio/stations`.

## Limits

- Headphones must stay connected because their cable is the FM antenna.
- The driver reports only service/no-service, not calibrated signal strength.
- RDS is unavailable, so scanned stations start with frequency-based names.
- The application will not take over while another audio stream or radio
  controller is active.
- `SIGKILL` or power loss cannot run audio cleanup; reboot before using normal
audio if either interrupts an active FM session.

Remove the package with `sudo apk del postmarketos-vince-fm-radio`. Saved
stations and volume preferences under `~/.config/vince-fm-radio` are left in
place and may be removed separately.

## Package and source

The `aarch64` reference package is
`postmarketos-vince-fm-radio-1.0.0-r1.apk`, SHA-256
`d86190e0666163fb381720af3ab0492541f37ad01a7a93433cc06a14da47c795`.
Its reproducible aport and licence are under
[`packages/postmarketos-vince-fm-radio`](../packages/postmarketos-vince-fm-radio/).
The APK is intended for the cumulative
[`v2026.09.25-r16`](../releases/v2026.09.25-r16.md) release because it depends
on that release's kernel and UCM support.
