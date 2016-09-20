#
# Build vagrant VM to test Zabbix classes
#

# Install PostgreSQL server first
class { '::postgresql::server' :
  # postgres_password => 'Password1',
  pg_hba_conf_defaults => false,
}

# Allow all hosts
postgresql::server::pg_hba_rule { 'allow all hosts':
  type        => 'host',
  database    => 'all',
  user        => 'all',
  address     => 'all',
  auth_method => 'trust',
}

# Allow all local sockets
postgresql::server::pg_hba_rule { 'allow all local':
  type        => 'local',
  database    => 'all',
  user        => 'all',
  auth_method => 'trust',
}

# install zabbix server
class { '::zabbix::server' :
  require       => Class['::postgresql::server'],
}
