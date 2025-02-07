#!/bin/bash

# Constants
STUDIO_ONE_DEB_URL="https://drive.usercontent.google.com/download?id=1t7-rjngrJ8xEV3t0GNlfOww7rNZK7ZhH&export=download&authuser=0&confirm=t&uuid=0cb9362b-c5b4-4389-a3d5-f2f81a18d47a&at=AIrpjvPwHpyXEfphUUDUbdGqZDJd%3A1738798478594"

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
    log_install "Studio One"

    configure_studio_one_audio

    # Set non-interactive frontend for apt
    export DEBIAN_FRONTEND=noninteractive

    local temp_deb="${TEMPDIR}/studio-one.deb"
    safe_download --url "${STUDIO_ONE_DEB_URL}" --dest "${temp_deb}"
    install_deb "${temp_deb}"

    log_install_complete "Studio One"
}
