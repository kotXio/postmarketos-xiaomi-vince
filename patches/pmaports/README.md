# pmaports patch series

Target: [`postmarketOS/pmaports`](https://gitlab.postmarketos.org/postmarketOS/pmaports),
branch `v26.06`, base commit
`2b7f90ea7c2ae4d42ae187dc0b528dc163767b04`.

Apply the files in lexical order. Use `git apply --unidiff-zero` for plain
diffs `0001`-`0004`, then commit that group before applying mail-formatted
patches `0005`-`0007` with `git am`. Apply plain diffs `0008`-`0009` with
`git apply`.
The patch order mirrors the tested cumulative packages.

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

`0002` is build-parity configuration, not part of the RMI4 diagnosis and not a
device fix by itself. The same package sources are also available as standalone
directories under [`packages/`](../../packages/).

`0009` depends on the separately built Vince libcamera/IPA `99991.7.1-r3`
packages. Its `242..726` interval is specific to the test handset.
