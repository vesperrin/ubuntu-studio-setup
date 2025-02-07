#!/bin/bash

# Constants
PULSE_APPIMAGE="pulse.appimage"
PULSE_URL="https://pulse-client.nyc3.digitaloceanspaces.com/dist/Pulse-40.4.20.AppImage"
PULSE_INSTALL_DIR="/opt/pulse"
PULSE_DESKTOP_ENTRY="/usr/share/applications/pulse.desktop"
PULSE_ICON_URL="https://drive.usercontent.google.com/download?id=1PuPSuHxolteTqUA8t1pySGC0f5c4GOk4&export=download&authuser=0"
PULSE_ICON_PATH="${PULSE_INSTALL_DIR}/pulse-icon.png"
PULSE_TEMPDIR="${TEMPDIR}/pulse"

install_pulse() {
    log_install "Pulse"

    setup_temp_dir "${PULSE_TEMPDIR}"
    create_install_dir "${PULSE_INSTALL_DIR}"
    sudo chmod 755 "${PULSE_INSTALL_DIR}"

    install_dependencies libfuse2

    # Setup Pulse AppImage
    safe_download --url "${PULSE_URL}" --dest "${PULSE_TEMPDIR}/${PULSE_APPIMAGE}"
    sudo cp "${PULSE_TEMPDIR}/${PULSE_APPIMAGE}" "${PULSE_INSTALL_DIR}/Pulse.AppImage"
    sudo chmod +x "${PULSE_INSTALL_DIR}/Pulse.AppImage"

    # Setup icon
    safe_download --url "${PULSE_ICON_URL}" --dest "${PULSE_TEMPDIR}/pulse-icon.png"
    sudo cp "${PULSE_TEMPDIR}/pulse-icon.png" "${PULSE_ICON_PATH}"

    sudo ln -sf "${PULSE_INSTALL_DIR}/Pulse.AppImage" "/usr/local/bin/pulse"
    create_desktop_entry \
        --entry-path "${PULSE_DESKTOP_ENTRY}" \
        --exec-path "${PULSE_INSTALL_DIR}/Pulse.AppImage" \
        --icon-path "${PULSE_ICON_PATH}" \
        --app-name "Pulse"

    log_install_complete "Pulse"
}
