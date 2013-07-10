# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
	['loadbalancer-1', 'stager-1', 'appserver-1', 'registry-1'].each do |vm_name|
		config.vm.define vm_name do |cfg|
			cfg.vm.box = "base_fusion"
			cfg.vm.hostname = vm_name

			cfg.vm.synced_folder("test-modules", "/tmp/vagrant-puppet/modules-0/")
			cfg.vm.synced_folder(".", "/tmp/vagrant-puppet/modules-1/dokku")
			cfg.vm.provision :shell,
				:inline => "cd /tmp/vagrant-puppet/modules-1/dokku && puppet apply --modulepath '/tmp/vagrant-puppet/modules-1:/etc/puppet/modules:/tmp/vagrant-puppet/modules-0' test.pp -v --pluginsync"
		end
	end
end
