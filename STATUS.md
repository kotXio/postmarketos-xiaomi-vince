# Device status

Last updated: 2026-09-12

Test device: Xiaomi Redmi 5 Plus (`vince`), `aarch64`, postmarketOS `v26.06`,
Plasma Mobile, Linux `7.0.9-msm8953`, cumulative kernel package
`7.0.9_p20260912095627-r13`.

This table reports observations from one physical handset. It is not a promise
that the same package will work on another release or package baseline.

| Area | Status | Notes |
| --- | --- | --- |
| Boot and Plasma Mobile | Working | Normal persistent boot verified repeatedly. |
| Display and GPU | Working | Adreno 506 uses Mesa Freedreno hardware rendering. |
| Touch | Working | Works normally and after waking from suspend. |
| Wi-Fi | Working | Normal browsing works; reconnection after suspend can take tens of seconds. |
| Bluetooth | Working | Physical device connection verified. |
| Main TAS2557 speaker | Working | Physically verified at conservative `-28 dB` hardware gain. |
| Earpiece | Working | Physically verified. |
| Microphone | Working | Clean Mic2 route uses ADC2 analog gain `8` and digital level `100%`. |
| Front camera OV5675 | Working | Live image and still capture physically verified. |
| Rear camera OV12A10 | Working | Preview/capture, five sensor modes and one-shot autofocus verified. |
| Rear lens DW9763 | Working with limitation | One-shot contrast AF, manual movement, parking and runtime suspend work; the tested `242..726` endpoints are handset-local. |
| Rear PMI8950 torch | Working | Four brightness levels and separate cool/warm intensity work through native LED controls and Plasma Mobile; capped at `50 mA` per channel. |
| Video codec Venus | Working with limitation | Angelfish uses Venus for hardware video with Qt WebEngine `6.11.1-r10`. YouTube is smooth and used about half as much CPU as software decoding. Two firmware errors recovered automatically during a longer fullscreen test without a visible playback problem. |
| Plasma Camera video | Partial | Direct RAW and processed libcamera capture works at the expected rate. Only the Plasma Camera/Qt Multimedia recording path was slow: the tested file averaged about `4.12 fps`, had timestamp defects and no audio. |
| Angelfish | Working with workaround | Hardware video works with Qt WebEngine `r10` and `AcceleratedVideoDecoder`; GPU rasterization and WebGL remain disabled for stability while GPU composition and Canvas stay enabled. |
| Auto-rotation | Working | Physically verified. |
| Vibration | Working | Physically verified. |
| microSD | Working | Mounting and file reading were physically verified. |
| Hall sensor | Unverified | Linux exposes `SW_LID`, but a physical state transition has not been verified. |
| Suspend/resume | Working | Suspend-to-idle and power-button wake work normally. Overnight testing passed with good battery behaviour. |
| IR transmitter | Not enabled | Xiaomi specifications confirm the emitter; exact PWM/GPIO wiring for Linux is unresolved. |
| Fingerprint | Not working | Not enabled. |
| Proximity sensor | Not working | Not enabled. |
| Camera photo flash | Deferred | Continuous torch works; high-current flash and V4L2/sensor strobe integration are intentionally not implemented. |
| Calls, SMS, mobile data, GPS | Unverified | Not tested without an active SIM. |

## Status vocabulary

- **Working:** physically verified on the test handset.
- **Working with limitation:** the feature works physically, with a documented
  boundary or reliability qualification.
- **Working with workaround:** usable, with a documented limitation.
- **Partial:** a useful hardware path works, but integration or reliability is
  incomplete.
- **Unverified:** exposed or expected, but not yet physically proven.
- **Not working:** currently unavailable or known to fail.
