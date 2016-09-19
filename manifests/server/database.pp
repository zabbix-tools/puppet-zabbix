# PRIVATE CLASS: do not use directly
class zabbix::server::database {
  case $::zabbix::server::database_driver {
    # PostgreSQL
    'pgsql' : {
      $client_bin = 'psql'

      # command defaults
      Exec {
        path => [ '/bin', '/usr/bin', '/usr/local/bin' ],
      }

      # admin password
      if $dbadmin_password {
        $dbadmin_env = [ "PGPASSWORD=${::zabbix::server::database_admin_password}" ]
      } else {
        $dbadmin_env = undef
      }

      # db password {
      if $dbpasswd {
        $db_env = [ "PGPASSWORD=${::zabbix::server::database_password}" ]
      } else {
        $db_env = undef
      }
      
      # create database and schema
      exec { 'create zabbix db role' :
        command     => "${client_bin} -h ${::zabbix::server::database_host} -U ${::zabbix::server::database_admin} -c \"CREATE ROLE \\\"${::zabbix::server::database_user}\\\" WITH LOGIN PASSWORD '${::zabbix::server::database_password}';\"",
        unless      => "${client_bin} -h ${::zabbix::server::database_host} -U ${::zabbix::server::database_user} -At -c \"SELECT 'true' FROM pg_roles WHERE rolname='${::zabbix::server::database_user}';\" -At | grep '^true$'",
        environment => $dbadmin_env,
      } ->
      exec { 'create zabbix database' :
        command     => "${client_bin} -h ${::zabbix::server::database_host} -U ${::zabbix::server::database_admin} -c \"CREATE DATABASE \\\"${::zabbix::server::database_name}\\\" WITH OWNER \\\"${::zabbix::server::database_user}\\\" TEMPLATE \\\"template1\\\";\"",
        unless      => "${client_bin} -h ${::zabbix::server::database_host} -U ${::zabbix::server::database_user} -At -c \"SELECT 'true' FROM pg_database WHERE datname='${::zabbix::server::database_name}';\" | grep '^true$'",
        environment => $dbadmin_env,
      }

      # create database schema
      if $create_schema {
        exec { 'create zabbix database schema' :
          command     => "${client_bin} -h ${::zabbix::server::database_host} -U ${::zabbix::server::database_user} -d ${::zabbix::server::database_name} -f ${pgscripts}/schema.sql",
          unless      => "${client_bin} -h ${::zabbix::server::database_host} -U ${::zabbix::server::database_user} -At -c \"SELECT table_name FROM information_schema.tables WHERE table_name='hosts' AND table_schema='${::zabbix::server::database_schema}'\" | grep '^hosts$'",
          environment => $db_env,
          require     => Exec['create zabbix database'],
        }

        # load sample data
        if $load_sample_data {
          exec { 'load sample data images' :
            command     => "${client_bin} -h ${::zabbix::server::database_host} -U ${::zabbix::server::database_user} -d ${::zabbix::server::database_name} -f ${pgscripts}/images.sql",
            onlyif      => "${client_bin} -h ${::zabbix::server::database_host} -U ${::zabbix::server::database_user} -At -c \"SELECT COUNT(*) FROM images;\" | grep '^0$'",
            environment => $db_env,
            require     => Exec['create zabbix database schema'],
          } ->
          exec { 'load sample data' :
            command     => "${client_bin} -h ${::zabbix::server::database_host} -U ${::zabbix::server::database_user} -d ${::zabbix::server::database_name} -f ${pgscripts}/data.sql",
            onlyif      => "${client_bin} -h ${::zabbix::server::database_host} -U ${::zabbix::server::database_user} -At -c \"SELECT COUNT(*) FROM hosts;\" | grep '^0$'",
            environment => $db_env,
          }
        } 
      }
    }

    default : {
      fail("Unsupported database driver: ${::zabbix::server::database_engine}")
    }
  }
}