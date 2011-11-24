class sysdata_web (
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

  if !defined(Class['tcserver::install']) {
    if !defined(Class['tcserver::params']) {
      include 'tcserver::params'
    }

    class { 'tcserver::install':
      package_name => $tcserver::params::package_name,
      version      => $tcserver::params::version,
    }
  }

  class { 'sysdata_web::server': }

  class { 'sysdata_web::application':
    version              => $version,
    release              => $release,
    artifactory_username => $artifactory_username,
    artifactory_password => $artifactory_password,
    crowd_username       => $crowd_username,
    crowd_password       => $crowd_password,
    crowd_server_url     => $crowd_server_url,
    logout_url           => $logout_url,
    my_account_url       => $my_account_url,
    sysdata_url          => $sysdata_url,
    webportal_url        => $webportal_url,
    datasource_url       => $datasource_url,
    datasource_username  => $datasource_username,
    datasource_password  => $datasource_password,
    grails_server_url    => $grails_server_url,
    webservice_base_url  => $webservice_base_url,
    conf_dir             => $conf_dir,
    require              => Class['sysdata_web::server'],
  }

  Class['sysdata_web::server'] -> Class['sysdata_web::application']

}
