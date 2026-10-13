#!/usr/bin/env bash
# Sign the built ISO: checksum + detached GPG signature + optional Secure Boot.
set -euo pipefail

ISO="${1:-}"
if [ -z "$ISO" ] || [ ! -e "$ISO" ]; then
    echo "usage: $0 <path-to-iso>" >&2
    exit 2
fi

sha256sum "$ISO" > "$ISO.sha256"
echo "[+] wrote $ISO.sha256"

gpg --armor --detach-sign "$ISO"
echo "[+] wrote $ISO.asc"

if command -v sbsign >/dev/null 2>&1 && [ -n "${SB_KEY:-}" ] && [ -n "${SB_CERT:-}" ]; then
    sbsign --key "$SB_KEY" --cert "$SB_CERT" --output "$ISO.sb" "$ISO"
    echo "[+] Secure Boot signature: $ISO.sb (enroll SB_CERT via MOK on target)"
else
    echo "[i] sbsign or SB_KEY/SB_CERT not set - skipped Secure Boot signing."
fi

echo "[+] signing complete."
