#!/usr/bin/env bash
# Pin the Debian archive to a fixed snapshot timestamp for reproducibility.
set -euo pipefail

STAMP="${1:-}"
if [ -z "$STAMP" ]; then
    echo "usage: $0 <snapshot-timestamp>   (e.g. 20261012T000000Z)" >&2
    echo "find one at https://snapshot.debian.org" >&2
    exit 2
fi

OUT="config/archives/adrishya-snapshot.list.chroot"
mkdir -p "$(dirname "$OUT")"
cat > "$OUT" <<EOF
deb https://snapshot.debian.org/archive/debian/${STAMP}/ trixie main contrib non-free non-free-firmware
EOF
echo "[+] wrote $OUT (pinned to ${STAMP})"
