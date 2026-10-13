#!/usr/bin/env bash
# Build the Adrishya ISO inside a disposable Debian cloud VM using QEMU.
# Requirements: qemu-system-x86_64, qemu-img, cloud-localds (or genisoimage).
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
REPO="$(cd "$HERE/.." && pwd)"
CACHE="$HERE/.cache"
OUT="$REPO/out"
mkdir -p "$CACHE" "$OUT"

IMG_URL="${IMG_URL:-https://cloud.debian.org/images/cloud/trixie/latest/debian-13-genericcloud-amd64.qcow2}"
BASE="$CACHE/debian-13.qcow2"
OVERLAY="$CACHE/overlay.qcow2"
SEED="$CACHE/seed.iso"

echo "[*] base image"
if [ ! -f "$BASE" ]; then
    curl -fL "$IMG_URL" -o "$BASE"
fi

echo "[*] overlay disk"
rm -f "$OVERLAY"
qemu-img create -f qcow2 -F qcow2 -b "$BASE" "$OVERLAY" >/dev/null

echo "[*] cloud-init seed"
if command -v cloud-localds >/dev/null 2>&1; then
    cloud-localds "$SEED" "$HERE/cloud-init/user-data" "$HERE/cloud-init/meta-data"
else
    genisoimage -output "$SEED" -volid cidata -joliet -rock \
        "$HERE/cloud-init/user-data" "$HERE/cloud-init/meta-data"
fi

# Accelerator: KVM on Linux, WHPX on Windows (ACCEL=whpx), else slow TCG.
# Override explicitly, e.g.  ACCEL=whpx ./build-host/qemu-build.sh
ACCEL="${ACCEL:-}"
if [ -z "$ACCEL" ]; then
    ACCEL="tcg"
    if [ -w /dev/kvm ]; then ACCEL="kvm"; fi
fi
echo "[*] booting VM (accel=$ACCEL) - build output streams below"

qemu-system-x86_64 \
    -machine "accel=$ACCEL" -m 4096 -smp 4 \
    -drive file="$OVERLAY",if=virtio,format=qcow2 \
    -drive file="$SEED",if=virtio,format=raw \
    -virtfs "local,path=$REPO,mount_tag=host0,security_model=none,readonly=off" \
    -netdev user,id=n0 -device virtio-net-pci,netdev=n0 \
    -nographic -no-reboot

echo "[+] VM finished. Look in $OUT for the ISO."
