#!/bin/bash
set -eu

# Uninstall a preinstalled Podman version to ensure the desired version will be installed.
sudo dnf remove -y podman

# Construct the download URL for the specific Podman version.
COMPOSE_VERSION="fc$(echo "$COMPOSE" | cut -d '-' -f 2)"
CUSTOM_PODMAN_URL="https://kojipkgs.fedoraproject.org//packages/podman/${PODMAN_VERSION}/1.${COMPOSE_VERSION}/${ARCH}/podman-${PODMAN_VERSION}-1.${COMPOSE_VERSION}.${ARCH}.rpm"

# Install Podman based on the requested version:
#   - "nightly": install the latest nightly build from the rhcontainerbot/podman-next COPR repository
#   - "latest": install the latest stable release from the official Fedora repositories
#   - any other version string: download and install the matching RPM directly from Fedora Koji
if [[ "$PODMAN_VERSION" == "nightly" ]]; then
    sudo dnf install -y podman --enablerepo=copr:copr.fedorainfracloud.org:rhcontainerbot:podman-next
elif [[ "$PODMAN_VERSION" == "latest" ]]; then
    sudo dnf install -y podman --disablerepo=testing-farm-tag-repository
    PODMAN_VERSION="$(curl -s https://api.github.com/repos/containers/podman/releases/latest | jq -r .tag_name | sed 's/^v//')"
else
    curl -Lo podman.rpm "$CUSTOM_PODMAN_URL"
    sudo dnf install -y ./podman.rpm
    rm -f podman.rpm
fi

# Verify that the installed Podman version matches the expected version. 
INSTALLED_PODMAN_VERSION="$(podman --version | cut -d ' ' -f 3)"
NORMALIZED_PODMAN_VERSION="${PODMAN_VERSION//\~/-}"

if [[ "$INSTALLED_PODMAN_VERSION" != "$NORMALIZED_PODMAN_VERSION" ]]; then
    echo "Podman version mismatch: expected $NORMALIZED_PODMAN_VERSION but got $INSTALLED_PODMAN_VERSION"
    exit 1
fi

echo "Podman installed successfully: $INSTALLED_PODMAN_VERSION"
