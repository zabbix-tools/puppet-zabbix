class zabbix::server::database (
  $dbengine = $::zabbix::params::dbengine,
  $dbhost = $::zabbix::params::dbhost,
  $dbschema = $::zabbix::params::dbschema,
  $dbname = $::zabbix::params::dbname,
  $dbuser = $::zabbix::params::dbuser,
  $dbpasswd = $::zabbix::params::dbpasswd,
  $dbport = $::zabbix::params::dbport,

  $dbadmin = $::zabbix::params::dbadmin,
  $dbadmin_password = $::zabbix::params::dbadmin_password,
  $dbadmin_db = $::zabbix::params::dbadmin_db,
  
  $pgscripts = $::zabbix::params::pgscripts,

  $create_schema = true,
  $load_sample_data = true,
) {

  # The base class must be included first because parameter defaults depend on it
  if ! defined(Class['zabbix::server']) {
    fail('You must include the zabbix::server class before using the server configuration class')
  }

  require ::zabbix::dbclient
  require ::zabbix::server

  case $dbengine {
    # PostgreSQL
    'pgsql' : {
      $client_bin = 'psql'

      # command defaults
      Exec {
        path => '/bin:/usr/bin',
      }

      # admin password
      if $dbadmin_password {
        $dbadmin_env = [ "PGPASSWORD=${dbadmin_password}" ]
      } else {
        $dbadmin_env = undef
      }

      # db password {
      if $dbpasswd {
        $db_env = [ "PGPASSWORD=${dbpasswd}" ]
      } else {
        $db_env = undef
      }
      
      # create database and schema
      exec { 'create zabbix db role' :
        command     => "${client_bin} -h ${dbhost} -U ${dbadmin} -d ${dbadmin_db} -c \"CREATE ROLE \\\"${dbuser}\\\" WITH LOGIN PASSWORD '${dbpasswd}';\"",
        unless      => "${client_bin} -h ${dbhost} -U ${dbuser} -d ${dbadmin_db} -At -c \"SELECT 'true' FROM pg_roles WHERE rolname='${dbuser}';\" -At | grep '^true$'",
        environment => $dbadmin_env,
      } ->
      exec { 'create zabbix database' :
        command     => "${client_bin} -h ${dbhost} -U ${dbadmin} -d ${dbadmin_db} -c \"CREATE DATABASE \\\"${dbname}\\\" WITH OWNER \\\"${dbuser}\\\" TEMPLATE \\\"template1\\\";\"",
        unless      => "${client_bin} -h ${dbhost} -U ${dbuser} -At -c \"SELECT 'true' FROM pg_database WHERE datname='${dbname}';\" | grep '^true$'",
        environment => $dbadmin_env,
      }

      # create database schema
      if $create_schema {
        exec { 'create zabbix database schema' :
          command     => "${client_bin} -h ${dbhost} -U ${dbuser} -d ${dbname} -f ${pgscripts}/schema.sql",
          unless      => "${client_bin} -h ${dbhost} -U ${dbuser} -At -c \"SELECT table_name FROM information_schema.tables WHERE table_name='hosts' AND table_schema='${dbschema}'\" | grep '^hosts$'",
          environment => $db_env,
          require     => Exec['create zabbix database'],
        }

        # load sample data
        if $load_sample_data {
          exec { 'load sample data images' :
            command     => "${client_bin} -h ${dbhost} -U ${dbuser} -d ${dbname} -f ${pgscripts}/images.sql",
            onlyif      => "${client_bin} -h ${dbhost} -U ${dbuser} -At -c \"SELECT COUNT(*) FROM images;\" | grep '^0$'",
            environment => $db_env,
            require     => Exec['create zabbix database schema'],
          } ->
          exec { 'load sample data' :
            command     => "${client_bin} -h ${dbhost} -U ${dbuser} -d ${dbname} -f ${pgscripts}/data.sql",
            onlyif      => "${client_bin} -h ${dbhost} -U ${dbuser} -At -c \"SELECT COUNT(*) FROM hosts;\" | grep '^0$'",
            environment => $db_env,
          }
        } 
      }
    }

    default : {
      fail("Unsupported database driver: ${dbengine}")
    }
  }
}