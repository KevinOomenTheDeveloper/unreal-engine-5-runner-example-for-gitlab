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

# Confirmation prompt
read -p "You are about to UNLOCK all files with local changes. Are you sure? (y/n): " CONFIRM

# Check the user's response
if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
  info "Operation canceled."
  exit 0
fi

# Find all Unreal Engine files (.uasset and .umap) changed in the last commit
changed_files=$(git diff --name-only HEAD~1 HEAD)

if [ -z "$changed_files" ]; then
  info "No modified LFS files to unlock from the last commit."
else
  info "Unlocking LFS files changed in the last commit:"
  echo # Blank line for readability
  for file in $changed_files; do
    info "Unlocking $file"
    git lfs unlock "$file"
    
    if [ $? -eq 0 ]; then
      success "$file unlocked successfully."
    else
      error "Failed to unlock $file"
    fi
    echo # Blank line for readability
  done
  success "All LFS files changed in the last commit are unlocked."
fi
