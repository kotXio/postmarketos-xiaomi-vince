# OV12A10 one-shot autofocus

Status: physically verified in Plasma Camera, including rapid camera switching,
saved stills, teardown race guards, lens parking and runtime suspend.

## Problem

The Simple libcamera pipeline discovered the linked DW9763 actuator but did not
forward lens controls or calculate a focus metric. Plasma Camera `2.1.1` also
did not submit standard autofocus controls. Early working versions exposed two
separate teardown races during rapid rear-to-front switching.

## Solution

The [libcamera series](../patches/libcamera/README.md) adds guarded lens
plumbing, a central raw-Bayer gradient metric, a bounded two-stage contrast
search, standard `AfMode`/`AfTrigger`/`AfState` reporting and both teardown
guards. The [Plasma Camera patch](../patches/plasma-camera/README.md) submits
exactly one startup trigger for each rear-camera session.

The OV12A10 tuning uses the tested interval `242..726`, coarse step `48`, fine
step `8`, two settling frames and the median of three valid metric frames. The
kernel patch extends the actuator's exposed maximum to `726`; the existing
driver still parks and runtime-suspends the lens after close.

## Verification

- A fixed-scene native pair selected `522` twice; curve correlation was
  `0.997992580`.
- The first in-stack scan selected `530`, within `8` DAC codes of the earlier
  independent result `538`.
- Cancel, successful Focused results and ordinary flat-scene Failed results
  were all observed without out-of-range lens commands.
- Rear/front previews, two saved stills, seven selections and three exits while
  scanning completed without a crash.
- The formerly fatal malformed-control condition was hit twice and safely
  skipped; no new coredump appeared.
- OV12A10, DW9763 and OV5675 all returned to `suspended` after application
  close and remained correct after a normal reboot.

## Compatibility and limitations

This is experimental handset-local DIY work for the tested Sunny OV12A10 plus
DW9763 module. Endpoints `242..726` came from checksum-valid EEPROM data on one
phone and are not claimed to be universal for every `vince`. Raw EEPROM data is
not published.

This implements one-shot contrast AF at rear-session start. It is not
continuous AF, touch-to-focus, PDAF, face detection or calibrated manual focus
distance. A low-detail scene can correctly finish as `AfStateFailed`.

Plasma Camera's approximately `4.12 fps`, timestamp-imperfect, no-audio encoded
video result is a separate Qt Multimedia/application limitation. Native RAW and
processed libcamera paths reached their expected rates; the autofocus patch
does not change the recorder path.
