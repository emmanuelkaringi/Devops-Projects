#!/bin/bash

########
# Author: Emmanuel Kariithi
# Date: 17-10-2024
#
# Version: v1
#
# Nginx Log Analyser (awk)
#
# This script analyzes logs from the command line
########

set -e

# check if a log file path is provided as an argument
if [ $# -eq 0 ]; then
    echo "Please provide the path to the nginx access log file."
    exit 1
fi

# store the log file path in a variable
LOG_FILE="$1"

if [ ! -f "$LOG_FILE" ]; then
    echo "Error: File '$LOG_FILE' not found."
    exit 1
fi

echo "Analyzing nginx access log: $LOG_FILE"

format_output(){
    awk '{printf "%s - %s requests\n", $2, $1}'
}

# awk is used to extract the relevant field, then pipe the output through sort, uniq -c (to count occurrences), sort -rn (to sort numerically in reverse order), and head -n 5 (to get the top 5 results).

# Top 5 IP addresses with the most requests
echo -e "\nTop 5 IP addresses with most requests:"
awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -rn | head -n 5 | format_output
# print the first field ($1) which contains the IP address.

# Top 5 most requested paths
echo -e "\nTop 5 most requested paths:"
awk '{print $7}' "$LOG_FILE" | sort | uniq -c | sort -rn | head -n 5 | format_output
# print the seventh field ($7) which contains the requested path

# Top 5 response status codes
echo -e "\nTop 5 response status codes:"
awk '{print $9}' "$LOG_FILE" | sort | uniq -c | sort -rn | head -n 5 | format_output
# print the nineth field ($9) which contains the status code

# Top 5 user agents
echo -e "\nTop 5 user agents:"
awk -F'"' '{print $6}' "$LOG_FILE" | sort | uniq -c | sort -rn | head -n 5 | format_output
# -F'"' sets the field separator to double quotes, as the user agent is typically the 6th field when split this way