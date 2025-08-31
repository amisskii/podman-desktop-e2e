#!/bin/bash
set -e

if ! dnf repolist | grep -q "docker-ce"; then
    sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
fi

if ! command -v docker &> /dev/null; then
    sudo dnf install -y docker-ce docker-ce-cli containerd.io
else
    echo "Docker already installed, skipping..."
fi

sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER
