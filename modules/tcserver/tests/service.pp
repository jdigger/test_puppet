Package {
  provider => 'yum',
}

class { 'tcserver::instance':
  instance_name => 'a_server_instance',
  owner         => 'tc-server',
  group         => 'tc-server',
  service_name  => 'tcserver-a_server_instance',
}
->
tcserver::service {'tcserver-myapp':
  instance_name => 'myapp',
  service_name => 'tcserver-myapp',
  owner => 'tc-server',
  group => 'tc-server',
  instance_dir => '/var/run/tcserver-myapp',
}
