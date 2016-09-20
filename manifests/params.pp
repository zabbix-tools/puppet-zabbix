# private computed global parameters
class zabbix::params inherits zabbix::globals {
  $version         = pick($version, '3.2.0')

  # compute version components
  $version_parts = split($version, '[.]')
  $ver_major = $version_parts[0]
  $ver_minor = $version_parts[1]
  $ver_patch = $version_parts[2]

  # compute OS distrelease for package repos
  # this will be 5 or 6 on RedHat, 6 or wheezy on Debian, 12 or quantal on Ubuntu, etc.
  $osr_array = split($::operatingsystemrelease,'[\/\.]')
  $distrelease = $osr_array[0]
  if ! $distrelease {
    fail("Unparsable \$::operatingsystemrelease: ${::operatingsystemrelease}")
  }

  $repo_manage     = pick($repo_manage, true)
  $repo_ensure     = pick($repo_ensure, 'present')
  $repo_enabled    = pick($repo_enabled, true)
  $repo_baseurl    = pick($repo_baseurl, "http://repo.zabbix.com/zabbix/${ver_major}.${ver_minor}/rhel/${distrelease}/${architecture}/")

  $repo_enable_nonsupported  = pick($repo_enable_nonsupported, true)
  $repo_baseurl_nonsupported = pick($repo_baseurl_nonsupported, "http://repo.zabbix.com/non-supported/rhel/${distrelease}/${architecture}/")

  $database_manage = pick($database_manage, true)
  $database_driver = pick($database_driver, 'pgsql')

  $database_host   = pick($database_host, 'localhost')
  $database_name   = pick($database_name, 'zabbix')
  $database_user   = pick($database_user, 'zabbix')

  case $database_driver {
    'pgsql' : {
      $database_schema = pick($database_schema, 'public')
      $database_port   = pick($database_port, 5432)
      $database_admin  = pick($database_admin, 'postgres')
    }
  }

  $server_package_manage = true
  $server_package_name   = "zabbix-server-${database_driver}"

  $server_service_manage = true
  $server_service_name  = 'zabbix-server'
  $server_service_ensure = 'running'
  $server_service_enable = true

  $server_user  = 'zabbix'
  $server_group = 'zabbix'

  $server_config_manage = true
  $server_config_ensure = 'file'
  $server_config_path   = '/etc/zabbix/zabbix_server.conf'
  $server_config_owner  = 'root'
  $server_config_group  = $server_group
  $server_config_mode   = '0640'

  $server_config_alert_scripts_path        = '/usr/lib/zabbix/alertscripts'
  $server_config_allow_root                = 0
  $server_config_cache_size                = '8M'
  $server_config_cache_update_frequency    = 60
  $server_config_config_includes           = []
  $server_config_dbsocket                  = '/var/lib/mysql/mysql.sock'
  $server_config_debug_level               = 3
  $server_config_drop_user                 = undef
  $server_config_enable_snmp_bulk_requests = 1
  $server_config_external_scripts_path     = '/usr/lib/zabbix/externalscripts'
  $server_config_fping6_location           = '/usr/sbin/fping6'
  $server_config_fping_location            = '/usr/sbin/fping'
  $server_config_history_cache_size        = '8M'
  $server_config_history_index_cache_size  = '4M'
  $server_config_history_text_cache_size   = '16M'
  $server_config_housekeeping_frequency    = 1
  $server_config_java_gateway              = undef
  $server_config_java_gateway_port         = 10052
  $server_config_listen_ip                 = '0.0.0.0'
  $server_config_listen_port               = pick($server_port, 10051)
  $server_config_load_modules              = []
  $server_config_load_modules_path         = undef
  $server_config_log_file                  = '/var/log/zabbix/zabbix_server.log'
  $server_config_log_file_size             = 1
  $server_config_log_slow_queries          = 0
  $server_config_log_type                  = 'file'
  $server_config_max_housekeeper_delete    = 500
  $server_config_node_id                   = 0
  $server_config_node_no_events            = 0
  $server_config_node_no_history           = 0
  $server_config_pid_file                  = '/run/zabbix/zabbix_server.pid'
  $server_config_proxy_config_frequency    = 3600
  $server_config_proxy_data_frequency      = 1
  $server_config_sender_frequency          = 30
  $server_config_snmp_trapper_file         = '/var/log/snmptt/snmptt.log'
  $server_config_source_ip                 = undef
  $server_config_ssh_key_location          = undef
  $server_config_ssl_ca_location           = undef
  $server_config_ssl_cert_location         = '${datadir}/zabbix/ssl/certs'
  $server_config_ssl_key_location          = '${datadir}/zabbix/ssh/keys'
  $server_config_start_db_syncers          = 4
  $server_config_start_discoverers         = 1
  $server_config_start_escalators          = 1
  $server_config_start_http_pollers        = 1
  $server_config_start_ipmi_pollers        = 0
  $server_config_start_java_pollers        = 0
  $server_config_start_pingers             = 1
  $server_config_start_pollers             = 5
  $server_config_start_pollers_unreachable = 1
  $server_config_start_proxy_pollers       = 1
  $server_config_start_snmp_trapper        = 0
  $server_config_start_timers              = 1
  $server_config_start_trappers            = 5
  $server_config_start_vmware_collectors   = 0
  $server_config_timeout                   = 3
  $server_config_tls_ca_file               = undef
  $server_config_tls_cert_file             = undef
  $server_config_tls_crl_file              = undef
  $server_config_tls_key_file              = undef
  $server_config_tmp_dir                   = '/tmp'
  $server_config_trapper_timeout           = 300
  $server_config_trend_cache_size          = '4M'
  $server_config_unavailable_delay         = 60
  $server_config_unreachable_delay         = 15
  $server_config_unreachable_period        = 45
  $server_config_value_cache_size          = '8M'
  $server_config_vmware_cache_size         = '8M'
  $server_config_vmware_frequency          = 60
  $server_config_vmware_perf_frequency     = 60
  $server_config_vmware_timeout            = 10


