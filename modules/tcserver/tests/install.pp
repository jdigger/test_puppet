Package {
  provider => 'yum',
}

class {'tcserver::install':
  owner => 'tc-server',
  group => 'tc-server',
}
