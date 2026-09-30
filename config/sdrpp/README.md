# SDR++ phone-sized profile

These optional settings use a narrow, maximized window, a `190`-pixel menu,
a `16384`-point FFT and a waterfall target of `15` updates per second.
The starting mode is WFM at `100 MHz`, with audio muted and volume at `20%`.
Choose a local station and unmute when ready.

With SDR++ closed, copy the three JSON files from this directory to
`~/.config/sdrpp/` **only if that directory does not already exist**. Keep an
existing profile and adjust its settings in the app instead. From this
directory:

```sh
if test ! -e "$HOME/.config/sdrpp"; then
    mkdir -p "$HOME/.config/sdrpp"
    cp config.json radio_config.json audio_sink_config.json "$HOME/.config/sdrpp/"
else
    printf '%s\n' 'Existing SDR++ profile left unchanged.'
fi
```

The receiver configuration is deliberately not included: choose your own
device in the app, set `2.4 MS/s` and enable tuner AGC. Leave the bias tee off
unless your antenna setup specifically needs it.

Use one of SDR++'s supported UI scales (`1`, `2`, `3` or `4`); fractional
values such as `1.15` cause this version to fail at startup. This profile
uses `1`.

The settings were selected by Kostiantyn Andriiuk
<konstantin@andriyuk.com> using SDR++'s existing configuration format and
defaults. They are provided under GPL-3.0-only, with the
[SDR++ source licence](../../packages/sdrpp-vince/licenses/GPL-3.0.txt).
See the [installation and usage guide](../../fixes/sdrpp.md).
