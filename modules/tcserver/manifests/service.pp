# == Define: tcserver::service
#
# tcServer instance service.
#
# == Examples:
# tcserver::service{'a_server_instance': }
#
define tcserver::service (
  $instance_name,
  $service_name,
  $owner,
  $group,
  $instance_dir
) {

  # where to find files; first try local filesystem, then the puppet master
  $module = 'tcserver'
  $prefix = '/etc/puppet/modules'
  $p1     = "${prefix}/${module}/files"
  $p2     = "puppet://modules/${module}"

  # Create initd (service) file
  file { "/etc/init.d/${service_name}":
    ensure  => link,
    target  => "${instance_dir}/bin/init.d.sh",
    require => Tcserver::Instance[$instance_name],
  }

  # Create a useful "status" command
  file { "${instance_name}_status_script":
    path    => "${instance_dir}/bin/status.sh",
    source  => ["${p1}/server-status.sh", "${p2}/server-status.sh"],
    mode    => '0700',
    owner   => $owner,
    group   => $group,
    require => Tcserver::Instance[$instance_name],
  }

  service { $service_name:
      ensure     => running,
      enable     => true,
      hasstatus  => false,
      status     => "${instance_dir}/bin/status.sh",
      hasrestart => true,
      require    => [File["/etc/init.d/${service_name}", "${instance_name}_status_script"], Tcserver::Instance[$instance_name]],
  }

}
