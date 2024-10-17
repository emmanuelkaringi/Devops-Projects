#!/bin/bash

########
# Author: Emmanuel Kariithi
# Date: 17-10-2024
#
# Version: v1
#
# Nginx Log Analyser (sed)
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

format_output() {
    sed -E 's/^\s*([0-9]+) (.*)$/\2 - \1 requests/'
}
# The sed command swaps the order of the count and the item, and adds " requests" to the end of each line.

# Top 5 IP addresses with the most requests
echo -e "\nTop 5 IP addresses with the most requests:"
sed -E 's/^([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+).*/\1/' "$LOG_FILE" | sort | uniq -c | sort -rn | head -n 5 | format_output
# -E: Use extended regular expressions
# 's/^([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+).*/\1/': Matches IP address at the start of the line and replaces the whole line with just the IP address

# Top 5 most requested paths
echo -e "\nTop 5 most requested paths:"
sed -nE 's/.*"GET ([^ ]*) HTTP.*/\1/p' "$LOG_FILE" | sort | uniq -c | sort -rn | head -n 5 | format_output
# -n: Don't print lines by default
# 's/.*"GET ([^ ]*) HTTP.*/\1/p': Matches the path after "GET " and before " HTTP", and prints only this part

# Top 5 response status codes
echo -e "\nTop 5 response status codes:"
sed -nE 's/.*" ([0-9]{3}) .*/\1/p' "$LOG_FILE" | sort | uniq -c | sort -rn | head -n 5 | format_output
# 's/.*" ([0-9]{3}) .*/\1/p': Matches 3 digits after a quote and space, and prints only these digits

# Top 5 user agents
echo -e "\nTop 5 user agents:"
sed -nE 's/.*"([^"]*)"$/\1/p' "$LOG_FILE" | sort | uniq -c | sort -rn | head -n 5 | format_output
# 's/.*"([^"]*)"$/\1/p': Matches everything between the last set of quotes in the line and prints only this part