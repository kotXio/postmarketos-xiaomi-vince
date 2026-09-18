# Source patches

The public source is split by upstream target:

- [`kernel/`](kernel/README.md): Linux changes, in one cumulative order;
- [`ltr579/`](ltr579/README.md): optional sensor-driver and Device Tree
  changes for a separately identified LTR579 handset variant;
- [`pmaports/`](pmaports/README.md): matching kernel-package, device and data
  package changes;
- [`libcamera/`](libcamera/README.md): Simple-pipeline one-shot autofocus and
  teardown guards;
- [`plasma-camera/`](plasma-camera/README.md): one rear-session autofocus
  trigger in Plasma Camera;
- [`qtwebengine/`](qtwebengine/README.md): Qt WebEngine/Chromium stateful V4L2
  hardware-video integration for Qualcomm Venus.

Apply each numbered directory in lexical order against the base recorded in
[`SOURCES.md`](../SOURCES.md). The series represents the physically tested
configuration, not a claim that every patch is ready for upstream acceptance.
Patch checksums are listed in [`SHA256SUMS`](SHA256SUMS).
For the cumulative kernel, follow the [build instructions](BUILDING.md).

The LTR579 series is not part of the generic cumulative kernel. Both tested
optical-sensor variants report part ID `0xb1`, so its Device Tree patch must be
used only after confirming the fitted sensor independently. See the
[LTR579 guide](../fixes/ltr579-proximity.md).

Kernel patch `0014` and pmaports patch `0010` add the cumulative PMI8950 torch
`r7` update on top of the previously published autofocus `r4` state. They are
standalone diffs and apply with `git apply`.

Kernel patches `0015`-`0016` and pmaports patch `0011` add the cumulative
suspend/resume `r13` update after that `r7` state. They are mail-formatted
standalone patches; use the same `git apply --unidiff-zero` command as the
earlier patches. Do not apply a second cumulative
kernel series on top. See [suspend/resume](../fixes/suspend-resume.md).

The Qt WebEngine directory is independent of the kernel/pmaports series. Its
cumulative aport diff applies to the exact Alpine base recorded in
[`SOURCES.md`](../SOURCES.md#angelfish-and-hardware-video) and carries all six
source patches used by package `6.11.1-r10`.
