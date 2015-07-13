class zabbix::agent (
  $ensure           = 'present',
  $package          = $::zabbix::params::agent_package,
  $package_version  = $::zabbix::params::package_version,
  $package_source   = undef,
  $package_provider = undef,
  $manage_repo      = $::zabbix::params::manage_repo,
  $manage_service   = true,
) inherits zabbix::params {
  case $ensure {
    # install zabbix agent
    'present': {
      # install package repo
      if $manage_repo {
        require ::zabbix::repo
      }

      # which provider should we use?
      $_package_provider = $package_provider ? {
        undef   => $package_source ? { undef => 'yum', default => 'rpm' },
        default => $package_provider,
      }

      # install agent package
      package { $package :
        ensure        => $package_version,
        provider      => $_package_provider,
        source        => $package_source,
        allow_virtual => false,
      }

      # manage agent service
      if $manage_service {
        class { '::zabbix::agent::service' : 
          require => Package[$package],
        }
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