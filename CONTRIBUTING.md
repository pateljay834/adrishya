# Contributing to Adrishya

## Before you start

Read `docs/THREAT-MODEL.md`. Every change is judged against it: does it keep the
default path safe, keep the system amnesic, and keep non-Tor egress blocked?

## Workflow

1. Run `./scripts/verify.sh` - it must pass before you open a merge request.
2. Keep changes small and reviewable. A security change with no rationale will
   be sent back.
3. Update `docs/THREAT-MODEL.md` if your change alters the threat model.

## Style

- Shell scripts: `#!/usr/bin/env bash`, `set -euo pipefail`, quote variables.
- Hooks: numbered prefixes, one concern per hook.
- Prefer upstreaming fixes to Tails or Debian over maintaining a private fork.

## What we especially want

- Packaging Tails' hardening patches onto the Debian 13 base.
- Indic localisation QA (22 scheduled languages).
- Reproducible-build verification by independent builders.
- An independent security audit.
