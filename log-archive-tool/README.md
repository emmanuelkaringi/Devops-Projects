# Log Archiving Tool

This tool is designed to archive logs on a set schedule by compressing them and storing them in a new directory. It can also send email notifications, backup to a remote server, and upload to S3 cloud storage.

This project is part of the [DevOps Roadmap](https://roadmap.sh/projects/log-archive-tool) at [roadmap.sh](https://roadmap.sh/).

## Features
- Compress logs into a tar.gz file
- Store archives in a designated directory
- Log the date and time of each archive operation
- Send email notifications
- Backup archives to a remote server
- Upload archives to an S3 bucket
- Scheduled execution via cron

## Requirements
- Bash shell
- tar (usually pre-installed on Unix-based systems)
- mail command (for email notifications)
- scp command (for remote server backups)
- AWS CLI (for S3 uploads)

## Installation
1. Clone the repository

    ```sh
    git clone git@github.com:emmanuelkaringi/Devops-Projects.git
    cd log-archive-tool
    ```

2. Move the script to a suitable location, such as `/usr/local/bin/`

    ```sh
    sudo mv log-archive-tool.sh /usr/local/bin/log-archive-tool.sh
    ```
3. Make the script executable
    ```sh
    sudo chmod +x /usr/local/bin/log-archive-tool.sh
    ```

## Usage
### Basic usage:

```sh
./log-archive-tool.sh <log-directory> [options]
```

**Options**:

* `-e` EMAIL: Send email notification to EMAIL
* `-r` USER@HOST:PATH: Send archive to remote server
* `-c` BUCKET_NAME: Upload archive to S3 bucket

**Examples**:

1. Archive logs with email notification:
    ```sh
    log-archive-tool.sh /var/log -e admin@example.com
    ```

2. Archive logs and send to a remote server:
    ```sh
    log-archive-tool.sh /var/log -r user@remote-server:/path/to/backup/
    ```

3. Archive logs and upload to S3:
    ```sh
    log-archive-tool.sh /var/log -c my-log-archives-bucket
    ```

4. Combine multiple options:
    ```sh
    log-archive-tool.sh /var/log -e admin@example.com -r user@remote-server:/path/to/backup/ -c my-log-archives-bucket
    ```

## Scheduling
To run the tool on a schedule, you can set up a cron job. Here's an example that runs daily at 2 AM:

1. Open the root crontab for editing:
    ```sh
    sudo crontab -e
    ```

2. Add the following line:
    ```sh
    0 2 * * * /usr/local/bin/log-archive-tool.sh /var/log -e admin@example.com -c my-log-archives-bucket
    ```

3. Save and exit the editor.

Adjust the schedule and options as needed for your use case.

## Configuration
Before using the remote backup or S3 upload features, ensure that:

1. **For remote backups**: SSH key-based authentication is set up for the remote server.
2. **For S3 uploads**: AWS CLI is installed and configured with appropriate credentials.