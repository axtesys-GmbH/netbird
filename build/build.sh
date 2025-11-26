#!/usr/bin/env bash

export DOCKER_BUILDKIT=1
# Ensure QEMU emulation is available for cross-platform builds
docker run --privileged --rm tonistiigi/binfmt --install all

rm -rf dist && mkdir dist
docker build --force-rm -t local/netbird-releaser -f build/Base.Dockerfile --target=builder .
docker run --rm -v "/var/run/docker.sock:/var/run/docker.sock" -v "$(pwd)/dist:/app/dist" local/netbird-releaser --skip=publish,announce
#docker build --force-rm -t local/netbird-releaser -f build/Base.Dockerfile --output=./dist .
docker build --force-rm -t local/netbird-releaser-ui -f build/UI.Dockerfile --output=./dist .
docker build --force-rm -t local/netbird-releaser-ui -f build/UI_Darwin.Dockerfile --output=./dist .
docker build --force-rm -t local/netbird-releaser-wininstall -f build/WinInstaller.Dockerfile --output=./dist .
