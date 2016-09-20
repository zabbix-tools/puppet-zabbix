class zabbix::sender (
  $package_name   = $::zabbix::params::sender_package_name,
  $package_ensure = $::zabbix::params::sender_package_ensure,

  $repo_manage    = $::zabbix::params::repo_manage,
) inherits zabbix::params {
	if $repo_manage {
		require zabbix::repo
	}
	
	package { $package_name:
		ensure => $package_ensure,
	}
}
