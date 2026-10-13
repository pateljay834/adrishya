# Adrishya post-build smoke test

Run after writing the ISO to a USB stick, on a spare machine or VM.

## Boot
- [ ] System boots to the GNOME desktop with no errors.
- [ ] The session is Wayland (`echo $XDG_SESSION_TYPE` prints `wayland`).
- [ ] No X11 server is running (`pgrep Xorg` is empty).

## Network and anonymity
- [ ] Before connecting to Tor, no application can reach the internet.
- [ ] All traffic goes through Tor (check with the Tor Browser's circuit view).
- [ ] Non-Tor egress is dropped (`nft list ruleset` shows the default-deny).
- [ ] DNS does not leak (`/etc/resolv.conf` points at 127.0.0.1).
- [ ] The MAC address is randomised at boot (`ip link` before/after reboot).

## Amnesia
- [ ] Nothing is written to internal disks (boot with internal disks detached;
      the system still works).
- [ ] `journalctl` does not persist across reboots.
- [ ] No swap is active (`swapon --show` is empty).
- [ ] On shutdown, the RAM-wipe unit runs without error.

## Applications
- [ ] Tor Browser launches and connects.
- [ ] A bundled app cannot reach the network outside its Tor proxy.
- [ ] Metadata Cleaner (MAT2) strips EXIF from a test image.

## Localisation
- [ ] A Devanagari (and one other Indic) keyboard layout is selectable.
- [ ] Indic text renders without missing glyphs.

## Persistence
- [ ] Persistent Storage is off by default.
- [ ] After creating it, files survive a reboot and are encrypted at rest.
