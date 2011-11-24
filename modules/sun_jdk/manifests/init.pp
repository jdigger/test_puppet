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
  $jdk_package_name = '',
  $jdk_version = ''
) {

  if !defined(Class['sun_jdk::params']) {
    include 'sun_jdk::params'
  }

  $the_package_name = $jdk_package_name ? {
    '' => $sun_jdk::params::jdk_package_name, default => $jdk_package_name}
  $the_version = $jdk_version ? {
    '' => $sun_jdk::params::jdk_version, default => $jdk_version}

  $java_home = "/usr/java/jdk${the_version}"

  package { $the_package_name:
    ensure => "${the_version}-fcs",
  }

}
