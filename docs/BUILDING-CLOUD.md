# Building Adrishya in the cloud (no Linux machine needed)

If you are on Windows (or any machine you would rather not install Linux on),
you do not need a local VM. Let someone else's Linux machine do the build: push
the source to a git host, let its CI build the ISO, and download the result.
GitHub Actions is free for public repositories.

This is the same thing as a local build - the runner is a full Ubuntu VM with
root and loop devices - just somewhere else. You end up with the ISO file on
your Windows desktop, which is all you actually wanted.

## Steps

1. **Make a repository.** Create a new (public) repository on GitHub.

2. **Push the source.** The repository root must be the *contents* of the
   `adrishya` folder, not the folder itself. From inside `adrishya`:

   ```sh
   git init
   git add .
   git commit -m "Adrishya"
   git branch -M main
   git remote add origin https://github.com/YOUR-NAME/adrishya.git
   git push -u origin main
   ```

   (Run those in a Linux shell - Git Bash on Windows works for the git part.)

3. **Run the build.** Open the repository's **Actions** tab, pick **build-iso**,
   and click **Run workflow**. The workflow verifies the tree, downloads and
   GPG-verifies Tor Browser, builds the ISO, and uploads it.

4. **Download the ISO.** When the run finishes (10-30 minutes), open the run and
   download the **adrishya-iso** artifact. Unzip it to get the `.iso` and its
   checksum.

5. **Write it to a USB stick** with Rufus or balenaEtcher on Windows, then boot
   the target machine and run `tests/smoke-test.md`.

## The workflow file

It is `.github/workflows/build.yml`. The parts worth knowing:

- It runs on `ubuntu-latest`, which is a full VM - root and loop devices work,
  which is exactly what WSL2 lacks.
- It frees disk space first, because a live ISO build needs room.
- It triggers on a manual run or on a `v*` tag.

## Honest limits

- GitHub-hosted runners have disk and time limits. This workflow should fit, but
  if the build runs out of space, extend the "Free up disk space" step.
- The build is reproducible only if you pin the Debian snapshot (see
  `scripts/pin-snapshot.sh`); otherwise two runs can differ.
- A cloud build is no more trustworthy than any other build until you verify the
  checksum and, ideally, rebuild it yourself. That is the point of the signing
  and SBOM tooling in `scripts/`.

## Other CI systems

`.gitlab-ci.yml` does the same on GitLab CI, which needs a runner tagged
`privileged`. Any Linux CI with root and loop devices will work.
