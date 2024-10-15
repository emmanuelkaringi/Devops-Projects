#!/bin/bash

########
# Author: Emmanuel Kariithi
# Date: 15-10-2024
#
# Version: v1
#
# Server Information Report
#
# This script provides a comprehensive overview of server resources and usage
########

echo "======= Server Information Report ======="
echo "Date: $(date)"
echo "----------------------------------------"


# OS Version
echo "OS Version:"
cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2
echo "----------------------------------------"
# cat /etc/os-release: Displays the content of the os-release file.
# grep PRETTY_NAME: Filters for the line containing "PRETTY_NAME" which contains the OS name and version.
# cut -d'"' -f2: Extracts the text between the second set of quotation marks.

# Uptime
echo "System Uptime:"
uptime -p
echo "----------------------------------------"
# uptime -p: Shows how long the system has been running in a pretty, human-readable format.

# Load Average
echo "Load Average (1, 5, 15 min):"
uptime | awk '{print $10 " " $11 " " $12}'
echo "----------------------------------------"
# uptime: Shows system uptime and load average.
# The output is piped to awk.
# awk '{print $8 " " $9 " " $10}': Prints fields 8, 9, and 10, which correspond to the 1, 5, and 15-minute load averages.

# CPU Usage
echo "CPU Usage:"
mpstat 1 1 | awk '/Average:/ {print 100-$NF "%"}'
echo "----------------------------------------"
# mpstat 1 1: This runs the mpstat command, which reports processor statistics. The 1 1 means it will take 1 sample with a 1-second interval.
# The output is piped (|) to awk.
# awk '/Average:/ {print "CPU Usage: " 100-$NF "%"}': This awk command looks for the line containing "Average:", then calculates the CPU usage by subtracting the idle percentage (last field, $NF) from 100.


# Memory Usage
echo "Memory Usage:"
free -h | awk 'NR==2{printf "%s/%s (%.2f%%)\n", $3,$2,$3*100/$2 }'
echo "----------------------------------------"
# free -m: Shows memory usage in megabytes.
# The output is piped to awk.
# awk 'NR==2{...}': This processes the second line of the output (which contains the actual memory statistics).
# It prints the used memory ($3), total memory ($2), and calculates the percentage used.

# Disk Usage
echo "Disk Usage:"
df -h | awk '$NF=="/"{printf "%s/%s (%s)\n", $3,$2,$5}'
echo "----------------------------------------"
# df -h: Shows disk usage in a human-readable format.
# The output is piped to awk.
# awk '$NF=="/"{...}': This processes the line where the last field (mount point) is "/", i.e., the root filesystem.
# It prints the used space ($3), total space ($2), and usage percentage ($5).

# Top 5 CPU-consuming processes
echo "Top 5 CPU-consuming processes:"
ps aux --sort=-%cpu | head -n 6
echo "----------------------------------------"
# ps aux: Lists all processes.
# --sort=-%cpu: Sorts the output by CPU usage (descending order).
# head -n 6: Shows only the first 6 lines (header + top 5 processes).

# Top 5 Memory-consuming processes
echo "Top 5 Memory-consuming processes:"
ps aux --sort=-%mem | head -n 6
echo "----------------------------------------"
# Similar to the previous command, but sorts by memory usage (-%mem) instead of CPU.

# Logged in users
echo "Currently logged in users:"
who
echo "----------------------------------------"
#who: Shows who is logged on.

# Failed login attempts
echo "Failed login attempts:"
if [ -f "/var/log/auth.log" ]; then
    grep "Failed password" /var/log/auth.log | wc -l
else
    echo "Auth log not accessible or doesn't exist."
fi
echo "----------------------------------------"
# grep "Failed password" /var/log/auth.log: Searches for lines containing "Failed password" in the auth log.
# wc -l: Counts the number of lines, giving the number of failed attempts.

echo "======= End of Server Information Report ======="