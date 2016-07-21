# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  open("inventory/hosts" ,'w') do |f|
     f.write "[windows]\n"
  end
  
  config.vm.define "dc" do |dc|
    dc.vm.box = "mwrock/Windows2012R2Full"
	dc.vm.guest = :windows
	dc.vm.communicator = "winrm"
	dc.vm.boot_timeout = 600
    dc.vm.graceful_halt_timeout = 600
	dc.vm.hostname = 'dc'
	dc.winrm.username = "vagrant"
	dc.winrm.retry_limit = 60
	dc.winrm.retry_delay = 10
	dc.winrm.max_tries = 20
	dc.vm.provider :virtualbox do |v|
	 v.customize "pre-boot", [
       "storageattach", :id,
       "--storagectl", "IDE Controller",
        "--port", "0",
       "--device", "1",
       "--type", "dvddrive",
       "--medium", "iso/Win2012R2Std.ISO",
       ]
	  end 
	dc.vm.network "private_network", ip: "192.168.100.10", mac: "080027000010"
	dc.vm.provision :shell, inline: "iex ((new-object net.webclient).DownloadString('https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1'))"
	dc.vm.provision :shell, :path => "provisioning/00_admin_password.ps1", :privileged => "false"
	dc.vm.provision :shell, :path => "provisioning/01_install_AD.ps1"
	open("inventory/hosts" ,'a') do |f|
     f.puts "dc\sansible_host:192.168.100.10\sansible_user:vagrant\sansible_password=vagrant/sansible_winrm_server_cert_validation=ignore\n"
    end
  
  end

(5..7).each do |i|  
vm_name = "srv#{i}"
disk_file = "#{vm_name}.vdi"
hdd_control = "SATA#{i}"
  config.vm.define "srv#{i}" do |srv|
    srv.vm.box = "mwrock/Windows2012R2Full"
	srv.vm.guest = :windows
	srv.vm.hostname = "#{vm_name}"
	srv.vm.box_url = "windows2012r2min-virtualbox.box" 
	
	srv.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
	  unless File.exist?(disk_file)
        v.customize ['createhd', '--filename', disk_file, '--size', 10 * 1024]
      end
	  v.customize ["storagectl", :id, "--name", hdd_control, "--add", "SATA"]
	  v.customize ['storageattach', :id,  '--storagectl', hdd_control, '--port', 1, '--device', 0, '--type', 'hdd', '--medium', disk_file]
	  v.customize "pre-boot", [
       "storageattach", :id,
       "--storagectl", "IDE Controller",
        "--port", "0",
       "--device", "1",
       "--type", "dvddrive",
       "--medium", "iso/Win2012R2Std.ISO",
      ]
    end
	srv.vm.network "private_network", ip: "192.168.100.#{i}"
	srv.vm.provision :shell, :path => "provisioning/ChangeDisks.ps1"
	srv.vm.provision :shell, inline: "iex ((new-object net.webclient).DownloadString('https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1'))"
  end
  VAGRANT_NETWORK_IP="192.168.100.#{i}"
  open("inventory/hosts" ,'a') do |f|
    f.puts "#{vm_name}\sansible_host:#{VAGRANT_NETWORK_IP}\sansible_user:vagrant\sansible_password=vagrant/sansible_winrm_server_cert_validation=ignore\n"
  end
end  
	
  config.vm.define "control" do |control|
    control.vm.box = "centos/7"
	config.vm.synced_folder ".", "/home/vagrant/sync", type: "virtualbox"
    control.vm.network "private_network", ip: "192.168.100.20", mac: "080027000020"
    control.vm.provider "virtualbox" do |v|
      v.cpus = 1
      v.memory = 512
    end
    # copy private key so hosts can ssh using key authentication (the script below sets permissions to 600)
    control.vm.provision :file do |file|
      file.source      = 'C:\Users\mike.fennemore\.vagrant.d\insecure_private_key'
      file.destination = '/home/vagrant/.ssh/id_rsa'
    end
	control.vm.provision :shell, path: "provisioning/control-centos.sh"
  end
  
    # setup the ansible inventory file
  Dir.mkdir("inventory") unless Dir.exist?("inventory")

#  config.vm.define "control" do |control|
#    control.vm.box = "ubuntu/trusty64"
#    control.vm.network "private_network", ip: "192.168.100.20", mac: "080027000020"
#    control.vm.provider "virtualbox" do |v|
#      v.cpus = 1
#      v.memory = 512
#    end
    # copy private key so hosts can ssh using key authentication (the script below sets permissions to 600)
#    control.vm.provision :file do |file|
#      file.source      = 'C:\Users\mike.fennemore\.vagrant.d\insecure_private_key'
#      file.destination = '/home/vagrant/.ssh/id_rsa'
#    end
#    control.vm.provision :shell, path: "provisioning/control.sh"
#  end

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   sudo apt-get update
  #   sudo apt-get install -y apache2
  # SHELL
end
