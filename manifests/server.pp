class zabbix::server (
  $ensure          = 'present',
  $version         = $::zabbix::params::version,

  $repo_manage     = $::zabbix::params::repo_manage,

  $database_manage = $::zabbix::params::database_manage,
  $database_driver = $::zabbix::params::database_driver,
  $database_admin  = $::zabbix::params::database_admin,
  $database_engine = $::zabbix::params::database_engine,
  $database_host   = $::zabbix::params::database_host,
  $database_schema = $::zabbix::params::database_schema,
  $database_name   = $::zabbix::params::database_name,
  $database_user   = $::zabbix::params::database_user,
  $database_passwd = $::zabbix::params::database_password,
  $database_port   = $::zabbix::params::database_port,

  $package_manage  = $::zabbix::params::server_package_manage,
  $package_name    = $::zabbix::params::server_package_name,

  $service_manage  = $::zabbix::params::server_service_manage,
  $service_name    = $::zabbix::params::server_service_name,
  $service_ensure  = $::zabbix::params::server_service_ensure,
  $service_enable  = $::zabbix::params::server_service_enable,

  $user            = $::zabbix::params::server_user,
  $group           = $::zabbix::params::server_group,

  $config_manage   = $::zabbix::params::server_config_manage,
  $config_path     = $::zabbix::params::server_config_path,

  $alert_scripts_path        = $::zabbix::params::server_config_alert_scripts_path,
  $allow_root                = $::zabbix::params::server_config_allow_root,
  $cache_size                = $::zabbix::params::server_config_cache_size,
  $cache_update_frequency    = $::zabbix::params::server_config_cache_update_frequency,
  $config_includes           = $::zabbix::params::server_config_config_includes,
  $dbsocket                  = $::zabbix::params::server_config_dbsocket,
  $debug_level               = $::zabbix::params::server_config_debug_level,
  $drop_user                 = $::zabbix::params::server_config_drop_user,
  $enable_snmp_bulk_requests = $::zabbix::params::server_config_enable_snmp_bulk_requests,
  $external_scripts_path     = $::zabbix::params::server_config_external_scripts_path,
  $fping6_location           = $::zabbix::params::server_config_fping6_location,
  $fping_location            = $::zabbix::params::server_config_fping_location,
  $history_cache_size        = $::zabbix::params::server_config_history_cache_size,
  $history_index_cache_size  = $::zabbix::params::server_config_history_index_cache_size,
  $history_text_cache_size   = $::zabbix::params::server_config_history_text_cache_size,
  $housekeeping_frequency    = $::zabbix::params::server_config_housekeeping_frequency,
  $java_gateway              = $::zabbix::params::server_config_java_gateway,
  $java_gateway_port         = $::zabbix::params::server_config_java_gateway_port,
  $listen_ip                 = $::zabbix::params::server_config_listen_ip,
  $listen_port               = $::zabbix::params::server_config_listen_port,
  $load_modules              = $::zabbix::params::server_config_load_modules,
  $load_modules_path         = $::zabbix::params::server_config_load_modules_path,
  $log_file                  = $::zabbix::params::server_config_log_file,
  $log_file_size             = $::zabbix::params::server_config_log_file_size,
  $log_slow_queries          = $::zabbix::params::server_config_log_slow_queries,
  $log_type                  = $::zabbix::params::server_config_log_type,
  $max_housekeeper_delete    = $::zabbix::params::server_config_max_housekeeper_delete,
  $node_id                   = $::zabbix::params::server_config_node_id,
  $node_no_events            = $::zabbix::params::server_config_node_no_events,
  $node_no_history           = $::zabbix::params::server_config_node_no_history,
  $pid_file                  = $::zabbix::params::server_config_pid_file,
  $proxy_config_frequency    = $::zabbix::params::server_config_proxy_config_frequency,
  $proxy_data_frequency      = $::zabbix::params::server_config_proxy_data_frequency,
  $sender_frequency          = $::zabbix::params::server_config_sender_frequency,
  $snmp_trapper_file         = $::zabbix::params::server_config_snmp_trapper_file,
  $source_ip                 = $::zabbix::params::server_config_source_ip,
  $ssh_key_location          = $::zabbix::params::server_config_ssh_key_location,
  $ssl_ca_location           = $::zabbix::params::server_config_ssl_ca_location,
  $ssl_cert_location         = $::zabbix::params::server_config_ssl_cert_location,
  $ssl_key_location          = $::zabbix::params::server_config_ssl_key_location,
  $start_db_syncers          = $::zabbix::params::server_config_start_db_syncers,
  $start_discoverers         = $::zabbix::params::server_config_start_discoverers,
  $start_escalators          = $::zabbix::params::server_config_start_escalators,
  $start_http_pollers        = $::zabbix::params::server_config_start_http_pollers,
  $start_ipmi_pollers        = $::zabbix::params::server_config_start_ipmi_pollers,
  $start_java_pollers        = $::zabbix::params::server_config_start_java_pollers,
  $start_pingers             = $::zabbix::params::server_config_start_pingers,
  $start_pollers             = $::zabbix::params::server_config_start_pollers,
  $start_pollers_unreachable = $::zabbix::params::server_config_start_pollers_unreachable,
  $start_proxy_pollers       = $::zabbix::params::server_config_start_proxy_pollers,
  $start_snmp_trapper        = $::zabbix::params::server_config_start_snmp_trapper,
  $start_timers              = $::zabbix::params::server_config_start_timers,
  $start_trappers            = $::zabbix::params::server_config_start_trappers,
  $start_vmware_collectors   = $::zabbix::params::server_config_start_vmware_collectors,
  $timeout                   = $::zabbix::params::server_config_timeout,
  $tls_ca_file               = $::zabbix::params::server_config_tls_ca_file,
  $tls_cert_file             = $::zabbix::params::server_config_tls_cert_file,
  $tls_crl_file              = $::zabbix::params::server_config_tls_crl_file,
  $tls_key_file              = $::zabbix::params::server_config_tls_key_file,
  $tmp_dir                   = $::zabbix::params::server_config_tmp_dir,
  $trapper_timeout           = $::zabbix::params::server_config_trapper_timeout,
  $trend_cache_size          = $::zabbix::params::server_config_trend_cache_size,
  $unavailable_delay         = $::zabbix::params::server_config_unavailable_delay,
  $unreachable_delay         = $::zabbix::params::server_config_unreachable_delay,
  $unreachable_period        = $::zabbix::params::server_config_unreachable_period,
  $value_cache_size          = $::zabbix::params::server_config_value_cache_size,
  $vmware_cache_size         = $::zabbix::params::server_config_vmware_cache_size,
  $vmware_frequency          = $::zabbix::params::server_config_vmware_frequency,
  $vmware_perf_frequency     = $::zabbix::params::server_config_vmware_perf_frequency,
  $vmware_timeout            = $::zabbix::params::server_config_vmware_timeout,
) inherits zabbix::params {
  case $ensure {
    'present' : {
      anchor { '::zabbix::start' : } ->
      class { '::zabbix::server::install' : } ->
      class { '::zabbix::server::config' : } ->
      class { '::zabbix::server::database' : } ->
      class { '::zabbix::server::service' : } ->
      anchor { '::zabbix::end' : }

      # configure database before webserver if on the same box
      if defined(Class['::zabbix::webserver']) {
        Class['::zabbix::server::database'] -> Class['::zabbix::webserver']
      }
    }

    default: {
      fail ("Unsupported 'ensure' value: ${ensure}")
    }
  }
}