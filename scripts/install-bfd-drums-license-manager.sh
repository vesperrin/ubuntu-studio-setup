#!/bin/bash
# BFD Drums License Manager Installer

set -euo pipefail

# Constants
BFDDRUMS_VERSION="30622"
BFDDRUMS_INSTALLER="bfd-drums-license-manager.exe"
BFDDRUMS_DOWNLOAD_URL="https://cdn.inmusicbrands.com/BFD/LicenseManager/BFD%20License%20Manager_${BFDDRUMS_VERSION}_Win.exe"
BFDDRUMS_INSTALL_DIR="${WINE_PREFIX}/drive_c/Program\ Files/BFD\ Drums"
BFDDRUMS_TEMPDIR="${TEMPDIR}/bfd-drums-license-manager"

install_bfd_drums_license_manager() {
    log_install "BFD Drums License Manager"

    setup_temp_dir "${BFDDRUMS_TEMPDIR}"
    create_install_dir "${BFDDRUMS_INSTALL_DIR}"

    wine_download_and_install \
        --source "${BFDDRUMS_DOWNLOAD_URL}" \
        --dest "${BFDDRUMS_TEMPDIR}/${BFDDRUMS_INSTALLER}"

    sync_yabridge

    log_install_complete "BFD Drums License Manager"
}
