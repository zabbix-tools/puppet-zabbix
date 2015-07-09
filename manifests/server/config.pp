class zabbix::server::config (
  $ensure = 'present',
  $config_file = $::zabbix::params::server_config_file,
  $user = $::zabbix::params::server_config_owner,
  $group = $::zabbix::params::server_config_group,
  $mode = $::zabbix::params::server_config_mode,
  $version = $::zabbix::params::repo_version,

  $dbhost = $::zabbix::params::dbhost,
  $dbschema = $::zabbix::params::dbschema,
  $dbname = $::zabbix::params::dbname,
  $dbuser = $::zabbix::params::dbuser,
  $dbpasswd = $::zabbix::params::dbpasswd,
  $dbport = $::zabbix::params::dbport,
  
  $listen_port = $::zabbix::params::server_port,

  $alert_scripts_path = '/usr/lib/zabbix/alertscripts',
  $allow_root = 0,
  $cache_size = '8M',
  $cache_update_frequency = 60,
  $config_includes = [],
  $dbsocket = '/var/lib/mysql/mysql.sock',
  $debug_level = 3,
  $enable_snmp_bulk_requests = 1,
  $external_scripts = '/usr/lib/zabbix/externalscripts',
  $fping6_location = '/usr/sbin/fping6',
  $fping_location = '/usr/sbin/fping',
  $history_cache_size = '8M',
  $history_text_cache_size = '16M',
  $housekeeping_frequency = 1,
  $java_gateway = undef,
  $java_gateway_port = 10052,
  $listen_ip = '0.0.0.0',
  $load_modules = [],
  $load_modules_path = undef,
  $log_file = '/var/log/zabbix/zabbix_server.log',
  $log_file_size = 1,
  $log_slow_queries = 0,
  $max_housekeeper_delete = 500,
  $node_id = 0,
  $node_no_events = 0,
  $node_no_history = 0,
  $pid_file = '/run/zabbix/zabbix_server.pid',
  $proxy_config_frequency = 3600,
  $proxy_data_frequency = 1,
  $sender_frequency = 30,
  $snmp_trapper_file = '/var/log/snmptt/snmptt.log',
  $source_ip = undef,
  $ssh_key_location = undef,
  $start_db_syncers = 4,
  $start_discoverers = 1,
  $start_http_pollers = 1,
  $start_ipmi_pollers = 0,
  $start_java_pollers = 0,
  $start_pingers = 1,
  $start_pollers = 5,
  $start_pollers_unreachable = 1,
  $start_proxy_pollers = 1,
  $start_snmp_trapper = 0,
  $start_timers = 1,
  $start_trappers = 5,
  $start_vmware_collectors = 0,
  $timeout = 3,
  $tmp_dir = '/tmp',
  $trapper_timeout = 300,
  $trend_cache_size = '4M',
  $unavailable_delay = 60,
  $unreachable_delay = 15,
  $unreachable_period = 45,
  $value_cache_size = '8M',
  $vmware_cache_size = '8M',
  $vmware_frequency = 60,
  $vmware_perf_frequency = 60,
  $vmware_timeout = 10,
) {

  # The base class must be included first because parameter defaults depend on it
  if ! defined(Class['zabbix::server']) {
    fail('You must include the zabbix::server class before using the server configuration class')
  }

  case $ensure {
    'present' : {
      # install server first so config is not overwritten
      require zabbix::server

      # create config file from template
      file { $config_file :
        ensure  => $ensure,
        owner   => $user,
        group   => $group,
        mode    => $mode,
        content => template("${module_name}/zabbix_server.conf.erb"),
        notify  => Class['::zabbix::server::service'],
      }
    }

    'absent' : {
      file { $config_file :
        ensure => 'absent',
      }
    }

    default: {
      fail ("Unsupported 'ensure' value: ${ensure}")
    }
  } 
}