class zabbix::webserver::apache (
  $ensure = 'present',

  $http_port = $::zabbix::params::http_port,
  $docroot = $::zabbix::params::docroot,
  $vhost_priority = false,

  $user = $::zabbix::params::web_user,
  $group = $::zabbix::params::web_group,
  $mode  = $::zabbix::params::docroot_mode,

  $timezone = $::zabbix::params::timezone,

  $php_max_execution_time = 300,
  $php_memory_limit = '128M',
  $php_post_max_size = '16M',
  $php_upload_max_filesize = '2M',
  $php_max_input_time = 300,
) inherits zabbix::params {

  case $ensure {
    'present' : {
      # install apache
      class { '::apache' :
        default_mods        => false,
        default_confd_files => false,
        default_vhost       => false,
      }

      # Start a name server on the required port
      apache::namevirtualhost { "*:${http_port}" : }

      # install PHP
      class { '::apache::mod::php' : }

      # configure Zabbix VHost
      apache::vhost { 'zabbix':
        port          => $http_port,
        docroot       => $docroot,
        docroot_owner => $user,
        docroot_group => $group,
        docroot_mode  => $mode,
        priority      => $vhost_priority,
        directories   => [
          {
            path       => $docroot,
            require    => 'all granted',
            option     => [ 'FollowSymLinks' ],
            php_values => [
                "max_execution_time ${php_max_execution_time}",
                "memory_limit ${php_memory_limit}",
                "post_max_size ${php_post_max_size}",
                "upload_max_filesize ${php_upload_max_filesize}",
                "max_input_time ${php_max_input_time}",
                "date.timezone ${timezone}",
            ],
          },
          { 'path' => "${docroot}/conf",    'require'   => 'all denied' },
          { 'path' => "${docroot}/include", 'require'   => 'all denied' },
        ],
      }
    }

    'absent' : {
      # Remove apache
      package { [ 'httpd', 'httpd-tools' ] :
        ensure => 'purged',
      } ->

      file { '/etc/httpd' :
        ensure => 'absent',
        force  => true,
      }
    }

    default : {
      fail("Unsupported 'ensure' field: ${ensure}")
    }
  }
}