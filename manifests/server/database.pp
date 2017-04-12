# PRIVATE CLASS: do not use directly
class zabbix::server::database {
  if $::zabbix::server::database_manage {
    case $::zabbix::server::database_driver {
      'pgsql' : {
        $setup_bin = '/usr/local/bin/setup_zabbix_pgsql_database.sh'

        # install db configuration script
        file { $setup_bin :
          ensure  => 'file',
          owner   => 0,
          group   => 0,
          mode    => '0755',
          source  => "puppet:///modules/${module_name}/setup_zabbix_pgsql_database.sh",
          seluser => 'system_u',
          seltype => 'bin_t',
          selrole => 'object_r',
        } ->

        # configure database if not configured
        exec { 'setup zabbix database' :
          command => $setup_bin,
          unless  => "${setup_bin} check",
          path    => '/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin',
        }

        # install ~/.pgpass credentials
        file { "${::zabbix::server::user_home}/.pgpass" :
          ensure  => 'file',
          content => template("${module_name}/pgpass.erb"),
          owner   => $::zabbix::server::user_name,
          group   => $::zabbix::server::user_group,
          mode    => '0600',
        }
      }

      default : {
        fail("Unsupported database driver: ${::zabbix::server::database_driver}")
      }
    }
  }
}
