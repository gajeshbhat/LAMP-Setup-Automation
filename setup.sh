#!/usr/bin/env bash

# Install Ansible
sudo apt-get update
sudo apt-get install software-properties-common
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt-get install ansible

# Clone the repository
git clone https://github.com/ansible/ansible-lamp-stack.git

# Navigate to the repository
cd ansible-lamp-stack

# Run the playbook
ansible-playbook playbook.yml -i hosts
