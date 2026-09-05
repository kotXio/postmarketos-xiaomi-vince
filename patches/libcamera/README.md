# libcamera patch series

Target: upstream libcamera tag [`v0.7.1`](https://gitlab.freedesktop.org/camera/libcamera/-/tree/v0.7.1),
commit `183e37362f57ff3ce7493abf0bc6f1b57b931f55`.

Apply all patches in lexical order with `git am`:

| Patch | Purpose |
| --- | --- |
| `0001` | Forward guarded lens commands and results through the Simple pipeline. |
| `0002` | Add a central raw-Bayer focus statistic to CPU SoftISP. |
| `0003` | Add bounded, configurable, one-shot contrast autofocus to the Simple IPA. |
| `0004` | Advertise the generated `AfState` output control. |
| `0005` | Reject late lens commands/results after SoftwareIsp stop begins. |
| `0006` | Safely skip tail statistics with missing or malformed delayed sensor controls. |

The complete final source head is
`3a6c4602cb797e7418ad67bcf790c08f54799e2a`. The series is physically tested
project work, not a claim that it is ready for upstream acceptance unchanged.

The actual actuator interval is supplied by the separate OV12A10 tuning file.
Do not interpret its raw DAC endpoints as calibrated focus distance.
