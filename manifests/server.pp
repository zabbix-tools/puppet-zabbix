class zabbix::server (
  $ensure = 'present',
  $version = $::zabbix::params::version,

  $user = $::zabbix::params::server_user,
  $group = $::zabbix::params::server_group,
    
  $dbengine = $::zabbix::params::dbengine,
  $manage_db = false,
) inherits zabbix::params {
  # OS specific imlementations
  if $::osfamily != 'RedHat' {
    fail("Unsupported operating system: ${::osfamily}")
  }

  # Install server before webserver if on the same box
  if defined(Class['::zabbix::webserver']) {
    Class['::zabbix::server'] -> Class['::zabbix::webserver']
  }

  $server_packages = [ 'zabbix', "zabbix-server-${dbengine}" ]

  case $ensure {
    # Install Zabbix server
    'present': {
      require ::zabbix::repo

      # Server package
      package { $server_packages :
        ensure        => $package_version,
        allow_virtual => false,
      }

      # Start Zabbix Server
      class { '::zabbix::server::service' : 
        require => Package[$server_packages],
      }

      # Install PostgreSQL schema
      if $manage_db {
        class { '::zabbix::server::database' :
          dbengine => $dbengine,
          before   => Class['::zabbix::server::service'],
          require  => Package[$server_packages],
        }
      }
    }

    # remove zabbix server
    'absent': {
      package { $server_packages :
        ensure        => 'purged',
        allow_virtual => false,
      }
    }

    default: {
      fail ("Unsupported 'ensure' value: ${ensure}")
    }
  }
}