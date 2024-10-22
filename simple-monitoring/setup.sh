#!/bin/bash

########
# Author: Emmanuel Kariithi
# Date: 22-10-2024
#
# Version: v1
#
# Netdata installation
#
# This script installs and configures Netdata
########

set -euo pipefail

# Define log file
LOG_FILE="/var/log/netdata_setup.log"

# Function for logging
log() {
    local message="[$(date +'%Y-%m-%d %H:%M:%S')] $1"
    echo "$message" | sudo tee -a "$LOG_FILE"
    echo "$message"
}

# Check if running as root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        log "Error: This script must be run as root"
        echo "sudo ./setup.sh"
        exit 1
    fi
}

# Installation function
install_netdata() {

    log "Starting Netdata installation..."

    # Update system
    log "Updating system packages..."
    yum update -y >> "$LOG_FILE" 2>&1 || {
        log "Error: System update failed"
        exit 1
    }

    # Download and install Netdata
    log "Downloading and installing Netdata..."
    wget -O /tmp/netdata-kickstart.sh https://get.netdata.cloud/kickstart.sh >> "$LOG_FILE" 2>&1 || {
        log "Error: Failed to download Netdata installer"
        exit 1
    }
    
    sh /tmp/netdata-kickstart.sh --non-interactive >> "$LOG_FILE" 2>&1 || {
        log "Error: Netdata installation failed"
        exit 1
    }

    # Start Netdata
    log "Starting Netdata..."
    systemctl start netdata >> "$LOG_FILE" 2>&1 || {
        log "Error: Starting Netdata failed"
        exit 1
    }

    # Verify installation
    if ! systemctl is-active --quiet netdata; then
        log "Error: Netdata service is not running"
        exit 1
    fi

    # Configure Netdata
    log "Configuring Netdata..."
    cat > /etc/netdata/netdata.conf << EOF
[global]
    history = 7200

[web]
    bind to = 0.0.0.0
EOF

    # Create CPU usage alert configuration
    cat > /etc/netdata/health.d/cpu_usage.conf << EOF
alarm: cpu_usage
on: system.cpu
lookup: average -1m unaligned of user,system,softirq,irq,guest
every: 1m
warn: \$this > 80
crit: \$this > 90
info: CPU utilization over 80%
EOF

    # Restart Netdata to apply changes
    systemctl restart netdata >> "$LOG_FILE" 2>&1 || {
        log "Error: Failed to restart Netdata"
        exit 1
    }

    log "Netdata installation completed successfully"
}
    
# Main execution
main() {
    # Create log file
    touch "$LOG_FILE"
    chmod 644 "$LOG_FILE"

    # Run checks
    check_root

    # Install Netdata
    install_netdata
}

main