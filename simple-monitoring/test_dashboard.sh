#!/bin/bash

########
# Author: Emmanuel Kariithi
# Date: 22-10-2024
#
# Version: v1
#
# Load Test
#
# This script loads the server to test Netdata monitoring
########

set -euo pipefail

LOG_FILE="/var/log/netdata_test.log"

# Function for logging
log() {
    local message="[$(date +'%Y-%m-%d %H:%M:%S')] $1"
    echo "$message" | sudo tee -a "$LOG_FILE"
    echo "$message"
}

# Install test tools
install_tools() {
    log "Installing test tools..."
    yum install stress-ng iperf3 -y >> "$LOG_FILE" 2>&1 || {
        log "Error: Failed to install test tools"
        exit 1
    }
}

# Run tests
run_tests() {
    log "Starting system load tests..."

    # CPU Test
    log "Testing CPU load..."
    stress-ng --cpu 2 --timeout 30 >> "$LOG_FILE" 2>&1
    log "CPU test completed"

    # Memory Test
    log "Testing memory usage..."
    stress-ng --vm 1 --vm-bytes 1G --timeout 30 >> "$LOG_FILE" 2>&1
    log "Memory test completed"

    # Disk I/O Test
    log "Testing disk I/O..."
    mkdir -p ~/io-test
    cd ~/io-test
    stress-ng --io 2 --timeout 30 >> "$LOG_FILE" 2>&1
    dd if=/dev/zero of=testfile bs=1M count=1000 >> "$LOG_FILE" 2>&1
    log "Disk I/O test completed"

    # Network Test
    log "Testing network..."
    iperf3 -s -D >> "$LOG_FILE" 2>&1
    sleep 2  # Give server time to start
    iperf3 -c localhost >> "$LOG_FILE" 2>&1
    pkill -f iperf3
    log "Network test completed"

    # Combined Load Test
    log "Running combined load test..."
    stress-ng --cpu 2 --vm 1 --vm-bytes 512M --io 2 --timeout 60 >> "$LOG_FILE" 2>&1
    log "Combined load test completed"
}

# Main execution
main() {
    touch "$LOG_FILE"
    chmod 644 "$LOG_FILE"

    if [[ $EUID -ne 0 ]]; then
        log "Error: This script must be run as root"
        exit 1
    fi

    install_tools
    run_tests

    log "All tests completed successfully"
    log "Check Netdata dashboard to view the results"
}

main