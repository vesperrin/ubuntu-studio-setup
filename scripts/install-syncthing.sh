#!/bin/bash

SYNCTHING_KEY_URL="https://syncthing.net/release-key.gpg"
SYNCTHING_REPO_COMPONENTS="https://apt.syncthing.net/ syncthing stable"

install_syncthing() {
    add_apt_repository \
        "${SYNCTHING_KEY_URL}" \
        "${SYNCTHING_REPO_COMPONENTS}" \
        "syncthing"

    # Install and configure
    install_dependencies syncthing
    configure_service "syncthing@${USER}.service"

    # Firewall configuration
    if command -v ufw >/dev/null; then
        echo "🔓 Configuring firewall..."
        sudo ufw allow syncthing
        sudo ufw reload
    fi

    echo -e "${GREEN}✅ Syncthing installation complete!${NC}"
}