class zabbix::agent (
  $ensure           = 'present',

  $user             = $::zabbix::params::agent_user,
  $group            = $::zabbix::params::agent_group,

  $bin_dir          = $::zabbix::params::agent_bin_dir,

  $package_manage   = $::zabbix::params::agent_package_manage,
  $package_name     = $::zabbix::params::agent_package_name,
  $package_ensure   = $::zabbix::params::agent_package_ensure,

  $repo_manage      = $::zabbix::params::repo_manage,

  $service_manage   = $::zabbix::params::agent_service_manage,
  $service_name     = $::zabbix::params::agent_service_name,
  $service_ensure   = $::zabbix::params::agent_service_ensure,
  $service_enable   = $::zabbix::params::agent_service_enable,

  $config_manage    = $::zabbix::params::agent_config_manage,
  $config_path      = $::zabbix::params::agent_config_path,

  $aliases                = $::zabbix::params::agent_config_aliases,
  $allow_root             = $::zabbix::params::agent_config_allow_root,
  $buffer_send            = $::zabbix::params::agent_config_buffer_send,
  $buffer_size            = $::zabbix::params::agent_config_buffer_size,
  $debug_level            = $::zabbix::params::agent_config_debug_level,
  $drop_user              = $::zabbix::params::agent_config_drop_user,
  $enable_remote_commands = $::zabbix::params::agent_config_enable_remote_commands,
  $host_metadata          = $::zabbix::params::agent_config_host_metadata,
  $host_metadata_item     = $::zabbix::params::agent_config_host_metadata_item,
  $hostname               = $::zabbix::params::agent_config_hostname,
  $hostname_item          = $::zabbix::params::agent_config_hostname_item,
  $includes               = $::zabbix::params::agent_config_includes,
  $listen_ip              = $::zabbix::params::agent_config_listen_ip,
  $listen_port            = $::zabbix::params::agent_config_listen_port,
  $load_module_path       = $::zabbix::params::agent_config_load_module_path,
  $load_modules           = $::zabbix::params::agent_config_load_modules,
  $log_file               = $::zabbix::params::agent_config_log_file,
  $log_file_size          = $::zabbix::params::agent_config_log_file_size,
  $log_remote_commands    = $::zabbix::params::agent_config_log_remote_commands,
  $log_type               = $::zabbix::params::agent_config_log_type,
  $max_lines_per_second   = $::zabbix::params::agent_config_max_lines_per_second,
  $pid_file               = $::zabbix::params::agent_config_pid_file,
  $refresh_active_checks  = $::zabbix::params::agent_config_refresh_active_checks,
  $server_active          = $::zabbix::params::agent_config_server_active,
  $servers                = $::zabbix::params::agent_config_servers,
  $source_ip              = $::zabbix::params::agent_config_source_ip,
  $start_agents           = $::zabbix::params::agent_config_start_agents,
  $timeout                = $::zabbix::params::agent_config_timeout,
  $unsafe_user_parameters = $::zabbix::params::agent_config_unsafe_user_parameters,
  $user_parameters        = $::zabbix::params::agent_config_user_parameters,
) inherits zabbix::params {
  case $ensure {
    'present': {
      anchor { '::zabbix::agent::start' : } ->
      class { '::zabbix::agent::install' : } ->
      class { '::zabbix::agent::config' : } ->
      class { '::zabbix::agent::service' : } ->
      anchor { '::zabbix::agent::end' : }
    }

    default: {
      fail ("Unsupported 'ensure' value: ${ensure}")
    }
  }
}