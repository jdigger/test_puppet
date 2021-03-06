node 'base' {

  $artifactory_username = 'yumclient'
  $artifactory_password = 'p%4055w0rd'  # must (currently) be pre-urlencoded

  yumrepo { 'artifactory':
    baseurl  => "https://${artifactory_username}:${artifactory_password}@canoe-ventures.artifactoryonline.com/canoe_ventures/rpms-release-local/",
    descr    => 'Canoe Artifactory Online Server',
    enabled  => '1',
    gpgcheck => '0',
  }

  Package {
    provider => 'yum',
    require  => Yumrepo['artifactory'],
  }

  Yumrepo <| |> -> Package <| provider == yum |>
}


node 'default' inherits 'base' {

  file { '/var/conf':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }
  ->
  class { 'tcserver':
    instance_name => 'sysdata',
  }
  ->
  class { 'sysdata_web':
    version              => '1.4.2_7',
    release              => true,
    conf_dir             => '/var/conf/sysdata',
    server_dir           => $tcserver::instance_dir_real,

    crowd_username       => 'web_portal',
    crowd_password       => 'admin',
    crowd_server_url     => 'http://10.13.18.56:9095/crowd/',

    artifactory_username => 'yumclient',
    artifactory_password => 'p%4055w0rd',  # must (currently) be pre-urlencoded
    logout_url           => 'https://qa.accesscanoe.com/portal/logout/index',
    my_account_url       => 'https://qa.accesscanoe.com/portal/account/profile',
    sysdata_url          => 'https://qa.accesscanoe.com/sysdata',
    webportal_url        => 'https://qa.accesscanoe.com/portal/',
    grails_server_url    => 'http://localhost:8080/sysdata',
    webservice_base_url  => 'http://localhost:8080/sysdata',

    datasource_url       => 'jdbc:oracle:thin:@10.13.18.67:1522:caasit02',
    datasource_username  => 'sysdata',
    datasource_password  => 'secret',
  }

}
