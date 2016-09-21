# PRIVATE CLASS: do not use directly
class zabbix::webserver::vhost {
  if $::zabbix::webserver::vhost_manage {
    apache::vhost { $::zabbix::webserver::vhost_name :
      port          => $::zabbix::webserver::apache_http_port,
      docroot       => $::zabbix::webserver::docroot,
      docroot_owner => $::zabbix::webserver::user,
      docroot_group => $::zabbix::webserver::group,
      docroot_mode  => '0755',
      priority      => false,
      directories   => [
        {
          path       => $::zabbix::webserver::docroot,
          require    => 'all granted',
          php_values => [
              "date.timezone                 ${::zabbix::webserver::php_timezone}",
              "max_execution_time            ${::zabbix::webserver::php_max_execution_time}",
              "max_input_time                ${::zabbix::webserver::php_max_input_time}",
              "max_input_vars                ${::zabbix::webserver::php_max_input_vars}",
              "memory_limit                  ${::zabbix::webserver::php_memory_limit}",
              "post_max_size                 ${::zabbix::webserver::php_post_max_size}",
              "upload_max_filesize           ${::zabbix::webserver::php_upload_max_filesize}",
              "always_populate_raw_post_data -1",
              "arg_separator.output          &",
              "mbstring.func_overload        0",
              "session.auto_start            0",
          ],
        },
        { 'path' => "${::zabbix::webserver::docroot}/app",     'require' => 'all denied' },
        { 'path' => "${::zabbix::webserver::docroot}/conf",    'require' => 'all denied' },
        { 'path' => "${::zabbix::webserver::docroot}/include", 'require' => 'all denied' },
        { 'path' => "${::zabbix::webserver::docroot}/local",   'require' => 'all denied' },
      ],
    }
  }
}
