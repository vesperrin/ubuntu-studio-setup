#!/bin/bash
# Wine Mono Auto-Installer for Ubuntu 24.10
set -euo pipefail

WINE_MONO_REPO="https://api.github.com/repos/wine-mono/wine-mono/releases/latest"
INSTALL_DIR="${HOME}/.wine/drive_c/wine-mono"
TEMPDIR="$(mktemp -d)"

cleanup() {
    echo "🧹 Cleaning up temporary files..."
    rm -rf "${TEMPDIR}"
}
trap cleanup EXIT

get_latest_release() {
    curl -sL "${WINE_MONO_REPO}" |
        jq -r '.tag_name'
}

download_msi() {
    local version="$1"
    local msi_url="https://github.com/wine-mono/wine-mono/releases/download/${version}/${version}-x86.msi"

    echo "⬇️ Downloading Wine Mono ${version}..."
    if ! curl -sL "${msi_url}" -o "${TEMPDIR}/${version}-x86.msi"; then
        echo "❌ Failed to download MSI package"
        exit 1
    fi
}

install_mono() {
    local msi_file="$1"
    echo "🔨 Installing ${msi_file##*/}..."

    if ! wine msiexec /i "${msi_file}" /qn; then
        echo "❌ Installation failed"
        exit 1
    fi

    echo "✅ Wine Mono installed to ${INSTALL_DIR}"
}

main() {
    echo "🔍 Checking latest Wine Mono release..."
    echo "📦 Installing required dependencies..."

    local latest_version
    latest_version="$(get_latest_release)"

    if [[ -z "${latest_version}" ]]; then
        echo "❌ Failed to fetch release information"
        exit 1
    fi

    download_msi "${latest_version}"
    install_mono "${TEMPDIR}/${latest_version}-x86.msi"

    echo -e "\n💡 Verify installation with:"
    echo "wine mono --version"
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    main
fi
