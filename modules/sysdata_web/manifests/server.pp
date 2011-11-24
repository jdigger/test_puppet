class sysdata_web::server (
  $tcserver_version = 'UNSET'
) {
  
  Class['tcserver::install'] -> Class['sysdata_web::server']

  if !defined(Class['tcserver::install']) {
    if !defined(Class['tcserver::params']) {
      require 'tcserver::params'
    }

    $tcs_version = $tcserver_version ? {
      'UNSET' => $tcserver::params::version,
      default => $tcserver_version,
    }

    class { 'tcserver::install':
      version => $tcs_version,
#      stage   => 'setup_infra',
    }
  }

  $sysdata_instance_dir = "${tcserver::install::tcserver_home}/sysdata"

  class {'tcserver::instance':
    name         => 'sysdata',
    instance_dir => $sysdata_instance_dir,
    require      => Class['tcserver::install'],
#    stage        => 'main',
  }

  class {'tcserver::service':
    instance_name => 'sysdata',
    instance_dir  => $sysdata_instance_dir,
    service_name  => 'tcserver-sysdata',
#    stage         => 'deploy_app',
    require       => Class['tcserver::instance'],
  }

}
