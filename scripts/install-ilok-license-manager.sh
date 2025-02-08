#!/bin/bash
# Ilok License Manager Installer

set -euo pipefail

# Constants
ILOK_VERSION="5.10.0_869c108c"
ILOK_INSTALLER="LicenseSupportInstallerWin64_v${ILOK_VERSION}/License\ Support\ Win64.exe"
ILOK_DOWNLOAD_URL="https://downloads.ilok.com/iloklicensemanager/LicenseSupportInstallerWin64.zip"
ILOK_INSTALL_DIR="${WINE_PREFIX}/drive_c/Program\ Files/Ilok\ License\ Manager"
ILOK_TEMPDIR="${TEMPDIR}/ilok-license-manager"

install_ilok_license_manager    () {
    log_install "Ilok License Manager"

    setup_temp_dir "${ILOK_TEMPDIR}"
    create_install_dir "${ILOK_INSTALL_DIR}"

    wine_download_and_install \
        --source "${ILOK_DOWNLOAD_URL}" \
        --dest "${ILOK_TEMPDIR}/ilok-license-manager.zip" \
        --installer "${ILOK_INSTALLER}"

    sync_yabridge

    log_install_complete "Ilok License Manager"
}
