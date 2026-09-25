# Device status

Last updated: 2026-09-25

Reference device: Xiaomi Redmi 5 Plus (`vince`), `aarch64`, postmarketOS `v26.06`,
Plasma Mobile, Linux `7.0.9-msm8953`, cumulative kernel package
`7.0.9_p20260914105626-r16`.

Snapdragon 625 with eight Cortex-A53 cores; about `3.5 GiB` RAM is visible to
Linux on this handset.

This table reports observations from one physical handset. It is not a promise
that the same package will work on another release or package baseline.

| Area | Status | Notes |
| --- | --- | --- |
| Boot and Plasma Mobile | Working | Normal persistent boots. |
| Display and GPU | Working | Adreno 506 uses Mesa Freedreno hardware rendering. |
| Touch | Working | Works normally and after waking from suspend. |
| Wi-Fi | Working | Normal browsing works; reconnection after suspend can take tens of seconds. |
| Bluetooth | Working | Connects normally to Bluetooth devices. |
| USB networking | Working | USB gadget networking and SSH work, including reconnection after wake. |
| USB host / OTG | Partial | An unpowered hub and RTL8152 Ethernet adapter enumerate and recover after removal. Repeated xHCI halt errors remain and Ethernet traffic was not tested. |
| Main TAS2557 speaker | Working | Clean output at a conservative `-28 dB` hardware gain. |
| Earpiece | Working | Audio output works. |
| Microphone | Working | Clean default Mic2 uses ADC2 analog gain `8` and digital level `100%`; Mic1 is a noisy fallback. The source can start muted after reboot. |
| Wired headphones / headset | Working with limitation | Headphone detection and FM audio output work. Headset microphone capture and wider media-profile coverage remain untested. |
| Front camera OV5675 | Working | Live preview and still photos work. |
| Rear camera OV12A10 | Working | Preview, still photos, five sensor modes and one-shot autofocus work. |
| Rear lens DW9763 | Working with limitation | One-shot contrast AF, manual movement, parking and runtime suspend work; the `242..726` endpoints are handset-local. |
| Rear PMI8950 torch | Working | Four brightness levels and separate cool/warm intensity work through native LED controls and Plasma Mobile; capped at `50 mA` per channel. |
| Front selfie fill light | Working with limitation | Binary control is available through `white:torch-1`, and the light turns off automatically during suspend. Current, hardware cutoff and camera synchronization are unknown. |
| Video codec Venus | Working with limitation | Angelfish uses Venus for hardware video with Qt WebEngine `6.11.1-r10`. YouTube is smooth and used about half as much CPU as software decoding. Two firmware errors recovered automatically during a longer fullscreen test without a visible playback problem. |
| Plasma Camera video | Partial | Rear recording closes safely, but the public camera stack produced low frame rate, timestamp defects and no audio. Direct camera capture produces good results; the limitation is in Plasma Camera integration. |
| Angelfish | Working with workaround | Hardware video works with Qt WebEngine `r10` and `AcceleratedVideoDecoder`; GPU rasterization and WebGL remain disabled for stability while GPU composition and Canvas stay enabled. |
| Motion sensors / auto-rotation | Working | BMI120 acceleration, gyroscope readings and automatic rotation work. |
| Ambient light sensor | Working | Live illumination readings are available; this does not establish proximity support. |
| Automatic brightness | Working | Plasma Mobile adjusted the display brightness in response to physical light changes and returned to the previous level. |
| Magnetometer | Working | Responds to physical rotation; compass heading accuracy and calibration have not been evaluated. |
| Vibration | Working | Haptic vibration works. |
| Power and volume buttons | Working | Power, Volume Up and Volume Down work. |
| microSD | Working | The card mounts and files can be read. |
| Internal eMMC | Working | Internal storage works with no known I/O problems. |
| Battery / charging / temperatures | Working | Charging and battery/SoC/PMIC readings work. Actual battery capacity has not been measured. |
| RTC / system clock | Working | Correct system time survived a reboot without NTP through the existing `swclock-offset` service. Alarm wake and complete power-loss retention are untested. |
| White notification LED | Working | The AW2013 indicator supports blinking; automatic notification policy was not tested. |
| Hall sensor | Working | A physical magnet sweep produced repeatable `SW_LID` open/close transitions. Flip-cover policy and the exact chip are untested. |
| Suspend/resume | Working | The phone enters suspend-to-idle and wakes with the power button; overnight use showed normal battery behaviour. |
| IR transmitter | Working with limitation | Transmission works through rc-core and fixed-rate SPI sampling. Compatibility with real appliances and electrical characteristics remain unknown. |
| FM radio | Working with limitation | Tuning, seeking and stereo audio work through wired headphones or the TAS2557 speaker. Wired headphones serve as the antenna; RDS and long-duration reception remain untested. |
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
| LTR579 binding | Working | The optional driver registers `ltr579` and loads automatically after reboot. |
| Ambient light | Working | Illumination readings remain available; the sensor reported about `0.15 lux` in darkness. |
| Raw proximity | Partial | Stable far-state readings are available, but physical near/cover response has not been checked. |
| Threshold/IRQ/wake | Not implemented | No threshold writes, IIO events, interrupt route or wake claim. Polling only. |
| Other passive hardware | No regression observed | Display, touch, GPU, cameras, Venus, audio, motion sensors, radio/IR nodes, Wi-Fi, Bluetooth, power and storage continue to work. |

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

- **Working:** the feature works on the reference handset.
- **Working with limitation:** the feature works, with a documented
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
