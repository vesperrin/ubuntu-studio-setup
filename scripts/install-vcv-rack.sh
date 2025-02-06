#!/bin/bash
source utils.sh

# Constants
RACK_URL="https://vcvrack.com/RackProDownload?version=2.5.2&arch=lin-x64"
INSTALL_DIR="/opt/VCVRack"
DESKTOP_ENTRY="/usr/share/applications/vcv-rack.desktop"

main() {
    echo "🎹 Installing VCV Rack Pro 2.5.2..."

    setup_tempdir
    configure_audio

    # Install dependencies
    install_dependencies zenity

    # Download VCV Rack
    local rack_zip="${TEMPDIR}/vcv-rack.zip"
    safe_download "${RACK_URL}" "${rack_zip}"

    # Install to system directory
    echo "📂 Extracting files..."
    sudo mkdir -p "${INSTALL_DIR}"
    sudo unzip -q "${rack_zip}" -d "${INSTALL_DIR}"
    sudo chmod +x "${INSTALL_DIR}/Rack"

    create_desktop_entry \
        "${DESKTOP_ENTRY}" \
        "${INSTALL_DIR}/Rack" \
        "${INSTALL_DIR}/Rack.svg" \
        "VCV Rack Pro"

    # Create symlink for terminal access
    echo "🔗 Creating command line access..."
    sudo ln -sf "${INSTALL_DIR}/Rack" /usr/local/bin/rack

    # Post-install configuration
    echo "⚙️ Finalizing installation..."
    sudo chown -R root:root "${INSTALL_DIR}"
    sudo ldconfig

    echo -e "${GREEN}✅ VCV Rack Pro installation complete!${NC}"
}

# Only execute if not in source mode
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    main
fi
