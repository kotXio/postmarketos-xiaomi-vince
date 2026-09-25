# Build the cumulative Vince kernel

For the exact tested `r16` package, use the self-contained recipe under
[`packages/linux-postmarketos-qcom-msm8953-r16`](../packages/linux-postmarketos-qcom-msm8953-r16/README.md).
It includes the pinned configuration, changed-source manifest and all 43
patches in the order used by the accepted APK.

The steps below reproduce the shorter patch series used by the earlier public
releases.

Use an ARM64 Linux host or VM with four CPUs and about `8 GiB` RAM,
pmbootstrap `3.11.1` and postmarketOS `v26.06`. Keep the sources on a Linux
filesystem. Run the following from the extracted source archive or this
repository's root.

## Get the pinned sources

```sh
sources_dir=$PWD
git clone https://github.com/msm8953-mainline/linux.git linux-vince
git -C linux-vince checkout 5be94b504b80d032481b90d533ee350ee13850f2
git clone https://gitlab.postmarketos.org/postmarketOS/pmaports.git pmaports-vince
git -C pmaports-vince checkout 2b7f90ea7c2ae4d42ae187dc0b528dc163767b04
```

## Apply patches in order

```sh
for patch in "$sources_dir"/patches/kernel/*.patch; do
  git -C linux-vince apply --unidiff-zero "$patch" || exit 1
done
for patch in "$sources_dir"/patches/pmaports/*.patch; do
  git -C pmaports-vince apply --unidiff-zero "$patch" || exit 1
done
```

For a handset independently confirmed to contain LTR579, apply the optional
series after the generic kernel series:

```sh
for patch in "$sources_dir"/patches/ltr579/*.patch; do
  git -C linux-vince apply --check "$patch" || exit 1
  git -C linux-vince apply "$patch" || exit 1
done
```

Do not apply that optional Device Tree change to an LTRF216A handset. Use a
unique local package version so it cannot be mistaken for the generic `r13`
build, and test it through `lk2nd`/`fastboot boot` before installation.

Use either the complete numbered series or the three new suspend patches on
an already-patched `r7` source tree, not both. Patch purposes are listed under
[kernel](kernel/README.md) and [pmaports](pmaports/README.md).

## Build

```sh
pmbootstrap -p "$sources_dir/pmaports-vince" init
```

Choose `v26.06` and `xiaomi-vince`, then build only the kernel:

```sh
pmbootstrap -p "$sources_dir/pmaports-vince" -j4 --no-ccache \
  build --force --src "$sources_dir/linux-vince" \
  linux-postmarketos-qcom-msm8953
```

Without the optional variant series, the recipe produces revision `r13`.
Rebuild timestamps and APK checksums can differ from the released file. Test a
new build temporarily before installing it permanently. Proprietary TAS2557
firmware is not needed to compile the kernel and is not included in the source
archive.

See [source credits](../SOURCES.md) and
[installation instructions](../releases/v2026.09.12-suspend.md).
