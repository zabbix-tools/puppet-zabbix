# public overrides
class zabbix::globals (
  $version         = undef,

  $repo_manage     = undef,
  $repo_ensure     = undef,
  $repo_enabled    = undef,
  $repo_baseurl    = undef,

  $repo_nonsupported_manage  = undef,
  $repo_nonsupported_ensure  = undef,
  $repo_nonsupported_enabled = undef,
  $repo_nonsupported_baseurl = undef,

  $database_manage   = undef,
  $database_driver   = undef,
  $database_host     = undef,
  $database_schema   = undef,
  $database_name     = undef,
  $database_user     = undef,
  $database_password = undef,
  $database_port     = undef,

  $server_host = undef,
  $server_port = undef,

  $user_name  = undef,
  $user_group = undef,
  $user_home  = undef,
) {

}
