#!/usr/bin/env bash
# Copy the rendered branding assets into the live-build includes tree so they
# ship inside the ISO.
set -euo pipefail

HERE="$(cd "$(dirname "$0")/.." && pwd)"
SRC="$HERE/branding"
DST="$HERE/config/includes.chroot/usr/share"

mkdir -p "$DST/backgrounds/adrishya" "$DST/pixmaps" "$DST/icons/hicolor/512x512/apps" \
         "$DST/plymouth/themes/adrishya"

cp "$SRC/wallpaper.png" "$DST/backgrounds/adrishya/wallpaper.png"
cp "$SRC/logo-256.png"  "$DST/backgrounds/adrishya/logo.png"
cp "$SRC/logo.png"      "$DST/icons/hicolor/512x512/apps/adrishya.png"
cp "$SRC/logo-256.png"  "$DST/pixmaps/adrishya.png"
cp "$SRC/logo-256.png"  "$DST/plymouth/themes/adrishya/logo.png"

echo "[+] branding assets installed into config/includes.chroot"
