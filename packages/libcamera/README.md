# Vince libcamera autofocus build

This aport rebuilds libcamera `v0.7.1` for AArch64 with the project's ordered
Simple-pipeline autofocus series. It builds only the Simple pipeline and IPA,
plus the matching `cam` and V4L2 compatibility subpackages.

The runtime packages provide standard one-shot `AfMode`, `AfTrigger` and
`AfState` behavior, CPU SoftISP focus statistics and two teardown guards found
during rapid rear/front switching on the physical phone. The implementation
does not expose raw actuator values as calibrated `LensPosition` distances.

The package version intentionally sorts after the postmarketOS `v26.06`
`99990.7.1-r0` build and is pinned to the matching IPA revision. It is a
Vince-specific replacement, not a general Alpine libcamera upgrade.

The Release APK was built from the same final source at commit
`3a6c4602cb797e7418ad67bcf790c08f54799e2a`. A local rebuild creates a new IPA
signing key and therefore is not expected to be byte-identical to the published
APK, but it builds the same source and signs a matching core/IPA pair.

See the [libcamera patch series](../../patches/libcamera/README.md),
[autofocus guide](../../fixes/ov12a10-autofocus.md) and
[source provenance](../../SOURCES.md#ov12a10-one-shot-autofocus).
