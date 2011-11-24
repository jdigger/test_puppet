$artifactory_username = 'testclient'
$artifactory_password = 'testpw'

class {"webapp": 
  group_name => "com.canoeventures.sysdata",
  app_name => "sysdata",
  version => "1.4.2_7",
}
