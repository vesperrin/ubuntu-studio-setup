#!/bin/bash
# XLN Audio Online Installer

set -euo pipefail

# Constants
XLN_AUDIO_VERSION="4_3_0"
XLN_AUDIO_INSTALLER="xln-audio-online-installer.exe"
XLN_AUDIO_DOWNLOAD_URL="https://xlnaudio.s3.amazonaws.com/products/XLN%20Online%20Installer/${XLN_AUDIO_VERSION}%20Release3/downloadables/XLN%20Online%20Installer.exe"
XLN_AUDIO_INSTALL_DIR="${WINE_PREFIX}/drive_c/Program\ Files/XLN\ Audio"
XLN_AUDIO_TEMPDIR="${TEMPDIR}/xln-audio-online-installer"

install_xln_audio_online_installer  () {
    log_install "XLN Audio Online"

    setup_temp_dir "${XLN_AUDIO_TEMPDIR}"
    create_install_dir "${XLN_AUDIO_INSTALL_DIR}"

    wine_download_and_install \
        --source "${XLN_AUDIO_DOWNLOAD_URL}" \
        --dest "${XLN_AUDIO_TEMPDIR}/${XLN_AUDIO_INSTALLER}"

    sync_yabridge

    log_install_complete "XLN Audio Online"
}
