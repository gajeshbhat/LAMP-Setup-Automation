# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # Base box configuration
  config.vm.box = "ubuntu/jammy64"  # Ubuntu 22.04 LTS
  config.vm.box_check_update = false

  # VM Configuration
  config.vm.define "lamp-vm" do |lamp|
    # Network configuration
    lamp.vm.network "private_network", ip: "192.168.56.10"
    lamp.vm.network "forwarded_port", guest: 80, host: 8080, auto_correct: true
    lamp.vm.network "forwarded_port", guest: 443, host: 8443, auto_correct: true
    lamp.vm.network "forwarded_port", guest: 3306, host: 3306, auto_correct: true

    # Hostname
    lamp.vm.hostname = "lamp-server"

    # VirtualBox specific configuration
    lamp.vm.provider "virtualbox" do |vb|
      vb.name = "LAMP-Stack-VM"
      vb.memory = "2048"
      vb.cpus = 2
      vb.gui = false
      
      # Enable symlinks (useful for development)
      vb.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/vagrant", "1"]
    end

    # Shared folders
    lamp.vm.synced_folder ".", "/vagrant", type: "virtualbox"
    lamp.vm.synced_folder "./www", "/var/www/html", 
      create: true, 
      owner: "www-data", 
      group: "www-data",
      mount_options: ["dmode=775,fmode=664"]

    # Provisioning with shell script (basic setup)
    lamp.vm.provision "shell", inline: <<-SHELL
      # Update system
      apt-get update
      
      # Install Python for Ansible
      apt-get install -y python3 python3-pip
      
      # Create www directory if it doesn't exist
      mkdir -p /var/www/html
      chown -R www-data:www-data /var/www/html
      
      echo "VM provisioning completed. Ready for Ansible deployment."
    SHELL

    # Optional: Provision with Ansible directly
    # Uncomment the following block to run Ansible automatically
    # lamp.vm.provision "ansible" do |ansible|
    #   ansible.playbook = "site.yml"
    #   ansible.inventory_path = "inventory/hosts.yml"
    #   ansible.limit = "all"
    #   ansible.verbose = "v"
    # end
  end

  # Global VM settings
  config.vm.boot_timeout = 600
  config.vm.graceful_halt_timeout = 60

  # SSH configuration
  config.ssh.insert_key = false
  config.ssh.forward_agent = true
end
