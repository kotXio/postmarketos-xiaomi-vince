#!/bin/sh
# SPDX-License-Identifier: MIT
# Read-only net battery telemetry. The optional path is for offline fixtures.
set -eu

battery_path=${1:-/sys/class/power_supply/qcom-battery}
IFS= read -r voltage < "$battery_path/voltage_now"
IFS= read -r current < "$battery_path/current_now"
IFS= read -r capacity < "$battery_path/capacity"

case "$voltage" in ''|*[!0-9]*) exit 1 ;; esac
case "${current#-}" in ''|*[!0-9]*) exit 1 ;; esac
case "$capacity" in ''|*[!0-9]*) exit 1 ;; esac

temperature=null
if test -r "$battery_path/temp" && IFS= read -r battery_temperature < "$battery_path/temp"; then
    case "${battery_temperature#-}" in
        ''|*[!0-9]*) ;;
        *) temperature=$battery_temperature ;;
    esac
fi

# power_supply/temp is in tenths of a degree Celsius.
printf '{"voltage":%s,"current":%s,"capacity":%s,"temperature":%s}\n' \
    "$voltage" "$current" "$capacity" "$temperature"
