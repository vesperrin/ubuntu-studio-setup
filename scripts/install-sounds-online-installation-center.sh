#!/bin/bash
# Sounds Online Installation Center Installer

set -euo pipefail

# Constants
SOUNDS_ONLINE_VERSION="1.5.0"
SOUNDS_ONLINE_INSTALLER="EW Installation Center-${SOUNDS_ONLINE_VERSION}.exe"
SOUNDS_ONLINE_DOWNLOAD_URL="https://software.soundsonline.com/Products/IC/IC_${SOUNDS_ONLINE_VERSION}_Win.zip"
SOUNDS_ONLINE_INSTALL_DIR="${WINE_PREFIX}/drive_c/Program Files/Sounds Online"
SOUNDS_ONLINE_TEMPDIR="${TEMPDIR}/sounds-online"

install_sounds_online_installation_center() {
    log_install "Sounds Online Installation Center"

    setup_temp_dir "${SOUNDS_ONLINE_TEMPDIR}"
    create_install_dir "${SOUNDS_ONLINE_INSTALL_DIR}"

    # install_wine_comp onents comctl32 ole32 vcrun6

    wine_download_and_install \
        --source "${SOUNDS_ONLINE_DOWNLOAD_URL}" \
        --dest "${SOUNDS_ONLINE_TEMPDIR}/sounds-online-installation-center.zip" \
        --installer "${SOUNDS_ONLINE_INSTALLER}"

    sync_yabridge

    log_install_complete "Sounds Online Installation Center"
}
