#!/bin/bash
# Cableguys ShaperBox Installer

set -euo pipefail

# Constants
DOWNLOAD_URL="https://drive.usercontent.google.com/download?id=1OFlYWvuaJtVz_NHyJEZ1jDQGDXB3Du_D&export=download&authuser=0&confirm=t&uuid=78500e2a-3920-4de8-a8e5-572507567f52&at=AIrpjvMawb76bXU2s-bml9-9Evw1%3A1738857456359"
INSTALL_DIR="${HOME}/.wine/drive_c/Program Files/Cableguys/ShaperBox"
PLUGIN_DIR="${HOME}/.wine/drive_c/Program Files/Steinberg/VstPlugins"

install_cableguys_shaperbox() {
    echo "🎛️  Starting Cableguys ShaperBox installation..."

    echo "📂 Creating installation directory..."
    mkdir -p "${INSTALL_DIR}"

    echo "⬇️ Downloading ShaperBox..."
    setup_tempdir
    local installer_path="${TEMPDIR}/ShaperBoxInstaller.exe"
    safe_download "${DOWNLOAD_URL}" "${installer_path}"

    echo "🔨 Installing ShaperBox..."
    wine "${installer_path}" /S

    echo "🚚 Moving plugin files..."
    mkdir -p "${PLUGIN_DIR}"
    mv "${INSTALL_DIR}"/*.dll "${PLUGIN_DIR}/"

    # Configure yabridge if installed
    if command -v yabridgectl >/dev/null; then
        echo "🔗 Configuring yabridge..."
        yabridgectl add "${PLUGIN_DIR}"
        yabridgectl sync
    fi

    echo "✅ Installation complete!"
    echo -e "\nShaperBox installed to: ${PLUGIN_DIR}"
    echo "Launch your DAW and scan for new plugins"
}