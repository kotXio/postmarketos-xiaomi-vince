#!/bin/sh
# SPDX-License-Identifier: GPL-2.0-only
set -eu

controller=${1:-./vince-fm-radio}
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' 0 HUP INT TERM

: >"$tmp/old-empty"
cat >"$tmp/found" <<'EOF'
87.8|FM 87.8 MHz
103.7|FM 103.7 MHz
EOF
sh "$controller" --internal-merge-stations \
    "$tmp/old-empty" "$tmp/found" "$tmp/merged-empty"
cmp "$tmp/found" "$tmp/merged-empty"

cat >"$tmp/old" <<'EOF'
87.8|Radio Culture
99.3|Old generic name
EOF
cat >"$tmp/found-updated" <<'EOF'
87.8|FM 87.8 MHz
103.7|FM 103.7 MHz
EOF
cat >"$tmp/expected-updated" <<'EOF'
87.8|Radio Culture
103.7|FM 103.7 MHz
EOF
sh "$controller" --internal-merge-stations \
    "$tmp/old" "$tmp/found-updated" "$tmp/merged-updated"
cmp "$tmp/expected-updated" "$tmp/merged-updated"

printf 'PASS: station merge handles an empty first-run list and preserves names.\n'
