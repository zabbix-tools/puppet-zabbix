class zabbix::webserver (
  $version           = $::zabbix::params::version,

  $docroot           = $::zabbix::params::web_docroot,
  $user              = $::zabbix::params::web_user,
  $group             = $::zabbix::params::web_group,  

  $repo_manage       = $::zabbix::params::repo_manage,

  $package_manage    = $::zabbix::params::web_package_manage,
  $package_name      = $::zabbix::params::web_package_name,
  $package_ensure    = $::zabbix::params::web_package_ensure,

  $config_manage     = $::zabbix::params::web_config_manage,
  $config_path       = $::zabbix::params::web_config_path,

  $server_descr      = $::zabbix::params::web_server_descr,
  $server_host       = $::zabbix::params::server_host,
  $server_port       = $::zabbix::params::server_port,

  $database_driver   = $::zabbix::params::database_driver,
  $database_host     = $::zabbix::params::database_host,
  $database_schema   = $::zabbix::params::database_schema,
  $database_name     = $::zabbix::params::database_name,
  $database_user     = $::zabbix::params::database_user,
  $database_password = $::zabbix::params::database_password,
  $database_port     = $::zabbix::params::database_port,

  $apache_manage     = $::zabbix::params::web_apache_manage,
  $apache_http_port  = $::zabbix::params::web_apache_http_port,

  $php_package_manage = $::zabbix::params::web_php_package_manage,
  $php_package_name   = $::zabbix::params::web_php_package_name,
  $php_package_ensure = $::zabbix::params::web_php_package_ensure,

  $php_timezone                      = 'UTC',
  $php_max_execution_time            = '300',
  $php_memory_limit                  = '128M',
  $php_post_max_size                 = '16M',
  $php_upload_max_filesize           = '2M',
  $php_max_input_time                = '300',
  $php_max_input_vars                = '5000',
  $php_always_populate_raw_post_data = '-1',
) inherits zabbix::params {
  anchor { '::zabbix::webserver::start' : } ->
  class { '::zabbix::webserver::install' : } ->
  class { '::zabbix::webserver::config' : } ->
  class { '::zabbix::webserver::apache' : } ->
  anchor { '::zabbix::webserver::end' : }
}
