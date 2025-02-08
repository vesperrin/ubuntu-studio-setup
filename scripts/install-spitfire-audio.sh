#!/bin/bash
# Spitfire Audio Installer

set -euo pipefail

# Constants
SPITFIRE_VERSION="3.4.13"
SPITFIRE_INSTALLER="spitfire-audio.exe"
SPITFIRE_DOWNLOAD_URL="https://d1t3zg51rvnesz.cloudfront.net/p/files/lm/1720086000/win/SpitfireAudio-Win-${SPITFIRE_VERSION}.exe"
SPITFIRE_INSTALL_DIR="${WINE_PREFIX}/drive_c/Program\ Files/Spitfire"
SPITFIRE_TEMPDIR="${TEMPDIR}/spitfire-audio"

install_spitfire_audio() {
    log_install "Spitfire Audio"

    setup_temp_dir "${SPITFIRE_TEMPDIR}"
    create_install_dir "${SPITFIRE_INSTALL_DIR}"

    wine_download_and_install \
        --source "${SPITFIRE_DOWNLOAD_URL}" \
        --dest "${SPITFIRE_TEMPDIR}/${SPITFIRE_INSTALLER}" \
        --options "/SILENT"

    sync_yabridge

    log_install_complete "Spitfire Audio"
}
