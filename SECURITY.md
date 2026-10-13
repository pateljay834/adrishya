# Security policy

Adrishya is a security tool, so security reports get priority.

## Reporting

Do **not** open a public issue for a vulnerability. Report privately to the
maintainers (contact address to be published) with: a description, affected
component, reproduction steps, and impact.

## Scope and honest limitations

Adrishya has not yet had an independent security audit. Until it has, do not
rely on it for high-stakes anonymity. The threat model and its residual risks
are documented in `docs/THREAT-MODEL.md` - read it before trusting the system
with anything that matters.

## Supply chain

- Pin the Debian snapshot for builds (`scripts/pin-snapshot.sh`).
- Bundle Tor Browser only after GPG-verifying it (`scripts/fetch-tor-browser.sh`).
- Sign releases and publish checksums plus an SBOM (`make sign`, `make sbom`).
