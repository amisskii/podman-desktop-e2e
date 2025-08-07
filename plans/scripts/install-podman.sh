#!/bin/bash
set -eu

COMPOSE_VERSION="fc$(echo "$COMPOSE" | cut -d '-' -f 2)"
CUSTOM_PODMAN_URL="https://kojipkgs.fedoraproject.org//packages/podman/${PODMAN_VERSION}/1.${COMPOSE_VERSION}/${ARCH}/podman-${PODMAN_VERSION}-1.${COMPOSE_VERSION}.${ARCH}.rpm"

if [[ $PODMAN_VERSION == "latest" ]]; then
    sudo dnf install -y podman
else
    curl -Lo podman.rpm "$CUSTOM_PODMAN_URL"
    sudo dnf install -y ./podman.rpm
    rm -f podman.rpm
fi

INSTALLED_PODMAN_VERSION="$(podman --version | cut -d ' ' -f 3)"

if [[ $INSTALLED_PODMAN_VERSION != $PODMAN_VERSION ]]; then
    echo "Podman version mismatch: expected $PODMAN_VERSION but got $INSTALLED_PODMAN_VERSION"
    exit 1
fi
