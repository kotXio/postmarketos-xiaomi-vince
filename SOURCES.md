# Sources and provenance

This file pins the source set used for the physically tested handset. Upstream
authorship is preserved, and project-authored mail patches use
`Kostiantyn Andriiuk <konstantin@andriyuk.com>`.

## Linux

- Repository: <https://github.com/msm8953-mainline/linux>
- Branch: `7.0.9/main`
- Base/tag: `5be94b504b80d032481b90d533ee350ee13850f2`
  (`v7.0.9-r0`)

The first four TAS2557 patches preserve Gianluca Boiano's authorship and come
from immutable commits in
[`msm8953-mainline/linux#252`](https://github.com/msm8953-mainline/linux/pull/252):

1. `43261695e3f7584d84fb714476fdcfed6721d8d4`
2. `7b74e5ed9ea296bf9a6e632aaf0c3ed95c56f876`
3. `aa59117667a1291c486802987dce3e6c7954bc57`
4. `67526b7ad6eac87dac859eb6ff0de143f2231abe`

Local tested changes after those commits are published as ordered patch files:

| Change | Patch |
| --- | --- |
| TAS2557 I2C `400 kHz` | [`0005`](patches/kernel/0005-vince-tas2557-i2c-400khz.patch) |
| TAS2557 VBAT supply | [`0006`](patches/kernel/0006-vince-tas2557-vbat-supply.patch) |
| RMI4 failed-suspend guard | [`0007`](patches/kernel/0007-rmi4-suspend-error-guard.patch) |
| OV12A10 driver and modes | [`0008`-`0011`](patches/kernel/README.md#patch-order) |
| DW9763 lens control | [`0012`](patches/kernel/0012-dw9763-series.patch) |

## postmarketOS packaging

- pmaports repository: <https://gitlab.postmarketos.org/postmarketOS/pmaports>
- Branch: `v26.06`
- Base: `2b7f90ea7c2ae4d42ae187dc0b528dc163767b04`
- pmbootstrap: tag `3.11.1`, commit
  `130b89d3c391596a1de9c12997b228b1e8a1f692`

The matching ordered pmaports changes are documented in
[`patches/pmaports`](patches/pmaports/README.md).

## Proprietary input

TAS2557 speaker-protection firmware came from Xiaomi stock build
`V11.0.2.0.OEGMIXM`. It is identified only by the verification data in the
[local firmware recipe](packages/firmware-xiaomi-vince-tas2557-local/README.md).
The blob and any APK containing it are not distributed here.
