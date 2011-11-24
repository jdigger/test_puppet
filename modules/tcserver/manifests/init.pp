# == Class: tcServer
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
#  class {'tcserver': }
#
class tcserver(
) {


}
