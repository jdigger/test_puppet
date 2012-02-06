webapp::ext_conf { 'the_conf':
  sysproperty_name => 'THECONF',
  conf_dir         => '/conf',
  server_dir       => '/opt/server',
  owner            => 'test-user',
  template_file    => 'sysdata_web/log4j.groovy.erb',
}

webapp::ext_conf { 'the_confs':
  sysproperty_name => 'THECONF',
  conf_dir         => '/conf',
  server_dir       => '/opt/server',
  owner            => 'test-user',
  template_files   => ['sysdata_web/navigation.groovy.erb'],
}
