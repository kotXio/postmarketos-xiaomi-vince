# SDR++ with a USB RTL-SDR receiver

SDR++ runs natively on Vince and turns an external RTL-SDR dongle into a
portable radio receiver. The spectrum and waterfall work, touch controls work
under Wayland, and radio audio plays through the phone. This uses the USB
receiver, not Vince's built-in FM radio.

The `1.3.0_git20260704-r3` package adds touch support, starts reception from
the app icon and releases the receiver when the window closes. Its private
GLFW library leaves the system GLFW library unchanged.

## Requirements

- Xiaomi Redmi 5 Plus (`vince`), `aarch64`, postmarketOS `v26.06` with
  Alpine `3.24` packages and Plasma Mobile's Wayland session.
- A USB OTG adapter, an RTL-SDR receiver and an appropriate antenna. The
  tested receiver is a Realtek RTL2838UHIDIR (`0bda:2838`) with an R820T tuner.
- USB access for your normal desktop account; see the setup below.

The handset tests used Linux `7.0.9-msm8953` with cumulative kernel `r17`.
SDR++ reads samples directly through `librtlsdr` and libusb; it does not use
`/dev/swradio0` or require the DVB driver. This application package does not
install a kernel. It was not separately retested on the public `r16` kernel.

## Install

Download `sdrpp-vince-1.3.0_git20260704-r3.apk` and `SHA256SUMS` from the
[SDR++ release](https://github.com/kotXio/postmarketos-xiaomi-vince/releases/tag/v2026.09.30-sdrpp)
into the same directory. Check the file and preview installation:

```sh
grep '  sdrpp-vince-1.3.0_git20260704-r3.apk$' SHA256SUMS | sha256sum -c -
sudo apk add --simulate --allow-untrusted \
  ./sdrpp-vince-1.3.0_git20260704-r3.apk librtlsdr-udev
```

The package uses the distribution's FFTW, VOLK, RtAudio and RTL-SDR libraries.
Continue if the transaction changes only SDR++ and its dependencies, without
removing unrelated packages. Repeat without `--simulate` to install. No reboot
or firmware installation is needed. `--allow-untrusted` is used because this
is a community package, not a distribution-signed APK.

The `librtlsdr-udev` package grants receiver access to the `plugdev` group.
Check your account with `id -nG`. If `plugdev` is missing, run this from your
normal desktop account, then log out and back in:

```sh
sudo addgroup "$(id -un)" plugdev
```

Reconnect the receiver after installing the rules. Run SDR++ as your normal
user, not as root.

## First launch

The optional [phone-sized profile](../config/sdrpp/README.md) gives the app a
narrow layout and a modest waterfall update rate. It does not overwrite an
existing profile or select someone else's receiver.

For initial setup, run `sdrpp` from a terminal without `--autostart`. In
**Source**, choose **RTL-SDR**, select your receiver, use `2.4 MS/s` and enable
tuner AGC. Choose **WFM** in **Radio** and tune a local FM broadcast station.
Press Play, unmute the Radio stream and start with low volume.

After setup, the normal SDR++ icon starts reception automatically. Close the
window normally to release the receiver. If a forced termination leaves the
USB receiver busy, unplug and reconnect it. Do not use a DVB application and
SDR++ on the same receiver at the same time.

## Included modules

The package contains 14 modules: RTL-SDR source, audio output, Radio,
Frequency Manager, Recorder, Scanner, ATV, DAB, KG-SSTV, M17, Meteor,
Pager, VOR and Weather Satellite. Extra modules can be added as instances
from SDR++'s Module Manager; they are not all enabled in the default profile.

For this phone, the profile uses a `16384`-point FFT and `15` waterfall
updates per second. VOLK can also choose DSP implementations for the local
CPU. The short calibration used on Vince was:

```sh
volk_profile -i 100 -w 100
```

Run it as your desktop user with SDR++ closed. It saves its choices under
`~/.volk`; do not copy another phone's calibration file. Active reception
also powers the USB dongle, so expect higher battery use than ordinary idle.

## Remove

Close SDR++, then run `sudo apk del sdrpp-vince`. Your settings and recordings
are kept. If replacing an older SDR++ package, save its APK before upgrading
so you can reinstall that version if needed.

The [package recipe and four patches](../packages/sdrpp-vince/README.md)
describe the build. [Sources and credits](../SOURCES.md#sdr-with-a-usb-receiver)
identify the upstream projects and the older SDR++ code reused here.
