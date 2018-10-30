# -*- mode: ruby -*-
# vi: set ft=ruby

require 'yaml'

servers = YAML.load_file(File.join(File.dirname(__FILE__), 'config/servers.yaml'))

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"

  config.vm.provider "virtualbox" do |vb|
    vb.customize [ "modifyvm", :id, "--uartmode1", "disconnected" ]
  end

  servers['vagrant'].each do |name, server|
    config.vm.define name do |host|
      host.vm.hostname = name
      host.vm.network :private_network, ip: server["ip"]
    end

    if server.has_key?("mem") then
      config.vm.provider :virtualbox do |host|
        host.memory = server["mem"]
      end
    end

    if server.has_key?("cpu") then
      config.vm.provider :virtualbox do |host|
        host.cpus = server["cpu"]
      end
    end

  end

  config.vm.provision :shell, path: "config/bootstrap-kube.sh", :privileged => true

end
