# public overrides
class zabbix::globals (
  $version = undef,

  $install_db_client = undef,
  $dbengine = undef,
  $dbhost = undef,
  $dbschema = undef,
  $dbname = undef,
  $dbuser = undef,
  $dbpasswd = undef,
  $dbport = undef,

  $dbadmin = undef,
  $dbadmin_password = undef,
  $dbadmin_db = undef,
  
  $repo_url = undef,
  $ns_repo_url = undef,
  $repo_gpgkey = undef,

  $timezone = undef,

  $server = undef,
  $server_port = undef,
) {

}