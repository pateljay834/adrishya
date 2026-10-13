#!/bin/sh
# Best-effort wipe of free RAM at shutdown, to blunt cold-boot attacks.
# Defence-in-depth, NOT a guarantee: firmware may retain memory.
set -eu
sdmem -l -l -v || true
logger -t adrishya "RAM wipe attempted"
exit 0
