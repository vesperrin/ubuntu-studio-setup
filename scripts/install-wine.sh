#!/bin/bash
# Wine & Wine Mono Installer for Ubuntu 24.10

set -euo pipefail

main() {
    echo "🔧 Configuring system..."
    dpkg --add-architecture i386
    apt-get update -y

    echo "🔗 Adding WineHQ repository..."
    mkdir -pm755 /etc/apt/keyrings
    curl -L "https://dl.winehq.org/wine-builds/winehq.key" \
        -o /etc/apt/keyrings/winehq-archive.key
    curl -L "https://dl.winehq.org/wine-builds/ubuntu/dists/$(lsb_release -cs)/winehq-$(lsb_release -cs).sources" \
        -o /etc/apt/sources.list.d/winehq.sources

    echo "🔄 Updating package lists..."
    apt-get update -y

    echo "🍷 Installing WineHQ stable..."
    apt-get install -y --install-recommends winehq-staging
 
    echo "⚙️  Running initial Wine configuration..."
    winecfg &>/dev/null &

    echo "✅ Installation complete!"
    echo -e "\nCheck versions:"
    echo "Wine: $(wine --version)"
    echo "Mono: $(wine mono --version 2>/dev/null || echo 'Not found')"
}

# Only execute if not in source mode
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    main
fi
