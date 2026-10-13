#!/usr/bin/env bash
# Adrishya repository self-checks. Runs without root and without live-build.
# Exits non-zero if any check fails.
set -u

fail=0
ok()   { printf '  \033[32mOK\033[0m    %s\n' "$1"; }
bad()  { printf '  \033[31mFAIL\033[0m  %s\n' "$1"; fail=1; }
head_(){ printf '\n== %s ==\n' "$1"; }

head_ "Shell syntax"
while IFS= read -r f; do
    if bash -n "$f" 2>/dev/null; then ok "syntax: $f"; else bad "syntax: $f"; fi
done < <(find . -type f ! -path './.git/*' \( -name '*.sh' -o -name '*.hook.chroot' -o -path './auto/*' \) | sort)

head_ "Required files"
for f in \
    auto/config build.sh Makefile \
    config/package-lists/adrishya-tor.list.chroot \
    config/includes.chroot/etc/nftables.conf \
    config/includes.chroot/etc/sysctl.d/99-adrishya-hardening.conf \
    scripts/fetch-tor-browser.sh scripts/sign-iso.sh; do
    [ -e "$f" ] && ok "present: $f" || bad "missing: $f"
done

head_ "Firewall policy"
if grep -q 'hook output priority filter; policy drop' config/includes.chroot/etc/nftables.conf; then
    ok "output chain default-deny"
else
    bad "output chain is not default-deny"
fi
if grep -q 'skuid debian-tor' config/includes.chroot/etc/nftables.conf; then
    ok "only the tor uid may egress"
else
    bad "tor uid is not the sole egress rule"
fi

head_ "Amnesia and Tor defaults"
grep -q 'nopersistence' auto/config && ok "boot params disable persistence" || bad "nopersistence missing"
grep -q 'TransPort 9040' config/hooks/live/0100-adrishya-tor-default.hook.chroot && ok "Tor transparent proxy configured" || bad "Tor TransPort missing"
grep -q 'Storage=volatile' config/hooks/live/0100-adrishya-tor-default.hook.chroot && ok "journald volatile" || bad "journald not volatile"

head_ "Hardening present"
grep -q "init_on_free=1" auto/config && ok "kernel cmdline hardened" || bad "kernel cmdline hardening missing"
grep -q "lockdown=confidentiality" auto/config && ok "kernel lockdown enabled" || bad "kernel lockdown missing"
[ -f config/includes.chroot/etc/systemd/system/tor.service.d/10-adrishya-sandbox.conf ] && ok "tor sandbox drop-in" || bad "tor sandbox drop-in missing"
[ -f config/includes.chroot/etc/dconf/db/local.d/00-adrishya-privacy ] && ok "GNOME privacy lockdown" || bad "privacy lockdown missing"

head_ "Hook ordering"
hooks=$(ls config/hooks/live/*.hook.chroot 2>/dev/null | wc -l)
[ "$hooks" -ge 5 ] && ok "$hooks hooks present" || bad "expected at least 5 hooks, found $hooks"

printf '\n'
if [ "$fail" -eq 0 ]; then
    printf '\033[32mALL CHECKS PASSED\033[0m - repository is structurally sound.\n'
    printf 'Note: this does NOT build or test the ISO. See docs/BUILDING.md.\n'
else
    printf '\033[31mCHECKS FAILED\033[0m - fix the items above.\n'
fi
exit $fail
