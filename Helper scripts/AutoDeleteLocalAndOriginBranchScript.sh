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
read -p "You are about to delete the '$branch_name' branch both locally and remotely. Are you sure? (y/n): " CONFIRM

# Check the user's response
if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
  info "Operation canceled."
  exit 0
fi

# Check out the develop branch
info "Switching to develop branch..."
git checkout develop || error "Failed to checkout 'develop' branch."
echo # Blank line for readability

# Delete the remote branch
info "Deleting origin $branch_name branch..."
git push origin --delete "$branch_name" || error "Failed to delete remote branch '$branch_name'."
echo # Blank line for readability

# Delete the local branch
info "Deleting local $branch_name branch..."
git branch -D "$branch_name" || error "Failed to delete local branch '$branch_name'."
echo # Blank line for readability

success "Branch deletion complete!"
