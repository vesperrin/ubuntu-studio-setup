#!/bin/bash
# Two Notes Genome Installer

set -euo pipefail

# Constants
GENOME_VERSION="1.7.0_full_build_3721"
GENOME_INSTALLER="two-notes-genome.msi"
GENOME_DOWNLOAD_URL="https://public-downloads.two-notes.com/setups/genome/Genome_${GENOME_VERSION}_installer_win64.msi"
GENOME_INSTALL_DIR="${WINE_PREFIX}/drive_c/Program\ Files/Two\ Notes\ Genome"
GENOME_TEMPDIR="${TEMPDIR}/two-notes"

install_two_notes_genome() {
    log_install "Two Notes Genome"

    setup_temp_dir "${GENOME_TEMPDIR}"
    create_install_dir "${GENOME_INSTALL_DIR}"

    wine_download_and_install \
        --source "${GENOME_DOWNLOAD_URL}" \
        --dest "${GENOME_TEMPDIR}/${GENOME_INSTALLER}"

    sync_yabridge

    log_install_complete "Two Notes Genome"
}
