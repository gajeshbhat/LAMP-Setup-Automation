#!/bin/bash

# LAMP Stack Testing Script
# Usage: ./scripts/test.sh [environment]

set -e

# Default values
ENVIRONMENT=${1:-development}
INVENTORY_FILE="inventory/${ENVIRONMENT}.yml"

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

# Check if inventory file exists
if [[ ! -f "$INVENTORY_FILE" ]]; then
    if [[ "$ENVIRONMENT" == "development" ]]; then
        INVENTORY_FILE="inventory/hosts.yml"
    else
        log_error "Inventory file $INVENTORY_FILE not found!"
        exit 1
    fi
fi

log_info "Starting LAMP stack tests..."
log_info "Environment: $ENVIRONMENT"
log_info "Inventory: $INVENTORY_FILE"

# Check if Ansible is installed
if ! command -v ansible-playbook &> /dev/null; then
    log_error "Ansible is not installed. Please install Ansible first."
    exit 1
fi

# Run the test playbook
log_info "Running LAMP stack validation tests..."
ansible-playbook tests/test-lamp-stack.yml -i "$INVENTORY_FILE"

log_info "All tests completed!"

# Additional manual tests
echo ""
log_info "Manual verification steps:"
echo "1. Open http://localhost:8080 in your browser"
echo "2. Check PHP info at http://localhost:8080/info.php"
echo "3. Test database connection at http://localhost:8080/db_test.php"
echo "4. SSH into the server and check services:"
echo "   - sudo systemctl status apache2"
echo "   - sudo systemctl status mysql"
echo "   - sudo ufw status"
