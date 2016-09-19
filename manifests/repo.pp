# PRIVATE CLASS: do not use directly
class zabbix::repo inherits zabbix::params {
  if $repo_manage {
    case $::osfamily {
      'RedHat', 'Linux' : {
        $repo_version = "${ver_major}.${ver_minor}"

        yumrepo { "zabbix-${repo_version}-${architecture}.el${distrelease}" :
          ensure   => $repo_ensure,
          enabled  => $repo_enabled,
          baseurl  => $repo_url,
          descr    => "Zabbix ${repo_version} EL${distrelease} ${architecture}",
          gpgcheck => 1,
          gpgkey   => 'http://repo.zabbix.com/RPM-GPG-KEY-ZABBIX',
        }
      }

      default : {
        fail("Unsupported managed repository for osfamily: ${::osfamily}, operatingsystem: ${::operatingsystem}, module ${module_name} currently only supports managing repos for osfamily RedHat")
      }
    }
  }
}