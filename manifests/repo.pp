class zabbix::repo (
  $ensure = 'present',
  $enabled = true,

  $baseurl = $::zabbix::params::repo_url,
  $ns_baseurl = $::zabbix::params::ns_repo_url,
  $gpgkey = $::zabbix::params::repo_gpgkey,

  $repo_version = $::zabbix::params::repo_version,
  $distrelease = $::zabbix::params::distrelease,
) {
  # The base class must be included first because parameter defaults depend on it
  if ! defined(Class['zabbix::params']) {
    fail('You must include the zabbix::params class before using any Zabbix defined resources')
  }

  # Base packages repo
  $repo_name = "zabbix-${repo_version}-${architecture}.el${distrelease}"
  $repo_descr = "Zabbix ${repo_version} EL${distrelease} ${architecture}"
  yumrepo { $repo_name :
    ensure   => $ensure,
    baseurl  => $baseurl,
    descr    => $repo_descr,
    enabled  => $enabled,
    gpgcheck => true,
    gpgkey   => $gpgkey,
  }

  # Non-supported packages repo
  $ns_repo_name = "zabbix-non-supported-${architecture}.el${distrelease}"
  $ns_repo_descr = "Zabbix Non-Supported EL${distrelease} ${architecture}"
  yumrepo { $ns_repo_name :
    ensure   => $ensure,
    baseurl  => $ns_baseurl,
    descr    => $ns_repo_descr,
    enabled  => $enabled,
    gpgcheck => true,
    gpgkey   => $gpgkey,
  }
}