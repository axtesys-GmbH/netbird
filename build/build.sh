#!/usr/bin/env bash

export DOCKER_BUILDKIT=1

#rm -rf dist && mkdir dist
#docker build --force-rm -t local/netbird-releaser -f build/Base.Dockerfile --output=./dist .
#docker build --force-rm -t local/netbird-releaser-ui -f build/UI.Dockerfile --output=./dist .
docker build --force-rm -t local/netbird-releaser-ui -f build/UI_Darwin.Dockerfile --output=./dist .
#docker build --force-rm -t local/netbird-releaser-wininstall -f build/WinInstaller.Dockerfile --output=./dist .
