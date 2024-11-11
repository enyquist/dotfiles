#!/bin/bash

# Update package lists
echo "Updating package lists..."
sudo apt update

# Install NVIDIA driver and utilities
echo "Installing NVIDIA driver and utilities..."
sudo apt install -y nvidia-driver-560 nvidia-utils-560

# Verify NVIDIA driver installation
if dpkg -l | grep -q "nvidia-driver-560" && dpkg -l | grep -q "nvidia-utils-560"; then
    echo "NVIDIA driver and utilities installed successfully."
else
    echo "Failed to install NVIDIA driver and/or utilities. Please check for errors."
    exit 1
fi

# Add the NVIDIA package repository
# Configure the production repository
echo "Adding the NVIDIA package repository..."
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

# Update the packages list from the repository:
sudo apt-get update

# Install the NVIDIA Container Toolkit
echo "Installing NVIDIA Container Toolkit..."
sudo apt install -y nvidia-container-toolkit

# Configure the Docker daemon to use the NVIDIA runtime
echo "Configuring Docker to use NVIDIA runtime..."
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker

# Check if installation succeeded
if dpkg -l | grep -q "nvidia-container-toolkit"; then
    echo "NVIDIA Container Toolkit installed successfully."
else
    echo "Failed to install NVIDIA Container Toolkit. Please check for errors."
    exit 1
fi

# Create the Docker group if it doesn't already exist
if ! getent group docker > /dev/null; then
    sudo groupadd docker
    echo "Docker group created."
fi

# Add the current user to the Docker group
sudo usermod -aG docker $USER
echo "Added $USER to the Docker group. Log out and back in for changes to take effect."

# Enable Docker to start on boot
sudo systemctl enable docker
echo "Docker is set to start on boot."

# Reboot prompt
echo "It's recommended to reboot to activate the NVIDIA driver and container toolkit."
echo "Run 'sudo reboot' to restart your machine."
