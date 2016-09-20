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

postgresql::server::role { 'zabbix' :
  password_hash => postgresql_password('zabbix', 'zabbix'),
} ->

postgresql::server::database { 'zabbix' :
  owner => 'zabbix',
}

# configure globals
class { '::zabbix::globals' :
  version     => '3.2.0',
  server_port => '10051',
}

# install zabbix server
class { '::zabbix::server' :
  require       => [
    Class['::postgresql::server'],
    Postgresql::Server::Database['zabbix'],
  ],
}

# install zabbix agent
class { '::zabbix::agent' :
  hostname_item => 'system.hostname',
}

# install utilities
class { '::zabbix::get' : }
class { '::zabbix::sender' : }
