#!/bin/bash
# Common Utilities for Installation Scripts

set -euo pipefail

# String Utils
extract_version() {
    [[ "$1" =~ (v?[0-9]+(\.[0-9]+)*(-[a-zA-Z0-9.]+)?) ]] || return 1
    local version="${BASH_REMATCH[0]#v}"
    echo "$version"
}

# Colors and formatting
export NC='\033[0m' RED='\033[0;31m' GREEN='\033[0;32m' YELLOW='\033[0;33m' BLUE='\033[00;34m' PURPLE='\033[00;35m' CYAN='\033[00;36m'

log_install() {
    local app_name=""
    app_name="$1"

    echo -e "${CYAN}🎛 Installing ${app_name}...${NC}"
}

log_install_complete() {
    local app_name=""
    app_name="$1"

    echo -e "${GREEN}✅ ${app_name} installation complete!${NC}"
}

# Error handling
die() {
    echo -e "${RED}Error: $*${NC}" >&2
    exit 1
}

# System Information
get_distro_codename() {
    local codename
    codename="$(lsb_release -cs 2>/dev/null)" || die "Failed to detect distribution codename"

    [[ -z "${codename}" ]] && die "Could not determine distribution codename"

    echo "${codename}"
}

# Github
get_github_latest_release() {
    local org="" repo=""
    while [[ $# -gt 0 ]]; do
        case "$1" in
        --org)
            org="$2"
            shift 2
            ;;
        --repo)
            repo="$2"
            shift 2
            ;;
        *)
            die "Unknown option: $1"
            ;;
        esac
    done
    [[ -z "$org" ]] && die "Missing required parameter: --org"
    [[ -z "$repo" ]] && die "Missing required parameter: --repo"

    local api_url="https://api.github.com/repos/${org}/${repo}/releases/latest"
    if ! command -v jq >/dev/null; then
        install_dependencies jq
    fi

    curl -sL "${api_url}" | jq -r '.tag_name' || die "Failed to fetch release information"
}

download_github_package() {
    local org="" repo="" release_name="" prefix="" suffix=""
    while [[ $# -gt 0 ]]; do
        case "$1" in
        --org)
            org="$2"
            shift 2
            ;;
        --repo)
            repo="$2"
            shift 2
            ;;
        --release)
            release_name="$2"
            shift 2
            ;;
        --prefix)
            prefix="$2"
            shift 2
            ;;
        --suffix)
            suffix="$2"
            shift 2
            ;;
        *)
            die "Unknown option: $1"
            ;;
        esac
    done
    [[ -z "$org" ]] && die "Missing required parameter: --org"
    [[ -z "$repo" ]] && die "Missing required parameter: --repo"
    [[ -z "$release_name" ]] && die "Missing required parameter: --release_name"
    [[ -z "$prefix" ]] && die "Missing required parameter: --prefix"
    [[ -z "$suffix" ]] && die "Missing required parameter: --suffix"

    local version
    version="$(extract_version "$release_name")"

    local destination="${TEMPDIR}/${prefix}${release_name}${suffix}"
    local source="https://github.com/${org}/${repo}/releases/download/${release_name}/${prefix}${version}${suffix}"

    safe_download --url "${source}" --dest "${destination}"

    echo "${destination}"
}

download_github_latest_package() {
    local org="" repo="" prefix="" suffix=""
    while [[ $# -gt 0 ]]; do
        case "$1" in
        --org)
            org="$2"
            shift 2
            ;;
        --repo)
            repo="$2"
            shift 2
            ;;
        --prefix)
            prefix="$2"
            shift 2
            ;;
        --suffix)
            suffix="$2"
            shift 2
            ;;
        *)
            die "Unknown option: $1"
            ;;
        esac
    done
    [[ -z "$org" ]] && die "Missing required parameter: --org"
    [[ -z "$repo" ]] && die "Missing required parameter: --repo"
    [[ -z "$prefix" ]] && die "Missing required parameter: --prefix"
    [[ -z "$suffix" ]] && die "Missing required parameter: --suffix"

    local release_name
    release_name="$(get_github_latest_release --org "${org}" --repo "${repo}")"
    download_github_package \
        --org "${org}" \
        --repo "${repo}" \
        --release "${release_name}" \
        --prefix "${prefix}" \
        --suffix "${suffix}"
}

