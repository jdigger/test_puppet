Package {
  provider => 'yum',
}

class { 'tcserver':
  instance_name => 'a_server_instance',
  owner         => 'tc-server',
  group         => 'tc-server',
  service_name  => 'tcserver-a_server_instance',
}
