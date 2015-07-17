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

# configure zabbix globals
class { '::zabbix::globals' :
  install_db_client => true,
}

# install zabbix server
class { '::zabbix::server' :
  manage_db     => false,
  require       => Class['::postgresql::server'],
}

# manage the server config file
class { '::zabbix::server::config' : 
  start_db_syncers => 1,
  start_trappers   => 1,
  start_pollers    => 1,
}

# bootstrap the database
class { '::zabbix::server::database' :
  load_sample_data => true,
}

# install the web server
class { '::zabbix::webserver' : }

# install zdcabbix agent
class { '::zabbix::agent' : }

class { '::zabbix::agent::config' : }
