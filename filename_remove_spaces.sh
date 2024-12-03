#!/bin/bash

# Initialize the global counter for changed files
changed_files=0

# Function to recursively traverse a directory
function traverse_directory() {
  # Get the directory path
  directory=$1

  # Iterate through all files and subdirectories in the directory
  for entry in "$directory"/*; do
    # Check if it is a file
    if [ -f "$entry" ]; then
      # Replace spaces in the filename with dash
      new_name=${entry// /-}
      
      # Check if the filename has changed
      if [ "$entry" != "$new_name" ]; then
        # Increment the global counter
        ((changed_files++))

        # Display the old and new filenames with path
        echo "**File renamed:**"
        echo "  Old name: $entry"
        echo "  New name: $new_name"

        # Append the change to the log file
        echo "**File renamed:**" >> "$log_file"
        echo "Old name: $entry" >> "$log_file"
        echo "New name: $new_name" >> "$log_file"

        # Rename the file
        mv "$entry" "$new_name"
      fi
    # Check if it is a subdirectory
    elif [ -d "$entry" ]; then
      # Recursively traverse the subdirectory
      traverse_directory "$entry"
    fi
  done
}

# Check if the script was called with a parameter
if [ $# -eq 0 ]; then
  echo "Usage: $0 <full_directory_path>"
  exit 1
fi

# Get the directory path from the parameter
directory=$1

# Check if the directory exists
if [ ! -d "$directory" ]; then
  echo "Directory '$directory' does not exist!"
  exit 1
fi

# Create a unique log file name
log_file="log_$(date +"%Y%m%d_%H%M").txt"

# Start the recursive traversal of the directory
traverse_directory "$directory"

# Display the total number of changed files
echo "**Total changed files: $changed_files"

# Append the total number of changed files to the log file
echo "Total changed files: $changed_files" >> "$log_file"

echo "Script executed successfully!"
