# -*- mode: ruby -*-
# vim: set ft=ruby :

MACHINES = {
  :otus => {
    :box_name => "generic/ubuntu2204",
    :vm_name => "otus",
    :net => [
      ["192.168.11.150", 2, "255.255.255.0", "inet"],
    ]
  }
}

Vagrant.configure("2") do |config|

  MACHINES.each do |boxname, boxconfig|

    config.vm.define boxname do |box|
      box.vm.box = boxconfig[:box_name]
      box.vm.host_name = boxconfig[:vm_name]
      
      box.vm.synced_folder "./", "/vagrant"
      
      box.vm.provider "virtualbox" do |vb|
        vb.memory = 2048
        vb.cpus = 2

    # Добавление 4 виртуальных дисков по 1 ГБ каждый
    vb.customize ['createhd', '--filename', "#{File.dirname(__FILE__)}/sata1_new.vdi", '--size', 1024]
    vb.customize ['createhd', '--filename', "#{File.dirname(__FILE__)}/sata2_new.vdi", '--size', 1024]
    vb.customize ['createhd', '--filename', "#{File.dirname(__FILE__)}/sata3_new.vdi", '--size', 1024]
    vb.customize ['createhd', '--filename', "#{File.dirname(__FILE__)}/sata4_new.vdi", '--size', 1024]

    vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', "#{File.dirname(__FILE__)}/sata1_new.vdi"]
    vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', "#{File.dirname(__FILE__)}/sata2_new.vdi"]
    vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 3, '--device', 0, '--type', 'hdd', '--medium', "#{File.dirname(__FILE__)}/sata3_new.vdi"]
    vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 4, '--device', 0, '--type', 'hdd', '--medium', "#{File.dirname(__FILE__)}/sata4_new.vdi"]
      end

      boxconfig[:net].each do |ipconf|
        box.vm.network("private_network", ip: ipconf[0], adapter: ipconf[1], netmask: ipconf[2], virtualbox__intnet: ipconf[3])
      end

      if boxconfig.key?(:public)
        box.vm.network "public_network", boxconfig[:public]
      end

      box.vm.provision "shell", path: "setup_raid.sh"
    end
  end
end
