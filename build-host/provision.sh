#!/usr/bin/env bash
# Vagrant provisioner: install build dependencies in the guest.
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y --no-install-recommends \
    live-build git gnupg curl ca-certificates

cd /adrishya
./scripts/verify.sh
echo "[+] build host ready. Run: sudo ./build.sh"
