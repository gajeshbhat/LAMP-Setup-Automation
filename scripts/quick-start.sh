#!/bin/bash

# LAMP Stack Quick Start Script
# This script provides a guided setup for the LAMP stack

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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

log_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

# Welcome message
echo -e "${GREEN}"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                    LAMP Stack Automation                    ║"
echo "║              Quick Start Setup Assistant                    ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

echo "This script will help you set up a complete LAMP stack using Vagrant and Ansible."
echo ""

# Check prerequisites
log_step "Checking prerequisites..."

# Check Vagrant
if ! command -v vagrant &> /dev/null; then
    log_error "Vagrant is not installed!"
    echo "Please install Vagrant from: https://www.vagrantup.com/downloads"
    exit 1
else
    log_info "Vagrant is installed: $(vagrant --version)"
fi

# Check VirtualBox
if ! command -v VBoxManage &> /dev/null; then
    log_error "VirtualBox is not installed!"
    echo "Please install VirtualBox from: https://www.virtualbox.org/wiki/Downloads"
    exit 1
else
    log_info "VirtualBox is installed"
fi

# Check Ansible
if ! command -v ansible &> /dev/null; then
    log_warn "Ansible is not installed. Would you like to install it? (y/n)"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        log_info "Installing Ansible..."
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
        fi
    else
        log_error "Ansible is required. Please install it manually."
        exit 1
    fi
else
    log_info "Ansible is installed: $(ansible --version | head -n1)"
fi

echo ""
log_step "Setting up the development environment..."

# Start Vagrant VM
log_info "Starting Vagrant VM (this may take a few minutes)..."
vagrant up

if [ $? -eq 0 ]; then
    log_info "✅ Vagrant VM is running successfully!"
else
    log_error "❌ Failed to start Vagrant VM"
    exit 1
fi

echo ""
log_step "Deploying LAMP stack..."

# Deploy LAMP stack
log_info "Running Ansible playbook to install LAMP stack..."
./scripts/deploy.sh development

if [ $? -eq 0 ]; then
    log_info "✅ LAMP stack deployed successfully!"
else
    log_error "❌ Failed to deploy LAMP stack"
    exit 1
fi

echo ""
log_step "Running validation tests..."

# Run tests
./scripts/test.sh development

if [ $? -eq 0 ]; then
    log_info "✅ All tests passed!"
else
    log_warn "⚠️  Some tests failed. Check the output above."
fi

# Success message
echo ""
echo -e "${GREEN}"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                    🎉 SUCCESS! 🎉                          ║"
echo "║              Your LAMP stack is ready!                      ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

echo ""
echo "🌐 Access your LAMP stack:"
echo "   • Main site: http://localhost:8080"
echo "   • PHP Info:  http://localhost:8080/info.php"
echo "   • DB Test:   http://localhost:8080/db_test.php"
echo ""
echo "🔧 Useful commands:"
echo "   • SSH into VM:     vagrant ssh"
echo "   • Stop VM:         vagrant halt"
echo "   • Restart VM:      vagrant reload"
echo "   • Destroy VM:      vagrant destroy"
echo "   • Redeploy:        ./scripts/deploy.sh"
echo "   • Run tests:       ./scripts/test.sh"
echo ""
echo "📚 Documentation: Check README.md for detailed information"
echo ""
echo "Happy coding! 🚀"
