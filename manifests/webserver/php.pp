# Install PHP prerequisites
class zabbix::webserver::php (
  $ensure = 'present',
) {
  $packages = [ 'php', 'php-common', 'php-pgsql', 'php-mbstring', 'php-bcmath', 'php-ldap', 'php-xml', 'php-gd' ]

  package { $packages :
    ensure        => $ensure,
    allow_virtual => false,
  }
}