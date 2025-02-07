#!/bin/bash

# Constants
WINE_MONO_REPO_ORG="wine-mono"
WINE_MONO_REPO_NAME="wine-mono"
WINE_MONO_PACKAGE_PREFIX="wine-mono-"
WINE_MONO_PACKAGE_SUFFIX="-x86.msi"
WINE_MONO_INSTALL_DIR="${WINE_PREFIX}/drive_c/wine-mono"

install_mono() {
    local msi_file="$1"
    echo "🔨 Installing ${msi_file##*/}..."

    # Check Wine version compatibility first
    if ! wine --version | grep -q "wine-7"; then
        die "Wine version too old - requires at least Wine 7.x"
    fi

    install_wine_components msi || die "Failed to install MSI support"
    wine msiexec /i "${msi_file}" /qn || die "Installation failed"

    echo -e "${GREEN}✅ Wine Mono installed to ${WINE_MONO_INSTALL_DIR}${NC}"
}

install_wine_mono() {
    log_install "Wine Mono"

    # Verify .NET requirements first
    if [ -d "${WINE_MONO_INSTALL_DIR}" ]; then
        echo -e "${YELLOW}⚠️  Wine Mono already installed, skipping...${NC}"
        return 0
    fi

    install_dependencies winetricks cabextract
    configure_wine

    local wine_mono_msi
    wine_mono_msi=$(
        download_github_latest_package \
            --org "${WINE_MONO_REPO_ORG}" \
            --repo "${WINE_MONO_REPO_NAME}" \
            --prefix "${WINE_MONO_PACKAGE_PREFIX}" \
            --suffix "${WINE_MONO_PACKAGE_SUFFIX}"
    )

    install_mono "${wine_mono_msi}"

    echo -e "\n💡 Verification:"
    wine mono --version || die "Verification failed"

    log_install_complete "Wine Mono"
}
