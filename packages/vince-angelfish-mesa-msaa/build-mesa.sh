#!/bin/sh
# SPDX-License-Identifier: MIT
# Copyright (c) 2026 Kostiantyn Andriiuk <konstantin@andriyuk.com>
# Run only in a disposable native Alpine3.24 aarch64 build environment.
# Dependencies: build-base bash binutils python3 meson ninja pkgconf bison flex
# py3-mako py3-packaging py3-yaml py3-ply py3-cparser libdrm-dev expat-dev zlib-dev
# zstd-dev elfutils-dev eudev-dev wayland-dev wayland-protocols libx11-dev
# libxrandr-dev libxdamage-dev libxfixes-dev libxshmfence-dev libxxf86vm-dev
# xorgproto patch file.
set -eu
umask 022
export LC_ALL=C SOURCE_DATE_EPOCH=0
[ "$(uname -m)" = aarch64 ]
archive=${1:?Verified Mesa archive required}
out=${2:?New absolute output directory required}
case "$out" in /*) ;; *) echo 'Output must be absolute' >&2;exit 1;; esac
[ ! -e "$out" ]
base=$(CDPATH='' cd -- "$(dirname -- "$0")/../.." && pwd)
echo '5296b88a0f1e012e2cb9ada150a2bbadf728ca81e5a4fb2ab43c83a4d2158606  '"$archive" | sha256sum -c -
mkdir "$out" "$out/source" "$out/stage"
source_dir=$out/source
build_dir=$out/output
stage=$out/stage
export CFLAGS='-Os -O2 -g1 -fstack-clash-protection -Wformat -Werror=format-security -ffile-prefix-map=/build=/usr/src/vince-mesa-msaa-fix'
export CXXFLAGS="$CFLAGS" CPPFLAGS='-O2 -g1'
tar -xJf "$archive" -C "$source_dir" --strip-components=1
echo '06429b39963ce6618fd04e955fc3596f02d918537c1074a20d1ff281a8f35c83  '"$source_dir/src/gallium/drivers/freedreno/freedreno_gmem.c" | sha256sum -c -
(cd "$source_dir" && patch --fuzz=0 -p1 < "$base/patches/mesa/23575.patch")
(cd "$source_dir" && patch --fuzz=0 -p1 < "$base/patches/mesa/0001-freedreno-count-zs-samples-once.patch")
meson setup "$build_dir" "$source_dir" --prefix=/usr --libdir=lib \
--buildtype=release --wrap-mode=nofallback \
-Db_ndebug=true -Db_lto=false -Dbackend_max_links=1 \
-Dallow-kcmp=enabled -Dexpat=enabled -Dshader-cache=enabled \
-Dxlib-lease=enabled -Dxmlconfig=enabled -Dzstd=enabled \
-Dbuild-tests=false -Ddri-drivers-path=/usr/lib/dri \
-Dgallium-drivers=freedreno -Dvulkan-drivers= -Dvulkan-layers= \
-Dfreedreno-kmds=msm,virtio -Dplatforms=x11,wayland \
-Dllvm=disabled -Dshared-llvm=disabled -Ddraw-use-llvm=false \
-Dgbm=enabled -Dglx=dri -Dglvnd=disabled -Dopengl=true \
-Dgles1=enabled -Dgles2=enabled -Degl=enabled \
-Dgallium-extra-hud=true -Dgallium-rusticl=false \
-Dgallium-va=disabled -Dvideo-codecs= -Dtools= \
-Dmesa-clc=auto -Dprecomp-compiler=auto \
-Dspirv-tools=disabled -Dlibunwind=disabled \
> "$out/meson-setup.log" 2>&1
meson configure "$build_dir" > "$out/meson-configure.txt"
ninja -C "$build_dir" -j3 > "$out/ninja.log" 2>&1
DESTDIR="$stage" meson install -C "$build_dir" --no-rebuild \
> "$out/install.log" 2>&1
sha256sum "$stage/usr/lib/libgallium-26.1.6.so"
