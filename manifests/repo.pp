# PRIVATE CLASS: do not use directly
class zabbix::repo inherits zabbix::params {
  if $repo_manage {
    case $::osfamily {
      'RedHat', 'Linux' : {
        $repo_version = "${ver_major}.${ver_minor}"
        $gpg_key_path = '/etc/pki/rpm-gpg/RPM-GPG-KEY-ZABBIX'

        file { $gpg_key_path :
          source  => "puppet:///modules/${module_name}/RPM-GPG-KEY-ZABBIX",
          owner   => 'root',
          group   => 'root',
          mode    => '0644',
          seluser => 'system_u',
          selrole => 'object_r',
          seltype => 'cert_t',
        }

        yumrepo { "zabbix-${repo_version}-${architecture}.el${distrelease}" :
          ensure   => $repo_ensure,
          enabled  => $repo_enabled,
          baseurl  => $repo_baseurl,
          descr    => "Zabbix ${repo_version} EL${distrelease} ${architecture}",
          gpgcheck => 1,
          gpgkey   => "file://${gpg_key_path}",
          require  => File[$gpg_key_path],
        }

        if $repo_enable_nonsupported {
          yumrepo { "zabbix-non-supported-${architecture}.el${distrelease}" :
            ensure   => $repo_ensure,
            enabled  => $repo_enabled,
            baseurl  => $repo_baseurl_nonsupported,
            descr    => "Zabbix Non-Supported EL${distrelease} ${architecture}",
            gpgcheck => 1,
            gpgkey   => "file://${gpg_key_path}",
            require  => File[$gpg_key_path],
          }
        }
      }

      default : {
        fail("Unsupported managed repository for osfamily: ${::osfamily}, operatingsystem: ${::operatingsystem}, module ${module_name} currently only supports managing repos for osfamily RedHat")
      }
    }
  }
}