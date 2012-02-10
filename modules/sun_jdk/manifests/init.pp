# == Class: sun_jdk
#
# The Sun/Oracle JDK
#
# === Parameters
#
# [*jdk_version*]
#   The version of the JDK to install.  Is not necessarily the same as
#   $jdk_package_version.  Defaults to $sun_jdk::params::jdk_version.
#
# [*jdk_package_name*]
#   The name of the package in the packaging system for the OS.
#   Defaults to $sun_jdk::params::jdk_package_name
#
# [*jdk_package_version*]
#   The version of the JDK to install acording to the packaging system.
#   The default is $jdk_version with "-rcs" appended.
#
# === Examples
#
#  class {'sun_jdk': }
#
class sun_jdk(
  $jdk_version = 'UNSET',
  $jdk_package_name = 'UNSET',
  $jdk_package_version = 'UNSET'
) {

  require 'sun_jdk::params'

  # where to find files; first try local filesystem, then the puppet master
  $module = 'sun_jdk'
  $p1     = "/etc/puppet/modules/${module}/files"
  $p2     = "puppet://modules/${module}"

  $package_name_real = $jdk_package_name ? {
    'UNSET' => $sun_jdk::params::jdk_package_name, default => $jdk_package_name}
  $jdk_version_real = $jdk_version ? {
    'UNSET' => $sun_jdk::params::jdk_version, default      => $jdk_version}
  $jdk_package_version_real = $jdk_package_version ? {
    'UNSET' => "${jdk_version_real}-fcs", default  => $jdk_package_version}

  $java_home = "/usr/java/jdk${jdk_version_real}"

  package { $package_name_real:
    ensure => $jdk_package_version_real,
  }

  # Install the "unlimited" Java Cryptography policy files
  File {
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    require => Package[$package_name_real],
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
