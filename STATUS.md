# Device status

Last updated: 2026-09-05

Test device: Xiaomi Redmi 5 Plus (`vince`), `aarch64`, postmarketOS `v26.06`,
Plasma Mobile, Linux `7.0.9-msm8953` with locally packaged cumulative changes.

This table reports observations from one physical handset. It is not a promise
that the same package will work on another release or package baseline.

| Area | Status | Notes |
| --- | --- | --- |
| Boot and Plasma Mobile | Working | Normal persistent boot verified repeatedly. |
| Display and GPU | Working | Adreno 506 uses Mesa Freedreno hardware rendering. |
| Touch | Partial | Works normally and is protected from one failed-suspend path; full suspend reliability remains unresolved. |
| Wi-Fi | Working | Used for SSH and normal browsing. |
| Bluetooth | Working | Physical device connection verified. |
| Main TAS2557 speaker | Working | Physically verified at conservative `-28 dB` hardware gain. |
| Earpiece | Working | Physically verified. |
| Microphone | Working | Clean Mic2 route uses ADC2 analog gain `8` and digital level `100%`. |
| Front camera OV5675 | Working | Live image and still capture physically verified. |
| Rear camera OV12A10 | Working | Preview/capture, five sensor modes and one-shot autofocus verified. |
| Rear lens DW9763 | Working with limitation | One-shot contrast AF, manual movement, parking and runtime suspend work; the tested `242..726` endpoints are handset-local. |
| Video codec Venus | Partial | Direct stateful V4L2 H.264/HEVC works; GStreamer and paced FFmpeg H.264 hardware-decode tests pass, but Qt WebEngine still uses software decoding. |
| Plasma Camera video | Partial | Direct RAW and processed libcamera capture works at the expected rate. Only the Plasma Camera/Qt Multimedia recording path was slow: the tested file averaged about `4.12 fps`, had timestamp defects and no audio. |
| Angelfish | Working with workaround | Stable with GPU rasterization and WebGL disabled; GPU composition and Canvas remain enabled. |
| Auto-rotation | Working | Physically verified. |
| Vibration | Working | Physically verified. |
| microSD | Working | Mounting and file reading were physically verified. |
| Hall sensor | Unverified | Linux exposes `SW_LID`, but a physical state transition has not been verified. |
| Suspend/resume | Not working reliably | Intermittent RMI4/I2C failures remain unresolved; the safety guard prevents one failed-suspend path from disabling touch. |
| IR transmitter | Not enabled | Xiaomi specifications confirm the emitter; exact PWM/GPIO wiring for Linux is unresolved. |
| Fingerprint | Not working | Not enabled. |
| Proximity sensor | Not working | Not enabled. |
| Camera flash | Not working | Not enabled. |
| Calls, SMS, mobile data, GPS | Unverified | Not tested without an active SIM. |

## Status vocabulary

- **Working:** physically verified on the test handset.
- **Working with workaround:** usable, with a documented limitation.
- **Partial:** a useful hardware path works, but integration or reliability is
  incomplete.
- **Unverified:** exposed or expected, but not yet physically proven.
- **Not working:** currently unavailable or known to fail.
