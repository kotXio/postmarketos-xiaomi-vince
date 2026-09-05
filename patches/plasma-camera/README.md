# Plasma Camera patch

Target: Plasma Camera tag [`v2.1.1`](https://invent.kde.org/plasma-mobile/plasma-camera/-/tree/v2.1.1).

Apply `0001-one-shot-autofocus.patch` with `git am`. It queues one standard
one-shot autofocus trigger when a rear camera advertises the required
libcamera controls. Front cameras and cameras without autofocus remain
unchanged.

The tested source head is `c43aef4dd36fbc70528869ad7d30ce01252a045f`.
