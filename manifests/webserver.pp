class zabbix::webserver (
  $ensure = 'present',
  $version = $::zabbix::params::version,
  $package = $::zabbix::params::web_package,

  $dbengine = $::zabbix::params::dbengine,
  $dbdriver = $::zabbix::params::web_db_driver,
  $dbhost = $::zabbix::params::dbhost,
  $dbschema = $::zabbix::params::dbschema,
  $dbname = $::zabbix::params::dbname,
  $dbuser = $::zabbix::params::dbuser,
  $dbpasswd = $::zabbix::params::dbpasswd,
  $dbport = $::zabbix::params::dbport,

  $manage_apache = true,
  $user = $::zabbix::params::web_user,
  $group = $::zabbix::params::web_group,

  $server = $::zabbix::params::server,
  $server_port = $::zabbix::params::server_port,

  $config_file = $::zabbix::params::web_config_file,
  $config_file_mode = $::zabbix::params::web_config_file_mode,
  
) inherits zabbix::params {
      
  # OS specific imlementations
  if $::osfamily != 'RedHat' {
    fail("Unsupported operating system: ${::osfamily}")
  }
  

  case $ensure {
    'present' : {
      # Install server first if on the same box
      if defined(Class['::zabbix::server']) {
        Class['::zabbix::server'] -> Class['::zabbix::webserver']
      }
          
      require ::zabbix::repo

      # Install web server package
      package { $package :
        ensure        => 'present',
        allow_virtual => false,
      }

      # Install Apache HTTP server
      if $manage_apache {
        class { '::zabbix::webserver::apache' :
          user    => $user,
          group   => $group,
        }
      }

      # config file
      file { $config_file :
        ensure  => 'file',
        content => template("${module_name}/zabbix.conf.php.erb"),
        owner   => $user,
        group   => $group,
        mode    => $config_file_mode,
        require => Package[$package],
      }
    }

    'absent' : {
      package { $package :
        ensure => 'purged',
        allow_virtual => false,
      }

      file { $config_file :
        ensure => 'absent',
      }

      if $manage_apache {
        class { '::zabbix::webserver::apache' :
          ensure  => 'absent',
          require => Package[$package],
        }

        class { '::zabbix::webserver::php' : 
          ensure => 'purged',
        }
      }
    }

    default : {
      fail("Unsupported 'ensure' field: ${ensure}")
    }
  }
    
}