# PRIVATE CLASS: do not use directly
class zabbix::webserver::apache {
  if $::zabbix::webserver::apache_manage {
    class { '::apache' :
      default_mods        => false,
      default_confd_files => false,
      default_vhost       => false,
    }
      
    selinux::boolean { 'httpd_can_network_connect_db' : ensure => 'on' }
    selinux::boolean { 'httpd_can_connect_zabbix' :     ensure => 'on' }
    selinux::boolean { 'httpd_can_connect_ldap' :       ensure => 'on' }

    apache::namevirtualhost { "*:${::zabbix::webserver::apache_http_port}" : }

    apache::vhost { 'zabbix':
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
          option     => [ 'FollowSymLinks' ],
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

    if $::zabbix::webserver::php_package_manage {
      class { '::apache::mod::php' : }

      package { $::zabbix::webserver::php_package_name :
        ensure => $::zabbix::webserver::php_package_ensure,
        notify => Class['::apache::service'],
      }
    }
  }
}
