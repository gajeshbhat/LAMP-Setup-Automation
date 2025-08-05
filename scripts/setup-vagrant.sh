#!/bin/bash

# Vagrant Setup Script for LAMP Stack
# This script sets up the development environment using Vagrant

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Vagrant is installed
if ! command -v vagrant &> /dev/null; then
    log_error "Vagrant is not installed. Please install Vagrant first."
    echo "Visit: https://www.vagrantup.com/downloads"
    exit 1
fi

# Check if VirtualBox is installed
if ! command -v VBoxManage &> /dev/null; then
    log_error "VirtualBox is not installed. Please install VirtualBox first."
    echo "Visit: https://www.virtualbox.org/wiki/Downloads"
    exit 1
fi

# Check for KVM conflict on Linux
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if lsmod | grep -q kvm; then
        log_warn "KVM modules are loaded. This may conflict with VirtualBox."
        echo "If you encounter virtualization errors, disable KVM with:"
        echo "  sudo modprobe -r kvm_amd   # For AMD processors"
        echo "  sudo modprobe -r kvm_intel # For Intel processors"
        echo "  sudo modprobe -r kvm"
        echo ""
        echo "Continue anyway? (y/n)"
        read -r response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            log_info "Setup cancelled. Please disable KVM and try again."
            exit 0
        fi
    fi
fi

# Check if Ansible is installed
if ! command -v ansible &> /dev/null; then
    log_warn "Ansible is not installed. Installing Ansible..."
    
    # Install Ansible based on the OS
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        sudo apt update
        sudo apt install -y software-properties-common
        sudo add-apt-repository --yes --update ppa:ansible/ansible
        sudo apt install -y ansible
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        if command -v brew &> /dev/null; then
            brew install ansible
        else
            log_error "Homebrew not found. Please install Ansible manually."
            exit 1
        fi
    else
        log_error "Unsupported OS. Please install Ansible manually."
        exit 1
    fi
fi

log_info "Starting Vagrant VM..."
vagrant up

log_info "VM is ready! You can now deploy the LAMP stack."
echo ""
echo "Next steps:"
echo "1. Deploy LAMP stack: ./scripts/deploy.sh"
echo "2. Access the server: http://localhost:8080"
echo "3. SSH into VM: vagrant ssh"
echo "4. Stop VM: vagrant halt"
echo "5. Destroy VM: vagrant destroy"
