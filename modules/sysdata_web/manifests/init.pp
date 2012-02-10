# == Class: sysdata_web
#
# The SysData web application
#
# === Parameters
#
# [*version*]
#   The version of the application.
#
# [*conf_dir*]
#   The directory on the machine to install the external configuration into.
#
# [*server_dir*]
#   The directory where the instance of tc-Server is installed.
#
# [*artifactory_username*]
#   Username to use when getting the WAR from Artifactory.
#
# [*artifactory_password*]
#   Password to use when getting the WAR from Artifactory.
#
# [*release*]
#   Is this a release version (as opposed to a SNAPSHOT)?
#   Defaults to 'true'.
#
# === Examples
#
# class { 'sysdata_web':
#   version              => '1.4.2_7',
#   release              => true,
#   conf_dir             => '/var/conf/sysdata',
#   server_dir           => $tcserver::instance_dir_real,
# 
#   crowd_username       => #####,
#   crowd_password       => #####,
#   crowd_server_url     => 'http://crowd_server:9095/crowd/',
# 
#   artifactory_username => #####,
#   artifactory_password => #####,  # must (currently) be pre-urlencoded
#   logout_url           => 'https://server_name/portal/logout/index',
#   my_account_url       => 'https://server_name/portal/account/profile',
#   sysdata_url          => 'https://server_name/sysdata',
#   webportal_url        => 'https://server_name/portal/',
#   grails_server_url    => 'http://server_name/sysdata',
#   webservice_base_url  => 'http://server_name/sysdata',
# 
#   datasource_url       => 'jdbc:oracle:thin:@oracle_server:1522:sid',
#   datasource_username  => #####,
#   datasource_password  => #####,
# }
#
class sysdata_web (
  $version,
  $conf_dir,
  $server_dir,
  $artifactory_username,
  $artifactory_password,

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

  $instance_name = 'sysdata'
  $service_name  = 'tcserver-sysdata'

  if !defined(Class['tcserver']) {
    class { 'tcserver':
      instance_name => $instance_name,
      service_name  => $service_name,
    }
  }

  $owner_real = $tcserver::owner_real
  $group_real = $tcserver::group_real

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
    instance_dir  => $server_dir,
  }

}
