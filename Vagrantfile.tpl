Vagrant.configure("2") do |config|
  ## Chose your base box
  config.vm.box = "zanbai"

  config.vm.network :private_network, ip: "10.11.12.13"

  ## allocate 1GB memory by default
  config.vm.provider :virtualbox do |vb|
    vb.name = "zanbai"
    vb.customize ["modifyvm", :id, "--memory", "1024"]
  end

  ## do NOT auto update VirtualBox additions
  config.vbguest.auto_update = false

  ## For masterless, mount your salt file root
  config.vm.synced_folder local_zanbai_repo_file, "/vat/tmp"

end