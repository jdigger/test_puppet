# == Define: tcserver::instance
#
# tcServer user instance.
#
# == Examples:
# tcserver::instance{'a_server_instance': }
#

class tcserver::instance (
  $name,
  $service_name = "tcserver-${name}",
  $instance_dir = "${tcserver::install::tcserver_home}/${name}"
) {

  Class['tcserver::params'] -> Class['tcserver::install']

  if !defined(Class['tcserver::params']) {
    class {'tcserver::params': }
  }

  if !defined(Class['tcserver::install']) {
    class { 'tcserver::install':
      version => $tcserver::params::version,
    }
  }
  
  $java_home = $sun_jdk::java_home
  $tcserver_home = $tcserver::install::tcserver_home
  $tomcat_version = $tcserver::params::tomcat_version
  info("tc-Server instance '${name}': java_home='${java_home}' tcserver_home='${tcserver_home}' tomcat_version='${tomcat_version}'")

  # Create instance
  exec { "create_tcserver_${name}":
    command  => "export JAVA_HOME=${java_home} ; ${tcserver_home}/tcruntime-instance.sh create --java-home ${java_home} --version ${tomcat_version} --instance-directory ${tcserver_home} ${name}",
    cwd      => $tcserver::install::tcserver_home,
    creates  => "${instance_dir}/webapps",
    provider => shell,
    user     => 'tc-server',
    group    => 'tc-server',
    require  => [Class["tcserver::install"], Package['tc-server']],
  }

  Package['tc-server'] -> Exec["create_tcserver_${name}"]
}
