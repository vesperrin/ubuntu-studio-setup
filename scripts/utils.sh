#!/bin/bash
# Common Utilities for Installation Scripts

set -euo pipefail

# Colors and formatting
export NC='\033[0m' RED='\033[0;31m' GREEN='\033[0;32m' YELLOW='\033[0;33m'

# Error handling
die() {
    echo -e "${RED}Error: $*${NC}" >&2
    exit 1
}

# Temporary directory management
setup_tempdir() {
    declare -g TEMPDIR
    TEMPDIR="$(mktemp -d)"
    trap "cleanup_tempdir '${TEMPDIR}'" EXIT
}

cleanup_tempdir() {
    local dir="${1:-}"
    if [[ -n "$dir" && -d "$dir" ]]; then
        echo "🧹 Cleaning up temporary files..."
        rm -rf "$dir"
    fi
}

# System Information
get_distro_codename() {
    local codename
    codename="$(lsb_release -cs 2>/dev/null)" || die "Failed to detect distribution codename"

    if [[ -z "${codename}" ]]; then
        die "Could not determine distribution codename"
    fi

    echo "${codename}"
}

# Github
get_github_latest_release() {
    local repo="$1" # Format: "owner/repo"
    local api_url="https://api.github.com/repos/${repo}/releases/latest"

    # Ensure jq is installed
    if ! command -v jq >/dev/null; then
        install_dependencies jq
    fi

    # Fetch and return the latest release tag
    curl -sL "${api_url}" | jq -r '.tag_name' || die "Failed to fetch release information"
}

download_github_package() {
    local repo="$1" # Format: "owner/repo"
    local version="$2"
    local prefix="$3"
    local suffix="$4"

    local destination="${TEMPDIR}/${prefix}${version}${suffix}"
    local source="https://github.com/${repo}/releases/download/${version}/${prefix}${version}${suffix}"

    echo "⬇️ Downloading ${repo} ${version}..."
    safe_download "${source}" "${destination}"
    echo "${destination}"
}

download_github_latest_package() {
    local repo="$1" # Format: "owner/repo"
    local prefix="$3"
    local suffix="$4"

    local version
    version="$(get_github_latest_release "${repo}")"

    download_github_package "${repo}" "${version}" "${prefix}" "${suffix}"
}

# Package management
install_dependencies() {
    local deps=("$@")
    echo "📦 Installing dependencies: ${deps[*]}..."
    sudo apt-get update -y
    sudo apt-get install -y "${deps[@]}" || die "Failed to install dependencies"
}

# Repository management
add_repository_key() {
    local key_url="$1"
    local key_name="${2:-$(basename "$key_url")}"
    local keyring_dir="/etc/apt/keyrings"

    echo "🔑 Adding repository key: ${key_name}"

    # Create temp file with correct permissions
    local temp_key
    temp_key="$(mktemp)"

    # Download key with error handling
    safe_download "${key_url}" "${temp_key}" || die "Failed to download repository key"

    # Move to keyring directory with proper permissions
    sudo mkdir -p "${keyring_dir}"
    sudo mv "${temp_key}" "${keyring_dir}/${key_name}"
    sudo chmod 644 "${keyring_dir}/${key_name}"

    echo "✓ Key installed to: ${keyring_dir}/${key_name}"
}

add_repository() {
    local repo_line="$1"
    local list_name="${2:-$(echo "$repo_line" | awk '{print $1}').list}"

    echo "📦 Adding repository: ${list_name}"
    echo "${repo_line}" | sudo tee "/etc/apt/sources.list.d/${list_name}" >/dev/null
    sudo apt-get update -y
}

add_apt_repository() {
    local key_url="$1"
    local repo_components="$2"
    local service_name="$3"
    
    local key_name="${service_name}-archive-keyring.gpg"
    local repo_line="deb [signed-by=/etc/apt/keyrings/${key_name}] ${repo_components}"

    # Add repository key and source
    add_repository_key "${key_url}" "${key_name}"
    add_repository "${repo_line}" "${service_name}.list"
}

# File management
safe_download() {
    local url="$1"
    local dest="$2"
    echo "⬇️ Downloading $(basename "$dest")..."
    curl -fsSL "$url" -o "$dest" || die "Failed to download $url"
}

install_deb() {
    local deb_path="$1"
    echo "🔨 Installing DEB package..."
    sudo apt-get install -y "$deb_path" || die "Failed to install DEB package"
}

# Wine specific utilities
configure_wine() {
    echo "🍷 Configuring Wine..."
    winecfg &>/dev/null &
}

install_wine_component() {
    local component="$1"
    echo "🔧 Installing Wine component: $component..."
    winetricks -q "$component" || die "Failed to install $component"
}

# Service management
configure_service() {
    local service_name="$1"
    echo "⚙️ Configuring $service_name service..."
    sudo systemctl enable "$service_name" || die "Failed to enable $service_name"
    sudo systemctl start "$service_name" || die "Failed to start $service_name"
}

# Path management
add_to_path() {
    local path_dir="$1"
    local line="export PATH=\"\$PATH:$path_dir\""
    echo "🔗 Adding to PATH: $path_dir"

    # Append the line to .bashrc only if it's not already there
    if ! grep -Fxq "$line" "${HOME}/.bashrc"; then
        echo "$line" >> "${HOME}/.bashrc"
    fi

    export PATH="$PATH:$path_dir"
}

# Desktop entries
create_desktop_entry() {
    local entry_path="$1"
    local exec_path="$2"
    local icon_path="$3"
    local app_name="$4"

    echo "📝 Creating desktop entry..."
    sudo tee "$entry_path" >/dev/null <<EOF
[Desktop Entry]
Name=$app_name
Exec=$exec_path
Icon=$icon_path
Terminal=false
Type=Application
Categories=Audio;Music;
EOF
}
