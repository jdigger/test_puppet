# == Define: tcserver::instance
#
# tcServer user instance.
#
# == Examples:
# tcserver::instance{'a_server_instance': }
#
define tcserver::instance (
  $instance_name  = $name,
  $owner          = 'UNSET',
  $group          = 'UNSET',
  $service_name   = "tcserver-${instance_name}",
  $tomcat_version = 'UNSET',
  $instance_dir   = 'UNSET'
) {

  require 'tcserver::params'

  if !defined(Class['sun_jdk']) {
    class {'sun_jdk': }
  }

  $owner_real = $owner ? {
    'UNSET' => $tcserver::params::owner,
    default => $owner,
  }
  $group_real = $group ? {
    'UNSET' => $tcserver::params::group,
    default => $group,
  }

  if !defined(Class['tcserver::install']) {
    class {'tcserver::install':
      owner => $owner_real,
      group => $group_real,
    }
  }

  $java_home = $sun_jdk::java_home
  $tcserver_home = $tcserver::install::tcserver_home
  $tomcat_version_real = $tomcat_version ? {
    'UNSET' => $tcserver::params::tomcat_version,
    default => $tomcat_version,
  }
  $instance_dir_real = $instance_dir ? {
    'UNSET' => "${tcserver_home}/${instance_name}",
    default => $instance_dir,
  }

  info("tc-Server instance '${name}': java_home='${java_home}' tcserver_home='${tcserver_home}' tomcat_version='${tomcat_version_real}'")

  # Create instance
  exec { "create_tcserver_${instance_name}":
    command  => "export JAVA_HOME=${java_home} ; ${tcserver_home}/tcruntime-instance.sh create --java-home ${java_home} --version ${tomcat_version_real} --instance-directory ${tcserver_home} ${instance_name}",
    cwd      => $tcserver_home,
    creates  => "${instance_dir_real}/webapps",
    provider => shell,
    user     => $owner_real,
    group    => $group_real,
    require  => Class['tcserver::install'],
  }

}
