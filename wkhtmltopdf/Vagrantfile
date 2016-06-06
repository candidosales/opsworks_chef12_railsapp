# Base hostname
cookbook = 'wkhtmltopdf'

Vagrant.configure('2') do |config|
  config.berkshelf.enabled = true
  config.cache.auto_detect = true
  config.omnibus.chef_version = :latest

  config.vm.define :centos5 do |centos5|
    centos5.vm.box      = 'opscode-centos-5.11'
    centos5.vm.box_url  = 'http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_centos-5.11_chef-provisionerless.box'
    centos5.vm.hostname = "#{cookbook}-centos-5"
  end

  config.vm.define :centos6 do |centos6|
    centos6.vm.box      = 'opscode-centos-6.6'
    centos6.vm.box_url  = 'http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_centos-6.6_chef-provisionerless.box'
    centos6.vm.hostname = "#{cookbook}-centos-6"
  end

  config.vm.define :debian7 do |debian7|
    debian7.vm.box      = 'opscode-debian-7.7'
    debian7.vm.box_url  = 'http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_debian-7.7_chef-provisionerless.box'
    debian7.vm.hostname = "#{cookbook}-debian-7"
  end

  config.vm.define :fedora18 do |fedora18|
    fedora18.vm.box      = 'opscode-fedora-18'
    fedora18.vm.box_url  = 'http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_fedora-18_chef-provisionerless.box'
    fedora18.vm.hostname = "#{cookbook}-fedora-18"
  end

  config.vm.define :fedora19 do |fedora19|
    fedora19.vm.box      = 'opscode-fedora-19'
    fedora19.vm.box_url  = 'http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_fedora-19_chef-provisionerless.box'
    fedora19.vm.hostname = "#{cookbook}-fedora-19"
  end

  config.vm.define :fedora20 do |fedora20|
    fedora20.vm.box      = 'opscode-fedora-20'
    fedora20.vm.box_url  = 'http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_fedora-20_chef-provisionerless.box'
    fedora20.vm.hostname = "#{cookbook}-fedora-20"
  end

  config.vm.define :freebsd9 do |freebsd9|
    freebsd9.vm.box      = 'opscode-freebsd-9.2'
    freebsd9.vm.box_url  = 'http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_freebsd-9.2_chef-provisionerless.box'
    freebsd9.vm.hostname = "#{cookbook}-freebsd-9"
  end

  config.vm.define :freebsd10 do |freebsd10|
    freebsd10.vm.box      = 'opscode-freebsd-10.1'
    freebsd10.vm.box_url  = 'http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_freebsd-10.1_chef-provisionerless.box'
    freebsd10.vm.hostname = "#{cookbook}-freebsd-10"
  end

  config.vm.define :ubuntu1204 do |ubuntu1204|
    ubuntu1204.vm.box      = 'opscode-ubuntu-12.04'
    ubuntu1204.vm.box_url  = 'http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-12.04_chef-provisionerless.box'
    ubuntu1204.vm.hostname = "#{cookbook}-ubuntu-1204"
  end

  config.vm.define :ubuntu1404 do |ubuntu1404|
    ubuntu1404.vm.box      = 'opscode-ubuntu-14.04'
    ubuntu1404.vm.box_url  = 'http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-14.04_chef-provisionerless.box'
    ubuntu1404.vm.hostname = "#{cookbook}-ubuntu-1404"
  end

  config.vm.network :private_network, ip: '192.168.50.10'

  config.vm.provider 'virtualbox' do |v|
    v.customize ['modifyvm', :id, '--memory', 1024]
  end

  config.vm.provision :chef_solo do |chef|
    chef.log_level = :debug
    chef.json = {
    }
    chef.run_list = [
      "recipe[#{cookbook}]"
    ]
  end
end
