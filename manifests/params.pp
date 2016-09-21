# private computed global parameters
class zabbix::params inherits zabbix::globals {
  $version       = pick($version, '3.2.0')
  $version_parts = split($version, '[.]')
  $ver_major     = $version_parts[0]
  $ver_minor     = $version_parts[1]
  $ver_patch     = $version_parts[2]

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

  $repo_nonsupported_manage  = pick($repo_nonsupported_manage, $repo_manage)
  $repo_nonsupported_ensure  = pick($repo_nonsupported_ensure, 'present')
  $repo_nonsupported_enabled = pick($repo_nonsupported_enabled, true)
  $repo_nonsupported_baseurl = pick($repo_nonsupported_baseurl, "http://repo.zabbix.com/non-supported/rhel/${distrelease}/${architecture}/")

  $database_manage = pick($database_manage, true)
  $database_driver = pick($database_driver, 'pgsql')

  $database_host   = pick($database_host, 'localhost')
  $database_name   = pick($database_name, 'zabbix')
  $database_user   = pick($database_user, 'zabbix')

  case $database_driver {
    'pgsql' : {
      $database_schema = pick($database_schema, 'public')
      $database_port   = pick($database_port, 5432)
    }
  }

  #
  # zabbix_get parameters
  #
  $get_package_name   = 'zabbix-get'
  $get_package_ensure = "${version}-1.el${distrelease}"

  #
  # zabbix_sender parameters
  #
  $sender_package_name   = 'zabbix-sender'
  $sender_package_ensure = "${version}-1.el${distrelease}"

  #
  # Server parameters
  #
  $server_host  = pick($server_host, '127.0.0.1')
  $server_port  = pick($server_port, 10051)
  $server_user  = 'zabbix'
  $server_group = 'zabbix'

  $server_package_manage = true
  $server_package_name   = "zabbix-server-${database_driver}"
  $server_package_ensure = "${version}-1.el${distrelease}"

  $server_service_manage = true
  $server_service_name  = 'zabbix-server'
  $server_service_ensure = 'running'
  $server_service_enable = true

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
  $server_config_listen_port               = $server_port
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

  #
  # agent parameters
  #
  $agent_user    = $server_user
  $agent_group   = $server_group

  $agent_package_manage  = true
  $agent_package_name    = 'zabbix-agent'
  $agent_package_ensure  = "${version}-1.el${distrelease}"

  $agent_service_manage  = true
  $agent_service_ensure  = 'running'
  $agent_service_enable  = true

  $agent_config_manage   = true

  case $::operatingsystem {
    'windows': {
      $agent_install_root = 'C:/Program Files/Zabbix'

      $agent_service_name = 'Zabbix Agent'

      $agent_bin_dir = $::architecture ? {
        'x64'   => "${agent_install_root}/bin/win64",
        default => "${agent_install_root}/bin/win32",
      }

      $agent_config_path     = "${agent_install_root}/conf/zabbix_agentd.win.conf"
      $agent_config_includes = []
      $agent_config_log_dir  = "${agent_install_root}/logs"
      $agent_config_log_file = "${agent_log_dir}/zabbix_agentd.log"
    }
    
    default: {
      $agent_service_name    = 'zabbix-agent'

      $agent_config_path     = '/etc/zabbix/zabbix_agentd.conf'
      $agent_config_owner    = 'root'
      $agent_config_group    = $agent_group
      $agent_config_mode     = '0640'
      $agent_config_log_file = '/var/log/zabbix/zabbix_agentd.log'
      if versioncmp($version, '2.4.0') > 0 {
        $agent_config_includes = [ '/etc/zabbix/zabbix_agentd.d/*.conf' ]
      } else {
        $agent_config_includes = [ '/etc/zabbix/zabbix_agentd.d/' ]
      }
    }
  }

  $agent_config_aliases                = []
  $agent_config_allow_root             = 0
  $agent_config_buffer_send            = 5
  $agent_config_buffer_size            = 100
  $agent_config_debug_level            = 3
  $agent_config_drop_user              = undef
  $agent_config_enable_remote_commands = 0
  $agent_config_host_metadata          = undef
  $agent_config_host_metadata_item     = undef
  $agent_config_hostname               = downcase($::fqdn)
  $agent_config_hostname_item          = undef
  $agent_config_listen_ip              = '0.0.0.0'
  $agent_config_listen_port            = '10050'
  $agent_config_load_module_path       = undef
  $agent_config_load_modules           = []
  $agent_config_log_file_size          = 0
  $agent_config_log_remote_commands    = 0
  $agent_config_log_type               = 'file'
  $agent_config_max_lines_per_second   = 100
  $agent_config_pid_file               = '/var/run/zabbix/zabbix_agentd.pid'
  $agent_config_refresh_active_checks  = 120
  $agent_config_server_active          = [ "${server_host}:${server_config_listen_port}" ]
  $agent_config_servers                = [ '127.0.0.1', $server_host ]
  $agent_config_source_ip              = undef
  $agent_config_start_agents           = 3
  $agent_config_timeout                = 3
  $agent_config_unsafe_user_parameters = 0
  $agent_config_user_parameters        = []

  #
  # web server parameters
  #
  $web_user               = 'apache'
  $web_group              = 'apache'
  $web_docroot            = '/usr/share/zabbix'

  $web_server_descr       = join([ 'Zabbix ', camelcase($::environment) ])

  $web_package_manage     = true
  $web_package_name       = "zabbix-web-${database_driver}"
  $web_package_ensure     = "${version}-1.el${distrelease}"

  $web_vhost_manage       = true
  $web_vhost_name         = "zabbix_${::environment}"

  $web_apache_manage      = false
  $web_apache_http_port   = '80'

  $web_php_package_manage = true
  $web_php_package_ensure = 'installed'
  $web_php_package_name   = [
    'php',
    'php-bcmath',
    'php-common',
    'php-gd',
    'php-ldap',
    'php-mbstring',
    'php-pgsql',
    'php-xml',
  ]

  $web_config_manage = true
  if versioncmp($version, '2.2.0') >= 0 {
    $web_config_path = '/etc/zabbix/web/zabbix.conf.php'
  } else {
    $web_config_path = "${web_docroot}/conf/zabbix.conf.php"
  }
}
