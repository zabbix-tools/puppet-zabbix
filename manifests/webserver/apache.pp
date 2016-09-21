# PRIVATE CLASS: do not use directly
class zabbix::webserver::apache {
  if $::zabbix::webserver::apache_manage {
    class { '::apache' :
      default_mods        => false,
      default_confd_files => false,
      default_vhost       => false,
    }

    class { '::apache::mod::php' : }

    apache::namevirtualhost { "*:${::zabbix::webserver::apache_http_port}" : }
  }
}
