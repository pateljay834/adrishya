#!/bin/sh
# Randomise the MAC of every non-loopback interface at boot.
# Adrishya extension: stable-per-network mode derives the MAC from a keyed hash
# of the SSID, so a returning user is not a brand-new device on every boot.
# Set ADRISHYA_MAC_MODE=stable and ADRISHYA_MAC_KEY to enable it.
set -eu

MODE="${ADRISHYA_MAC_MODE:-random}"

for iface in $(ls /sys/class/net | grep -v '^lo$'); do
    ip link set dev "$iface" down 2>/dev/null || continue
    if [ "$MODE" = "stable" ] && [ -n "${ADRISHYA_MAC_KEY:-}" ]; then
        ssid="$(iwgetid -r "$iface" 2>/dev/null || echo '')"
        if [ -n "$ssid" ]; then
            h="$(printf '%s' "${ADRISHYA_MAC_KEY}:${ssid}" | sha256sum | cut -c1-12)"
            mac="02:$(printf '%s' "$h" | sed 's/\(..\)/\1:/g; s/:$//')"
            macchanger -m "$mac" "$iface" >/dev/null 2>&1 || macchanger -r "$iface" >/dev/null 2>&1 || true
        else
            macchanger -r "$iface" >/dev/null 2>&1 || true
        fi
    else
        macchanger -r "$iface" >/dev/null 2>&1 || true
    fi
    ip link set dev "$iface" up 2>/dev/null || true
    logger -t adrishya "randomised MAC on $iface (mode=$MODE)"
done
exit 0
