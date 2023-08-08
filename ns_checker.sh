#!/bin/bash

# Read each line (domain name) from the text file
while IFS= read -r domain; do
    echo "Checking nameservers for: $domain"
    
    # Run host command with type NS and filter out authoritative nameservers
    nameservers=$(host -t ns "$domain" | awk '/name server/ {print $NF}')
    
    # Print the nameservers
    echo "Authoritative nameservers for $domain:"
    echo "$nameservers"
    
    echo "=============================="
done < domain_list.txt
