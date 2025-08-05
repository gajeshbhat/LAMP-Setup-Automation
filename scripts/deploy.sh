#!/bin/bash

# LAMP Stack Deployment Script
# Usage: ./scripts/deploy.sh [environment] [tags]

set -e

# Default values
ENVIRONMENT=${1:-development}
TAGS=${2:-all}
INVENTORY_FILE="inventory/${ENVIRONMENT}.yml"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if inventory file exists
if [[ ! -f "$INVENTORY_FILE" ]]; then
    if [[ "$ENVIRONMENT" == "development" ]]; then
        INVENTORY_FILE="inventory/hosts.yml"
    else
        log_error "Inventory file $INVENTORY_FILE not found!"
        exit 1
    fi
fi

log_info "Starting LAMP stack deployment..."
log_info "Environment: $ENVIRONMENT"
log_info "Inventory: $INVENTORY_FILE"
log_info "Tags: $TAGS"

# Check if Ansible is installed
if ! command -v ansible-playbook &> /dev/null; then
    log_error "Ansible is not installed. Please install Ansible first."
    exit 1
fi

# Run syntax check
log_info "Running syntax check..."
ansible-playbook site.yml -i "$INVENTORY_FILE" --syntax-check

# Run the playbook
log_info "Deploying LAMP stack..."
if [[ "$TAGS" == "all" ]]; then
    ansible-playbook site.yml -i "$INVENTORY_FILE" --ask-become-pass
else
    ansible-playbook site.yml -i "$INVENTORY_FILE" --tags "$TAGS" --ask-become-pass
fi

log_info "Deployment completed successfully!"

# Show access information
if [[ "$ENVIRONMENT" == "development" ]]; then
    echo ""
    log_info "Access your LAMP stack at:"
    echo "  - Local: http://localhost:8080"
    echo "  - VM: http://192.168.56.10"
    echo "  - PHP Info: http://localhost:8080/info.php"
fi
