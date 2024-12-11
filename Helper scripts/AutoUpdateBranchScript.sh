#!/bin/bash

# Function to display error messages and exit
error() {
  echo -e "\033[31mError: $1\033[0m"  # Red text for error messages
  exit 1
}

# Function to display informational messages
info() {
  echo -e "\033[34m$1\033[0m"  # Blue text for informational messages
}

# Function to display success messages
success() {
  echo -e "\033[32m$1\033[0m"  # Green text for success messages
}

# Get the name of the current branch
branch_name=$(git symbolic-ref --short HEAD) || error "Failed to get current branch name."

# Confirmation prompt
read -p "You are about to merge 'develop' into '$branch_name'. Are you sure? (y/n): " CONFIRM

# Check the user's response
if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
  info "Operation canceled."
  exit 0
fi

# Check out the develop branch and pull the latest changes
info "Switching to develop branch..."
git checkout develop || error "Failed to checkout 'develop' branch."
echo # Blank line for readability
git pull || error "Failed to pull latest changes for 'develop'."
echo # Blank line for readability

# Check out the feature branch and pull the latest changes
info "Switching to $branch_name branch..."
git checkout "$branch_name" || error "Failed to checkout '$branch_name' branch."
echo # Blank line for readability
git pull || error "Failed to pull latest changes for '$branch_name'."
echo # Blank line for readability

# Merge develop into the feature branch
info "Merging develop into $branch_name..."
git merge develop || error "Failed to merge 'develop' into '$branch_name'."
echo # Blank line for readability

success "Merge complete!"
