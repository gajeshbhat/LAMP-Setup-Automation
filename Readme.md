# 🚀 LAMP Stack Automation with Vagrant & Ansible

A modern, production-ready LAMP (Linux, Apache, MySQL, PHP) stack deployment using Vagrant for local development and Ansible for configuration management. This project follows Ansible best practices with modular roles, proper security hardening, and comprehensive testing.

## 📋 Table of Contents

- [Features](#-features)
- [Prerequisites](#-prerequisites)
- [Quick Start](#-quick-start)
- [Project Structure](#-project-structure)
- [Configuration](#-configuration)
- [Deployment](#-deployment)
- [Testing](#-testing)
- [Troubleshooting](#-troubleshooting)
- [Contributing](#-contributing)

## ✨ Features

- **🔧 Modern Stack**: Ubuntu 22.04 LTS, Apache 2.4, MySQL 8.0, PHP 8.1
- **🏗️ Infrastructure as Code**: Complete Vagrant + Ansible automation
- **🔒 Security Hardening**: UFW firewall, Fail2Ban, SSL support, security headers
- **📦 Modular Design**: Ansible roles for maintainable and reusable code
- **🧪 Automated Testing**: Comprehensive validation tests
- **🌍 Multi-Environment**: Development, staging, and production configurations
- **📚 Best Practices**: Following Ansible and security best practices

## 🔧 Prerequisites

### Required Software

1. **Vagrant** (>= 2.2.0)
   ```bash
   # Ubuntu/Debian
   wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
   echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
   sudo apt update && sudo apt install vagrant

   # macOS
   brew install vagrant
   ```

2. **VirtualBox** (>= 6.1)
   ```bash
   # Ubuntu/Debian
   sudo apt install virtualbox

   # macOS
   brew install --cask virtualbox
   ```

   **⚠️ Important for Linux users**: VirtualBox conflicts with KVM. If you encounter virtualization errors, disable KVM:
   ```bash
   # Check if KVM is running
   lsmod | grep kvm

   # Temporarily disable KVM (choose based on your processor)
   sudo modprobe -r kvm_amd   # For AMD processors
   sudo modprobe -r kvm_intel # For Intel processors
   sudo modprobe -r kvm
   ```

3. **Ansible** (>= 4.0)
   ```bash
   # Ubuntu/Debian
   sudo apt update
   sudo apt install software-properties-common
   sudo add-apt-repository --yes --update ppa:ansible/ansible
   sudo apt install ansible

   # macOS
   brew install ansible
   ```

### System Requirements

- **RAM**: Minimum 4GB (8GB recommended)
- **Disk Space**: At least 10GB free space
- **CPU**: 2+ cores recommended

## 🚀 Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/gajeshbhat/LAMP-Setup-Automation.git
cd LAMP-Setup-Automation
```

### 2. Set Up Development Environment

```bash
# Set up Vagrant VM
./scripts/setup-vagrant.sh

# Deploy LAMP stack
./scripts/deploy.sh

# Run tests
./scripts/test.sh
```

### 3. Access Your LAMP Stack

- **Main Site**: http://localhost:8080
- **PHP Info**: http://localhost:8080/info.php
- **Database Test**: http://localhost:8080/db_test.php

## 📁 Project Structure

```
LAMP-Setup-Automation/
├── 📁 inventory/              # Ansible inventory files
│   ├── hosts.yml             # Development inventory
│   ├── production.yml        # Production inventory
│   └── staging.yml           # Staging inventory
├── 📁 group_vars/            # Group variables
│   ├── all.yml              # Global variables
│   ├── lamp_servers.yml     # LAMP server variables
│   └── vault.yml            # Encrypted secrets
├── 📁 roles/                 # Ansible roles
│   ├── 📁 common/           # Common system tasks
│   ├── 📁 security/         # Security hardening
│   ├── 📁 apache/           # Apache web server
│   ├── 📁 mysql/            # MySQL database
│   └── 📁 php/              # PHP configuration
├── 📁 scripts/               # Utility scripts
│   ├── setup-vagrant.sh     # Vagrant setup script
│   ├── deploy.sh            # Deployment script
│   └── test.sh              # Testing script
├── 📁 tests/                 # Test playbooks
│   └── test-lamp-stack.yml  # LAMP stack validation
├── 📁 www/                   # Web content
│   └── index.html           # Default homepage
├── ansible.cfg              # Ansible configuration
├── site.yml                 # Main playbook
├── Vagrantfile              # Vagrant configuration
└── README.md                # This file
```

## ⚙️ Configuration

### Environment Variables

The project supports multiple environments with different configurations:

#### Development (Default)
- **VM IP**: 192.168.56.10
- **Ports**: HTTP (8080), HTTPS (8443), MySQL (3306)
- **Security**: Basic firewall, development-friendly settings
- **PHP**: Debug mode enabled

#### Staging
- **Target**: Remote staging server
- **Security**: Enhanced security, SSL optional
- **PHP**: Production-like settings with some debugging

#### Production
- **Target**: Production servers
- **Security**: Full security hardening, SSL required
- **PHP**: Production optimized, error logging only

### Customizing Variables

Edit the appropriate files in `group_vars/` to customize your deployment:

```yaml
# group_vars/lamp_servers.yml
apache:
  server_name: "your-domain.com"
  server_admin: "admin@your-domain.com"

mysql:
  databases:
    - name: "your_app_db"
      encoding: "utf8mb4"
  users:
    - name: "app_user"
      password: "secure_password"
      priv: "your_app_db.*:ALL"

php:
  version: "8.1"
  settings:
    memory_limit: "512M"
    upload_max_filesize: "100M"
```

### Securing Secrets

Use Ansible Vault to encrypt sensitive data:

```bash
# Encrypt the vault file
ansible-vault encrypt group_vars/vault.yml

# Edit encrypted file
ansible-vault edit group_vars/vault.yml

# Deploy with vault password
ansible-playbook site.yml -i inventory/hosts.yml --ask-vault-pass
```

## 🚀 Deployment

### Local Development with Vagrant

1. **Start the VM**:
   ```bash
   vagrant up
   ```

2. **Deploy LAMP Stack**:
   ```bash
   ./scripts/deploy.sh development
   ```

3. **Access the Application**:
   - Main site: http://localhost:8080
   - SSH into VM: `vagrant ssh`

### Remote Server Deployment

1. **Update Inventory**:
   ```bash
   # Edit inventory/production.yml or inventory/staging.yml
   vim inventory/production.yml
   ```

2. **Deploy to Remote Server**:
   ```bash
   ./scripts/deploy.sh production
   ```

3. **Deploy Specific Components**:
   ```bash
   # Deploy only Apache
   ./scripts/deploy.sh production apache

   # Deploy web components (Apache + PHP)
   ./scripts/deploy.sh production web

   # Deploy database only
   ./scripts/deploy.sh production mysql
   ```

### Advanced Deployment Options

```bash
# Dry run (check what would be changed)
ansible-playbook site.yml -i inventory/hosts.yml --check

# Verbose output
ansible-playbook site.yml -i inventory/hosts.yml -vvv

# Limit to specific hosts
ansible-playbook site.yml -i inventory/hosts.yml --limit lamp-vm

# Skip specific tasks
ansible-playbook site.yml -i inventory/hosts.yml --skip-tags security
```

## 🧪 Testing

### Automated Testing

Run the comprehensive test suite to validate your LAMP stack:

```bash
# Test development environment
./scripts/test.sh

# Test specific environment
./scripts/test.sh production

# Run tests manually
ansible-playbook tests/test-lamp-stack.yml -i inventory/hosts.yml
```

### Manual Testing

1. **Web Server Test**:
   ```bash
   curl -I http://localhost:8080
   # Should return HTTP/1.1 200 OK
   ```

2. **PHP Test**:
   ```bash
   curl http://localhost:8080/info.php
   # Should display PHP information
   ```

3. **Database Test**:
   ```bash
   curl http://localhost:8080/db_test.php
   # Should show "Connection successful"
   ```

4. **Service Status**:
   ```bash
   vagrant ssh -c "sudo systemctl status apache2 mysql"
   ```

### Test Coverage

The automated tests verify:
- ✅ Apache service status and HTTP responses
- ✅ MySQL service status and connectivity
- ✅ PHP installation and functionality
- ✅ Database connectivity from PHP
- ✅ Security configurations (firewall, fail2ban)
- ✅ SSL configuration (if enabled)

## 🔧 Troubleshooting

### Common Issues

#### 1. Vagrant VM Won't Start

**VirtualBox/KVM Conflict (Linux)**:
```bash
# Check if KVM modules are loaded
lsmod | grep kvm

# Disable KVM temporarily (choose based on your processor)
sudo modprobe -r kvm_amd   # For AMD processors
sudo modprobe -r kvm_intel # For Intel processors
sudo modprobe -r kvm

# Try starting VM again
vagrant up
```

**General VirtualBox Issues**:
```bash
# Check VirtualBox status
VBoxManage list runningvms

# Restart VirtualBox service (Linux)
sudo systemctl restart vboxdrv

# Destroy and recreate VM
vagrant destroy -f
vagrant up
```

#### 2. Ansible Connection Issues

```bash
# Test connectivity
ansible all -i inventory/hosts.yml -m ping

# Check SSH configuration
vagrant ssh-config

# Update SSH key
ssh-copy-id -i ~/.ssh/id_rsa.pub vagrant@192.168.56.10
```

#### 3. MySQL Connection Problems

```bash
# Check MySQL status
vagrant ssh -c "sudo systemctl status mysql"

# Reset MySQL root password
vagrant ssh -c "sudo mysql -e \"ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'newpassword';\""

# Check MySQL logs
vagrant ssh -c "sudo tail -f /var/log/mysql/error.log"
```

#### 4. Apache Not Serving Pages

```bash
# Check Apache status and configuration
vagrant ssh -c "sudo systemctl status apache2"
vagrant ssh -c "sudo apache2ctl configtest"

# Check Apache logs
vagrant ssh -c "sudo tail -f /var/log/apache2/error.log"

# Restart Apache
vagrant ssh -c "sudo systemctl restart apache2"
```

#### 5. PHP Not Working

```bash
# Check PHP installation
vagrant ssh -c "php --version"

# Check PHP modules
vagrant ssh -c "php -m"

# Check PHP-FPM (if using)
vagrant ssh -c "sudo systemctl status php8.1-fpm"
```

### Performance Tuning

#### For Development
```yaml
# group_vars/lamp_servers.yml
mysql:
  settings:
    innodb_buffer_pool_size: "128M"

php:
  settings:
    memory_limit: "256M"
    opcache.enable: 1
```

#### For Production
```yaml
# group_vars/lamp_servers.yml
mysql:
  settings:
    innodb_buffer_pool_size: "1G"
    max_connections: 200

php:
  settings:
    memory_limit: "512M"
    opcache.memory_consumption: 256
```

### Logs and Debugging

```bash
# View all logs
vagrant ssh -c "sudo journalctl -f"

# Apache logs
vagrant ssh -c "sudo tail -f /var/log/apache2/access.log"
vagrant ssh -c "sudo tail -f /var/log/apache2/error.log"

# MySQL logs
vagrant ssh -c "sudo tail -f /var/log/mysql/error.log"

# PHP logs
vagrant ssh -c "sudo tail -f /var/log/php_errors.log"

# System logs
vagrant ssh -c "sudo tail -f /var/log/syslog"
```

## 🤝 Contributing

We welcome contributions! Please follow these guidelines:

1. **Fork the Repository**
2. **Create a Feature Branch**: `git checkout -b feature/amazing-feature`
3. **Make Changes**: Follow Ansible best practices
4. **Test Your Changes**: Run the test suite
5. **Commit Changes**: Use conventional commit messages
6. **Push to Branch**: `git push origin feature/amazing-feature`
7. **Open a Pull Request**

### Development Guidelines

- Follow Ansible best practices and conventions
- Use meaningful variable names and comments
- Test all changes in development environment
- Update documentation for new features
- Ensure security best practices are followed

### Code Style

- Use 2 spaces for indentation in YAML files
- Use descriptive task names
- Group related tasks logically
- Use handlers for service restarts
- Implement proper error handling

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Ansible Community](https://www.ansible.com/community) for excellent documentation
- [Vagrant](https://www.vagrantup.com/) for local development environment
- [Ubuntu](https://ubuntu.com/) for the stable Linux foundation
- [Apache](https://httpd.apache.org/), [MySQL](https://www.mysql.com/), and [PHP](https://www.php.net/) communities




