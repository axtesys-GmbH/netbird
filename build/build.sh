#!/usr/bin/env bash

export DOCKER_BUILDKIT=1
# Ensure QEMU emulation is available for cross-platform builds
docker run --privileged --rm tonistiigi/binfmt --install all

rm -rf dist && mkdir dist
docker build --force-rm -t local/netbird-releaser -f build/Base.Dockerfile --target=builder .
docker run --rm -v "/var/run/docker.sock:/var/run/docker.sock" -v "$(pwd)/dist:/app/dist" local/netbird-releaser --skip=publish,announce
# JENKINS SPECIAL: Fix permissions for the generated files (docker group)
docker run --rm -v "$(pwd)/dist:/app/dist" busybox sh -c "chgrp -R 987 /app/dist/ && chmod -R g+w /app/dist/"
docker build --force-rm -t local/netbird-releaser-ui -f build/UI.Dockerfile --output=./dist .
docker build --force-rm -t local/netbird-releaser-ui -f build/UI_Darwin.Dockerfile --output=./dist .

# get git tag
GIT_TAG=$(git describe --tags --abbrev=0)
# Strip leading 'v' if present
GIT_TAG=${GIT_TAG#v}
# strip everything after first hyphen
GIT_TAG=${GIT_TAG%%-*}
# add .0 to the end
GIT_TAG="${GIT_TAG}.0"
docker build --force-rm -t local/netbird-releaser-wininstall --build-arg APPVER=$GIT_TAG -f build/WinInstaller.Dockerfile --output=./dist .
