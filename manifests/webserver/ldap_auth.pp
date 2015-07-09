class zabbix::webserver::ldap_auth (
  $dbengine = $::zabbix::params::dbengine,
  $dbhost = $::zabbix::params::dbhost,
  $dbschema = $::zabbix::params::dbschema,
  $dbname = $::zabbix::params::dbname,
  $dbuser = $::zabbix::params::dbuser,
  $dbpasswd = $::zabbix::params::dbpasswd,
  $dbport = $::zabbix::params::dbport,

  $ldap_host = $::zabbix::params::ldap_host,
  $ldap_port = $::zabbix::params::ldap_port,
  $ldap_base_dn = $::zabbix::params::ldap_base_dn,
  $ldap_bind_dn = $::zabbix::params::ldap_bind_dn,
  $ldap_bind_pwd = $::zabbix::params::ldap_bind_pwd,
  $ldap_user = $::zabbix::params::ldap_user,
  $ldap_search_att = $::zabbix::params::ldap_search_att,
) {
  # make sure webserver is defined
  if ! defined(Class['::zabbix::webserver']) {
    fail('You must include the zabbix::webserver class before using the LDAP auth configuration class')
  }

  require ::zabbix::dbclient
  require ::zabbix::webserver

  # validation
  if ! $ldap_host { fail('LDAP Host must be specified.') }
  if ! $ldap_base_dn { fail('Base search DN must be specified.') }
  if ! $ldap_bind_dn { fail('LDAP bind DN must be specified.') }
  if ! $ldap_bind_pwd { fail('LDAP bind password must be specified.') }
  if ! $ldap_user { fail('LDAP default user must be specified.') }
  
  case $dbengine {
    'pgsql' : {
      # command defaults
      $client_bin = 'psql'
      Exec {
        path => '/bin:/usr/bin',
      }

      # configure ldap connection
      exec { 'configure ldap auth' :
        command => "${client_bin} -h ${dbhost} -U ${dbuser} -d ${dbname} -c \"UPDATE config SET authentication_type=1, ldap_host='ldap://${ldap_host}', ldap_port='${ldap_port}', ldap_base_dn='${ldap_base_dn}', ldap_bind_dn='${ldap_bind_dn}', ldap_bind_password='${ldap_bind_pwd}', ldap_search_attribute='${ldap_search_att}'\"",
        unless  => "${client_bin} -h ${dbhost} -U ${dbuser} -d ${dbname} -At -c \"SELECT authentication_type FROM config WHERE authentication_type=1 AND ldap_host='ldap://${ldap_host}' AND ldap_port='${ldap_port}' AND ldap_base_dn='${ldap_base_dn}' AND ldap_bind_dn='${ldap_bind_dn}' AND ldap_bind_password='${ldap_bind_pwd}' AND ldap_search_attribute='${ldap_search_att}';\" | grep '^1$'",
      }

      # add service account
      exec { 'configure ldap service account' :
        command => "${client_bin} -h ${dbhost} -U ${dbuser} -d ${dbname} -c \"INSERT INTO users (userid,alias,name,surname,passwd,autologin,autologout,type) VALUES (4,'${ldap_user}','Zabbix','API Account','5fce1b3e34b520afeffb37ce08c7cd66',1,0,3);\"",
        unless  => "${client_bin} -h ${dbhost} -U ${dbuser} -d ${dbname} -At -c \"SELECT alias FROM users\" | grep '${ldap_user}'"
      }
    }
  }
}