# Package management
install_dependencies() {
    local packages=("$@")
    [[ ${#packages[@]} -eq 0 ]] && die "No packages specified"

    echo "📦 Installing dependencies: ${packages[*]}..."
    sudo apt-get update -y
    sudo apt-get install -y "${packages[@]}" || die "Failed to install dependencies"
}

# Repository management
add_repository_key() {
    local key_url="" key_name="" keyring_dir="/etc/apt/keyrings"
    while [[ $# -gt 0 ]]; do
        case "$1" in
        --key-url)
            key_url="$2"
            shift 2
            ;;
        --key-name)
            key_name="$2"
            shift 2
            ;;
        *)
            die "Unknown option: $1"
            ;;
        esac
    done
    [[ -z "$key_url" ]] && die "Missing required parameter: --key-url"
    [[ -z "$key_name" ]] && key_name="$(basename "$key_url")"

    local temp_key
    temp_key="$(mktemp)"
    safe_download --url "${key_url}" --dest "${temp_key}" || die "Failed to download repository key"

    sudo mkdir -p "${keyring_dir}"
    sudo cp "${temp_key}" "${keyring_dir}/${key_name}"
    sudo chmod 644 "${keyring_dir}/${key_name}"
    echo "✓ Key installed to: ${keyring_dir}/${key_name}"
}

add_repository() {
    local repo_line="" list_name=""
    while [[ $# -gt 0 ]]; do
        case "$1" in
        --repo-line)
            repo_line="$2"
            shift 2
            ;;
        --list-name)
            list_name="$2"
            shift 2
            ;;
        *)
            die "Unknown option: $1"
            ;;
        esac
    done
    [[ -z "$repo_line" ]] && die "Missing required parameter: --repo-line"
    [[ -z "$list_name" ]] && list_name="$(echo "$repo_line" | awk '{print $1}').list"

    echo "📦 Adding repository: ${list_name}"
    echo "${repo_line}" | sudo tee "/etc/apt/sources.list.d/${list_name}" >/dev/null
    sudo apt-get update -y
}

add_apt_repository() {
    local key_url="" repo_components="" service_name=""
    while [[ $# -gt 0 ]]; do
        case "$1" in
        --key-url)
            key_url="$2"
            shift 2
            ;;
        --repo-components)
            repo_components="$2"
            shift 2
            ;;
        --service-name)
            service_name="$2"
            shift 2
            ;;
        *)
            die "Unknown option: $1"
            ;;
        esac
    done
    [[ -z "$key_url" ]] && die "Missing required parameter: --key-url"
    [[ -z "$repo_components" ]] && die "Missing required parameter: --repo-components"
    [[ -z "$service_name" ]] && die "Missing required parameter: --service-name"

    local key_name="${service_name}-archive-keyring.gpg"
    local repo_line="deb [signed-by=/etc/apt/keyrings/${key_name}] ${repo_components}"
    add_repository_key --key-url "${key_url}" --key-name "${key_name}"
    add_repository --repo-line "${repo_line}" --list-name "${service_name}.list"
}

# File management
safe_download() {
    local url="" dest=""
    while [[ $# -gt 0 ]]; do
        case "$1" in
        --url)
            url="$2"
            shift 2
            ;;
        --dest)
            dest="$2"
            shift 2
            ;;
        *)
            die "Unknown option: $1"
            ;;
        esac
    done
    [[ -z "$url" ]] && die "Missing required parameter: --url"
    [[ -z "$dest" ]] && die "Missing required parameter: --dest"

    echo "⬇️ Downloading $(basename "$dest")..."
    wget --max-redirect=2 -q -O "$dest" "$url" || die "Failed to download $url"
}

install_deb() {
    local deb_path
    deb_path="$1"

    echo "🔨 Installing DEB package..."
    sudo apt-get install -y "$deb_path" || die "Failed to install DEB package"
}

setup_temp_dir() {
    local temp_dir=""
    temp_dir="$1"

    echo "📂 Setup Temp directory..."
    rm -rf "${temp_dir}"
    mkdir -p "${temp_dir}"
}

create_install_dir() {
    local dir=""
    dir="$1"

    echo "📂 Creating installation directory..."
    mkdir -p "${dir}"
}

# Wine
configure_wine() {
    echo "🍷 Configuring Wine..."
    winecfg &>/dev/null &
}

