#!/bin/bash
# Syncthing Auto-Installer for Linux
set -euo pipefail

SYNCTHING_KEY_URL="https://syncthing.net/release-key.gpg"
SYNCTHING_REPO="https://apt.syncthing.net/"
KEYRING_DIR="/etc/apt/keyrings"
REPO_FILE="/etc/apt/sources.list.d/syncthing.list"

main() {
    echo "🔧 Configuring system..."
    
    # Create keyring directory
    echo "🔑 Adding release PGP keys..."
    sudo mkdir -p "${KEYRING_DIR}"
    sudo curl -L -o "${KEYRING_DIR}/syncthing-archive-keyring.gpg" "${SYNCTHING_KEY_URL}"

    # Add repository
    echo "📦 Adding Syncthing repository..."
    echo "deb [signed-by=${KEYRING_DIR}/syncthing-archive-keyring.gpg] ${SYNCTHING_REPO} syncthing stable" | \
        sudo tee "${REPO_FILE}" >/dev/null

    # Update and install
    echo "🔄 Updating package lists..."
    sudo apt-get update -y
    
    echo "📦 Installing Syncthing..."
    sudo apt-get install -y syncthing

    # Configure systemd service
    echo "⚙️ Configuring Syncthing service..."
    sudo systemctl enable "syncthing@${USER}.service"
    sudo systemctl start "syncthing@${USER}.service"

    # Open firewall ports
    echo "🔓 Configuring firewall..."
    if command -v ufw >/dev/null; then
        sudo ufw allow syncthing
        sudo ufw reload
    fi
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    if [ "$(id -u)" -ne 0 ]; then
        exec sudo -E "$0" "$@"
    fi
    main
fi
