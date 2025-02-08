#!/bin/bash
# Cableguys ShaperBox Installer

set -euo pipefail

# Constants
SHAPERBOX_INSTALLER="ShaperBoxInstaller.exe"
SHAPERBOX_DOWNLOAD_URL="https://drive.usercontent.google.com/download?id=1OFlYWvuaJtVz_NHyJEZ1jDQGDXB3Du_D&export=download&authuser=0&confirm=t&uuid=78500e2a-3920-4de8-a8e5-572507567f52&at=AIrpjvMawb76bXU2s-bml9-9Evw1%3A1738857456359"
SHAPERBOX_INSTALL_DIR="${WINE_PREFIX}/drive_c/Program\ Files/Cableguys/ShaperBox"
SHAPERBOX_TEMPDIR="${TEMPDIR}/shaperbox"

install_cableguys_shaperbox() {
    log_install "Cableguys Shaperbox"

    setup_temp_dir "${SHAPERBOX_TEMPDIR}"
    create_install_dir "${SHAPERBOX_INSTALL_DIR}"

    wine_download_and_install \
        --source "${SHAPERBOX_DOWNLOAD_URL}" \
        --dest "${SHAPERBOX_TEMPDIR}/${SHAPERBOX_INSTALLER}" \
        --options "/SILENT"

    sync_yabridge

    log_install_complete "Cableguys Shaperbox"
}
