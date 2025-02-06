#!/bin/bash

# Constants
PULSE_URL="https://pulse-client.nyc3.digitaloceanspaces.com/dist/Pulse-40.4.20.AppImage"
PULSE_APPIMAGE="pulse.appimage"
PULSE_INSTALL_DIR="/opt/pulse"
PULSE_DESKTOP_ENTRY="/usr/share/applications/pulse.desktop"
PULSE_ICON_URL="https://pulsedownloader.com/wp-content/uploads/2020/09/favicon.png"
PULSE_ICON_PATH="${PULSE_INSTALL_DIR}/pulse-icon.png"

install_pulse() {
    echo "🎛 Installing Pulse..."

    setup_tempdir
    install_dependencies libfuse2

    # Create installation directory
    sudo mkdir -p "${PULSE_INSTALL_DIR}"
    sudo chmod 755 "${PULSE_INSTALL_DIR}"

    # Download Pulse AppImage
    safe_download "${PULSE_URL}" "${TEMPDIR}/${PULSE_APPIMAGE}"
    sudo mv "${TEMPDIR}/${PULSE_APPIMAGE}" "${PULSE_INSTALL_DIR}/Pulse.AppImage"
    sudo chmod +x "${PULSE_INSTALL_DIR}/Pulse.AppImage"

    # Download and set icon
    safe_download "${PULSE_ICON_URL}" "${PULSE_ICON_PATH}"
    sudo ln -sf "${PULSE_INSTALL_DIR}/Pulse.AppImage" "/usr/local/bin/pulse"
    create_desktop_entry "${PULSE_DESKTOP_ENTRY}" "${PULSE_INSTALL_DIR}/Pulse.AppImage" "${PULSE_ICON_PATH}" "Pulse"

    echo -e "${GREEN}✅ Pulse installation complete!${NC}"
}