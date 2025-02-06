#!/bin/bash
# Polyverse Manipulator Installer

set -euo pipefail

# Constants
MANIPULATOR_VERSION=1.4.9
MANIPULATOR_DOWNLOAD_URL="https://polyversemusic.com/downloads/releases/manipulator/InfectedMushroom-Manipulator-V${MANIPULATOR_VERSION}.zip"
MANIPULATOR_INSTALL_DIR="${WINE_PREFIX}/drive_c/Program Files/Polyverse/Manipulator"

install_polyverse_manipulator() {
    echo "🎛️  Starting Polyverse Manipulator installation..."

    # Create installation directory
    echo "📂 Creating installation directory..."
    mkdir -p "${MANIPULATOR_INSTALL_DIR}"

    # Download and extract the package
    echo "⬇️ Downloading Manipulator..."
    setup_tempdir
    safe_download "${MANIPULATOR_DOWNLOAD_URL}" "${TEMP_DIR}/polyverse-manipulator.zip"

    echo "📦 Extracting package..."
    unzip -q "${TEMP_DIR}/polyverse-manipulator.zip" -d "${TEMPDIR}"

    # Install the plugin
    echo "🔨 Installing Manipulator..."
    wine "${TEMPDIR}/InfectedMushroom-Manipulator-V${MANIPULATOR_VERSION}.exe" /S

    # Move to VST plugins directory
    echo "🚚 Moving plugin files..."
    mkdir -p "${VST3_DIR}"
    mv "${MANIPULATOR_INSTALL_DIR}"/*.dll "${VST3_DIR}/"

    # Configure yabridge if installed
    if command -v yabridgectl >/dev/null; then
        echo "🔗 Configuring yabridge..."
        yabridgectl add "${VST3_DIR}"
        yabridgectl sync
    fi

    echo "✅ Installation complete!"
    echo -e "\nManipulator installed to: ${VST3_DIR}"
    echo "Launch your DAW and scan for new plugins"
}