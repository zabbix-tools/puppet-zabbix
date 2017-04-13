# PRIVATE CLASS: do not use directly
class zabbix::webserver::config inherits zabbix::webserver {
  $database_driver = $::zabbix::webserver::database_driver ? {
    'pgsql' => 'POSTGRESQL',
    'mysql' => 'MYSQL',
  }

  if $::zabbix::webserver::config_manage {
    file { $::zabbix::webserver::config_path :
      ensure  => 'file',
      content => template("${module_name}/zabbix.conf.php.erb"),
      owner   => $::zabbix::webserver::user,
      group   => $::zabbix::webserver::group,
      mode    => '0644'
    }
  }
}
