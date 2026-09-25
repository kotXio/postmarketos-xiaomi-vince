# Cumulative r16 kernel source

This is the exact source recipe for the physically tested
`linux-postmarketos-qcom-msm8953-7.0.9_p20260914105626-r16.apk` package.
It targets Xiaomi Redmi 5 Plus (`xiaomi,vince`), `aarch64`, postmarketOS
`v26.06` and the pinned MSM8953 Linux `v7.0.9-r0` source.

The directory contains:

- the complete 43-patch cumulative kernel series in build order;
- the exact kernel configuration;
- the APKBUILD used for the accepted package;
- hashes of all changed source files after patch application.

Copy this directory to
`device/community/linux-postmarketos-qcom-msm8953` in a matching pmaports tree
and build it with pmbootstrap. Rebuilds can differ in timestamps, signatures
and package hashes even when the resulting source tree is identical.

The first four TAS2557 patches and patches `0038`-`0040` retain their original
upstream authors. Project-authored patches use
`Kostiantyn Andriiuk <konstantin@andriyuk.com>`. Detailed code provenance and
reference links are in [`SOURCES.md`](../../SOURCES.md).

Do not install this package on another device or kernel baseline. Test a new
build temporarily before replacing a working kernel.
