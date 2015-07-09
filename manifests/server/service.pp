# private service class. included by ::zabbix::server
class zabbix::server::service (
  $service = $::zabbix::params::server_service,
) {
  # The base class must be included first because parameter defaults depend on it
  if ! defined(Class['zabbix::params']) {
    fail('You must include the zabbix::params class before using the server service class')
  }

  service { $service :
    ensure  => 'running',
    enable  => true,
  }
}