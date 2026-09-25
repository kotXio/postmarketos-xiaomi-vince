# Cumulative kernel r16

Kernel `r16` combines the previously published Vince hardware work with three
additional hardware features:

- the front selfie light appears as the standard binary LED
  `white:torch-1`;
- the built-in infrared transmitter uses Linux rc-core and fixed-rate SPI
  sampling;
- the Qualcomm FM receiver appears as `/dev/radio0`, with qv4l2 controls
  and a matching 48 kHz stereo UCM route.

The front light supports only the stock-derived on/off mode. Its driver IC,
current and independent hardware cutoff are not characterized, and it is not
connected to camera exposure control.

Infrared transmission works, but compatibility with real appliances has not
yet been checked. Carrier accuracy, optical power and current remain unknown.

FM supports tuning, seeking, stereo reception and audio through wired
headphones or the TAS2557 speaker. Wired headphones remain the antenna. qv4l2
is an engineering control panel rather than a complete radio player, so
receiver control and audio routing remain separate.

The exact package recipe and all 43 ordered patches are under
[`packages/linux-postmarketos-qcom-msm8953-r16`](../packages/linux-postmarketos-qcom-msm8953-r16/).
External code and reference sources are listed in
[`SOURCES.md`](../SOURCES.md#cumulative-r16-front-light-infrared-and-fm).

The release also updates the TAS2557 UCM profile, adds qv4l2 and includes three
small FM configuration files. Compatibility, checksums, installation and
rollback instructions are in the
[`r16` release notes](../releases/v2026.09.25-r16.md).
