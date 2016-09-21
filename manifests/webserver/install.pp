# PRIVATE CLASS: do not use directly
class zabbix::webserver::install {
  if $::zabbix::webserver::package_manage {
    package { $::zabbix::webserver::package_name :
    	ensure => $::zabbix::webserver::package_ensure,
    }
  }
}
