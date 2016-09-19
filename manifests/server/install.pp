# PRIVATE CLASS: do not use directly
class zabbix::server::install {
	if $::zabbix::server::package_manage {
		require ::zabbix::repo

		package { $::zabbix::server::package_name :
			ensure => $::zabbix::server::package_ensure,
		}
	}
}
