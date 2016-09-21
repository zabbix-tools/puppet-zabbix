# PRIVATE CLASS: do not use directly
class zabbix::agent::service {
  if $::zabbix::agent::service_manage {
    if $::operatingsystem == 'windows' {
      exec { 'install zabbix agent service' :
        command => "\"${::zabbix::agent::bin_dir}/zabbix_agentd.exe\" --config \"${::zabbix::agent::config_path}\" --install",
        unless  => "\"${::system32}/sc.exe\" query \"${::zabbix::agent::service_name}\"",
        before  => Service[$::zabbix::agent::service_name],
      }
    }

    service { $::zabbix::agent::service_name :
      ensure  => $::zabbix::agent::service_ensure,
      enable  => $::zabbix::agent::service_enable,
    }
  }
}
