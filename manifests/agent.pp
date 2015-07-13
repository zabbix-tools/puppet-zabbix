class zabbix::agent (
  $ensure           = 'present',
  $package          = $::zabbix::params::agent_package,
  $package_version  = $::zabbix::params::package_version,
  $package_source   = undef,
  $package_provider = undef,
) inherits zabbix::params {
  case $ensure {
    # install zabbix agent
    'present': {
      require ::zabbix::repo

      # which provider should we use?
      $_package_provider = $package_provider ? {
        undef   => $package_source ? { undef => 'yum', default => 'rpm' },
        default => $package_provider,
      }

      package { $package :
        ensure        => $package_version,
        provider      => $_package_provider,
        source        => $package_source,
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