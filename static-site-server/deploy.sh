#!/bin/bash

########
# Author: Emmanuel Kariithi
# Date: 21-10-2024
#
# Version: v1
#
# Static Site Server
#
# This script uses rsync to sync your static site to a server
########

LOCAL_DIR="test-site/"
REMOTE_USER="ec2-user"
REMOTE_HOST="ec2-18-207-151-248.compute-1.amazonaws.com"
REMOTE_DIR="/var/www/html"
SSH_KEY="/home/immah/Downloads/devops-practice.pem"

# Function to run a command with error checking
run_command() {
    if ! "$@"; then
        echo "Error: Command failed: $*"
        exit 1
    fi
}

# Ensure the remote directory exists and has correct permissions
echo "Setting up remote directory..."
run_command ssh -i "$SSH_KEY" "$REMOTE_USER@$REMOTE_HOST" "sudo mkdir -p $REMOTE_DIR && sudo chown -R $REMOTE_USER:$REMOTE_USER $REMOTE_DIR && sudo chmod -R 755 $REMOTE_DIR"

# Sync files
echo "Syncing files..."
run_command rsync -avz --chmod=D755,F644 -e "ssh -i $SSH_KEY" "$LOCAL_DIR" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR"

# Set correct permissions after sync
echo "Setting final permissions..."
run_command ssh -i "$SSH_KEY" "$REMOTE_USER@$REMOTE_HOST" "sudo chown -R nginx:nginx $REMOTE_DIR && sudo chmod -R 755 $REMOTE_DIR"

echo "Deployment completed successfully!"