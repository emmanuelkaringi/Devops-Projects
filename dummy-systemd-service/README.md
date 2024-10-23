# Dummy Systemd Service
This project demonstrates how to create and manage a simple background service on a Linux system using `systemd`.

The goal is to help you become familiar with common `systemd` operations, such as creating and enabling a service, checking its status, managing logs, and configuring automatic restarts.

By following the step-by-step guide, you will learn how to:

- Create and configure a `systemd` service
- Enable and start the service automatically on boot
- Interact with the service (start, stop, enable, disable, and check its status)
- Monitor and manage logs using `journalctl`

## Step 1 - Create the `dummy.sh` Script
1. Connect to your AWS EC2 instance:
    ```sh
    ssh -i key-name.pem ec2-user@your-instance-ip
    ```
2. Create the script:
    ```sh
    sudo nano /usr/local/bin/dummy.sh
    ```
3. Add the following content to the script:
    ```sh
    while true; do
        echo "Dummy service is running..." >> /var/log/dummy-service.log
        sleep 10
    done
    ```
**This script writes a message to the log file every 10 seconds**

4. Save the file and exit the editor.

5. Make the script executable:
    ```sh
    sudo chmod +x /usr/local/bin/dummy.sh
    ```

## Step 2 - Create the Systemd Service File
1. Create a new service file:
    ```sh
    sudo nano /etc/systemd/system/dummy.service
    ```
2. Add the following content to the file:
    ```sh
    [Unit]
    # A short description of what the service does. Used for identification when checking the service status
    Description=Dummy Service
    # Specify that the service should only start after the network has been initialized
    After=network.target

    [Service]
    # Command to be executed to start the service
    ExecStart=/usr/local/bin/dummy.sh
    # Tell systemd to automatically restart the service if it stops for any reason
    Restart=always
    # Specify service to run as root user
    User=root

    [Install]
    # Indicate that the service should be started when the system reaches the multi-user (a common system state where most non-graphical services are active)
    WantedBy=multi-user.target
    ```
3. Save the file and exit the editor.

## Step 3: Enable and Start the Service
1. Reload `systemd` to recognize the new service:

    `sudo systemctl daemon-reload`
2. Enable the service to start on boot:

    `sudo systemctl enable dummy`
3. Start the service:

    `sudo systemctl start dummy`

## Step 4 - Check Service Status and Logs
1. Check if service is running:

    `sudo systemctl status dummy`

2. View realtime logs:

    `sudo journalctl -u dummy -f`
3. Open the log file to verify that messages are being written every 10 seconds:

    `sudo tail -f /var/log/dummy-service.log`

## Interacting with the Service
1. To start the service:

    `sudo systemctl start dummy`
2. To stop the service:

    `sudo systemctl stop dummy`
3. To enable the service to start on boot:

    `sudo systemctl enable dummy`
4. To restart the service (comes in handy if you have made any changes to `dummy.sh`):

    `sudo systemctl restart dummy`
5. To check the service status:

    `sudo systemctl status dummy`

6. To disable the service from starting on boot:

    `sudo systemctl disable dummy`

**Don't forget to terminate or stop your EC2 instance after testing to avoid unnecessary costs.**