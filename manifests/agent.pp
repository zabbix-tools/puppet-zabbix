class zabbix::agent (
  $ensure = 'present',
  $package = $::zabbix::params::agent_package,
  $package_version = $::zabbix::params::package_version,
) inherits zabbix::params {
  case $ensure {
    # install zabbix agent
    'present': {
      require ::zabbix::repo

      package { $package :
        ensure        => $package_version,
        allow_virtual => false,
      }

      class { '::zabbix::agent::service' : 
        require => Package[$package],
      }
    }

    'absent' : {
      # remove zabbix agent
      package { $package :
        ensure        => 'purged',
        allow_virtual => false,
      }
    }

    default: {
      fail ("Unsupported 'ensure' value: ${ensure}")
    }
  }
}