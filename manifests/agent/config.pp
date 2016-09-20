# PRIVATE CLASS: do not use directly
class zabbix::agent::config {
  if $::zabbix::agent::config_manage {
    file { $::zabbix::agent::config_path :
      ensure  => 'file',
      owner   => $::zabbix::params::agent_config_owner,
      group   => $::zabbix::params::agent_config_group,
      mode    => $::zabbix::params::agent_config_mode,
      content => template("${module_name}/zabbix_agentd.conf.erb"),
      notify  => Class['::zabbix::agent::service'],
    }
  }
}
