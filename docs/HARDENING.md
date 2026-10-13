# Adrishya hardening patch series

These changes move Adrishya past "a live Debian with Tor" toward the hardening
Tails applies. Each is a separate commit; run `git log --oneline` to see them and
`ls patches/` for the exported `format-patch` files.

## 1. Kernel command line
Adds `slab_nomerge init_on_alloc=1 init_on_free=1 page_alloc.shuffle=1
randomize_kstack_offset=on vsyscall=none debugfs=off oops=panic
lockdown=confidentiality`. `init_on_free=1` zeroes freed memory, which also
hardens the amnesia story. `lockdown=confidentiality` blocks kernel interfaces
that could leak memory to userspace.

## 2. systemd sandboxing drop-ins
Tor and nftables run with `NoNewPrivileges`, `ProtectSystem=strict`,
`ProtectHome`, `MemoryDenyWriteExecute`, a `SystemCallFilter`, and a minimal
capability set. A compromised Tor or firewall process is contained.

## 3. GNOME privacy lockdown
Disables recent files, external search providers, location services, and
thumbnailers, and locks the settings so an app cannot re-enable them. Fewer
forensic traces and less metadata leakage.

## 4. AppArmor profile for Tor Browser
Ships in **complain** mode so you tune it from real logs before enforcing.
Explicitly denies reads of `/etc/shadow`, `~/.ssh`, and `~/.gnupg`.

## 5. Coredumps and extra sysctls
Core dumps are disabled entirely (`Storage=none`), and `kernel.panic_on_oops`,
`bpf_jit_harden=2`, and `dev.tty.ldisc_autoload=0` are set.

## Applying / reverting

The changes are already applied in this tree. To re-apply them elsewhere:

```sh
git am patches/*.patch
```

## Honest limits

- Hardening is not the same as security. Without an audit and years of review,
  none of this makes Adrishya as trustworthy as Tails.
- The AppArmor profile is a starting point, not a finished one.
- Test every change on hardware; several of these can break hardware support.
