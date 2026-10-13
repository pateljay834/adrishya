# Adrishya threat model

## In scope

- A local network observer (Wi-Fi, hotel, ISP) correlating traffic and device
  identifiers.
- ISP-level deep packet inspection and censorship, including intermittent
  blocking of Tor.
- Forensic analysis of the machine after shutdown.
- Malicious websites and documents.
- Theft of the USB stick, including when it carries persistent data.

## Out of scope

- Hardware implants, compromised firmware, or baseboard management controllers.
- A keylogger or malware already resident on the host machine or keyboard.
- A global passive adversary able to observe a large fraction of Tor traffic.
- An attacker with physical access during the session.

These are out of scope for Tails too. Adrishya inherits the same boundary rather
than pretending to cross it.

## Design principles

- **Secure by default** - the safe path is the default path.
- **Amnesic unless opted in** - nothing persists without explicit configuration.
- **No traffic without Tor** - non-Tor egress is dropped, not discouraged.
- **Minimal surface** - unused protocols, filesystems, and services removed.
- **Verifiable** - the ISO is reproducible and signed.

## Residual risks

- **No adversarial review yet.** This is the dominant risk. A new codebase starts
  at zero trust; Tails has had 17 years of review. Mitigate by forking Tails'
  components, upstreaming fixes, and commissioning an audit before high-stakes
  use.
- **RAM-wipe completeness.** Firmware may retain memory. Treat the wipe as
  defence-in-depth, and say so in user documentation.
- **Tor is not magic.** A user who logs into a personal account while browsing
  anonymously deanonymises themselves regardless of the OS.
