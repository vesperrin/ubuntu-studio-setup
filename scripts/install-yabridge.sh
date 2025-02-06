#!/bin/bash
# yabridge Auto-Installer for Ubuntu
set -euo pipefail

YABRIDGE_URL="https://github.com/robbert-vdh/yabridge/releases/latest/download/yabridge.tar.gz"
INSTALL_DIR="${HOME}/.local/share/yabridge"
WINE_PREFIX="${HOME}/.wine"
VST2_DIR="${WINE_PREFIX}/drive_c/Program Files/Steinberg/VstPlugins"
VST3_DIR="${WINE_PREFIX}/drive_c/Program Files/Common Files/VST3"
CLAP_DIR="${WINE_PREFIX}/drive_c/Program Files/Common Files/CLAP"

cleanup() {
    echo "🧹 Cleaning up temporary files..."
    rm -rf "${TEMPDIR}"
}
trap cleanup EXIT

install_yabridge() {
    echo "⬇️ Downloading yabridge..."
    TEMPDIR="$(mktemp -d)"
    curl -L "${YABRIDGE_URL}" -o "${TEMPDIR}/yabridge.tar.gz"

    echo "📂 Extracting yabridge..."
    mkdir -p "${INSTALL_DIR}"
    tar -C "${INSTALL_DIR}" -xzf "${TEMPDIR}/yabridge.tar.gz"

    echo "🔗 Adding to PATH..."
    echo "export PATH=\"\$PATH:${INSTALL_DIR}\"" >>"${HOME}/.bashrc"
    source "${HOME}/.bashrc"
}

configure_yabridge() {
    echo "⚙️ Configuring yabridge..."

    # Create plugin directories if they don't exist
    mkdir -p "${VST2_DIR}" "${VST3_DIR}" "${CLAP_DIR}"

    # Add plugin directories to yabridge
    yabridgectl add "${VST2_DIR}"
    yabridgectl add "${VST3_DIR}"
    yabridgectl add "${CLAP_DIR}"

    # Sync plugins
    yabridgectl sync

    echo "✅ yabridge configured!"
}

main() {
    # Install Wine Staging
    install_wine_staging

    # Install yabridge
    install_yabridge

    # Configure yabridge
    configure_yabridge
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    main
fi
