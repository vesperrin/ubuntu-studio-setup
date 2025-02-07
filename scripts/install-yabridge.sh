#!/bin/bash
# yabridge Auto-Installer
set -euo pipefail

# Constants
YABRIDGE_REPO_ORG="robbert-vdh"
YABRIDGE_REPO_NAME="robbert-vdh/yabridge"
YABRIDGE_INSTALL_PARENT_DIR="${HOME}/.local/share"
YABRIDGE_INSTALL_DIR="${YABRIDGE_INSTALL_PARENT_DIR}/yabridge"
YABRIDGE_TEMPDIR="${TEMPDIR}/yabridge"

install_yabridge_package() {
    echo "🔍 Fetching latest yabridge release..."
    local latest_version
    latest_version=$(
        get_github_latest_release \
            --org "${YABRIDGE_REPO_ORG}" \
            --repo "${YABRIDGE_REPO_NAME}"
    )

    local download_url="https://github.com/${YABRIDGE_REPO_ORG}/${YABRIDGE_REPO_NAME}/releases/download/${latest_version}/yabridge-${latest_version}.tar.gz"

    safe_download --url "${download_url}" --dest "${YABRIDGE_TEMPDIR}/yabridge.tar.gz"

    echo "📂 Extracting yabridge..."
    mkdir -p "${YABRIDGE_INSTALL_PARENT_DIR}"
    tar -C "${YABRIDGE_INSTALL_PARENT_DIR}" -xzf "${YABRIDGE_TEMPDIR}/yabridge.tar.gz"

    add_to_path "${YABRIDGE_INSTALL_DIR}"
}

configure_yabridge() {
    echo "⚙️ Configuring yabridge..."

    mkdir -p "${WINDOWS_VST2_DIR}" "${WINDOWS_VST3_DIR}" "${WINDOWS_CLAP_DIR}"
    for dir in "${WINDOWS_VST2_DIR}" "${WINDOWS_VST3_DIR}" "${WINDOWS_CLAP_DIR}"; do
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
    log_install "Yabridge"

    setup_temp_dir "${YABRIDGE_TEMPDIR}"

    install_yabridge_package
    configure_yabridge

    log_install_complete "Yabridge"
}
