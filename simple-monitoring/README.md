# Simple Monitoring
This guide provides a step-by-step approach to setting up and using [**Netdata**](https://github.com/netdata/netdata?tab=readme-ov-file), a real-time performance monitoring tool, on an EC2 instance. We will cover two methods: a manual setup process and an automated approach using shell scripts. Additionally, this guide will show you how to conduct stress tests on your server to validate your monitoring setup and how to clean up your system once you're done.

## Method 1 - Manual Setup
### Step 1 - Configure NetData
1. Connect to your server via SSH, I'm using an EC2 instance:
    ```sh
    ssh -i your-key.pem ec2-user@your-instance-ip
    ```
2. Update your system packages:
    ```sh
    sudo yum update -y
    ```
3. Install required dependencies (Optional if wget and curl isn't pre-installed):
    ```sh
    sudo yum install curl wget -y
    ```
4. Install Netdata:
    ```sh
    wget -O /tmp/netdata-kickstart.sh https://get.netdata.cloud/kickstart.sh && sh /tmp/netdata-kickstart.sh
    ```
5. Verify Netdata is running:
    ```sh
    systemctl status netdata
    ```
6. Allow traffic to Netdata's default port (19999) in your EC2 security group (add an inbound rule):
    - **Type**: Custom TCP
    - **Port**: 19999
    - **Source**: Your IP address (for security)
7. Access the Netdata dashboard by opening a web browser and navigating to:

    `http://your-ec2-public-ip:19999`
8. To customize the dashboard, edit the configuration file:

    `sudo nano /etc/netdata/netdata.conf`

    Add these basic configurations:
    ```sh
    [global]
    # Increase history (default is 3600 seconds)
    history = 7200

    [web]
    # Allow connections from any IP
    bind to = 0.0.0.0
    ```
9. To set up an alert for CPU usage, create a new alert configuration:

    `sudo nano /etc/netdata/health.d/cpu_usage.conf`

    Add this alert configuration:
    ```sh
    alarm: cpu_usage
    on: system.cpu
    lookup: average -1m unaligned of user,system,softirq,irq,guest
    every: 1m
    warn: $this > 80
    crit: $this > 90
    info: CPU utilization over 80%
    ```
10. Restart Netdata to apply changes:

    `sudo systemctl restart netdata`

### Step 2 - Stress Test your Server
1. Install stress-ng tool for load testing:

    `sudo yum install stress-ng -y`
2. Test CPU Load:
    ```sh
    # Generate high CPU load using 2 workers for 60 seconds
    stress-ng --cpu 2 --timeout 60
    ```
3. Test Memory Usage:
    ```sh
    # Consume 1GB of RAM for 60 seconds
    stress-ng --vm 1 --vm-bytes 1G --timeout 60
    ```
4. Test Disk I/O:
    ```sh
    # Create a temporary directory for I/O testing
    mkdir ~/io-test
    cd ~/io-test

    # Generate disk I/O with 2 workers for 60 seconds
    stress-ng --io 2 --timeout 60
    ```
5. Test network load:
    ```sh
    sudo yum install iperf3 -y

    # Run iperf3 server
    iperf3 -s

    # In another terminal, run client test
    iperf3 -c localhost
    ```
6. Combined load test:

    `stress-ng --cpu 2 --vm 1 --vm-bytes 512M --io 2 --timeout 120`

### Step 3 - Cleanup System and Remove Netdata Agent
1. Stop the Netdata service:

    `sudo systemctl stop netdata`
2. Remove Netdata:

    `sudo yum remove netdata -y`
3. Remove Netdata configuration files and data:
    ```sh
    # Remove configuration directory
    sudo rm -rf /etc/netdata

    # Remove cache and lib directories
    sudo rm -rf /var/cache/netdata
    sudo rm -rf /var/lib/netdata

    # Remove log files
    sudo rm -rf /var/log/netdata
    ```
4. Remove the stress testing tools:

    `sudo yum remove stress-ng iperf3 -y`
5. Clean up test files and directory:
    ```sh
    # Remove the I/O test directory we created
    rm -rf ~/io-test

    # Remove any temporary files
    rm -f /tmp/testfile
    sudo rm -f /tmp/netdata-kickstart.sh
    ```
6. Clean package cache:

    `sudo yum clean all`
7. Verify cleanup:
    ```sh
    # Check if Netdata service exists
    systemctl status netdata

    # Check for any remaining Netdata processes
    ps aux | grep netdata

    # Check for remaining directories
    ls -la /etc/netdata
    ls -la /var/cache/netdata
    ls -la /var/lib/netdata
    ls -la /var/log/netdata
    ```
## Method 2 - Using Shell scripts
### Script 1 - Setup Netdata (setup.sh)
1. Create `setup.sh` and add the content from my [script](setup.sh):

    `nano setup.sh`
2. Make it executable:

    `chmod +x setup.sh`
3. Run the script:

    `sudo ./setup.sh`
4. Access the Netdata dashboard by opening a web browser and navigating to:

    `http://your-ec2-public-ip:19999`

### Script 2 - Test Netdata monitoring (test_dashboard.sh)
1. Create `test_dashboard.sh` and add the content from my [script](test_dashboard.sh):

    `nano test_dashboard.sh`
2. Make it executable:

    `chmod +x test_dashboard.sh`
3. Run the script:

    `sudo ./test_dashboard.sh`

### Script 4 - Remove Netdata and clean up the system (cleanup.sh)
1. Create `cleanup.sh` and add the content from my [script](cleanup.sh):

    `nano cleanup.sh`
2. Make it executable:

    `chmod +x cleanup.sh`
3. Run the script:

    `sudo ./cleanup.sh`

**Don't forget to terminate or stop your EC2 instance after testing to avoid unnecessary costs.**