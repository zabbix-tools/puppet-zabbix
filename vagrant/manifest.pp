#
# Build vagrant VM to test Zabbix classes
#

# install PostgreSQL server first
class { '::postgresql::server' :
  # postgres_password => 'Password1',
  pg_hba_conf_defaults => false,
}

# allow all hosts
postgresql::server::pg_hba_rule { 'allow all hosts':
  type        => 'host',
  database    => 'all',
  user        => 'all',
  address     => 'all',
  auth_method => 'trust',
}

# allow all local sockets
postgresql::server::pg_hba_rule { 'allow all local':
  type        => 'local',
  database    => 'all',
  user        => 'all',
  auth_method => 'trust',
}

# create zabbix role
postgresql::server::role { 'zabbix' :
  password_hash => postgresql_password('zabbix', 'zabbix'),
} ->

# create zabbix database
postgresql::server::database { 'zabbix' :
  owner => 'zabbix',
}

# configure zabbix class globals
class { '::zabbix::globals' :
  version => '3.2.0',
}

# install zabbix server
class { '::zabbix::server' :
  require =>  Postgresql::Server::Database['zabbix']
}

# install webserver, apache and php
class { '::zabbix::webserver' :
  apache_manage => true,
}

# install agent and tools
class { '::zabbix::agent' : }
class { '::zabbix::get' : }
class { '::zabbix::sender' : }
