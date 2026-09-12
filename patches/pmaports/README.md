# pmaports patch series

Target: [`postmarketOS/pmaports`](https://gitlab.postmarketos.org/postmarketOS/pmaports),
branch `v26.06`, base commit
`2b7f90ea7c2ae4d42ae187dc0b528dc163767b04`.

Apply files `0001`-`0011` in lexical order with `git apply --unidiff-zero`.
The order mirrors the cumulative packages; see the
[build instructions](../BUILDING.md).

| Patch | Purpose |
| --- | --- |
| `0001` | Enable TAS2557 in the MSM8953 kernel package. |
| `0002` | Preserve `CONFIG_PM_DEBUG` from the tested build baseline. |
| `0003` | Build OV12A10 as a module. |
| `0004` | Include and load OV12A10 for `xiaomi,vince` in initramfs. |
| `0005` | Build/load DW9763 and package the media-controller lens link. |
| `0006` | Add the `vince`-only WirePlumber camera discovery policy. |
| `0007` | Add the OV12A10 Simple IPA data package. |
| `0008` | Package the handset-tested autofocus kernel as `pkgrel=4`. |
| `0009` | Update the OV12A10 data aport for the exact patched IPA and AF policy. |
| `0010` | Package the cumulative PMI8950 torch kernel as `pkgrel=7` with built-in multicolor LED support. |
| `0011` | Package the cumulative suspend/resume kernel as `pkgrel=13` and remove the forced `PM_DEBUG` setting. |

`0002` preserves the earlier build configuration; `0011` removes that debug
setting for the final suspend/resume kernel. It is not a device fix by itself.
The same package sources are also available as standalone
directories under [`packages/`](../../packages/).

`0009` depends on the separately built Vince libcamera/IPA `99991.7.1-r3`
packages. Its `242..726` interval is specific to the test handset.

`0010` is the incremental kernel-only update for the exact published autofocus
baseline. It does not change the libcamera, Plasma Camera, IPA, UCM or private
firmware packages.

`0011` is a kernel-only update over that `r7` source. Apply it with kernel
patches `0015` and `0016`; it needs no additional sleep service or power-policy
configuration.