  #$repo_version = "${ver_major}.${ver_minor}"
  #$package_version = "${ver_major}.${ver_minor}.${ver_patch}-${ver_release}.el${distrelease}"

  # yum repo
  #$manage_repo = pick($manage_repo, true)
  #$repo_url = pick($repo_url, "http://repo.zabbix.com/zabbix/${repo_version}/rhel/${distrelease}/${architecture}/")
  #$ns_repo_url = pick($ns_repo_url, "http://repo.zabbix.com/non-supported/rhel/${distrelease}/${architecture}/")
  #$repo_gpgkey = pick($repo_gpgkey, 'http://repo.zabbix.com/RPM-GPG-KEY-ZABBIX')

  # database connection
  $pgscripts = "/usr/share/doc/zabbix-server-pgsql-${ver_major}.${ver_minor}.${ver_patch}/create"

  # server common
  $server = pick($server, 'localhost')
  $server_name = "Zabbix ${::environment}"
  $server_service = 'zabbix-server'


  # web server common
  $http_port            = 80
  $docroot              = '/usr/share/zabbix'
  $docroot_mode         = '0755'
  $web_package          = 'zabbix-web'
  
  if versioncmp($version, '2.4.0') >= 0 {
    $web_config_file    = '/etc/zabbix/web/zabbix.conf.php'
  } else {
    $web_config_file      = "${docroot}/conf/zabbix.conf.php"
  }
  $web_config_file_mode = '640'
  $web_user             = 'apache'
  $web_group            = 'apache'
  $timezone             = pick($timezone, 'Australia/Perth')

  case $database_driver {
    'pgsql': {
      $web_database_driver = 'POSTGRESQL'
    }

    default : { fail("Unsupported database driver: ${database_driver}") }
  }

  # LDAP auth integration
  $ldap_host = undef
  $ldap_port = 389
  $ldap_base_dn = undef
  $ldap_bind_dn = undef
  $ldap_bind_pwd = undef
  $ldap_user = undef
  $ldap_search_att = 'sAMAccountName'

  # agent
  $agent_package = 'zabbix-agent'
  $agent_user    = $server_user
  $agent_group   = $server_group

  # agent config
  case $::operatingsystem {
    'windows': {
      $agent_service = 'Zabbix Agent'
      $agent_install_root = 'C:/Program Files/Zabbix'
      $agent_config_file = "${agent_install_root}/conf/zabbix_agentd.win.conf"
      $agent_config_includes = []
      $agent_log_dir = "${agent_install_root}/logs"
      $agent_log_file = "${agent_log_dir}/zabbix_agentd.log"
      $agent_bin_dir = $::architecture ? {
        'x64' => "${agent_install_root}/bin/win64",
        default => "${agent_install_root}/bin/win32",
      }
      
      $agent_config_owner = undef
      $agent_config_group = undef
      $agent_config_mode = undef
    }
    
    default: {
      $agent_service = 'zabbix-agent'
      $agent_config_file = '/etc/zabbix/zabbix_agentd.conf'
      $agent_config_includes = [ '/etc/zabbix/zabbix_agentd.d/' ]
      $agent_config_owner = 'root'
      $agent_config_group = 'root'
      $agent_config_mode = '0644'
      $agent_log_file = '/var/log/zabbix/zabbix_agentd.log'
    }
  }
}
