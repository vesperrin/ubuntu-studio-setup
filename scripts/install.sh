#!/bin/bash
# Main Install Script

set -euo pipefail

source utils.sh
source install-syncthing.sh
source install-wine.sh
source install-wine-mono.sh
source install-yabridge.sh
source install-studio-one.sh
source install-vcv-rack.sh
source install-pulse.sh
source install-cableguys-shaperbox.sh

# install_syncthing

install_wine
# install_wine_mono
# install_yabridge

# install_studio_one
# install_vcv_rack
# install_pulse
# install_cableguys_shaperbox
