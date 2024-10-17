#!/bin/bash

########
# Author: Emmanuel Kariithi
# Date: 17-10-2024
#
# Version: v1
#
# Nginx Log Analyser (grep)
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

# Top 5 IP addresses with the most requests
echo -e "\nTop 5 IP addresses with the most requests:"
grep -oE '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' "$LOG_FILE" | sort | uniq -c | sort -rn | head -n 5 | format_output
# -o: Print only the matched parts of a matching line
# -E: Use extended regular expressions
# '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+': Matches IP addresses at the start of each line

# Top 5 most requested paths
echo -e "\nTop 5 most requested paths:"
grep -oE '"GET [^"]*' "$LOG_FILE" | sed 's/"GET //' | sort | uniq -c | sort -rn | head -n 5 | format_output
# '"GET [^"]*': Matches "GET " followed by everything up to the next quote
# sed 's/"GET //': Removes the "GET " part, leaving only the path

# Top 5 response status codes
echo -e "\nTop 5 response status codes:"
grep -oE '" [0-9]{3} ' "$LOG_FILE" | tr -d '"' | sort | uniq -c | sort -rn | head -n 5 | format_output
# '" [0-9]{3} ': Matches a space, followed by 3 digits, followed by a space, all between quotes
# tr -d '"': Removes the quotes

# Top 5 user agents
echo -e "\nTop 5 user agents:"
grep -oE '"[^"]*"$' "$LOG_FILE" | sed 's/"//g' | sort | uniq -c | sort -rn | head -n 5 | format_output
# '"[^"]*"$': Matches everything between quotes at the end of the line
# sed 's/"//g': Removes all quotes