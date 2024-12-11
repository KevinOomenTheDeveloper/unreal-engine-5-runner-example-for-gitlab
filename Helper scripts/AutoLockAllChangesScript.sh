#!/bin/bash

# Function to display error messages
error() {
  echo -e "\033[31mError: $1\033[0m"  # Red text for error messages
}

# Function to display informational messages
info() {
  echo -e "\033[34m$1\033[0m"  # Blue text for informational messages
}

# Function to display success messages
success() {
  echo -e "\033[32m$1\033[0m"  # Green text for success messages
}

# Function to display messages for files that are already locked
already_locked() {
  echo -e "\033[33m$1\033[0m"  # Yellow text for already locked messages
}

# Confirmation prompt
read -p "You are about to LOCK all files with local changes. Are you sure? (y/n): " CONFIRM

# Check the user's response
if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
  info "Operation canceled."
  exit 0
fi

# Find all modified or new files tracked by Git LFS, including in subdirectories
modified_files=$(git diff --name-only --diff-filter=ACM)

if [ -z "$modified_files" ]; then
  info "No modified LFS files to lock."
else
  info "Locking modified LFS files:"
  echo # Blank line for readability
  for file in $modified_files; do
    # Check if the file is already locked
    if git lfs locks | grep -q "$file"; then
      already_locked "$file is already locked."
    else
      info "Locking $file"
      git lfs lock "$file" 2>&1
      if [ $? -ne 0 ]; then
        error "Failed to lock $file"
      else
        success "$file locked successfully."
      fi
    fi
    echo # Blank line for readability
  done
  success "All modified LFS files are processed."
fi
