# Device status

Last updated: 2026-09-18

Test device: Xiaomi Redmi 5 Plus (`vince`), `aarch64`, postmarketOS `v26.06`,
Plasma Mobile, Linux `7.0.9-msm8953`, cumulative kernel package
`7.0.9_p20260912095627-r13`.

Snapdragon 625 with eight Cortex-A53 cores; about `3.5 GiB` RAM is visible to
Linux on this handset.

This table reports observations from one physical handset. It is not a promise
that the same package will work on another release or package baseline.

| Area | Status | Notes |
| --- | --- | --- |
| Boot and Plasma Mobile | Working | Normal persistent boot verified repeatedly. |
| Display and GPU | Working | Adreno 506 uses Mesa Freedreno hardware rendering. |
| Touch | Working | Works normally and after waking from suspend. |
| Wi-Fi | Working | Normal browsing works; reconnection after suspend can take tens of seconds. |
| Bluetooth | Working | Physical device connection verified. |
| USB networking | Working | USB gadget networking and SSH work, including reconnection after wake. |
| USB host / OTG | Unverified | No physical host-mode test on this handset. |
| Main TAS2557 speaker | Working | Physically verified at conservative `-28 dB` hardware gain. |
| Earpiece | Working | Physically verified. |
| Microphone | Working | Clean default Mic2 uses ADC2 analog gain `8` and digital level `100%`; Mic1 is a noisy fallback. The source can start muted after reboot. |
| Wired headphones / headset | Unverified | The headset-jack input interface is present; playback and headset recording have not been tested. |
| Front camera OV5675 | Working | Live image and still capture physically verified. |
| Rear camera OV12A10 | Working | Preview/capture, five sensor modes and one-shot autofocus verified. |
| Rear lens DW9763 | Working with limitation | One-shot contrast AF, manual movement, parking and runtime suspend work; the tested `242..726` endpoints are handset-local. |
| Rear PMI8950 torch | Working | Four brightness levels and separate cool/warm intensity work through native LED controls and Plasma Mobile; capped at `50 mA` per channel. |
| Front selfie fill light | Not enabled | Present in stock specifications and board files; not enabled or physically tested in Linux. |
| Video codec Venus | Working with limitation | Angelfish uses Venus for hardware video with Qt WebEngine `6.11.1-r10`. YouTube is smooth and used about half as much CPU as software decoding. Two firmware errors recovered automatically during a longer fullscreen test without a visible playback problem. |
| Plasma Camera video | Working with limitation | Local Camera `r15` and Qt Multimedia `r7` record rear 720p with Venus and Mic2 at about `30 fps`, with fast saving. Recording preview is about `5 fps`; Venus pads the output to `1280x736`. These recording packages are not yet published. |
| Angelfish | Working with workaround | Hardware video works with Qt WebEngine `r10` and `AcceleratedVideoDecoder`; GPU rasterization and WebGL remain disabled for stability while GPU composition and Canvas stay enabled. |
| Motion sensors / auto-rotation | Working | BMI120 acceleration and gyroscope readings work; automatic rotation is physically verified. |
| Ambient light sensor | Working | Live illumination readings are available; this does not establish proximity support. |
| Magnetometer | Working | Responds to physical rotation; compass heading accuracy and calibration have not been tested. |
| Vibration | Working | Physically verified. |
| microSD | Working | Mounting and file reading were physically verified. |
| Internal eMMC | Working | Internal storage works; no I/O errors were observed. |
| Battery / charging / temperatures | Working | Charging and battery/SoC/PMIC readings work. Actual battery capacity has not been measured. |
| RTC / system clock | Working | Correct system time survived a reboot without NTP through the existing `swclock-offset` service. Alarm wake and complete power-loss retention are untested. |
| White notification LED | Working | AW2013 indicator blinking was physically verified; automatic notification policy was not tested. |
| Hall sensor | Unverified | Linux exposes `SW_LID`, but a physical state transition has not been verified. |
| Suspend/resume | Working | Suspend-to-idle and power-button wake work normally. Overnight testing passed with good battery behaviour. |
| IR transmitter | Not enabled | Xiaomi confirms the emitter; stock Peel IR code uses SPI6/CS0. Linux transmission is not enabled or tested. |
| FM radio | Not enabled | Xiaomi confirms FM reception; Linux radio/audio support has not been enabled or tested. |
| Fingerprint | Not working | Not enabled. |
| Proximity sensor | Not enabled | This handset has the LTRF216A variant. The optional LTR579 work below must not be applied to it. |
| Camera photo flash | Deferred | Continuous torch works; high-current flash and V4L2/sensor strobe integration are intentionally not implemented. |
| Modem | Partial | Firmware loads and the SIM/operator are detected. The expired test SIM prevented network registration testing. |
| Calls, SMS, mobile data | Unverified | A known-active SIM is needed for service tests. |
| GNSS / GPS | Unverified | No outdoor position-fix test yet; standalone GNSS does not inherently require an active SIM. |

## Second-handset LTR579 variant

A second physical Redmi 5 Plus (`MEE7`, `4/64 GB`) has an LTR579 at I2C
address `0x53`, identified from its stock Android sensor inventory. Both
LTRF216A and LTR579 report part ID `0xb1`, so this is an explicit Device Tree
variant rather than safe runtime auto-detection.

| Area | Status | Notes |
| --- | --- | --- |
| LTR579 binding | Working | The optional driver registers `ltr579` and loads automatically after a persistent reboot. |
| Ambient light | Working | The existing illumination path remains available; the dark test returned `0.150000000 lux`. |
| Raw proximity | Partial | Thirty temporary-boot and twenty persistent-boot far samples returned `3-4`. Physical near/cover response is not yet tested. |
| Threshold/IRQ/wake | Not implemented | No threshold writes, IIO events, interrupt route or wake claim. Polling only. |
| Other passive hardware | No regression observed | Display, touch, GPU, cameras, Venus, audio, motion sensors, radio/IR nodes, Wi-Fi, Bluetooth, power and storage bindings remained present. |

The source, identification boundary and rollback guidance are in the
[LTR579 guide](fixes/ltr579-proximity.md). No community APK is published yet:
the physically tested binary contains later cumulative private work and needs
a clean rebuild against the public series first.

## Theoretical / unverified functions

These are research candidates, not confirmed extra hardware or working Linux
features.

| Area | Status | Notes |
| --- | --- | --- |
| Body / SAR sensing | Theoretical / unverified | Stock code exposes a virtual-SAR GPIO path. A separate physical SAR chip, its identity and the signal's purpose are not established on this handset. |
| Virtual sensors: step counter, significant motion, sensor fusion | Theoretical / unverified | Possible functions derived from existing sensors or the DSP; their availability and operation have not been verified. |

## Status vocabulary

- **Working:** physically verified on the test handset.
- **Working with limitation:** the feature works physically, with a documented
  boundary or reliability qualification.
- **Working with workaround:** usable, with a documented limitation.
- **Partial:** a useful hardware path works, but integration or reliability is
  incomplete.
- **Unverified:** exposed or expected, but not yet physically proven.
- **Not working:** currently unavailable or known to fail.
- **Not enabled:** support is not enabled or implemented in the current Linux
  stack; this is not a claim of faulty hardware.
- **Deferred:** a function intentionally left for later development.
- **Theoretical / unverified:** a research candidate whose presence or function
  has not been established on this handset.
