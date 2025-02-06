#!/bin/bash

# Constants
DEB_URL="https://drive.usercontent.google.com/download?id=1t7-rjngrJ8xEV3t0GNlfOww7rNZK7ZhH&export=download&authuser=0&confirm=t&uuid=0cb9362b-c5b4-4389-a3d5-f2f81a18d47a&at=AIrpjvPwHpyXEfphUUDUbdGqZDJd%3A1738798478594"

configure_studio_one_audio() {
    echo "🔧 Configuring audio subsystem..."
    sudo groupadd -f audio
    sudo usermod -a -G audio "${SUDO_USER:-$USER}"

    sudo tee /etc/security/limits.d/audio.conf >/dev/null <<EOF
@audio   -  rtprio     95
@audio   -  memlock    unlimited
EOF
}

install_studio_one() {
    echo "🎹 Installing Studio One Pro 7..."

    setup_tempdir
    configure_studio_one_audio

    # Set non-interactive frontend for apt
    export DEBIAN_FRONTEND=noninteractive

    # Download and install Studio One
    local temp_deb="${TEMPDIR}/studio-one.deb"
    safe_download "${DEB_URL}" "${temp_deb}"
    install_deb "${temp_deb}"

    echo -e "${GREEN}✅ Studio One Pro 7 installation complete!${NC}"
}