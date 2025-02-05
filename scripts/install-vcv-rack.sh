#!/bin/bash
# VCV Rack Pro 2.5.2 Auto-Installer for Linux
set -euo pipefail

RACK_URL="https://vcvrack.com/RackProDownload?version=2.5.2&arch=lin-x64"
INSTALL_DIR="/opt/VCVRack"
DESKTOP_ENTRY="/usr/share/applications/vcv-rack.desktop"
TEMPDIR="$(mktemp -d)"

cleanup() {
    echo "🧹 Cleaning up temporary files..."
    rm -rf "${TEMPDIR}"
}
trap cleanup EXIT

main() {
    echo "🔧 Configuring system..."
    
    # Audio setup for realtime priorities:cite[8]
    sudo groupadd -f audio
    sudo usermod -a -G audio "${SUDO_USER:-$USER}"
    
    # Install essential dependencies:cite[1]:cite[8]
    echo "📦 Installing dependencies..."
    export DEBIAN_FRONTEND=noninteractive
    sudo apt-get update -y
    sudo apt-get install -y \
        zenity

    # Download VCV Rack:cite[7]
    echo "⬇️ Downloading VCV Rack..."
    RACK_ZIP="${TEMPDIR}/vcv-rack.zip"
    curl -# -L "${RACK_URL}" -o "${RACK_ZIP}"

    # Install to system directory
    echo "📂 Extracting files..."
    sudo mkdir -p "${INSTALL_DIR}"
    sudo unzip -q "${RACK_ZIP}" -d "${INSTALL_DIR}"
    sudo chmod +x "${INSTALL_DIR}/Rack"

    # Create desktop entry:cite[3]
    echo "📝 Creating desktop shortcut..."
    cat <<EOF | sudo tee "${DESKTOP_ENTRY}" >/dev/null
[Desktop Entry]
Name=VCV Rack Pro
Exec=${INSTALL_DIR}/Rack
Icon=${INSTALL_DIR}/Rack.svg
Terminal=false
Type=Application
Categories=Audio;Music;
StartupWMClass=rack
EOF

    # Create symlink for terminal access
    sudo ln -sf "${INSTALL_DIR}/Rack" /usr/local/bin/rack

    # Post-install configuration
    echo "⚙️ Finalizing installation..."
    sudo chown -R root:root "${INSTALL_DIR}"
    sudo ldconfig
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    main
fi
