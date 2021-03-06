# == Class: tcServer::install
#
# Installs SpringSource tc Server from Yum.
#
# === Parameters
#
# [*package_name*]
#   The name of the Yum package to install.
#   Defaults to $tcserver::params::package_name
#
# [*version*]
#   The version of tc Server. (Does not include the
#   package revision.)  Defaults to $tcserver::params::version
#
# [*owner*]
#   The system owner to run tc Server as. Defaults to $tcserver::params::owner.
#
# [*group*]
#   The system group to run tc Server as. Defaults to $tcserver::params::group.
#
# === Examples
#
#  class { 'tcserver::install': }
#
# === Actions
#
# * Makes sure the Sun/Oracle JDK is installed. (see Class[sun_jdk])
# * Creates the user and group to run as
# * Installs the tc Server RPM from Yum and makes sure ownership is set
#
class tcserver::install(
  $owner        = 'UNSET',
  $group        = 'UNSET',
  $package_name = 'UNSET',
  $version      = 'UNSET'
) {

  require 'tcserver::params'

  $the_package_name = $package_name ? {
    'UNSET' => $tcserver::params::package_name, default => $package_name}
  $the_version = $version ? {
    'UNSET' => $tcserver::params::version, default => $version}

  $owner_real = $owner ? {
    'UNSET' => $tcserver::params::owner,
    default => $owner,
  }
  $group_real = $group ? {
    'UNSET' => $tcserver::params::group,
    default => $group,
  }

  $tcserver_home = "/opt/${the_package_name}-${the_version}"

  if !defined(Class['sun_jdk']) {
    class { 'sun_jdk': }
  }

  package { 'tc-server':
    ensure  => "${the_version}-1",
    name    => $the_package_name,
    require => [Class['sun_jdk'], User[$owner]],
  }

  group { $group_real:
    ensure => present,
  }

  user { $owner_real:
    ensure           => present,
    comment          => 'SpringSource tc-Server',
    gid              => $group_real,
    home             => $tcserver_home,
    password         => '!!',
    password_max_age => '-1',
    password_min_age => '-1',
    shell            => '',
  }

  exec { 'set_tcserver_dir_ownership':
    command => "chown -R ${owner}.${$group} ${tcserver_home}",
    path    => '/usr/bin:/bin',
    unless  => "test `stat -c %U ${tcserver_home}` = ${owner}",
    require => [Package['tc-server'], User[$owner_real]],
  }

  file { 'set_tcserver_dir_ownership':
    path    => $tcserver_home,
    owner   => $owner_real,
    group   => $group_real,
    recurse => false,
    mode    => '2600',
    require => Package['tc-server'],
  }

}
