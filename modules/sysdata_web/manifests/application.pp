class sysdata_web::application (
  $version,
  $artifactory_username,
  $artifactory_password,
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
  $conf_dir,
  $release = true
) {

  Class['sysdata_web::server'] -> Class['sysdata_web::application']

  webapp::install { 'sysdata':
    group_name           => 'com.canoeventures.sysdata',
    version              => $version,
    release              => $release,
    artifactory_username => $artifactory_username,
    artifactory_password => $artifactory_password,
    conf_dir             => $conf_dir,
    server_dir           => $sysdata_web::server::sysdata_instance_dir,
    require              => Class['sysdata_web::server'],
  }

  file { '/var/conf':
    ensure  => directory,
    owner   => 'tc-server',
    group   => 'tc-server',
  }

  webapp::ext_conf { 'sysdata_web':
    sysproperty_name => 'SYSDATACONF',
    conf_dir         => $conf_dir,
    server_dir       => $sysdata_web::server::sysdata_instance_dir,
    template_files   => [
      'sysdata_web/crowd-ehcache.xml.erb',
      'sysdata_web/crowd.properties.erb',
      'sysdata_web/log4j.groovy.erb',
      'sysdata_web/navigation.groovy.erb',
      'sysdata_web/sysdata.properties.erb',
    ],
    require          => Class['sysdata_web::server'],
  }

}
