# PRIVATE CLASS: do not use directly
class zabbix::server::config inherits zabbix::server {
  if $zabbix::server::config_manage {
    file { $zabbix::server::config_path :
      ensure  => 'file',
      owner   => $zabbix::server::user,
      group   => $zabbix::server::group,
      mode    => '0640',
      content => template("${module_name}/zabbix_server.conf.erb"),
      notify  => Class['::zabbix::server::service'],
    }
  }
}
