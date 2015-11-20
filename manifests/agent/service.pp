# private service class. included by ::zabbix::agent
class zabbix::agent::service (
  $service     = $::zabbix::params::agent_service,
  $bin_dir     = $::zabbix::params::agent_bin_dir,
  $config_file = $::zabbix::params::agent_config_file,
) {
  # The base class must be included first because parameter defaults depend on it
  if ! defined(Class['zabbix::params']) {
    fail('You must include the zabbix::params class before using the agent service class')
  }

  if $::operatingsystem == 'windows' {
    exec { 'install zabbix agent service' :
      command => "\"${bin_dir}/zabbix_agentd.exe\" --config \"${config_file}\" --install",
      unless  => "\"${::system32}/sc.exe\" query \"${service}\"",
      before  => Service[$service],
    }
  }
  
  service { $service :
    ensure  => 'running',
    enable  => true,
  }
}