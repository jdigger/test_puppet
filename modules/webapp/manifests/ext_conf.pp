define webapp::ext_conf (
  $app_name = $name,
  $sysproperty_name,
  $conf_dir,
  $template_file = '',
  $template_files = [],
  $service_name = '',
  $server_dir) {

  if !defined(Exec["update_external_conf_${name}"]) {
    # escape the slashes in the path for the regular expression
    $re_cd = regsubst(shellquote($conf_dir), '/', '\/', 'G')

    exec {"update_external_conf_${name}":
      path    => "/usr/bin:/bin",
      cwd     => "${server_dir}/bin",
      command => "sed -e \"s/^\\s*\\(JVM_OPTS=.*\\)\\\"\\s*$/\\1 -D${sysproperty_name}=${re_cd}\\\"/\" -i\".bak\" setenv.sh",
      unless  => "grep ${sysproperty_name} setenv.sh",
    }
  }

  if !defined(File[$conf_dir]) {
    file { $conf_dir:
      ensure  => directory,
      owner   => 'tc-server',
      group   => 'tc-server',
      require => Class['tcserver::instance'],
    }
  }

  if $template_file != '' {
    ext_template_conf{ $template_file:
      conf_dir     => $conf_dir,
      service_name => $service_name
    }
  }

  if $template_files != [] {
    ext_template_conf{ $template_files:
      conf_dir     => $conf_dir,
      service_name => $service_name
    }
  }

}
