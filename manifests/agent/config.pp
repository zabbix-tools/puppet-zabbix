class zabbix::agent::config (
  $ensure = 'present',
  $config_file = $::zabbix::params::agent_config_file,
  $user = $::zabbix::params::agent_config_owner,
  $group = $::zabbix::params::agent_config_group,
  $mode = $::zabbix::params::agent_config_mode,
  $version = $::zabbix::params::repo_version,

  $aliases = [],
  $allow_root = 0,
  $buffer_send = 5,
  $buffer_size = 100,
  $debug_level = 3,
  $enable_remote_commands = 0,
  $host_metadata = undef,
  $host_metadata_item = undef,
  $hostname = undef,
  $hostname_item = 'system.hostname',
  $includes = [ '/etc/zabbix/zabbix_agentd.d/' ],
  $listen_ip = '0.0.0.0',
  $listen_port = '10050',
  $load_module_path = undef,
  $load_modules = [],
  $log_file = '/var/log/zabbix/zabbix_agentd.log',
  $log_file_size = 0,
  $log_remote_commands = 0,
  $max_lines_per_second = 100,
  $pid_file = '/var/run/zabbix/zabbix_agentd.pid',
  $refresh_active_checks = 120,
  $server_active = [ $::zabbix::params::server ],
  $servers = [ $::zabbix::params::server ],
  $source_ip = undef,
  $start_agents = 3,
  $timeout = 3,
  $unsafe_user_parameters=0,
  $user_parameters = [],
) {

  # the base class must be included first because parameter defaults depend on it
  if ! defined(Class['zabbix::agent']) {
    fail('You must include the zabbix::agent class before using the agent configuration class')
  }

  # ensure Hostname and HostnameItem are mutually exclusive
  if $hostname and $hostname_item {
    fail("Fields 'hostname' and 'hostname_item' are mutually exclusive.")
  }

  if $hostname {
    $_hostname_item = undef
  } else {
    $_hostname_item = $hostname_item
  }


  case $ensure {
    'present' : {
      # install agent first so config is not overwritten
      require zabbix::agent

      # create config file from template
      file { $config_file :
        ensure  => $ensure,
        owner   => $user,
        group   => $group,
        mode    => $mode,
        content => template("${module_name}/zabbix_agentd.conf.erb"),
        notify  => Class['::zabbix::agent::service'],
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