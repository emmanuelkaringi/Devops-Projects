# Static Site Server

This project focuses on two key technologies: **Nginx** for efficient web serving and **rsync** for seamless file synchronization between your local development environment and the remote server.

## Step 1- Register and setup a remote Linux server on AWS
1. Log in to your AWS account.
2. Go to the EC2 dashboard.
3. Click "Launch Instance."
4. Assign a name e.g. devops-project
5. Choose an `Amazon Linux 2023` AMI or `Amazon Linux 2` AMI (both free tier eligible).
6. Select `t2.micro` instance type (free tier eligible).
7. Create a new key pair, download it, and keep it safe.
7. Configure instance details (use default settings for now).
8. Configure security group:
    
    **Allow SSH (port 22) from your IP address.**
9. Add storage (default 8GB is fine for this project).
10. Add tags (optional, but good practice).
11. Launch instance.

## Step 2 - Install and Configure Nginx
1. Connect to your AWS EC2 instance:
    ```sh
    ssh -i key-name.pem ec2-user@your-instance-ip
    ```
2. Update your system:
    ```sh
    sudo yum update -y
    ```
3. Install Nginx:
    ```sh
    sudo yum install nginx
    ```
4. Start Nginx and enable it to start on system boot:
    ```sh
    sudo systemctl start nginx
    sudo systemctl enable nginx
    ```
5. Create the `/var/www/html` directory:
    ```sh
    sudo mkdir -p /var/www/html
    ```
6. Set the correct ownership and permissions:
    ```sh
    sudo chown -R ec2-user:ec2-user /var/www/html
    sudo chmod -R 755 /var/www/html
    ```
7. Configure Nginx to serve your static site:
    ```sh
    sudo nano /etc/nginx/nginx.conf
    ```
    In the `server` block, update the `root` directive:

    ```sh
    root /var/www/html;
    ```
8. Save and exit, then restart Nginx:
    ```sh
    sudo systemctl restart nginx
    ```

## Step 3 - Prepare Your Static Site
1. On your local machine, create a directory for your static site:
    ```sh
    mkdir ~/sitename
    cd ~/sitename
    ```
2. Create your HTML, CSS, and add image files to this directory.

## Step 4 - Use rsync to Update the Remote Server (Deployment Script)
1. On your local machine, create a file named `deploy.sh`:
    ```sh
    nano deploy.sh
    ```
2. Add the following content:
    ```sh
    #!/bin/bash

    LOCAL_DIR="~/sitename/"
    REMOTE_USER="ec2-user"
    REMOTE_HOST="your-instance-ip"
    REMOTE_DIR="/var/www/html"
    SSH_KEY="location to your private key/key.pem"

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
    ```
**Remember to replace `your-instance-ip` and `location to your private key/key.pem` with your actual EC2 instance IP and key file name.**

3. Make the script executable:
    ```sh
    chmod +x deploy.sh
    ```
4. Run the script to deploy your site:
    ```sh
    ./deploy.sh
    ```

## Step 5 - Point a Domain Name to Your Server
1. Register a domain name if you haven't already.
2. In your domain registrar's DNS settings, create an A record:
    - Type: A
    - Host: @ (or www)
    - Value: Your EC2 instance's public IP address
3. Wait for DNS propagation (can take up to 48 hours, but often much faster).

*If you don't have a domain name, you can access your site via the server's IP address. This is already set up with the current Nginx configuration.*

**END!**