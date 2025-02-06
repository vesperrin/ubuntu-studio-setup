#!/bin/bash
# Wine Installer for Ubuntu

set -euo pipefail

WINE_KEY_URL="https://dl.winehq.org/wine-builds/winehq.key"
WINE_SOURCES_BASE="https://dl.winehq.org/wine-builds/ubuntu/dists"

create_keyring_dir() {
    echo "🔐 Creating keyring directory..."
    sudo mkdir -pm755 /etc/apt/keyrings || die "Failed to create keyring directory"
}

install_wine_key() {
    echo "🔑 Installing WineHQ repository key..."
    sudo wget -qO /etc/apt/keyrings/winehq-archive.key "${WINE_KEY_URL}" ||
        die "Failed to download repository key"
}

add_wine_sources() {
    local codename="$1"
    local sources_file="winehq-${codename}.sources"
    local sources_url="${WINE_SOURCES_BASE}/${codename}/${sources_file}"

    echo "📥 Adding repository sources..."
    sudo wget -qNP /etc/apt/sources.list.d/ "${sources_url}" ||
        die "Failed to add repository sources"
}

setup_winehq_repository() {
    local distro_codename
    distro_codename="$(get_distro_codename)"

    echo "🔧 Configuring WineHQ repository..."

    create_keyring_dir
    install_wine_key
    add_wine_sources "${distro_codename}"
}

install_wine() {
    echo "🍷 Beginning Wine installation..."

    # System preparation
    sudo dpkg --add-architecture i386 || die "Failed to enable 32-bit architecture"

    setup_winehq_repository

    # Install packages
    echo "🔄 Updating package lists..."
    sudo apt-get update -y || die "Package list update failed"

    echo "📦 Installing Wine..."
    sudo apt-get install -y --install-recommends winehq-staging ||
        die "Wine installation failed"

    # Post-install setup
    configure_wine

    echo -e "\n✅ Wine installation complete!"
    echo "Version: $(wine --version)"
}
