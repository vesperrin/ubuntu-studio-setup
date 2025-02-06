#!/bin/bash
# Wine Installer for Ubuntu 24.10

set -euo pipefail

# Source common utilities
source utils.sh

WINE_KEY_URL="https://dl.winehq.org/wine-builds/winehq.key"
WINE_REPO="deb [signed-by=/etc/apt/keyrings/winehq-archive.key] https://dl.winehq.org/wine-builds/ubuntu/ $(lsb_release -cs) main"

main() {
    echo "🔧 Configuring system..."

    # Enable 32-bit architecture
    sudo dpkg --add-architecture i386
    add_repository "${WINE_KEY_URL}" "${WINE_REPO}"
    install_dependencies winehq-staging
    configure_wine

    echo "✅ Installation complete!"
    echo -e "\nCheck versions:"
    echo "Wine: $(wine --version)"
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    main
fi
