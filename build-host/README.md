# Building Adrishya in a disposable VM

Building the ISO needs root and loop devices, so do it in a throwaway VM rather
than on your daily machine. Two paths, pick one.

## Path A - QEMU + cloud-init (no Vagrant, Linux/macOS host)

Requires: `qemu-system-x86_64`, `qemu-img`, and either `cloud-localds` or
`genisoimage`; KVM for speed (falls back to slow TCG emulation).

```sh
./build-host/qemu-build.sh
```

It downloads a Debian 13 cloud image, boots it, installs `live-build`, builds
the ISO from the mounted repository, copies the result to `./out/`, and shuts
the VM down. The base image is cached in `build-host/.cache/`.

## Path B - Vagrant (VirtualBox or libvirt)

```sh
cd build-host
vagrant up
vagrant ssh -c 'cd /adrishya && ./scripts/fetch-tor-browser.sh 14.5.7 && sudo ./build.sh'
```

The repository is shared at `/adrishya` inside the guest.

## Notes

- These definitions are a starting point and have not been run in the Adrishya
  CI environment. Verify the Debian image/box URL for your release before use.
- Neither path is a substitute for testing the ISO on real hardware afterwards;
  see `tests/smoke-test.md`.
