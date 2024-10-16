#!/bin/bash

set -e

usage() {
    echo "Usage: $0 <log-directory> [options]"
    echo "Archive log files from the specified directory."
    echo "Options:"
    echo "  -e EMAIL   Send email notification to EMAIL"
    echo "  -r USER@HOST:PATH   Send archive to remote server"
    echo "  -c BUCKET_NAME   Upload archive to S3 bucket"
    exit 1
}

while getopts ":e:r:c:" opt; do
    case $opt in
        e) email="$OPTARG" ;;
        r) remote="$OPTARG" ;;
        c) s3_bucket="$OPTARG" ;;
        \?) echo "Invalid option -$OPTARG" >&2; usage ;;
    esac
done

shift $((OPTIND-1))

if [ $# -eq 0 ]; then
    echo "Error: Please provide a log directory as an argument."
    usage
fi

log_directory="$1"

if [ ! -d "$log_directory" ]; then
    echo "Error: $log_directory is not a valid directory"
    exit 1
fi

timestamp=$(date +"%Y%m%d_%H%M%S")

archive_dir="${log_directory}/archived_logs"
mkdir -p "$archive_dir"

archive_name="logs_archive_${timestamp}.tar.gz"
archive_path="${archive_dir}/${archive_name}"

find "$log_directory" -maxdepth 1 -type f -print0 | tar -czf "$archive_path" --null -T -

if [ $? -eq 0 ] && [ -f "$archive_path" ]; then
    # Log the archiving operation
    log_file="${archive_dir}/archive_log.txt"
    echo "Archive created on $(date): ${archive_name}" >> "$log_file"

    echo "Log archive created: $archive_path"

    # Send email notification if requested
    if [ -n "$email" ]; then
        echo "Log archive created: $archive_path" | mail -s "Log Archive Notification" "$email"
        echo "Email notification sent to $email"
    fi

    # Send to remote server if requested
    if [ -n "$remote" ]; then
        scp "$archive_path" "$remote"
        echo "Archive sent to remote server: $remote"
    fi

    # Upload to S3 if requested
    if [ -n "$s3_bucket" ]; then
        aws s3 cp "$archive_path" "s3://$s3_bucket/"
        echo "Archive uploaded to S3 bucket: $s3_bucket"
    fi

else
    echo "Error: Failed to create archive"
    exit 1
fi