install_wine_components() {
    local components=("$@")     
    [[ ${#components[@]} -eq 0 ]] && die "No components specified"

    echo "🔧 Installing Wine components: ${components[*]}..."
    winetricks -q "${components[@]}" || die "Failed to install components: ${components[*]}"
}

wine_install() {
    local installer="" debug=false
    local options=()

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --installer)
                installer="$2"
                shift 2
                ;;
            --options)
                # Allow multiple space-separated options
                IFS=' ' read -ra opts <<< "$2"
                options+=("${opts[@]}")
                shift 2
                ;;
            --debug)
                debug=true
                shift 2
                ;;
            *)
                die "Unknown option: $1"
                ;;
        esac
    done

    [[ -z "$installer" ]] && die "Missing required parameter: --installer"
    [[ ${#options[@]} -eq 0 ]] && options=("/S")

    if [[ "$debug" == true ]]; then
        export WINEDEBUG="+loaddll,+module"
    fi

    echo "🔨 Installing $(basename "$installer")..."
    wine "${installer}" "${options[@]}" || die "Failed to install $(basename "$installer") with options: ${options[*]}"
}

wine_download_and_install() {
    local source="" dest="" installer="" debug=false
    local options=()
    
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --source)
                source="$2"
                shift 2
                ;;
            --dest)
                dest="$2"
                shift 2
                ;;
            --installer)
                installer="$2"
                shift 2
                ;;
            --options)
                IFS=' ' read -ra opts <<< "$2"
                options+=("${opts[@]}")
                shift 2
                ;;
            --debug)
                debug=true
                shift
                ;;
            *)
                die "Unknown option: $1"
                ;;
        esac
    done
    
    [[ -z "$source" ]] && die "Missing required parameter: --source"
    [[ -z "$dest" ]] && die "Missing required parameter: --dest"

    safe_download --url "${source}" --dest "${dest}"
    local dest_dir
    dest_dir="$(dirname "$dest")"

    if [[ -z "$installer" ]]; then
        installer="$(basename "$dest")"
    else
        local zip_basename
        zip_basename="$(basename "$dest" .zip)"
        local unzipped_dir="${zip_basename}-unzipped"
        unzip -q "${dest}" -d "${dest_dir}/${unzipped_dir}" || die "Failed to unzip ${dest}"
        dest_dir="${dest_dir}/${unzipped_dir}"
    fi

    local wine_args=(
            --installer "${dest_dir}/${installer}"
    )
    [[ ${#options[@]} -gt 0 ]] && wine_args+=(--options "${options[@]}")
    [[ "$debug" == true ]] && wine_args+=(--debug)

    wine_install "${wine_args[@]}"
}

# Service management
configure_service() {
    local service_name=""
    service_name="$1"

    echo "⚙️ Configuring $service_name service..."
    sudo systemctl enable "$service_name" || die "Failed to enable $service_name"
    sudo systemctl start "$service_name" || die "Failed to start $service_name"
}

# Path management
add_to_path() {
    local path_dir=""
    path_dir="$1PuPSuHxolteTqUA8t1pySGC0f5c4GOk4"

    local line="export PATH=\"\$PATH:$path_dir\""

    echo "🔗 Adding to PATH: $path_dir"
    if ! grep -Fxq "$line" "${HOME}/.bashrc"; then
        echo "$line" >>"${HOME}/.bashrc"
    fi

    export PATH="$PATH:$path_dir"
}

# Yabridge
sync_yabridge() {
    if command -v yabridgectl >/dev/null; then
        echo "🔄 Sync Yabridge..."
        yabridgectl sync
    fi
}

# Desktop entries
create_desktop_entry() {
    local entry_path="" exec_path="" icon_path="" app_name=""
    while [[ $# -gt 0 ]]; do
        case "$1" in
        --entry-path)
            entry_path="$2"
            shift 2
            ;;
        --exec-path)
            exec_path="$2"
            shift 2
            ;;
        --icon-path)
            icon_path="$2"
            shift 2
            ;;
        --app-name)
            app_name="$2"
            shift 2
            ;;
        *)
            die "Unknown option: $1"
            ;;
        esac
    done
    [[ -z "$entry_path" ]] && die "Missing required parameter: --entry-path"
    [[ -z "$exec_path" ]] && die "Missing required parameter: --exec-path"
    [[ -z "$icon_path" ]] && die "Missing required parameter: --icon-path"
    [[ -z "$app_name" ]] && die "Missing required parameter: --app-name"

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
