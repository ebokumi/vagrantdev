# -*- mode: ruby -*-
# # vi: set ft=ruby :

require 'fileutils'

Vagrant.require_version ">= 1.6.0"


# Defaults for config options defined in CONFIG
$web_instances = 1
$app_instances = 2
$web_name_prefix = "web"
$app_name_prefix = "app"
$update_channel = "alpha"
$image_version = "current"
$enable_serial_logging = false
$share_home = false
$vm_gui = false
$vm_memory = 512
$vm_cpus = 1
$shared_folders = {}
$forwarded_ports = {}

# Use old vb_xxx config variables when set
def vm_gui
  $vb_gui.nil? ? $vm_gui : $vb_gui
end

def vm_memory
  $vb_memory.nil? ? $vm_memory : $vb_memory
end

def vm_cpus
  $vb_cpus.nil? ? $vm_cpus : $vb_cpus
end

Vagrant.configure("2") do |config|
  # always use Vagrants insecure key

  config.vm.box = "ubuntu/vivid64"


        (1..$web_instances).each do |i|
          config.vm.define vm_name = "%s-%02d" % [$web_name_prefix, i] do |config|
  
            config.vm.provider :virtualbox do |vb, override|
              vb.customize ["storageattach", :id, "--storagectl", "SATAController", "--type", "dvddrive", "--medium", "./config/web/init.iso", "--port", "1", "--device", "0"]
              vb.gui = vm_gui
              vb.memory = vm_memory
              vb.cpus = vm_cpus
            end
  
            ip = "172.17.8.#{i+100}"
            config.vm.network :private_network, ip: ip
  end
  end

      (1..$app_instances).each do |i|
        config.vm.define vm_name = "%s-%02d" % [$app_name_prefix, i] do |config|

          config.vm.provider :virtualbox do |vb, override|
            vb.customize ["storageattach", :id, "--storagectl", "SATAController", "--type", "dvddrive", "--medium", "./config/app0#{i}/init.iso", "--port", "1", "--device", "0"]
            vb.gui = vm_gui
            vb.memory = vm_memory
            vb.cpus = vm_cpus
          end
  
          ip = "172.17.8.#{i+110}"
          config.vm.network :private_network, ip: ip

        end
      end






end