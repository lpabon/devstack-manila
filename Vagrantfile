# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.network :private_network, ip: "192.168.56.100"

  config.vm.provider :virtualbox do |vb|
    vb.memory = 4096
    vb.cpus = 2
  end

  # View the documentation for the provider you're using for more
  # information on available options.
  config.vm.provision :ansible do |ansible|
    ansible.limit = "all"
    ansible.playbook = "site.yml"
  end
end
