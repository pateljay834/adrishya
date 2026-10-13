# Adrishya build and release targets.
SHELL := /bin/bash
VERSION := $(shell cat VERSION 2>/dev/null || echo 0.0.0)

.PHONY: all build verify sbom sign release clean fetch-tor-browser pin help

all: build

help:
	@echo "make build                       - build the ISO (needs root)"
	@echo "make verify                      - run repository self-checks (no root)"
	@echo "make release                     - verify, build, sign, and SBOM"
	@echo "make fetch-tor-browser V=14.5.7  - download+verify Tor Browser"
	@echo "make pin T=20261012T000000Z      - pin the Debian snapshot"
	@echo "make sbom                        - generate a CycloneDX SBOM"
	@echo "make sign ISO=adrishya-*.iso     - sign the ISO"
	@echo "make clean                       - purge the build tree"

build:
	sudo ./build.sh

verify:
	./scripts/verify.sh

release: verify
	@echo "[*] building Adrishya $(VERSION)"
	sudo ./build.sh
	./scripts/sign-iso.sh "$$(ls -1 adrishya-*.iso | head -1)"
	./scripts/make-sbom.sh || echo '[i] SBOM skipped (install syft)'
	@echo "[+] release artifacts ready: ISO, .sha256, .asc, SBOM"

fetch-tor-browser:
	@test -n "$(V)" || { echo "set V=<version>, e.g. make fetch-tor-browser V=14.5.7"; exit 2; }
	./scripts/fetch-tor-browser.sh "$(V)"

pin:
	@test -n "$(T)" || { echo "set T=<snapshot timestamp>"; exit 2; }
	./scripts/pin-snapshot.sh "$(T)"

sbom:
	./scripts/make-sbom.sh

sign:
	@test -n "$(ISO)" || { echo "set ISO=<path>"; exit 2; }
	./scripts/sign-iso.sh "$(ISO)"

clean:
	sudo lb clean --purge || true
