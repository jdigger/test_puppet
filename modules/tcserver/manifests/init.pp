# == Class: tcServer
#
# Installs SpringSource tc Server from Yum.
#
# === Parameters
#
#
# === Examples
#
#  class {'tcserver': }
#
class tcserver(
  $instance_name,
  $owner,
  $group,
  $service_name = "tcserver-${instance_name}",
  $tomcat_version = 'UNSET',
  $instance_dir = 'UNSET'
) {

  require 'tcserver::params'

  class { 'tcserver::install':
    owner        => $owner,
    group        => $group,
    package_name => $tcserver::params::package_name,
    version      => $tcserver::params::version,
  }

  $tomcat_version_real = $tomcat_version ? {
    'UNSET' => $tcserver::params::tomcat_version,
    default => $tomcat_version,
  }
  $tcserver_home = $tcserver::install::tcserver_home
  $instance_dir_real = $instance_dir ? {
    'UNSET' => "${tcserver_home}/${instance_name}",
    default => $instance_dir,
  }

  tcserver::instance {$instance_name:
    owner          => $owner,
    group          => $group,
    service_name   => $service_name,
    tomcat_version => $tomcat_version_real,
    instance_dir   => $instance_dir_real,
    require        => Class['tcserver::install'],
  }

}
