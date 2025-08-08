#!/bin/bash
set -eu
echo "REMOVING PODMAN!!!"
sudo dnf remove -y podman
COMPOSE_VERSION="fc$(echo "$COMPOSE" | cut -d '-' -f 2)"
CUSTOM_PODMAN_URL="https://kojipkgs.fedoraproject.org//packages/podman/${PODMAN_VERSION}/1.${COMPOSE_VERSION}/${ARCH}/podman-${PODMAN_VERSION}-1.${COMPOSE_VERSION}.${ARCH}.rpm"

if [[ $PODMAN_VERSION == "latest" ]]; then
    sudo dnf install -y podman --disablerepo=testing-farm-tag-repository
    PODMAN_VERSION="$(curl -s https://api.github.com/repos/containers/podman/releases/latest | jq -r .tag_name | sed 's/^v//')"
else
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    echo $CUSTOM_PODMAN_URL
    curl -Lo podman.rpm "$CUSTOM_PODMAN_URL"
    sudo dnf install -y ./podman.rpm
    rm -f podman.rpm
    echo "TEST!!!!"
    podman --version
fi

INSTALLED_PODMAN_VERSION="$(podman --version | cut -d ' ' -f 3)"
echo "Podman version: $INSTALLED_PODMAN_VERSION!"


if [[ "$INSTALLED_PODMAN_VERSION" != "$PODMAN_VERSION" ]]; then
    echo "Podman version mismatch: expected $PODMAN_VERSION but got $INSTALLED_PODMAN_VERSION"
    exit 1
fi
