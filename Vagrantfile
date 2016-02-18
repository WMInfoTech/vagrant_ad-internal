# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "wmit/trusty64"
  config.vm.hostname = "trusty"
  config.vm.network :forwarded_port, guest: 9200, host: 9200, auto_correct: true # Elasticsearc
  config.vm.network :forwarded_port, guest: 27017, host: 27017, auto_correct: true # MongoDB
  config.vm.network :forwarded_port, guest: 5433, host: 5433, auto_correct: true # PostgreSQL
  config.vm.network :forwarded_port, guest: 5432, host: 5432, auto_correct: true # PostgreSQL
  config.vm.provider :virtualbox do |vbox|
    vbox.customize ["modifyvm", :id, "--memory", 1024]
  end
  config.vm.synced_folder "", "/vagrant", create: true
  config.vm.provision "shell", path: "./pre-puppet.sh"
  config.vm.provision "shell", path: "./post-puppet.sh"
end
