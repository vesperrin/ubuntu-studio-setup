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
source install-ilok-license-manager.sh
source install-studio-one.sh
source install-vcv-rack.sh
source install-pulse.sh
source install-cableguys-shaperbox.sh
source install-polyverse-manipulator.sh
source install-acustica-audio-aquarius.sh
source install-sounds-online-installation-center.sh
source install-two-notes-genome.sh
source install-spitfire-audio.sh
source install-bfd-drums-license-manager.sh
source install-xln-audio-online-installer.sh

# Services
# install_syncthing

# Utils
# install_ilok_license_manager
# install_wine
# install_yabridge

# DAW
# install_studio_one

# Product Portals
# install_pulse
# install_sounds_online_installation_center
# install_acustica_audio_aquarius

# Audio Plugins
# install_vcv_rack
# install_cableguys_shaperbox
# install_two_notes_genome
# install_spitfire_audio
# install_polyverse_manipulator
# install_bfd_drums_license_manager
install_xln_audio_online_installer