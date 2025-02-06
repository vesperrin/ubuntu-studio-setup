#!/bin/bash

# Constants
VCV_RACK_URL="https://vcvrack.com/RackProDownload?version=2.5.2&arch=lin-x64"
VCV_RACK_INSTALL_DIR="/opt/VCVRack"
VCV_RACK_DESKTOP_ENTRY="/usr/share/applications/vcv-rack.desktop"

install_vcv_rack() {
    echo "🎹 Installing VCV Rack Pro..."

    setup_tempdir
    configure_audio

    # Install dependencies
    install_dependencies zenity

    # Download VCV Rack
    local rack_zip="${TEMPDIR}/vcv-rack.zip"
    safe_download "${VCV_RACK_URL}" "${rack_zip}"

    # Install to system directory
    echo "📂 Extracting files..."
    sudo mkdir -p "${VCV_RACK_INSTALL_DIR}"
    sudo unzip -q "${rack_zip}" -d "${VCV_RACK_INSTALL_DIR}"
    sudo chmod +x "${VCV_RACK_INSTALL_DIR}/Rack"

    create_desktop_entry \
        "${VCV_RACK_DESKTOP_ENTRY}" \
        "${VCV_RACK_INSTALL_DIR}/Rack" \
        "${VCV_RACK_INSTALL_DIR}/Rack.svg" \
        "VCV Rack Pro"

    # Create symlink for terminal access
    echo "🔗 Creating command line access..."
    sudo ln -sf "${VCV_RACK_INSTALL_DIR}/Rack" /usr/local/bin/rack

    # Post-install configuration
    echo "⚙️ Finalizing installation..."
    sudo chown -R root:root "${VCV_RACK_INSTALL_DIR}"
    sudo ldconfig

    echo -e "${GREEN}✅ VCV Rack Pro installation complete!${NC}"
}