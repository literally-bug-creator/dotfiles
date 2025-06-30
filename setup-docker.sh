#!/bin/bash

# Function to print error messages and exit
error_exit() {
    echo "Error: $1" >&2
    exit 1
}

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    error_exit "Docker is not installed. Please install Docker before running this script."
fi

# Enable the Docker service to start on boot.
echo "Enabling Docker service..."
if ! sudo systemctl enable docker.service; then
    error_exit "Failed to enable docker.service."
fi

# Add the current user to the "docker" group
echo "Adding user '$USER' to the 'docker' group..."
if ! sudo usermod -aG docker $USER; then
    error_exit "Failed to add user '$USER' to the docker group."
fi

echo ""
echo "Docker has been configured successfully:"
echo "  - The docker.service has been enabled."
echo "  - User '$USER' has been added to the 'docker' group."
echo ""
echo "IMPORTANT: Please log out and log back in for the group changes to apply."
