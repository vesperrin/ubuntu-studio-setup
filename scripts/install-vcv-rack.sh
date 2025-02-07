#!/bin/bash
# VCV Rack Pro Installer
set -euo pipefail

# Constants
VCV_RACK_TEMPDIR="${TEMPDIR}/vcv_rack"
VCV_RACK_ZIP="${VCV_RACK_TEMPDIR}/vcv-rack.zip"
VCV_RACK_UNZIPPED="${VCV_RACK_TEMPDIR}/vcv-rack-unzipped"
VCV_RACK_URL="https://drive.usercontent.google.com/download?id=18o8kZrUTWBLZN50vIXgLjD70612BYDp3&export=download&authuser=00m"
VCV_RACK_INSTALL_DIR="/opt/VCVRack"
VCV_RACK_DESKTOP_ENTRY="/usr/share/applications/vcv-rack.desktop"

install_vcv_rack() {
    log_install "VCV Rack Pro"

    setup_temp_dir "${VCV_RACK_TEMPDIR}"
    create_install_dir "${VCV_RACK_INSTALL_DIR}"

    install_dependencies zenity

    safe_download --url "${VCV_RACK_URL}" --dest "${VCV_RACK_ZIP}"

    echo "📦 Installing VCV Rack..."
    unzip "${VCV_RACK_ZIP}" -d "${VCV_RACK_UNZIPPED}"

    sudo cp -r "${VCV_RACK_UNZIPPED}/Rack2Pro"/* "${VCV_RACK_INSTALL_DIR}/"
    sudo chmod +x "${VCV_RACK_INSTALL_DIR}/Rack"

    echo "🔌 Installing CLAP plugin..."
    mkdir -p "${LINUX_CLAP_DIR}"
    cp "${VCV_RACK_UNZIPPED}/VCV Rack 2.clap" "${LINUX_CLAP_DIR}/"

    create_desktop_entry \
        --entry-path    "${VCV_RACK_DESKTOP_ENTRY}" \
        --exec-path "${VCV_RACK_INSTALL_DIR}/Rack" \
        --icon-path "${VCV_RACK_INSTALL_DIR}/Rack.svg" \
        --app-name "VCV Rack Pro"

    echo "🔗 Creating command line access..."
    sudo ln -sf "${VCV_RACK_INSTALL_DIR}/Rack" /usr/local/bin/rack

    echo "⚙️ Finalizing installation..."
    sudo chown -R root:root "${VCV_RACK_INSTALL_DIR}"
    sudo ldconfig

    log_install_complete "VCV Rack Pro"
}
