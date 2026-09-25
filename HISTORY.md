# Project history

This chronology lists changes and investigations verified on the physical
handset. Reproduction details are linked where available.

## 2026-09-18 — LTR579 hardware variant

- Identified an LTR579 ambient-light/proximity sensor in a second Redmi 5 Plus
  while the first handset retains LTRF216A at the same I2C address.
- Added a separate `liteon,ltr579` binding and a polled 11-bit raw proximity
  channel to the existing `ltrf216a` driver.
- Temporary and persistent boots both registered `ltr579`; fifty passive far
  samples returned `3-4`, and the ambient-light path remained operational.
- Physical near/cover response, thresholds, interrupt routing and wake events
  remain open. The Device Tree change is optional because part ID `0xb1`
  cannot distinguish LTR579 from LTRF216A.
- See the [LTR579 variant guide](fixes/ltr579-proximity.md).

## 2026-09-15 — Front light, infrared and FM radio

- Added the front selfie light as a standard Linux `white:torch-1` LED. It also
  turns off automatically when the phone enters suspend.
- Added infrared transmission through Linux rc-core using fixed-rate SPI
  sampling. Compatibility with real appliances still needs to be checked.
- Added native V4L2 FM radio with tuning, seeking and stereo audio through
  wired headphones or the TAS2557 speaker. UCM `r3` provides the audio routes.
- Added a lightweight FM Radio application with full-band scanning, saved
  stations, volume and mute controls, and separate Plasma launchers for both
  outputs. The first scan found 19 local station candidates.
- Combined these additions with the existing hardware fixes in cumulative
  kernel `r16`.
- Source and reproduction details are in the
  [cumulative r16 guide](fixes/cumulative-r16.md).

## 2026-09-12 — Suspend/resume

Finally, after nearly two weeks of trying, failing, and a little crying,
suspend/resume works!

- Fixed the automatic reboot during resume and the touchscreen recovery path.
- The phone now sleeps and wakes with the power button, with the display and
  touch working normally.
- Overnight testing passed with normal battery behaviour.
- The cumulative `r13` kernel keeps the existing audio, camera, autofocus and
  torch fixes. See the [suspend/resume guide](fixes/suspend-resume.md).

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

- Added DW9763 lens control, movement and safe power-down parking.

## 2026-09-01 — OV12A10 modes

- Added five rear-camera sensor modes, including a conservative 1080p cap near
  `75 fps`.

## 2026-08-30 — RMI4 failed-suspend guard

- Reproduced an RMI4 F01 suspend write failure that could disable touch until
  reboot.
- Added a safety guard that preserves IRQ and regulator state when device
  suspend fails.
- Made the guard persistent after confirming that touch continued to work
  across normal boots.
- This was the first protective fix; the remaining suspend/resume problems
  were addressed in the [September 12 update](fixes/suspend-resume.md).

## 2026-08-29 — postmarketOS baseline and TAS2557 audio

- Established the postmarketOS `v26.06` Plasma Mobile baseline on `vince`.
- Enabled the TAS2557 bottom speaker with a conservative `-28 dB` output level.
- Identified the clean microphone path as
  `Mic2 -> INP3 -> ADC2 -> DEC1` and selected it for speaker and earpiece
  profiles with analog gain `8`.
