class sysdata_web (
  $version,
  $artifactory_username,
  $artifactory_password,
  $conf_dir,
  $owner,
  $group,
  $server_dir,

  # template values
  $crowd_username,
  $crowd_password,
  $crowd_server_url,
  $logout_url,
  $my_account_url,
  $sysdata_url,
  $webportal_url,
  $datasource_url,
  $datasource_username,
  $datasource_password,
  $grails_server_url,
  $webservice_base_url,

  $release = true
) {

  if !defined(Class['tcserver']) {
    class { 'tcserver':
      instance_name => 'sysdata',
      owner         => $owner,
      group         => $group,
      service_name  => 'tcserver-sysdata',
    }
  }

  webapp{ 'sysdata':
    group_name           => 'com.canoeventures.sysdata',
    version              => $version,
    release              => $release,
    artifactory_username => $artifactory_username,
    artifactory_password => $artifactory_password,
    owner                => $owner,
    group                => $group,
    conf_dir             => $conf_dir,
    server_dir           => $server_dir,
    sysproperty_name     => 'SYSDATACONF',
    template_files       => [
      'sysdata_web/crowd-ehcache.xml.erb',
      'sysdata_web/crowd.properties.erb',
      'sysdata_web/log4j.groovy.erb',
      'sysdata_web/navigation.groovy.erb',
      'sysdata_web/sysdata.properties.erb',
    ],
    service_name         => 'tcserver-sysdata',
  }

  ->

  tcserver::service { 'tcserver-sysdata':
    instance_name => 'sysdata',
    service_name  => 'tcserver-sysdata',
    owner         => 'tc-server',
    group         => 'tc-server',
    instance_dir  => "/opt/vfabric-tc-server-developer-2.6.2.RELEASE/sysdata",
  }

}
