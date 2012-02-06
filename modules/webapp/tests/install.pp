#
# Do install with no service notification
#
webapp::install { 'a_app':
  group_name           => 'com.canoeventures.a_app',
  version              => '14.5',
  server_dir           => '/opt/tcs',
  owner                => 'test-user',
  group                => 'test-group',
  artifactory_username => 'art-user',
  artifactory_password => 'art-pw',
  release              => true,
}

#
# Do install with service notification
#
service {'tcserver-b_app':}
webapp::install { 'b_app':
  group_name           => 'com.canoeventures.b_app',
  version              => '14.5',
  server_dir           => '/opt/tcs',
  owner                => 'test-user',
  group                => 'test-group',
  artifactory_username => 'art-user',
  artifactory_password => 'art-pw',
  service_name         => 'tcserver-b_app',
  release              => true,
}
