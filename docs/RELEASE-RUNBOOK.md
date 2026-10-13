# Release runbook - cutting Adrishya v0.1.0

From the source you have now to a published release, on a Windows laptop, with
no Linux installed. Follow it top to bottom. Steps marked *(once)* happen one
time only.

## Phase 0 - Prep (once)

1. Install **Git for Windows** (gives you "Git Bash"). Install **7-Zip** or use
   Windows' built-in extractor.
2. Create a free **GitHub** account if you do not have one.
3. Extract `Adrishya-OS-source.zip`. You get an `adrishya` folder.

## Phase 1 - Publish the source

Open **Git Bash**, `cd` into the `adrishya` folder, and run:

```sh
git init
git add .
git commit -m "Adrishya 0.1.0"
git branch -M main
git remote add origin https://github.com/YOUR-NAME/adrishya.git
git push -u origin main
```

Create the empty repository on GitHub first (no README, no .gitignore).

**Check:** `./scripts/verify.sh` should print ALL CHECKS PASSED. Run it here if
you have not already - it catches problems before you spend time building.

## Phase 2 - Turn on the website (once)

In the GitHub repository: **Settings > Pages > Source = GitHub Actions**.
The `pages` workflow publishes `docs/release/` to
`https://YOUR-NAME.github.io/adrishya/` on the next push.

## Phase 3 - Build the ISO in the cloud

1. Open the repository's **Actions** tab.
2. Select **build-iso** and click **Run workflow**.
3. Wait 10-30 minutes. The job verifies the tree, downloads and GPG-verifies
   Tor Browser, builds the ISO, and uploads it.
4. Open the finished run and download the **adrishya-iso** artifact. Unzip it.

**If it fails**, that is normal for a first build. Open the failed step and read
the last 30 lines. The usual causes: disk space (extend the "Free up disk space"
step), a package name that moved (edit the `.list.chroot` files), or a Tor
Browser version that no longer exists (pass a current one).

## Phase 4 - Verify what you built

On your Windows machine, in Git Bash:

```sh
sha256sum -c adrishya-*.iso.sha256
```

A cloud build is no more trustworthy than any other until you check it. For a
stronger check, rebuild and compare the checksums - identical inputs must give
identical bytes.

## Phase 5 - Test on hardware

1. Write the ISO to a USB stick with **Rufus** or **balenaEtcher**.
2. Boot the target machine from the stick.
3. Work through `tests/smoke-test.md`. At minimum: it boots, nothing leaves
   without Tor, nothing is written to internal disks, and the RAM wipe runs.

## Phase 6 - Publish the release

1. Tag the commit and push the tag (this re-runs `build-iso`):

   ```sh
   git tag v0.1.0
   git push origin v0.1.0
   ```

2. On GitHub, go to **Releases > Draft a new release**, pick the `v0.1.0` tag,
   and attach: the `.iso`, the `.iso.sha256`, the `.iso.asc` (if you signed it),
   and the SBOM.
3. Publish. The site's download links can now point at the release page.

## What "done" looks like

- A green `build-iso` run and a downloaded ISO.
- A passing smoke test on real hardware.
- A `v0.1.0` release with the ISO, its checksum, and the SBOM attached.
- The website live at your GitHub Pages URL.

## Honest limits

- This is a *first* release of a young project, not a hardened product. It has
  not been audited. Say so in the release notes.
- Do not market it as "more secure than Tails" - it is not, yet. What it is:
  a Tails-class design with our own hardening, identity, and Indic focus.
- The strongest next step is not more features; it is getting people to build
  it, break it, and report what they find.
