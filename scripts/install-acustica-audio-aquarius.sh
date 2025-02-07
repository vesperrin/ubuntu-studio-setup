#!/bin/bash
# Acustica Audio Aquarius Installer

set -euo pipefail

# Constants
ACUSTICA_VERSION="2.6.051"
ACUSTICA_INSTALLER="Setup Aquarius ${ACUSTICA_VERSION} Win.exe"
ACUSTICA_DOWNLOAD_URL="https://drive.usercontent.google.com/download?id=11QRhT9e9Mc_fmTkIlo_F7amtthYF7FJ8&export=download&authuser=0"
ACUSTICA_INSTALL_DIR="${WINE_PREFIX}/drive_c/Program Files/Acustica Audio"
ACUSTICA_TEMPDIR="${TEMPDIR}/acustica-audio"

install_acustica_audio_aquarius() {
    log_install "Acustica Audio Aquarius"

    setup_temp_dir "${ACUSTICA_TEMPDIR}"
    create_install_dir "${ACUSTICA_INSTALL_DIR}"

    install_wine_components comctl32 ole32 vcrun6

    wine_download_and_install \
        --source "${ACUSTICA_DOWNLOAD_URL}" \
        --dest "${ACUSTICA_TEMPDIR}/acustica-audio-aquarius.zip" \
        --installer "${ACUSTICA_INSTALLER}"

    sync_yabridge

    log_install_complete "Acustica Audio Aquarius"
}
