# Project history

This chronology lists changes and investigations verified on the physical
handset. Reproduction details are linked where available.

## 2026-09-05 — OV12A10 one-shot autofocus

- Added standard libcamera Auto/Trigger/State controls for the Simple pipeline,
  a CPU SoftISP focus metric and a bounded two-stage contrast search.
- Updated Plasma Camera to trigger exactly one scan for each rear-camera
  session while leaving the front camera unchanged.
- Fixed two teardown races found through rapid rear-to-front switching: late
  lens callbacks and malformed delayed sensor controls.
- Verified repeatable focus, rear/front switching, saved photos, normal reboot,
  no new coredump, lens parking and full camera-device runtime suspend.
- Retained Plasma Camera's slow, timestamp-imperfect, no-audio encoded-video
  result as a separate application limitation.

## 2026-09-04 — Angelfish stability and Venus investigation

- Replaced the all-software `--disable-gpu` workaround with
  `--disable-gpu-rasterization --disable-webgl`.
- Testing confirmed responsive pages and smooth YouTube playback.
- Confirmed that Chromium still reports software video decode.
- Proved the Qualcomm Venus stateful V4L2 hardware path directly with H.264 and
  HEVC 1080p encode/decode tests.
- Proved GStreamer `v4l2h264dec` on `/dev/video6` with all 120 fixture frames;
  it used about `10.4x` less CPU than the `openh264dec` software control.
- Confirmed that paced FFmpeg `h264_v4l2m2m` selects `qcom-venus` and matches
  software-decoder output at all `120/120` frame hashes. Unpaced raw Annex-B
  input exposed a documented FFmpeg drain limitation.
- Documented the current
  [hardware-video integration limitation](fixes/hardware-video.md).

## 2026-09-02 — DW9763 manual focus

- Added and physically verified DW9763 lens control, movement and parking.

## 2026-09-01 — OV12A10 modes

- Added five tested rear-camera sensor modes, including a conservative 1080p
  cap near `75 fps`.

## 2026-08-30 — RMI4 failed-suspend guard

- Reproduced an RMI4 F01 suspend write failure that could disable touch until
  reboot.
- Added and temporarily tested a safety guard that preserves IRQ and regulator
  state when device suspend fails.
- Installed the tested guard persistently and verified it across normal boots.
- Continued diagnostics showed that the underlying intermittent I2C NACK and
  full suspend/resume failure remain unresolved.

## 2026-08-29 — postmarketOS baseline and TAS2557 audio

- Installed the postmarketOS `v26.06` Plasma Mobile baseline on `vince`.
- Enabled the TAS2557 bottom speaker and verified conservative `-28 dB` output.
- Identified the clean microphone path as
  `Mic2 -> INP3 -> ADC2 -> DEC1` and selected it for speaker and earpiece
  profiles with analog gain `8`.
