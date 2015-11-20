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
      # manage agent service
      if $manage_service {
        class { '::zabbix::agent::service' : }
      }
      
      case $::operatingsystem {
        'windows': {
          file { $::zabbix::params::agent_log_dir :
            ensure => 'directory',
          }
          
          if $manage_service {
            File[$::zabbix::params::agent_log_dir] -> Class['::zabbix::agent::service']
          }
        }
        
        default: { 
          # install package repo
          if $manage_repo {
            require ::zabbix::repo
          }
    
          # install agent package
          package { $package :
            ensure        => $package_version,
            source        => $package_source,
            allow_virtual => false,
          }
          
          Package[$package] ~> Class['::zabbix::agent::service']
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