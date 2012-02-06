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
# === Examples
#
#  class { 'tcserver::install': }
#
# === Actions
#
# * Makes sure the Sun/Oracle JDK is installed. (see Class[sun_jdk])
# * Creates the 'tc-server' user and group.
# * Installs the tc Server RPM from Yum and makes sure it's owned by 'tc-server'
#
class tcserver::install(
  $package_name = '',
  $version = ''
) {

  if !defined(Class['tcserver::params']) {
    include 'tcserver::params'
  }

  $the_package_name = $package_name ? {
    '' => $tcserver::params::package_name, default => $package_name}
  $the_version = $version ? {
    '' => $tcserver::params::version, default => $version}

  $tcserver_home = "/opt/${the_package_name}-${the_version}"

  if !defined(Class['sun_jdk']) {
    class { 'sun_jdk':
      jdk_version => $tcserver::params::jdk_version,
    }
  }

  package { 'tc-server':
    name    => $the_package_name,
    ensure  => "${the_version}-1",
    require => [Class['sun_jdk'], User['tc-server']],
  }

  group { 'tc-server':
    ensure => present,
  }

  user { 'tc-server':
    ensure           => present,
    comment          => 'SpringSource tc-Server',
    gid              => 'tc-server',
    home             => $tcserver_home,
    password         => '!!',
    password_max_age => '-1',
    password_min_age => '-1',
    shell            => '',
    require          => Group['tc-server'],
  }
  
  exec { "set_tcserver_dir_ownership":
    command => "chown -R tc-server.tc-server ${tcserver_home}",
    path    => "/usr/bin:/bin",
    unless  => "test `stat -c %U ${tcserver_home}` = tc-server",
    require => [Package['tc-server'], User['tc-server']],
    before  => Class['tcserver::instance'],
  }

  file { "set_tcserver_dir_ownership":
    path => $tcserver_home,
    owner => 'tc-server',
    group => 'tc-server',
    recurse => false,
    mode => '2600',
    require => Package['tc-server'],
  }

}
