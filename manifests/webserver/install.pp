# PRIVATE CLASS: do not use directly
class zabbix::webserver::install {
  if $::zabbix::webserver::package_manage {
    # restart apache if these packages change
    if defined(Class['::apache::server']) {
      Class['::apache::service'] ~> Class['::zabbix::webserver::install']
    }

    # install zabbix web server
    package { $::zabbix::webserver::package_name :
      ensure => $::zabbix::webserver::package_ensure,
    }

    # allow httpd to connect to the zabbix server
    if $::selinux_enforced {
      $bools = [
        'httpd_can_connect_zabbix',
        'httpd_can_network_connect_db',
      ]
      selinux::boolean { $bools :
        ensure  => 'on',
        require => Package[$::zabbix::webserver::package_name],
      }
    }
  }

  if $::zabbix::webserver::php_package_manage {
    # php module packages
    package { $::zabbix::webserver::php_package_name :
      ensure => $::zabbix::webserver::php_package_ensure,
    }
  }
}
