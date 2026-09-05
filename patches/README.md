# Source patches

The public source is split by upstream target:

- [`kernel/`](kernel/README.md): Linux changes, in one cumulative order;
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
Published patch bytes are listed in [`SHA256SUMS`](SHA256SUMS).

Kernel patch `0014` and pmaports patch `0010` add the cumulative PMI8950 torch
`r7` update on top of the previously published autofocus `r4` state. They are
standalone diffs and apply with `git apply`.

The Qt WebEngine directory is independent of the kernel/pmaports series. Its
cumulative aport diff applies to the exact Alpine base recorded in
[`SOURCES.md`](../SOURCES.md#angelfish-and-hardware-video) and carries all six
source patches used by package `6.11.1-r10`.
