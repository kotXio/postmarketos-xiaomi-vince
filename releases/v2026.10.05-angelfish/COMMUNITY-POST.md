# Angelfish GPU/WebGL fix for Redmi 5 Plus

Angelfish now works with GPU rasterization and WebGL1/2 enabled on our two
Redmi 5 Plus phones running postmarketOS `v26.06`. The hangs came from Mesa's
Freedreno driver counting MSAA samples twice when sizing depth/stencil
buffers. A small correction fixes that calculation and removes the need
for the old disabling flags.

The source patches and package recipe are included, alongside Qt WebEngine
`6.11.1-r10` for Venus hardware H.264 decoding.

Project: [postmarketos-xiaomi-vince](https://github.com/kotXio/postmarketos-xiaomi-vince).
