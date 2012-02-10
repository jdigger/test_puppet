class sysdata_web (
  $version,
  $artifactory_username,
  $artifactory_password,
  $conf_dir,
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

  $owner = 'UNSET',
  $group = 'UNSET',
  $release = true
) {

  $owner_real = $owner ? {
    'UNSET' => $tcserver::params::owner,
    default => $owner,
  }
  $group_real = $group ? {
    'UNSET' => $tcserver::params::group,
    default => $group,
  }

  $instance_name = 'sysdata'
  $service_name  = 'tcserver-sysdata'

  if !defined(Class['tcserver']) {
    class { 'tcserver':
      instance_name => $instance_name,
      owner         => $owner_real,
      group         => $group_real,
      service_name  => $service_name,
    }
  }

  webapp{ 'sysdata':
    group_name           => 'com.canoeventures.sysdata',
    version              => $version,
    release              => $release,
    artifactory_username => $artifactory_username,
    artifactory_password => $artifactory_password,
    owner                => $owner_real,
    group                => $group_real,
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

  ~>

  tcserver::service { $service_name:
    instance_name => $instance_name,
    service_name  => $service_name,
    owner         => $owner_real,
    group         => $group_real,
    instance_dir  => "/opt/vfabric-tc-server-developer-2.6.2.RELEASE/sysdata",
  }

}
