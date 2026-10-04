# Vince Battery widget

A small, transparent Plasma Mobile home-screen widget for battery voltage,
signed net current and battery temperature. Its vertical battery icon follows
the reported charge level. Positive current means the battery is charging;
negative current means it is discharging. The widget updates every five seconds
while visible and stops polling when the screen is off or locked.

Version `1.2` was tested on a Xiaomi Redmi 5 Plus (`vince`) running
postmarketOS `v26.06` and Plasma Mobile `6.6.6`.

## Install

Download or clone this repository onto the phone. From its root directory,
run this as your normal Plasma user:

```sh
kpackagetool6 --type Plasma/Applet --install ./widgets/vince-battery/package
```

On the Plasma Mobile home screen, hold an empty area, open **Widgets**, find
**Vince Battery**, and drag it to a free space. If an older version is already
installed, use `--upgrade` instead of `--install` in the command above. If the
old appearance remains cached after an upgrade, log out and back in.

This widget expects readable `voltage_now`, `current_now`, `capacity` and
optional `temp` files under `/sys/class/power_supply/qcom-battery/`, plus
Plasma5Support's executable data engine and the standard `timeout` command.
Unavailable readings show `—`.

## Remove

Remove the widget from the home screen, then run as the same user:

```sh
kpackagetool6 --type Plasma/Applet --remove org.kostik.vince.batterytelemetry
```

## Source

The [widget source](package/) is [MIT-licensed](LICENSE). To run the
[offline tests](tests/telemetry.test.cjs) with Node.js from the repository root:

```sh
node widgets/vince-battery/tests/telemetry.test.cjs
```

See [sources and credits](../../SOURCES.md#plasma-mobile-battery-widget) for
the references used.
