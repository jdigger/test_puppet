# == Class: tcServer::install
#
# Installs the Sun/Oracle JDK.
#
# === Parameters
#
# [*top_java_dirname*]
#   The top-level directory to contain the Java installation.
#   (e.g., /usr/java)  Defaults to $sun_jdk::params::top_java_dirname
#
# [*jdk_dirname*]
#   The relative name of the directory under $top_java_dirname that gets
#   created by the installer. The full path is what gets put into
#   JAVA_HOME and PATH.  Defaults to $sun_jdk::params::jdk_dirname
#
# [*installer_file*]
#   The name of the installation program.
#   Defaults to $sun_jdk::params::installer_file
#
# === Examples
#
#  class { 'tcserver::install': }
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
