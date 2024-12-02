# bash-scripts
A collection of useful Bash Scripts that can speed up and assist in performing tedious tasks.

1. ns_checker.sh
   - Description: This Bash script reads a list of domain names from a text file (domain_list.txt), queries the authoritative nameservers for each domain using the host command, and prints the results.
   - Usage: ./ns_checker.sh

2. ping_ips.sh
   - Description: This Bash script reads a list of IP addresses from a file (ip_list.txt), pings each IP address five times, and prints the ping results for each IP address.
   - Usage: ./ping_ips.sh

3. monitor_memory_api.sh
   - This script is used in conjunction with a Rackspace Cloud Server that's got the Monitoring Agent installed. It will allow you to schedule the script with cron and then have it restart a service of your choosing if memory utilization percentage exceeds a threshold.
   - Usage: ./monitor_memory_api.sh
   - Add it to your cronjobs with the following steps:
     1) crontab -e
     2) Add the following line and save the file:
        */5 * * * * /usr/local/bin/monitor_memory_api.sh >> /var/log/monitor_memory_api.log 2>&1

4. extract_and_combine_logs.sh
   - Description: This Bash script was intended for Rackspace Cloud Files Logs. After downloading the folder structure of the Access Logs, you can put them in a directory and then run this script to extract all the subfolders, sort them by time/date, and then put them into a single file for viewing.
   - Usage: ./extract_and_combine_logs.sh $PARENT_FOLDER
  
5. ssl_diagnostics.sh
   - Description: This Bash script automates many of the checks for diagnosing SSL/TLS issues when connecting to a server. It tests the OpenSSL version, server certificates, supported protocols, and cipher suites, and outputs useful diagnostic information of the $HOSTNAME you pass in the command.
   - Usage: ./ssl_diagnostics.sh $HOSTNAME
