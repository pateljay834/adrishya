# Building Adrishya

## What you need

- A Debian or Ubuntu host with **root** and **loop device** support (a VM or
  bare metal; WSL and most containers do not qualify without `--privileged`).
- `live-build`: `sudo apt install live-build`.
- ~10 GB free disk, ~2 GB RAM, and network access to Debian mirrors.
- 30-90 minutes depending on hardware and network.

You cannot build the ISO on a non-root machine. `./scripts/verify.sh` runs
anywhere and checks the repository; it does not build the ISO.

## Steps

1. Verify the tree:

   ```sh
   ./scripts/verify.sh
   ```

2. Bundle Tor Browser (required for a usable image):

   ```sh
   ./scripts/fetch-tor-browser.sh 14.5.7
   ```

3. (Recommended) Pin the Debian snapshot for a reproducible tree:

   ```sh
   ./scripts/pin-snapshot.sh 20261012T000000Z
   ```

4. Build:

   ```sh
   sudo make build
   ```

5. Sign:

   ```sh
   gpg --armor --detach-sign adrishya-*.iso
   ```

## Writing to a USB stick

```sh
sudo dd if=adrishya-*.iso of=/dev/sdX bs=4M status=progress oflag=sync
```

**Double-check the device node.** `dd` to the wrong device destroys data.

## Testing before you trust it

Run the checklist in `tests/smoke-test.md` on real hardware, ideally in a VM
first and then on a spare machine. At minimum confirm: the system boots, no
traffic leaves without Tor, nothing is written to internal disks, and the RAM
wipe runs on shutdown.

## Reproducibility

Set `SOURCE_DATE_EPOCH` and pin the snapshot so two builders produce identical
bytes. Publish the checksum and the SBOM with every release.
