#!/bin/bash
# Main Install Script

set -euo pipefail

# Constants
REMOTE_PATH=https://raw.githubusercontent.com/vesperrin/ubuntu-studio-setup/refs/heads/main/scripts

# shellcheck disable=SC1090
source <(curl -fsSL "${REMOTE_PATH}/install.sh")

# curl -sSL "${REMOTE_PATH}/install-syncthing.sh" | sudo bash -s --

curl -sSL "${REMOTE_PATH}/install-wine.sh" | sudo bash -s --
# curl -sSL "${REMOTE_PATH}/install-wine-mono.sh" | sudo bash -s --
# curl -sSL "${REMOTE_PATH}/install-yabridge.sh" | sudo bash -s --

# curl -sSL "${REMOTE_PATH}/install-studio-one.sh" | sudo bash -s --
# curl -sSL "${REMOTE_PATH}/install-vcv-rack.sh" | sudo bash -s --
# curl -sSL "${REMOTE_PATH}/install-pulse.sh" | sudo bash -s --
# curl -sSL "${REMOTE_PATH}/install-cableguys-shaperbox.sh" | sudo bash -s --
