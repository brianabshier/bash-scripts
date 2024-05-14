Domain Nameserver Checker

This Bash script reads a list of domain names from a file named "domain_list.txt", queries the authoritative nameservers for each domain, and prints the results.

Usage:
1. Ensure the "domain_list.txt" file contains a list of domain names, each on a separate line.
2. Run the script using the following command:

./nameserver_checker.sh

Note: Ensure that the script has executable permissions (`chmod +x nameserver_checker.sh`) before running it.

Author: Brian Abshier
License: MIT License