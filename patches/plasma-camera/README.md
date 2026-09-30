# Plasma Camera patches

Target: Plasma Camera tag [`v2.1.1`](https://invent.kde.org/plasma-mobile/plasma-camera/-/tree/v2.1.1).

Apply `0001-one-shot-autofocus.patch` with `git am`. It queues one standard
one-shot autofocus trigger when a rear camera advertises the required
libcamera controls. Front cameras and cameras without autofocus remain
unchanged.

The autofocus source head is `c43aef4dd36fbc70528869ad7d30ce01252a045f`.
The published `r6` recipe uses only this first patch.

## Optional recording update

Apply `0002-video-recording-r15.patch` with `git apply` after `0001`. It adds
the cumulative recording changes, including the intervening 540p preview,
full-resolution still capture and tap-to-refocus work. The result matches
source head `94a6e0e87754b21bc289c1e04090e57e9b3053d0`, used for `2.1.1-r15`.

Starting from the official `2.1.1` archive, apply both patches in numerical
order with `git apply`. Do not apply `0002` directly to unpatched upstream
source. The [r15 recipe](../../packages/plasma-camera-r15/README.md) supplies
both patches; [setup and limitations](../../fixes/plasma-camera-video.md)
cover the matching Qt Multimedia build and launcher.
