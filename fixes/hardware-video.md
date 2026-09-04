# Qt WebEngine hardware-video investigation

Status: direct userspace hardware decode verified; browser integration is not
available.

## What works

Qualcomm Venus is exposed as stateful V4L2 memory-to-memory devices. Direct
H.264 and HEVC 1080p encoding and decoding completed faster than real time
without Venus, IOMMU or kernel faults.

GStreamer `v4l2h264dec` opened the `qcom-venus` decoder on `/dev/video6`,
negotiated H.264 to NV12 DMA-BUF and delivered all 120 buffers from a fixed
fixture. It used `0.41 CPU-s` versus `4.27 CPU-s` for `openh264dec`, about
`10.4x` less CPU.

Paced FFmpeg `h264_v4l2m2m` independently selected `/dev/video6` and produced
all 120 frames. Its NV12 hashes matched the software decoder at `120/120`
positions. An unpaced raw Annex-B run emitted only 99 real frames, so pacing or
a different demux/container path is required before treating FFmpeg EOF counts
as correctness evidence.

The graphical user already has access to the video devices. Both codec devices
returned to runtime suspend after the tests, and the kernel error filter stayed
empty.

## Missing browser integration

The current Qt WebEngine/Chromium build reports software-only video decode and
no hardware codec profiles. It links FFmpeg and VA-API libraries, but the phone
has no Venus VA-API backend and the Qt build does not enable Chromium's Linux
V4L2 codec path.

Do not use `libva-v4l2-request` for this device: that bridge targets stateless
Request API decoders, while Venus here is a stateful decoder. Do not keep
`--no-sandbox` as a workaround.

The Linux V4L2, GStreamer, FFmpeg, Chromium, Qt WebEngine and Alpine sources
used for this investigation are linked from
[`SOURCES.md`](../SOURCES.md#angelfish-and-hardware-video). No custom browser
package has been produced yet.
