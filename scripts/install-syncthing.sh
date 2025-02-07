#!/bin/bash

SYNCTHING_KEY_URL="https://syncthing.net/release-key.gpg"
SYNCTHING_REPO_COMPONENTS="https://apt.syncthing.net/ syncthing stable"

install_syncthing() {
    log_install "Syncthing"

    add_apt_repository \
        --key-url "${SYNCTHING_KEY_URL}" \
        --repo-components "${SYNCTHING_REPO_COMPONENTS}" \
        --service-name "syncthing"

    # Install and configure
    install_dependencies syncthing
    configure_service "syncthing@${USER}.service"

    # Firewall configuration
    if command -v ufw >/dev/null; then
        echo "🔓 Configuring firewall..."
        sudo ufw allow syncthing
        sudo ufw reload
    fi

    log_install_complete "Syncthing"
}
