#!/bin/sh
# Adrishya build entrypoint. Requires root (loop devices + chroot).
set -e

if [ "$(id -u)" -ne 0 ]; then
    echo "error: live-build needs root (loop devices, chroot)." >&2
    echo "       re-run with: sudo ./build.sh" >&2
    exit 1
fi

command -v lb >/dev/null 2>&1 || {
    echo "error: live-build not installed. Run: apt install live-build" >&2
    exit 1
}

echo "[*] cleaning previous build"
lb clean --purge || true

echo "[*] configuring"
lb config

echo "[*] building (this takes a while and needs network access)"
lb build

ISO=$(ls -1 adrishya-*.iso 2>/dev/null | head -1 || true)
if [ -n "$ISO" ]; then
    sha256sum "$ISO" | tee "$ISO.sha256"
    echo "[+] build complete: $ISO"
else
    echo "[!] build finished but no ISO found - inspect the log above." >&2
    exit 1
fi
