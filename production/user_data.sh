#!/bin/bash
set -e

exec > >(tee /var/log/user-data.log)
exec 2>&1

echo "===== EC2 Bootstrap Started ====="

# Update OS
apt update -y
apt upgrade -y

# Install common administration tools
apt install -y \
    git \
    curl \
    wget \
    unzip \
    vim \
    htop \
    net-tools \
    build-essential

# Set timezone to UTC
timedatectl set-timezone UTC

echo "===== Bootstrap Complete ====="

echo "Server is ready."
echo "Next steps:"
echo "1. SSH into the instance"
echo "2. Install Go"
echo "3. Clone your repository"
echo "4. Build the application"
echo "5. Create systemd service"