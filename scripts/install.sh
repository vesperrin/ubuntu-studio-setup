#!/bin/bash
# Main Install Script

set -euo pipefail

# Constants
TEMPDIR="/tmp"
WINE_PREFIX="${HOME}/.wine"
WINDOWS_VST2_DIR="${WINE_PREFIX}/drive_c/Program\ Files/Steinberg/VstPlugins"
WINDOWS_VST3_DIR="${WINE_PREFIX}/drive_c/Program\ Files/Common\ Files/VST3"
WINDOWS_CLAP_DIR="${WINE_PREFIX}/drive_c/Program\ Files/Common\ Files/CLAP"
LINUX_VST2_DIR="${HOME}/.vst"
LINUX_VST3_DIR="${HOME}/.vst3"
LINUX_CLAP_DIR="${HOME}/.clap"

source utils.sh
source install-syncthing.sh
source install-wine.sh
source install-wine-mono.sh
source install-yabridge.sh
source install-studio-one.sh
source install-vcv-rack.sh
source install-pulse.sh
source install-cableguys-shaperbox.sh
source install-polyverse-manipulator.sh
source install-acustica-audio-aquarius.sh

# install_syncthing

# install_wine
# install_wine_mono
# install_yabridge

# install_studio_one
# install_vcv_rack
# install_pulse
# install_cableguys_shaperbox
install_polyverse_manipulator
# install_acustica_audio_aquarius
