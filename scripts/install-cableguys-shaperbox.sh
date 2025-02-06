#!/bin/bash
# Cableguys ShaperBox Installer

set -euo pipefail

# Constants
SHAPERBOX_DOWNLOAD_URL="https://drive.usercontent.google.com/download?id=1OFlYWvuaJtVz_NHyJEZ1jDQGDXB3Du_D&export=download&authuser=0&confirm=t&uuid=78500e2a-3920-4de8-a8e5-572507567f52&at=AIrpjvMawb76bXU2s-bml9-9Evw1%3A1738857456359"
SHAPERBOX_INSTALL_DIR="${WINE_PREFIX}/drive_c/Program Files/Cableguys/ShaperBox"

install_cableguys_shaperbox() {
    echo "🎛️  Starting Cableguys ShaperBox installation..."

    echo "📂 Creating installation directory..."
    mkdir -p "${SHAPERBOX_INSTALL_DIR}"

    echo "⬇️ Downloading ShaperBox..."
    setup_tempdir
    local installer_path="${TEMPDIR}/ShaperBoxInstaller.exe"
    safe_download "${SHAPERBOX_DOWNLOAD_URL}" "${installer_path}"

    echo "🔨 Installing ShaperBox..."
    wine "${installer_path}" /S

    echo "🚚 Moving plugin files..."
    mkdir -p "${VST3_DIR}"
    mv "${SHAPERBOX_INSTALL_DIR}"/*.dll "${VST3_DIR}/"

    # Configure yabridge if installed
    if command -v yabridgectl >/dev/null; then
        echo "🔗 Configuring yabridge..."
        yabridgectl add "${VST3_DIR}"
        yabridgectl sync
    fi

    echo "✅ Installation complete!"
    echo -e "\nShaperBox installed to: ${VST3_DIR}"
    echo "Launch your DAW and scan for new plugins"
}