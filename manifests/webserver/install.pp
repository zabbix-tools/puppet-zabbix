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
    } ->

    # allow httpd to connect to the zabbix server
    selinux::boolean { 'httpd_can_connect_zabbix' : 
      ensure => 'on',
    }
  }

  if $::zabbix::webserver::php_package_manage {
    # php module packages
    package { $::zabbix::webserver::php_package_name :
      ensure => $::zabbix::webserver::php_package_ensure,
    }
  }
}
