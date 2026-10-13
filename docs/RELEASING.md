# Publishing the Adrishya website and releases

## The website (GitHub Pages)

`docs/release/index.html` is the release page. It is a single self-contained
file - the logo and wallpaper are embedded - so it needs no build step.

1. Push the repository to GitHub with `main` as the default branch.
2. In the repository, open **Settings > Pages** and set **Source** to
   **GitHub Actions**.
3. The `pages` workflow (`.github/workflows/pages.yml`) publishes `docs/release/`
   on every push to `main` that touches it, or on a manual run.
4. Your site appears at `https://YOUR-NAME.github.io/adrishya/`.

To edit the page, change `docs/release/index.html` (or regenerate it with the
branding assets) and push.

## Cutting a release

1. Build and verify the ISO (see `BUILDING.md` or `BUILDING-CLOUD.md`).
2. Sign it: `./scripts/sign-iso.sh adrishya-*.iso`.
3. Generate the SBOM: `make sbom`.
4. Tag the repository: `git tag v1.0 && git push origin v1.0`. This triggers the
   `build-iso` workflow.
5. Attach the ISO, its checksum, the signature, and the SBOM to a GitHub
   Release for that tag.

## What a user verifies

```sh
sha256sum -c adrishya-1.0.iso.sha256
gpg --verify adrishya-1.0.iso.asc
```

Publish the signing key fingerprint on the site so users can check the signature
against something they trust.
