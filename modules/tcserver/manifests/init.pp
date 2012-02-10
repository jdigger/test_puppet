# == Class: tcServer
#
# Installs SpringSource tc Server from Yum.
#
# === Parameters
#
# [*instance_name*]
#   The name of the tc Server instance to create after the server has been installed.
#
# [*version*]
#   The version of tc Server to install. Defaults to $tcserver::params::version.
#
# [*package_name*]
#   The package name of tc Server to install. Defaults to $tcserver::params::package_name.
#
# [*owner*]
#   The system owner to run tc Server as. Defaults to $tcserver::params::owner.
#
# [*group*]
#   The system group to run tc Server as. Defaults to $tcserver::params::group.
#
# [*service_name*]
#   The name to give the tc Server instance to run as. Defaults to "tcserver-${instance_name}".
#
# [*tomcat_version*]
#   The version of Tomcat to use for the instance. Defaults to $tcserver::params::tomcat_version.
#
# [*instance_dir*]
#   The directory to put the instance in. Defaults to a subdirectory of the main tc Server
#   installation, named the same as $instance_name.
#
# === Examples
#
#  class {'tcserver':
#    instance_name => 'my_application',
#  }
#
class tcserver(
  $instance_name,
  $version        = 'UNSET',
  $package_name   = 'UNSET',
  $owner          = 'UNSET',
  $group          = 'UNSET',
  $service_name   = "tcserver-${instance_name}",
  $tomcat_version = 'UNSET',
  $instance_dir   = 'UNSET'
) {

  require 'tcserver::params'

  $owner_real = $owner ? {
    'UNSET' => $tcserver::params::owner,
    default => $owner,
  }
  $group_real = $group ? {
    'UNSET' => $tcserver::params::group,
    default => $group,
  }

  $tomcat_version_real = $tomcat_version ? {
    'UNSET' => $tcserver::params::tomcat_version,
    default => $tomcat_version,
  }

  class { 'tcserver::install':
    owner          => $owner_real,
    group          => $group_real,
    package_name   => $package_name,
    version        => $version,
  }

  $tcserver_home = $tcserver::install::tcserver_home
  $instance_dir_real = $instance_dir ? {
    'UNSET' => "${tcserver_home}/${instance_name}",
    default => $instance_dir,
  }

  tcserver::instance {$instance_name:
    owner          => $owner_real,
    group          => $group_real,
    service_name   => $service_name,
    tomcat_version => $tomcat_version_real,
    instance_dir   => $instance_dir_real,
    require        => Class['tcserver::install'],
  }

}
