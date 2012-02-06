class tcserver::params {

  $package_name   = 'vfabric-tc-server-developer'
  $version        = '2.6.2.RELEASE'
  $tomcat_version = '7.0.22.A.RELEASE'
  info("params::tomcat_version='${tomcat_version}'")
  $owner          = 'tc-server'
  $group          = $owner

  $jdk_version    = '1.6.0_30'

}
