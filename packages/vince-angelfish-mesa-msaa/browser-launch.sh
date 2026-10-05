#!/bin/sh
# Browser-private Mesa: no global loader, compositor or package replacement.
set -eu
[ "$(uname -m)" = aarch64 ] || { echo 'This build requires aarch64.' >&2; exit 1; }
prefix=/usr/lib/vince-angelfish-mesa-msaa
printf '%s\n' \
 'a952bf19d2b32f391f6cbfe301c1f5521a14f6cbfd2662fc0a7c9fe068089aad  /usr/lib/libgallium-26.1.6.so' \
 '9a78a4d1e08317915909fc14416cf3873da2fd497299177a21bcb9868789db42  /usr/lib/libQt6WebEngineCore.so.6.11.1' \
 '7fa82120c990cec1a03f7f392f65ade1f7b65e94dbbae39ed91d4dbe48f7789f  /usr/lib/vince-angelfish-mesa-msaa/lib/libgallium-26.1.6.so' \
 | sha256sum -c - >/dev/null
export LD_LIBRARY_PATH="$prefix/lib"
export FD_MESA_DEBUG=''
export QTWEBENGINE_CHROMIUM_FLAGS='--enable-features=AcceleratedVideoDecoder'
exec /usr/bin/angelfish "$@"
