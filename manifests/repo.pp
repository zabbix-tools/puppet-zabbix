# PRIVATE CLASS: do not use directly
class zabbix::repo inherits zabbix::params {
  $repo_version = "${ver_major}.${ver_minor}"
  $gpg_key_path = '/etc/pki/rpm-gpg/RPM-GPG-KEY-ZABBIX'

  if $repo_manage or $repo_nonsupported_manage {
    file { $gpg_key_path :
      source  => "puppet:///modules/${module_name}/RPM-GPG-KEY-ZABBIX",
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      seluser => 'system_u',
      selrole => 'object_r',
      seltype => 'cert_t',
    }
  }

  if $repo_manage {
    yumrepo { "zabbix-${repo_version}-${architecture}.el${distrelease}" :
      ensure   => $repo_ensure,
      enabled  => $repo_enabled,
      baseurl  => $repo_baseurl,
      descr    => "Zabbix ${repo_version} EL${distrelease} ${architecture}",
      gpgcheck => 1,
      gpgkey   => "file://${gpg_key_path}",
      require  => File[$gpg_key_path],
    }
  }

  if $repo_nonsupported_manage {
    yumrepo { "zabbix-non-supported-${architecture}.el${distrelease}" :
      ensure   => $repo_nonsupported_ensure,
      enabled  => $repo_nonsupported_enabled,
      baseurl  => $repo_nonsupported_baseurl,
      descr    => "Zabbix Non-Supported EL${distrelease} ${architecture}",
      gpgcheck => 1,
      gpgkey   => "file://${gpg_key_path}",
      require  => File[$gpg_key_path],
    }
  }
}
