# == Class: sun_jdk
#
# The Sun/Oracle JDK
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
# === Examples
#
#  class {'sun_jdk': }
#
class sun_jdk(
  $jdk_package_name = 'UNSET',
  $jdk_version = 'UNSET'
) {

  if !defined(Class['sun_jdk::params']) {
    include 'sun_jdk::params'
  }

  # where to find files; first try local filesystem, then the puppet master
  $module = 'sun_jdk'
  $prefix = '/etc/puppet/modules'
  $p1     = "${prefix}/${module}/files"
  $p2     = "puppet://modules/${module}"

  $the_package_name = $jdk_package_name ? {
    'UNSET' => $sun_jdk::params::jdk_package_name, default => $jdk_package_name}
  $the_version = $jdk_version ? {
    'UNSET' => $sun_jdk::params::jdk_version, default => $jdk_version}

  $java_home = "/usr/java/jdk${the_version}"

  package { $the_package_name:
    ensure => "${the_version}-fcs",
  }

  # Install the "unlimited" Java Cryptography policy files
  File {
    mode    => '644',
    owner   => 'root',
    group   => 'root',
    require => Package[$the_package_name],
  }
  file { 'unlimited_local_policy.jar':
    path    => "${java_home}/jre/lib/security/local_policy.jar",
    source  => ["${p1}/local_policy.jar", "${p2}/local_policy.jar"],
  }
  file { 'unlimited_US_export_policy.jar':
    path    => "${java_home}/jre/lib/security/US_export_policy.jar",
    source  => ["${p1}/US_export_policy.jar", "${p2}/US_export_policy.jar"],
  }

}
