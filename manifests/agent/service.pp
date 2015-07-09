# private service class. included by ::zabbix::agent
class zabbix::agent::service (
  $service = $::zabbix::params::agent_service,
) {
  # The base class must be included first because parameter defaults depend on it
  if ! defined(Class['zabbix::params']) {
    fail('You must include the zabbix::params class before using the agent service class')
  }

  service { $service :
    ensure  => 'running',
    enable  => true,
  }
}