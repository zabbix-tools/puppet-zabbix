# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

# VM build script
$script = <<script
MOD_NAME=zabbix
BULLET="==>"

# Install Ruby Gem dependencies
echo -e "$BULLET Installing required Gems..."
su -l vagrant -c "bundler install --gemfile=/vagrant/Gemfile"

# Install module dependencies
echo -e "$BULLET Installing $MOD_NAME dependencies..."
puppet module install puppetlabs/stdlib
puppet module install puppetlabs/postgresql
puppet module install puppetlabs/apache
puppet module install jfryman/selinux

# Install this module by mapping /vagrant to /etc/puppet/modules/$MOD_NAME
echo -e "$BULLET Installing $MOD_NAME..."
[[ ! -d /etc/puppet/modules/$MOD_NAME ]] && ln -s /vagrant /etc/puppet/modules/$MOD_NAME

# Configure Hiera with alternative values
echo -e "$BULLET Configuring Hiera data..."
[[ -f /var/lib/hiera/global.yaml ]] || cat > /var/lib/hiera/global.yaml <<YAML
---

YAML

# Apply this module
echo -e "$BULLET Applying $MOD_NAME module..."
puppet apply /vagrant/vagrant/manifest.pp
script

# Vagrant condiguration
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "doe/centos-7.0"
  config.vm.network "forwarded_port", guest: 80, host: 8008
  config.vm.provision "shell", inline: $script
end
