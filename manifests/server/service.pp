# PRIVATE CLASS: do not use directly
class zabbix::server::service {
  if $::zabbix::server::service_manage {
    service { $::zabbix::server::service_name :
      ensure  => $::zabbix::server::service_ensure,
      enable  => $::zabbix::server::service_enable,
    }   
  }
}
