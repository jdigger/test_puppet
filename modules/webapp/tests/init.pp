webapp { 'a_app':
  group_name           => 'com.canoeventures.a_app',
  app_name             => 'a_app',
  version              => '14.5',
  conf_dir             => '/var/conf/a_app',
  server_dir           => '/opt/tcs',
  owner                => 'test-user',
  group                => 'test-group',
  artifactory_username => 'art-user',
  artifactory_password => 'art-pw',
  release              => true,
}
