class zabbix::dbclient (
  $dbengine = $::zabbix::params::dbengine,
  $install_db_client = $::zabbix::params::install_db_client,
) inherits zabbix::params {
  if $install_db_client {
    case $dbengine {
      'pgsql' : {
        # install PostgreSQL client
        class { '::postgresql::client' : }
      }

      default : {
        fail ("Unsupported db engine: ${dbengine}")
      }
    }
  }
}