# SSH Remote Server Setup
This project guides you through the process of setting up a remote Linux server and configuring it for secure SSH access. It's designed as a hands-on learning experience for those looking to understand the basics of Linux server management and SSH security practices.

This project can be found on [**roadmap.sh**](https://roadmap.sh/projects/ssh-remote-server-setup)

## Goal
The primary goal of this project is to provide a practical, step-by-step approach to:

- Set up a remote Linux server (using AWS EC2 in this example)
- Configure the server for SSH access using multiple key pairs
- Implement basic security measures to protect against common threats

By completing this project, you'll gain valuable experience in server administration, SSH key management, and basic server security configuration.

## Features

1. Remote Linux server setup on AWS EC2
2. Creation and management of multiple SSH key pairs
3. Configuration of SSH for secure remote access
Setup of SSH config file for simplified connections
4. Installation and configuration of fail2ban for enhanced security

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

## Step 2- Create two new SSH key pairs
Create these on your local machine:
1. Open a terminal on your local machine.
2. Run the following commands:
    ```sh
    ssh-keygen -t rsa -b 4096 -f ~/.ssh/aws_key1
    ssh-keygen -t rsa -b 4096 -f ~/.ssh/aws_key2
    ```
3. For each command, you'll be prompted to enter a passphrase. You can leave it empty for this exercise, but in real-world scenarios, using a passphrase is recommended.

## Step 3- Add the new SSH keys to your server
1. Locate your private key file (the key pair created in AWS).
2. Run this command, if necessary, to ensure your key is not publicly viewable (replace `key-name` with the actual key name).

    `chmod 400 "key-name.pem"`

3. Connect to your AWS instance using the key pair you created during instance launch:

    ```sh
    ssh -i key-name.pem ec2-user@your-instance-ip
    ```

4. On your local machine, display the public keys (open another terminal tab for this):
    ```sh
    cat ~/.ssh/aws_key1.pub
    cat ~/.ssh/aws_key2.pub
    ```
5. Copy the output of each command.
6. On your AWS instance, edit the `authorized_keys` file:
    ```sh
    sudo nano ~/.ssh/authorized_keys
    ```
7. Paste both public keys on new lines in this file.
8. Save and exit (Ctrl+X, then Y, then Enter).

## Step 4- Test connections with both keys
From your local machine, try connecting with both new keys:

```sh
ssh -i ~/.ssh/aws_key1 ec2-user@your-instance-ip
ssh -i ~/.ssh/aws_key2 ec2-user@your-instance-ip
```
Both should work successfully.

## Step 5- Setup SSH config for easier access
1. On your local machine, edit or create the SSH config file:
    ```sh
    nano ~/.ssh/config
    ```
2. Add the following entries:
    ```
    Host aws-server1
        HostName your-instance-ip
        User ec2-user
        IdentityFile ~/.ssh/aws_key1

    Host aws-server2
        HostName your-instance-ip
        User ec2-user
        IdentityFile ~/.ssh/aws_key2
    ```
3. Save and exit.

Now you can connect using:
```sh
ssh aws-server1
ssh aws-server2
```

## Step 6- Install and configure fail2ban
1. Connect to your AWS instance via:
    ```bash
    ssh aws-server1 OR ssh aws-server2
    ```
2. Install fail2ban:
    ```sh
    sudo amazon-linux-extras install epel
    sudo yum install fail2ban
    ```
3. Start and enable fail2ban:
    ```sh
    sudo systemctl start fail2ban
    sudo systemctl enable fail2ban
    ```
4. Configure fail2ban:
    ```sh
    sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
    sudo nano /etc/fail2ban/jail.local
    ```
5. In the [sshd] section, ensure it looks like this:
    ```
    [sshd]
    enabled = true
    port = ssh
    filter = sshd
    logpath = /var/log/secure
    maxretry = 3
    bantime = 600
    ```
6. Save and exit.
7. Restart fail2ban:

    `sudo systemctl restart fail2ban`

This configuration will ban an IP after 3 failed attempts for 10 minutes.

**You are done!**