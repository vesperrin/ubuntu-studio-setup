#!/bin/bash

SYNCTHING_KEY_URL="https://syncthing.net/release-key.gpg"
SYNCTHING_REPO="deb [signed-by=/etc/apt/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing stable"

install_syncthing() {
    add_repository "$SYNCTHING_KEY_URL" "$SYNCTHING_REPO"
    install_dependencies syncthing
    configure_service "syncthing@${USER}.service"

    if command -v ufw >/dev/null; then
        echo "🔓 Configuring firewall..."
        sudo ufw allow syncthing
        sudo ufw reload
    fi

    echo -e "${GREEN}✅ Syncthing installation complete!${NC}"
}