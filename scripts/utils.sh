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

add_repository() {
    local key_url="$1"
    local repo_line="$2"
    local keyring_dir="/etc/apt/keyrings"

    echo "🔑 Adding repository key..."
    sudo mkdir -p "$keyring_dir"
    sudo curl -fsSL "$key_url" -o "${keyring_dir}/$(basename "$key_url")" ||
        die "Failed to download repository key"

    echo "📦 Adding repository..."
    echo "$repo_line" | sudo tee "/etc/apt/sources.list.d/$(basename "$key_url").list" >/dev/null
    sudo apt-get update -y
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
    echo "🔗 Adding to PATH: $path_dir"
    echo "export PATH=\"\$PATH:$path_dir\"" >>"${HOME}/.bashrc"
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
