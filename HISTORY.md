# Project history

This chronology lists changes and investigations verified on the physical
handset. Reproduction details are linked where available.

## 2026-09-05 — Angelfish hardware video through Venus

- Added hardware video decoding to Angelfish through Qualcomm Venus using the
  patched Qt WebEngine `6.11.1-r10`.
- YouTube playback is smooth and used about half as much CPU as software
  decoding in a comparison test.
- Extended fullscreen playback remained visually normal. Two automatic Venus
  firmware recoveries appeared in the system log, so long-session stability is
  still being monitored.

## 2026-09-05 — PMI8950 dual-colour rear torch

- Enabled the rear torch in Plasma Mobile and through standard Linux LED
  controls.
- Added four brightness levels and separate control of the cool and warm LEDs,
  with a safe `50 mA` per-channel limit.
- Photo flash and camera-synchronised strobe support remain future work.

## 2026-09-05 — OV12A10 one-shot autofocus

- Added one-shot autofocus for the OV12A10 rear camera in libcamera and Plasma
  Camera.
- Fixed two shutdown races found while rapidly switching between the rear and
  front cameras.
- Autofocus, camera switching, saved photos and safe lens parking now work on
  the test phone.
- Plasma Camera video recording remains slow and has no audio; direct libcamera
  capture is unaffected.

## 2026-09-04 — Angelfish stability and Venus investigation

- Replaced the all-software `--disable-gpu` workaround with
  `--disable-gpu-rasterization --disable-webgl`.
- Pages became responsive again and YouTube played smoothly, although the
  browser was still decoding video in software.
- Direct H.264 and HEVC tests confirmed that the Qualcomm Venus hardware codec
  was working outside the browser.
- GStreamer hardware decoding used about one tenth of the CPU required by the
  software decoder. FFmpeg produced matching output when the input was paced.
- Documented the remaining browser-integration work, which led to the
  [Qt WebEngine update](fixes/hardware-video.md) the following day.

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
