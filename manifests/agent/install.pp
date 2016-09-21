# PRIVATE CLASS: do not use directly
class zabbix::agent::install {
  if $::zabbix::agent::package_manage {
    if $::zabbix::agent::repo_manage {
      require ::zabbix::repo
    }

    package { $::zabbix::agent::package_name :
      ensure => $::zabbix::agent::package_ensure,
    }
  }
}
