#!/bin/bash
source utils.sh

# Constants
WINE_MONO_REPO="wine-mono/wine-mono"
WINE_MONO_PACKAGE_PREFIX="-x86.msi"
INSTALL_DIR="${HOME}/.wine/drive_c/wine-mono"

install_mono() {
    local msi_file="$1"
    echo "🔨 Installing ${msi_file##*/}..."

    install_wine_component msi || die "Failed to install MSI support"
    wine msiexec /i "${msi_file}" /qn || die "Installation failed"

    echo -e "${GREEN}✅ Wine Mono installed to ${INSTALL_DIR}${NC}"
}

main() {
    echo "🍷 Installing Wine Mono..."

    setup_tempdir
    install_dependencies winetricks
    configure_wine

    local wine_mono_msi
    wine_mono_msi="$(download_github_latest_package "${WINE_MONO_REPO}" "" "${WINE_MONO_PACKAGE_PREFIX}")"

    install_mono "${wine_mono_msi}"

    echo -e "\n💡 Verify installation with:"
    echo "wine mono --version"
}

# Only execute if not in source mode
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    main
fi
