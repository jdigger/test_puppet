define webapp::ext_conf (
  $sysproperty_name,
  $conf_dir,
  $server_dir,
  $owner,
  $group = 'root',
  $mode = '0600',
  $app_name = $name,
  $template_file = 'UNSET',
  $template_files = [],
  $service_name = 'UNSET'
) {

  if !defined(Exec["update_external_conf_${name}"]) {
    # escape the slashes in the path for the regular expression
    $re_cd = regsubst(shellquote($conf_dir), '/', '\/', 'G')

    exec {"update_external_conf_${name}":
      path    => '/usr/bin:/bin',
      cwd     => "${server_dir}/bin",
      command => "sed -e \"s/^\\s*\\(JVM_OPTS=.*\\)\\\"\\s*$/\\1 -D${sysproperty_name}=${re_cd}\\\"/\" -i\".bak\" setenv.sh",
      unless  => "grep ${sysproperty_name} setenv.sh",
    }
  }

  if !defined(File['/var/conf']) {
    file { '/var/conf':
      ensure  => directory,
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
    }
  }

  if !defined(File[$conf_dir]) {
    file { $conf_dir:
      ensure  => directory,
      owner   => $owner,
      group   => $group,
      mode    => $mode,
      require => File['/var/conf'],
    }
  }

  if $template_file != 'UNSET' {
    ext_template_conf{ $template_file:
      conf_dir     => $conf_dir,
      owner        => $owner,
      group        => $group,
      mode         => $mode,
      service_name => $service_name,
      require      => File[$conf_dir],
    }
  }

  if $template_files != [] {
    ext_template_conf{ $template_files:
      conf_dir     => $conf_dir,
      owner        => $owner,
      group        => $group,
      mode         => $mode,
      service_name => $service_name,
      require      => File[$conf_dir],
    }
  }

}
