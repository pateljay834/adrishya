#!/usr/bin/env bash
# Generate a CycloneDX SBOM for the repository (software bill of materials).
set -euo pipefail

if command -v syft >/dev/null 2>&1; then
    syft dir:. -o cyclonedx-json > sbom.cyclonedx.json
    echo "[+] wrote sbom.cyclonedx.json"
else
    echo "[!] syft not installed. Install it from https://github.com/anchore/syft" >&2
    echo "    then re-run 'make sbom'." >&2
    exit 1
fi
