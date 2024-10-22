#!/bin/bash

########
# Author: Emmanuel Kariithi
# Date: 22-10-2024
#
# Version: v1
#
# Clean up System
#
# This script removes Netdata and cleans up the system
########

set -euo pipefail

LOG_FILE="/var/log/netdata_cleanup.log"

# Function for logging
log() {
    local message="[$(date +'%Y-%m-%d %H:%M:%S')] $1"
    echo "$message" | sudo tee -a "$LOG_FILE"
    echo "$message"
}

# Function to check if running as root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        log "Error: This script must be run as root"
        exit 1
    fi
}

# Function to remove Netdata and cleanup
cleanup() {
    log "Starting cleanup process..."

    # Stop Netdata service
    log "Stopping Netdata service..."
    systemctl stop netdata || log "Warning: Failed to stop Netdata service"

    # Remove Netdata package
    log "Removing Netdata package..."
    yum remove netdata -y >> "$LOG_FILE" 2>&1 || log "Warning: Failed to remove Netdata package"

    # Remove configuration and data directories
    log "Removing Netdata directories..."
    rm -rf /etc/netdata
    rm -rf /var/cache/netdata
    rm -rf /var/lib/netdata
    rm -rf /var/log/netdata

    # Remove test tools
    log "Removing test tools..."
    yum remove stress-ng iperf3 -y >> "$LOG_FILE" 2>&1 || log "Warning: Failed to remove test tools"

    # Clean up test files
    log "Cleaning up test files..."
    rm -rf ~/io-test
    rm -f /tmp/testfile
    rm -f /tmp/netdata-kickstart.sh

    # Remove Netdata user and group
    log "Removing Netdata user and group..."
    userdel netdata 2>/dev/null || log "Warning: Netdata user not found"
    groupdel netdata 2>/dev/null || log "Warning: Netdata group not found"

    # Clean package cache
    log "Cleaning package cache..."
    yum clean all >> "$LOG_FILE" 2>&1

    # Verify cleanup
    log "Verifying cleanup..."
    if systemctl is-active --quiet netdata; then
        log "Warning: Netdata service is still active"
    else
        log "Netdata service successfully removed"
    fi

    log "Cleanup completed successfully"
}

# Main execution
main() {
    touch "$LOG_FILE"
    chmod 644 "$LOG_FILE"

    check_root
    cleanup

    log "System has been cleaned up"
    log "Note: Don't forget to remove the security group rule for port 19999 in AWS console"
}

main