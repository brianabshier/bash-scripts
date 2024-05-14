#!/bin/bash

# Specify the file containing the list of IPs
ip_file="ip_list.txt"

# Loop through each IP in the file
while IFS= read -r ip; do
    echo "Pinging IP: $ip"
    
    # Perform the ping 5 times and save the output to a variable
    output=$(ping -c 5 "$ip")
    
    # Print the output
    echo "$output"
    
    echo "===================="
done < "$ip_file"
