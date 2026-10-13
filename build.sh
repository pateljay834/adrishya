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

VERSION="$(cat VERSION 2>/dev/null || echo 0.0.0)"

echo "[*] cleaning previous build"
lb clean --purge || true

echo "[*] configuring"
lb config

echo "[*] building (this takes a while and needs network access)"
lb build

echo "[*] locating the built ISO"
RAW="$(ls -1 ./*.hybrid.iso 2>/dev/null | head -1 || true)"
[ -z "$RAW" ] && RAW="$(ls -1 ./*.iso 2>/dev/null | head -1 || true)"
[ -z "$RAW" ] && RAW="$(find . -maxdepth 2 -type f -name '*.iso' 2>/dev/null | head -1 || true)"

if [ -z "$RAW" ]; then
    echo "[!] build finished but no ISO file was found." >&2
    exit 1
fi

OUT="adrishya-${VERSION}-amd64.iso"
if [ "$RAW" != "./$OUT" ] && [ "$RAW" != "$OUT" ]; then
    mv -f "$RAW" "$OUT"
fi
sha256sum "$OUT" | tee "$OUT.sha256"
echo "[+] build complete: $OUT"
