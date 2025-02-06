#!/bin/bash
# yabridge Auto-Installer
set -euo pipefail

YABRIDGE_REPO="robbert-vdh/yabridge"
YABRIDGE_INSTALL_PARENT_DIR="${HOME}/.local/share"
YABRIDGE_INSTALL_DIR="${YABRIDGE_INSTALL_PARENT_DIR}/yabridge"

install_yabridge_package() {
    setup_tempdir

    echo "🔍 Fetching latest yabridge release..."
    local latest_version
    latest_version="$(get_github_latest_release "${YABRIDGE_REPO}")"

    local download_url="https://github.com/${YABRIDGE_REPO}/releases/download/${latest_version}/yabridge-${latest_version}.tar.gz"

    echo "⬇️ Downloading yabridge ${latest_version}..."
    safe_download "${download_url}" "${TEMPDIR}/yabridge.tar.gz"

    echo "📂 Extracting yabridge..."
    mkdir -p "${YABRIDGE_INSTALL_PARENT_DIR}"
    tar -C "${YABRIDGE_INSTALL_PARENT_DIR}" -xzf "${TEMPDIR}/yabridge.tar.gz"

    echo "🔗 Adding to PATH..."
    add_to_path "${YABRIDGE_INSTALL_DIR}"
}

configure_yabridge() {
    echo "⚙️ Configuring yabridge..."

    mkdir -p "${VST2_DIR}" "${VST3_DIR}" "${CLAP_DIR}"
    for dir in "${VST2_DIR}" "${VST3_DIR}" "${CLAP_DIR}"; do
        yabridgectl add "${dir}" || die "Failed to add directory: ${dir}"
    done

    for attempt in {1..3}; do
        yabridgectl sync && break
        sleep 2
        [[ $attempt -eq 3 ]] && die "Failed to sync plugins after 3 attempts"
    done

    echo "✅ yabridge configured!"
}

install_yabridge() {
    install_yabridge_package
    configure_yabridge

    echo -e "\n💡 Verification:"
    yabridgectl --version || die "yabridge verification failed"
}
