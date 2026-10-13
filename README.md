# Adrishya

A Debian-based, Tails-class live operating system: **amnesic by default, all
traffic through Tor, optional encrypted persistence** - plus first-class Indic
localisation and six targeted hardening improvements over the Tails 7.x
baseline.

> **Status: source tree, build-ready. Not yet a released distro.**
> The ISO must be built on a privileged Debian/Ubuntu host (root + loop
> devices). This repository cannot build the ISO on a non-root machine, and no
> release exists yet. See `docs/BUILDING.md` (on Windows, `docs/BUILDING-WINDOWS.md`).

## Quick start (on a build host)

```sh
sudo apt install live-build
./scripts/verify.sh          # self-checks, no root needed
sudo make build              # runs live-build end to end
```

The ISO lands in the repository root as `adrishya-*.iso`.

No Linux machine of your own? Build it in the cloud and download the ISO - see
`docs/BUILDING-CLOUD.md` (GitHub Actions) or `.gitlab-ci.yml`.

The website and the release process are documented in `docs/RELEASING.md`.

## What is here

| Path | Purpose |
|------|---------|
| `auto/` | live-build configuration (`lb config` / `lb clean`) |
| `config/package-lists/` | package selection, split by role |
| `config/includes.chroot/` | files copied verbatim into the live root |
| `config/hooks/live/` | build-time hooks that configure the image |
| `scripts/` | build, signing, SBOM, snapshot-pinning, verification |
| `docs/` | build guide and threat model |
| `tests/` | post-build smoke-test checklist |
| `Makefile` | `make build / verify / sbom / sign` |

## The seven layers

Boot (signed shim to GRUB to live-boot) - Runtime (squashfs in RAM, tmpfs
overlays, no disk writes) - Network (nftables default-deny, Tor TransPort 9040)
- Isolation (Wayland-only, Flatpak + seccomp + Landlock) - Persistence (LUKS2 /
Argon2id) - Amnesia (RAM wipe, volatile journal, no swap) - Update (signed,
Tor-delivered).

## Improvements over the Tails 7.x baseline

Wayland-only session; per-app network namespaces; stable-per-network MAC mode;
Snowflake plus Moat bridge auto-fetch; LUKS2/Argon2id with a VeraCrypt option;
full Indic localisation (22 scheduled languages). The design specification
delivered alongside this source tree documents each one.

## Licence

GPL-3.0-or-later. See `LICENSE`. See `SECURITY.md` before reporting issues.
