#!/bin/bash
# Polyverse Manipulator Installer

set -euo pipefail

# Constants
MANIPULATOR_VERSION=1.4.9
MANIPULATOR_INSTALLER="InfectedMushroom-Manipulator-V${MANIPULATOR_VERSION}.exe"
MANIPULATOR_DOWNLOAD_URL="https://polyversemusic.com/downloads/releases/manipulator/InfectedMushroom-Manipulator-V${MANIPULATOR_VERSION}.zip"
MANIPULATOR_INSTALL_DIR="${WINE_PREFIX}/drive_c/Program\ Files/Polyverse/Manipulator"
MANIPULATOR_TEMPDIR="${TEMPDIR}/polyverse-manipulator"

install_polyverse_manipulator() {
    log_install "Polyverse Manipulator"

    setup_temp_dir "${MANIPULATOR_TEMPDIR}"
    create_install_dir "${MANIPULATOR_INSTALL_DIR}"

    install_wine_components comctl32 riched20 oleaut32

    wine_download_and_install \
        --source "${MANIPULATOR_DOWNLOAD_URL}" \
        --dest "${MANIPULATOR_TEMPDIR}/polyverse-manipulator.zip" \
        --installer "${MANIPULATOR_INSTALLER}" \
        --options "/SILENT"

    sync_yabridge

    log_install_complete "Polyverse Manipulator"
}