# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
	config.vm.box = "ubuntu/trusty64"

	# Forward ports to Apache and MySQL
	config.vm.network "forwarded_port", guest: 80, host: 14100
	config.vm.network "forwarded_port", guest: 443, host: 15100

	config.vm.synced_folder "yourapplication", "/var/www/", id: "vagrant-root",
	owner: "vagrant",
	group: "www-data",
	mount_options: ["dmode=775,fmode=664"]

	config.vm.provision "shell", path: "provision.sh"
end
