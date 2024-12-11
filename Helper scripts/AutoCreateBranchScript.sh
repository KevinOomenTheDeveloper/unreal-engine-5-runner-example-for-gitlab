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

# Prompt for the feature branch name
read -p "Enter the feature branch name (without 'feature/'): " branch_name

# Validate input
if [[ -z "$branch_name" ]]; then
  error "Feature branch name cannot be empty."
fi

# Confirmation prompt
read -p "You are about to create 'feature/$branch_name' branch from 'develop'. Are you sure? (y/n): " CONFIRM

# Check the user's response
if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
  info "Operation canceled."
  exit 0
fi

# Check out the develop branch and pull the latest changes
info "Switching to develop branch..."
git checkout develop || error "Failed to checkout 'develop' branch."
echo # Blank line for readability
git pull || error "Failed to pull latest changes for 'develop' branch."
echo # Blank line for readability

# Create the feature branch based on develop
info "Creating feature/$branch_name branch..."
git branch feature/"$branch_name" || error "Failed to create 'feature/$branch_name' branch."
echo # Blank line for readability

# Check out the feature branch
info "Switching to feature/$branch_name branch..."
git checkout feature/"$branch_name" || error "Failed to checkout 'feature/$branch_name' branch."
echo # Blank line for readability

# Set the upstream for the local branch
info "Setting upstream of feature/$branch_name branch..."
git push --set-upstream origin feature/"$branch_name" || error "Failed to set upstream for 'feature/$branch_name' branch."
echo # Blank line for readability

success "Branch creation complete"
