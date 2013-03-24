# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  [:riak1, :riak2, :riak3].each_with_index do |node, i|
    config.vm.define node do |config|
      config.vm.box = "riak-centos62"
      config.vm.box_url = "http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-x86_64-v20130309.box"
      config.vm.host_name = "#{node.to_s}.vagrant.local"
      config.vm.network :hostonly, "33.33.33.#{30+i}"
      config.vm.forward_port  22, 2230+i
      config.vm.network :hostonly, "10.0.3.#{10+i}"
      config.vm.customize ["modifyvm", :id, "--memory", 512]
      config.vm.provision :puppet do |puppet|
        puppet.manifests_path = "."
        puppet.manifest_file = "./manifests/site.pp"
      end
    end
  end
end
