#!/bin/bash

REPO_DIR="$1"
PKG="$2"

[[ -n "$REPO_DIR" ]] && [[ -n "$PKG" ]] || { echo "Please specify a repository URL and a package" && exit 1; }
wget "$REPO_DIR"/Release.key -O /tmp/key
echo "Get the release key"
gpg --import /tmp/key
wget "$REPO_DIR"/Release -O /tmp/Release
echo "Get the release"
wget "$REPO_DIR"/Release.gpg -O /tmp/Release.gpg
echo "Get the release file signature"
gpg --verify /tmp/Release.gpg /tmp/Release || { echo "Bad release signature" && exit 1; }
echo "Release file verified"

PACKAGES_CHECKSUM=$(sed -z < /tmp/Release 's/.*SHA256\(.*\)/\1/' | grep Packages$ | awk '{print $1;}')
echo "$PACKAGES_CHECKSUM /tmp/Packages" > /tmp/checksum
wget "$REPO_DIR"/Packages -O /tmp/Packages
sha256sum -c /tmp/checksum || { echo "Bad Packages checksum" && exit 1; }
echo "Packages file verified"

