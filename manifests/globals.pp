# public overrides
class zabbix::globals (
  $version         = undef,

  $repo_manage     = undef,
  $repo_ensure     = undef,
  $repo_enabled    = undef,
  $repo_baseurl    = undef,

  $repo_enable_nonsupported  = undef,
  $repo_baseurl_nonsupported = undef,

  $database_manage   = undef,
  $database_driver   = undef,  
  $database_admin    = undef,
  $database_admin_password = undef,
  $database_host     = undef,
  $database_schema   = undef,
  $database_name     = undef,
  $database_user     = undef,
  $database_password = undef,
  $database_port     = undef,

  $server_port = undef,





  $install_db_client = undef,

  $manage_repo = undef,  
  $repo_url = undef,
  $ns_repo_url = undef,
  $repo_gpgkey = undef,

  $timezone = undef,

  $server = undef,
) {

}