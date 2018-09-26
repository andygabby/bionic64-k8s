# -*- mode: ruby -*-
# vi: set ft=ruby

require 'yaml'

servers = YAML.load_file(File.join(File.dirname(__FILE__), 'config/servers.yaml'))

Vagrant.configure("2") do |config|
  config.vm.box = "generic/ubuntu1804"

  servers['vagrant'].each do |name, server|
    config.vm.define name do |host|
      config.vm.synced_folder ".", "/vagrant", type: "sshfs"
      host.vm.hostname = name
      host.vm.network :private_network, ip: server["ip"]
    end

    if server.has_key?("mem") then
      config.vm.provider :libvirt do |host|
        host.memory = server["mem"]
      end
    end

    if server.has_key?("cpu") then
      config.vm.provider :libvirt do |host|
        host.cpus = server["cpu"]
      end
    end

  end

  config.vm.provision :shell, path: "config/bootstrap-kube.sh", :privileged => true
end
