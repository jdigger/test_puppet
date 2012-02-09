class sysdata_web (
  $version,
  $artifactory_username,
  $artifactory_password,
  $conf_dir,
  $owner,
  $group,

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

  class { 'webapp':
    app_name             => 'sysdata',
    group_name           => 'com.canoeventures.sysdata',
    version              => $version,
    release              => $release,
    artifactory_username => $artifactory_username,
    artifactory_password => $artifactory_password,
    owner                => $owner,
    group                => $group,
    conf_dir             => $conf_dir,
    server_dir           => $tcserver::instance_dir_real,
    sysproperty_name     => 'SYSDATACONF',
    template_files       => [
      'sysdata_web/crowd-ehcache.xml.erb',
      'sysdata_web/crowd.properties.erb',
      'sysdata_web/log4j.groovy.erb',
      'sysdata_web/navigation.groovy.erb',
      'sysdata_web/sysdata.properties.erb',
    ],
    service_name         => 'tcserver-sysdata',
    # require              => Class['tcserver::service'],
  }

}
