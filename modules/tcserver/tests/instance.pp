Package {
  provider => 'yum',
}

class {'tcserver::instance':
  instance_name =>'a_server_instance',
}
