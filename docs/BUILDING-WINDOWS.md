# Building Adrishya from a Windows laptop

You cannot build the ISO directly on Windows. `live-build` needs a Linux kernel,
root, and loop devices, none of which Windows provides. The build has to happen
inside a Linux virtual machine. This guide is the Windows-specific path; the
generic one is in `BUILDING.md`.

Everything below assumes you have extracted `Adrishya-OS-source.zip` (right-click
the zip, choose **Extract All**, or use 7-Zip). You should end up with an
`adrishya` folder.

## Option 1 - VirtualBox + Vagrant (recommended)

This is the least fiddly route on Windows. Vagrant drives VirtualBox for you.

1. Install **VirtualBox** and **Vagrant** (both free, both have Windows
   installers). Reboot if the installer asks.
2. Open PowerShell or Command Prompt and go to the build-host folder:

   ```
   cd path\to\adrishya\build-host
   vagrant up
   ```

   The first run downloads a Debian box and takes a while. The repository is
   shared into the guest at `/adrishya`.

3. Log into the VM and build:

   ```
   vagrant ssh
   cd /adrishya
   ./scripts/fetch-tor-browser.sh 14.5.7
   sudo ./build.sh
   ```

4. The finished ISO appears in the `adrishya` folder on your Windows machine
   (it is a shared folder), in the repository root.

If `vagrant up` complains the box `generic/debian13` is unavailable, edit the
`config.vm.box` line in the `Vagrantfile` to a Debian box your provider has, such
as `generic/debian12`, and run `vagrant up` again.

## Option 2 - VirtualBox + a Debian VM, by hand

Use this if you would rather not install Vagrant.

1. Install **VirtualBox**.
2. Download a Debian 13 install ISO from debian.org and create a VM: about 4 GB
   RAM, 20 GB disk, default settings otherwise. Install Debian into it.
3. Inside the VM, install the build tools:

   ```
   sudo apt update
   sudo apt install -y live-build git gnupg curl ca-certificates
   ```

4. Get the `adrishya` folder into the VM. Easiest is a VirtualBox shared folder
   (**Devices > Shared Folders > Add**), or copy it in over the network.
5. Build:

   ```
   cd /path/to/adrishya
   ./scripts/verify.sh
   ./scripts/fetch-tor-browser.sh 14.5.7
   sudo ./build.sh
   ```

## Option 3 - QEMU on Windows

Possible but fiddlier, and not recommended over the two above. Install QEMU for
Windows, then run `build-host/qemu-build.sh` from **Git Bash** or inside WSL. The
script defaults to KVM acceleration, which Windows does not have; set the
accelerator explicitly:

```
ACCEL=whpx ./build-host/qemu-build.sh      # or ACCEL=tcg (slow, no special setup)
```

QEMU's 9p file sharing is less reliable on Windows than VirtualBox's shared
folders, which is the main reason to prefer Options 1 or 2.

## Why not WSL2

WSL2 runs a real Linux kernel and gives you `apt` and `bash`, so it looks
promising. In practice `live-build` usually fails there: loop devices and
`mount` are restricted, and the build errors out partway. Use a full VM.

## Writing the finished ISO to a USB stick

Do this on Windows once the ISO is built:

- **Rufus** - select the ISO, select the USB drive, click Start. Make sure the
  target is "DD image" mode if asked.
- **balenaEtcher** - pick the ISO, pick the drive, Flash.
- **Ventoy** - copy the ISO onto a Ventoy-formatted stick; no re-flashing.

Double-check you selected the USB drive and not a hard disk. Writing the ISO
erases whatever is on the target device.

Then boot the target machine from the USB stick and run the checklist in
`tests/smoke-test.md` before trusting the system with anything.

## Quick reference

| I want to... | Do this |
|---|---|
| Just read the design | Open the design-spec PDF |
| Check the source is sound | `./scripts/verify.sh` in a Linux VM (no root needed) |
| Build the ISO | Options 1 or 2 above, then `sudo ./build.sh` |
| Put it on a USB stick | Rufus or balenaEtcher on Windows |
| Test it | `tests/smoke-test.md` on real hardware |
