# OV12A10 one-shot autofocus

Status: working in Plasma Camera, including rapid camera switching, saved
photos, safe shutdown, lens parking and runtime suspend.

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

## Tested

One-shot autofocus repeatedly found a sharp position on the test phone. Rear
and front camera switching, saved photos and closing the application during a
scan worked without crashes. The lens parks correctly after use, and the
camera continues to work after reboot.

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
