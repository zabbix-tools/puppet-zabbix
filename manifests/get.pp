class zabbix::get (
  $package_name   = $::zabbix::params::get_package_name,
  $package_ensure = $::zabbix::params::get_package_ensure,

  $repo_manage    = $::zabbix::params::repo_manage,
) inherits zabbix::params {
	if $repo_manage {
		require zabbix::repo
	}
	
	package { $package_name:
		ensure => $package_ensure,
	}
}
