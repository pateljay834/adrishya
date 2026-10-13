#!/usr/bin/env bash
# Download and GPG-verify the Tor Browser bundle, staging it for bundling.
set -euo pipefail

VERSION="${1:-}"
if [ -z "$VERSION" ]; then
    echo "usage: $0 <tor-browser-version>   (e.g. 14.5.7)" >&2
    exit 2
fi

DEST="${DEST:-config/includes.chroot/opt/tor-browser}"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

BASE="https://dist.torproject.org/torbrowser/${VERSION}"
TARBALL="tor-browser-linux-x86_64-${VERSION}.tar.xz"

echo "[*] downloading ${TARBALL}"
curl -fsSL "${BASE}/${TARBALL}"     -o "$WORK/$TARBALL"
curl -fsSL "${BASE}/${TARBALL}.asc" -o "$WORK/$TARBALL.asc"

# Tor Browser signing key. VERIFY THIS FINGERPRINT from a trusted source.
KEY_FPR="EF6E286DDA85EA2A4BA7DE684E2C6E8793298290"
GNUPGHOME="$WORK/gnupg"; export GNUPGHOME
mkdir -p "$GNUPGHOME"; chmod 700 "$GNUPGHOME"

gpg --auto-key-locate nodefault,wkd --locate-keys torbrowser@torproject.org >/dev/null 2>&1
ACTUAL="$(gpg --list-keys --with-colons "$KEY_FPR" 2>/dev/null | awk -F: '/^fpr:/ {print $10; exit}')"
if [ "$ACTUAL" != "$KEY_FPR" ]; then
    echo "[!] signing key fingerprint mismatch (got '$ACTUAL'). Aborting." >&2
    exit 1
fi

gpg --verify "$WORK/$TARBALL.asc" "$WORK/$TARBALL"

echo "[*] extracting to $DEST"
mkdir -p "$DEST"
tar -xJf "$WORK/$TARBALL" -C "$DEST" --strip-components=1
echo "[+] Tor Browser ${VERSION} verified and staged in $DEST"
