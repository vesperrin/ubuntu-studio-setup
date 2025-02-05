#!/bin/bash
# Studio One Pro 7 Auto-Installer

set -euo pipefail

# Constants
DEB_URL=https://drive.usercontent.google.com/download?id=1t7-rjngrJ8xEV3t0GNlfOww7rNZK7ZhH&export=download&authuser=0&confirm=t&uuid=0cb9362b-c5b4-4389-a3d5-f2f81a18d47a&at=AIrpjvPwHpyXEfphUUDUbdGqZDJd%3A1738798478594

main() {
    echo "🔧 Configuring system..."
    
    # Audio setup
    groupadd -f audio
    usermod -a -G audio "${SUDO_USER:-root}"
    
    # RT priorities
    cat > /etc/security/limits.d/audio.conf <<EOF
@audio   -  rtprio     95
@audio   -  memlock    unlimited
EOF
    
    # Install dependencies
    export DEBIAN_FRONTEND=noninteractive

    # Download & install Studio One
    echo "⬇️ Downloading Studio One..."
    TEMP_DEB="$(mktemp)"
    curl -L "${DEB_URL}" -o "${TEMP_DEB}"
    
    echo "🔨 Installing package..."
    apt-get install -y "${TEMP_DEB}"
    rm -f "${TEMP_DEB}"
    
    echo "✅ Installation complete!"
}

# Only execute if not in source mode
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    main
fi
