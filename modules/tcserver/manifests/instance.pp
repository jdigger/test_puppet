# == Define: tcserver::instance
#
# tcServer user instance.
#
# == Examples:
# tcserver::instance{'a_server_instance': }
#
class tcserver::instance (
  $instance_name,
  $owner,
  $group,
  $service_name = "tcserver-${instance_name}",
  $tomcat_version = 'UNSET',
  $instance_dir = 'UNSET'
) inherits tcserver::params {

  Class['tcserver::params'] -> Class['tcserver::install']
  Class['tcserver::params'] -> Class['tcserver::instance']
  Class['tcserver::install'] -> Class['tcserver::instance']

  if !defined(Class['tcserver::params']) {
    class {'tcserver::params': }
  }

  if !defined(Class['sun_jdk']) {
    class {'sun_jdk': }
  }

  if !defined(Class['tcserver::install']) {
    class {'tcserver::install':
      owner => $owner,
      group => $group,
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
    command  => "export JAVA_HOME=${java_home} ; ${tcserver_home}/tcruntime-instance.sh create --java-home ${java_home} --version ${tomcat_version} --instance-directory ${tcserver_home} ${instance_name}",
    cwd      => $tcserver_home,
    creates  => "${instance_dir}/webapps",
    provider => shell,
    user     => $owner,
    group    => $group,
    require  => [Class['tcserver::install'], Package['tc-server']],
  }

  class { 'tcserver::service':
    instance_name => $instance_name,
    service_name  => $service_name,
    owner         => $owner,
    group         => $group,
    instance_dir  => $instance_dir,
    require       => Exec["create_tcserver_${instance_name}"],
  }


  Package['tc-server'] -> Exec["create_tcserver_${instance_name}"]
}
