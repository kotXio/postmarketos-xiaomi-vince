# Freedreno MSAA fix

The Mesa `26.1.6` correction fixes Angelfish hangs during GPU rasterization
and WebGL on Adreno 506. Depth/stencil resource sizes already include the MSAA
sample count; `gmem_key_init()` multiplied it a second time and could request
a tile that would never fit in GMEM.

Apply the two patches from the Mesa source root, in this order:

```sh
git apply /path/to/23575.patch
git apply /path/to/0001-freedreno-count-zs-samples-once.patch
```

`23575.patch` is Alpine's unchanged Rockchip EBC patch by Diederik de Haas.
The Freedreno correction is by Kostiantyn Andriiuk
<konstantin@andriyuk.com> and preserves Mesa's MIT license.

The corrected library passed GPU rasterization, WebGL1/2 MSAA rendering and
scrolling on two Vince phones. The [package recipe](../../packages/vince-angelfish-mesa-msaa/README.md)
builds and packages it for Angelfish. See the
[browser guide](../../fixes/angelfish-rendering.md) and
[source credits](../../SOURCES.md#freedreno-msaa-fix).
