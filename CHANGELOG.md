# Changelog

All notable changes to Adrishya are recorded here. This project follows
Semantic Versioning.

## [Unreleased]

## [0.1.0] - 2026-10-13

First cut: a Debian-based, Tails-class amnesic, Tor-by-default live system with
a Sanskrit-rooted identity.

### Added
- Debian 13 (Trixie) `live-build` source tree that produces a bootable ISO.
- Tor-by-default networking: nftables default-deny egress with only the tor
  user allowed out, DNS through Tor, and obfs4 / WebTunnel / Snowflake bridges.
- Amnesic defaults: no swap, volatile journal, RAM wipe on shutdown, and no
  machine-id baked into the image.
- Wayland-only GNOME session with the X11 server removed.
- Hardening patch series: kernel command line, systemd sandboxing, GNOME
  privacy lockdown, an AppArmor profile, and coredump/sysctl hardening.
- Branding built on the Devanagari letter अ: logo, wallpaper, and a Plymouth
  boot splash.
- Adrishya USB Installer (clones a running stick onto another).
- Cloud build (GitHub Actions and GitLab CI) and a GitHub Pages site.
- Tooling: `verify`, `fetch-tor-browser`, `pin-snapshot`, `sign-iso`, `make-sbom`.

### Notes
- The ISO has not yet been built or independently audited. See `SECURITY.md`.
