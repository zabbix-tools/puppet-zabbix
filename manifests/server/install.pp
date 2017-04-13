# PRIVATE CLASS: do not use directly
class zabbix::server::install {
  if $::zabbix::server::package_manage {
    if $::zabbix::server::repo_manage {
      require ::zabbix::repo
    }

    package { $::zabbix::server::package_name :
      ensure => $::zabbix::server::package_ensure,
      before => File[$::zabbix::server::user_home],
    }
  }

  # create home if it doesn't exist
  file { $::zabbix::server::user_home :
    ensure => 'directory',
    owner  => $::zabbix::server::user_name,
    group  => $::zabbix::server::user_group,
    mode   => '0750',
  }
}
