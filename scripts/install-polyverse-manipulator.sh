#!/bin/bash
# Polyverse Manipulator Installer

set -euo pipefail

# Constants
VERSION=1.4.9
DOWNLOAD_URL="https://polyversemusic.com/downloads/releases/manipulator/InfectedMushroom-Manipulator-V${VERSION}.zip"
TEMP_ZIP="${TEMPDIR}/polyverse-manipulator.zip"

INSTALL_DIR="${HOME}/.wine/drive_c/Program Files/Polyverse/Manipulator"
PLUGIN_DIR="${HOME}/.wine/drive_c/Program Files/Steinberg/VstPlugins"

install_polyverse_manipulator() {
    echo "🎛️  Starting Polyverse Manipulator installation..."

    # Create installation directory
    echo "📂 Creating installation directory..."
    mkdir -p "${INSTALL_DIR}"

    # Download and extract the package
    echo "⬇️ Downloading Manipulator..."
    setup_tempdir
    safe_download "${DOWNLOAD_URL}" "${TEMP_ZIP}"

    echo "📦 Extracting package..."
    unzip -q "${TEMP_ZIP}" -d "${TEMPDIR}"

    # Install the plugin
    echo "🔨 Installing Manipulator..."
    wine "${TEMPDIR}/InfectedMushroom-Manipulator-V${VERSION}.exe" /S

    # Move to VST plugins directory
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
    echo -e "\nManipulator installed to: ${PLUGIN_DIR}"
    echo "Launch your DAW and scan for new plugins"
}