# Android apps with Waydroid

Status: experimental; usable with native OpenGL ES graphics.

Waydroid runs Android inside postmarketOS without replacing the phone's OS.
With the settings below, the Android interface is responsive and Vector
Pinball plays smoothly. Calculator, Fossify Notes and Material Files launch
with hardware graphics; internet access, speaker output and ordinary video
playback also work.

Android video still uses software decoding. The working
[Angelfish hardware-video path](hardware-video.md) does not automatically
carry over into Waydroid.

## Tested setup

- Xiaomi Redmi 5 Plus (`vince`), about 3.5 GiB usable RAM, postmarketOS
  `v26.06`, systemd and Plasma Mobile.
- Waydroid `1.6.2-r0`, official ARM64 LineageOS 20 / Android 13
  `20260403` VANILLA system and MAINLINE vendor images, with Mesa `26.0.1`.
- Linux `7.0.9-msm8953`, local package `7.0.9_p20260917163344-r20`.
  The public `r16` config has the required Binder and container options, but
  Waydroid was not separately run on that APK.
- An Android surface of `540x1028` at density `240`. Full-resolution
  performance is not established by these tests.

These results are from September 23-24, 2026. Android started in about
31 seconds and Calculator opened in about half a second. The container
accounted for roughly 1.6 GiB RAM, including cache; this is not a lightweight
replacement for native Linux apps.

For initial installation, follow the
[postmarketOS Waydroid guide](https://wiki.postmarketos.org/wiki/Waydroid).
Use the systemd instructions for this setup and choose the ARM64 Vanilla
image; Google services were not part of the tests. The following changes are
for an already initialized Waydroid installation, not a custom Android image.

## Graphics workaround

The default graphics path could hang during startup or leave System UI using
an entire CPU core. Software rendering avoided the hang but was slow. The
working setup keeps Mesa/Freedreno and uses its `sysmem` rendering mode only
for three Android shell components. This is still GPU rendering, not
SwiftShader; ordinary applications keep the normal Freedreno path.

Close Android apps, then stop Waydroid and preserve your current configuration:

```sh
waydroid session stop
sudo waydroid container stop
sudo cp -n /var/lib/waydroid/waydroid.cfg /var/lib/waydroid/waydroid.cfg.before-vince-gpu
```

Merge these entries into the existing `[properties]` section of
`/var/lib/waydroid/waydroid.cfg`; do not replace the whole file or add a second
section with the same name:

```ini
[properties]
service.sf.prime_shader_cache = 0
wrap.com.android.systemui = /system/bin/logwrapper /system/bin/env FD_MESA_DEBUG=sysmem
wrap.com.android.launcher3 = /system/bin/logwrapper /system/bin/env FD_MESA_DEBUG=sysmem
wrap.com.android.settings = /system/bin/logwrapper /system/bin/env FD_MESA_DEBUG=sysmem
```

If you previously forced `ro.hardware.egl=swiftshader` or
`ro.hardware.gralloc=default`, remove those software-renderer overrides from
that section. Let Waydroid select native Mesa/GBM for the Adreno GPU. Do not
set `FD_MESA_DEBUG` for the whole container.

Regenerate the configuration without downloading new images:

```sh
sudo waydroid upgrade -o
sudo systemctl start waydroid-container.service
```

Open Waydroid from Plasma. The tested renderer reports `freedreno`, `FD506`
and `OpenGL ES 3.1`. Try Settings, Home, Recents and a simple app before
relying on it. Reducing the Android window size helped the earlier software
fallback, but is not a substitute for these graphics settings. See
[Waydroid's window-size options](https://docs.waydro.id/usage/waydroid-prop-options)
if the window needs adjusting.

## Internet access

On the tested system, postmarketOS's firewall blocked DHCP and forwarding even
though Waydroid's own rules allowed them. The following fragment fixes that
specific layout: `inet filter` with default-drop `input` and `forward` chains
and an `/etc/nftables.d/*.nft` include in `/etc/nftables.nft`. Check for earlier
drop/reject rules before adding it; this is not a replacement for another
firewall configuration.

Save it as `/etc/nftables.d/52_waydroid.nft`. If that file already exists,
inspect it first rather than overwriting or duplicating its rules:

```nft
table inet filter {
    chain input {
        iifname "waydroid0" udp dport { 53, 67 } accept comment "Allow Waydroid DNS and DHCP"
        iifname "waydroid0" tcp dport 53 accept comment "Allow Waydroid DNS"
    }
    chain forward {
        iifname "waydroid0" accept comment "Allow Waydroid outbound traffic"
        oifname "waydroid0" ct state { established, related } accept comment "Allow replies to Waydroid"
    }
}
```

Check the complete configuration before loading the new fragment once:

```sh
sudo nft -c -f /etc/nftables.nft
sudo nft -f /etc/nftables.d/52_waydroid.nft
```

Run the second command only if the check succeeds; loading the fragment again
would append duplicate rules. Restart Waydroid and check that it obtains an
IP address and can open a website. Runtime DHCP and DNS passed repeated tests;
the saved firewall change still needs a full-phone-reboot check.

## Reopening Android after Power off

Android's Power off can stop the container while leaving the user session
behind. If tapping the icon then does nothing, run `waydroid status`. For the
specific combination `Session: RUNNING` and `Container: STOPPED`, run this as
your Plasma user, without `sudo`, then open the icon again:

```sh
waydroid session stop
```

This clears the stale session without restarting the system service or
replacing the launcher.

## Limits and undo

- Vulkan and hardware video decoding are unavailable in the tested Android
  stack. The video test used Google's software H.264/AAC decoders, not Venus.
- Microphone capture, long sessions and suspend/resume are not yet validated.
  Cameras, sensors and telephony are not covered by this guide.
- Other apps may expose the same graphics issue. The three wrappers are a
  targeted workaround, not a general Adreno 506 driver fix.

To undo the graphics changes, stop the session and container, restore your
saved `waydroid.cfg`, run `sudo waydroid upgrade -o`, then start Waydroid again.
To undo the firewall addition, remove only the added fragment and reload your
normal firewall with Waydroid stopped, then restart Waydroid. Removing a file
alone does not remove rules already loaded into the running firewall. Neither
rollback requires deleting Android images or application data.

## Sources

The settings and recovery procedure were developed by Kostiantyn Andriiuk
<konstantin@andriyuk.com> through testing on this handset. No Waydroid, Mesa or
Android source patch is required by this guide. The upstream implementations
used as references are listed in
[source provenance](../SOURCES.md#android-apps-with-waydroid).
