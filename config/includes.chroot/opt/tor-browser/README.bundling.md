# Tor Browser bundling

This directory is populated at build time by `scripts/fetch-tor-browser.sh`,
which downloads the Tor Browser bundle and verifies its GPG signature before
staging it here. Do not commit the browser binary to git.

Run before building:

```sh
./scripts/fetch-tor-browser.sh 14.5.7
```

Verify the version against https://www.torproject.org/download/ and the signing
key fingerprint from a trusted source.
