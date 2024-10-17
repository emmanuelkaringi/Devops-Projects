# Nginx Log Analyser
This project provides a set of bash scripts to analyze Nginx access logs. The scripts extract useful information such as the top IP addresses, most requested paths, common response status codes, and popular user agents.

## Features
- Analyze Nginx access logs using different Unix command-line tools (awk, grep, sed)
- Provides the following information:
    1. Top 5 IP addresses with the most requests
    2. Top 5 most requested paths
    3. Top 5 response status codes
    4. Top 5 user agents

## Prerequisites
- Bash shell
- Unix-like environment (Linux, macOS, WSL for Windows)
- Basic command-line tools: awk, grep, sed, sort, uniq, head (Pre-installed)

## Usage
1. Clone the repository

    ```sh
    git clone git@github.com:emmanuelkaringi/Devops-Projects.git
    cd nginx-log-analyser
    ```
2. Make the scripts executable

    ```sh
    chmod +x nginx-log-analyser-*.sh
    ```
4. Run a script by providing the path to your Nginx access log file (Use any of the below commands)
    ```sh
    ./nginx-log-analyser-awk.sh /path/to/your/nginx access.log
    ./nginx-log-analyser-grep.sh /path/to/your/nginx access.log
    ./nginx-log-analyser-sed.sh /path/to/your/nginx access.log
    ```

**Example:** `./nginx-log-analyser-awk.sh nginx-access.log`

## Script Descriptions
### nginx-log-analyser-awk.sh
This script primarily uses `awk` to parse and analyze the log file. It's efficient for processing structured text files like log files.
### nginx-log-analyser-grep.sh
This script uses `grep` with regular expressions to extract relevant information from the log file. It demonstrates grep's pattern matching capabilities.
### nginx-log-analyser-sed.sh
This script uses `sed` to transform each line of the log file and extract the required information. It showcases sed's text transformation abilities.

## Sample Output: ./nginx-log-analyser-grep.sh nginx-access.log

```sh
Analyzing nginx access log: nginx-access.log

Top 5 IP addresses with the most requests:
178.128.94.113 - 1087 requests
142.93.136.176 - 1087 requests
138.68.248.85 - 1087 requests
159.89.185.30 - 1086 requests
86.134.118.70 - 277 requests

Top 5 most requested paths:
/v1-health HTTP/1.1 - 4560 requests
/ HTTP/1.1 - 206 requests
/v1-me HTTP/1.1 - 179 requests
/v1-list-workspaces HTTP/1.1 - 90 requests
/.env HTTP/1.1 - 55 requests

Top 5 response status codes:
 200  - 5740 requests
 404  - 937 requests
 304  - 621 requests
 400  - 260 requests
 403  - 23 requests

Top 5 user agents:
DigitalOcean Uptime Probe 0.22.0 (https://digitalocean.com) - 4347 requests
Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36 - 513 requests
Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36 - 332 requests
Custom-AsyncHttpClient - 294 requests
Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36 - 282 requests
```

## Customization
You can easily modify these scripts to extract different information or change the number of top results displayed. Look for the `head -n 5` command in each script and adjust the number as needed.
