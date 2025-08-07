#!/bin/bash
set -eu
sudo dnf repolist
COMPOSE_VERSION="fc$(echo "$COMPOSE" | cut -d '-' -f 2)"
CUSTOM_PODMAN_URL="https://kojipkgs.fedoraproject.org//packages/podman/${PODMAN_VERSION}/1.${COMPOSE_VERSION}/${ARCH}/podman-${PODMAN_VERSION}-1.${COMPOSE_VERSION}.${ARCH}.rpm"

if [[ $PODMAN_VERSION == "latest" ]]; then
    sudo dnf remove podman
    sudo dnf install podman --disablerepo=testing-farm-tag-repository
    sudo dnf install -y podman
    echo "??????????"
    podman --version
else
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    echo $CUSTOM_PODMAN_URL
    curl -Lo podman.rpm "$CUSTOM_PODMAN_URL"
    sudo dnf install -y ./podman.rpm
    rm -f podman.rpm
fi
