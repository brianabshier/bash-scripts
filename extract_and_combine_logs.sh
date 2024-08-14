#!/bin/bash

# Check if a directory was provided as an argument
if [ -z "$1" ]; then
    echo "Usage: $0 /path/to/directory"
    exit 1
fi

# Get the directory from the first argument
directory="$1"

# Define the output file
output_file="combined_logs.txt"

# Clear the output file if it already exists
> "$output_file"

# Find all .log.gz files in the specified directory, sort them, and process them in order
find "$directory" -type f -name "*.log.gz" | sort | while read -r file; do
    echo "Processing $file..."
    # Extract the .log.gz file and append its content to the output file
    gunzip -c "$file" >> "$output_file"
done

echo "All log files have been extracted and combined into $output_file in chronological order."
