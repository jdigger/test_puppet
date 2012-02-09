define webapp::ext_template_conf (
  $conf_dir,
  $owner,
  $group = 'root',
  $mode = '0600',
  $service_name = 'UNSET',
  $template_file = $name
) {

  validate_re($name, ['.erb$'])

  $filename = regsubst($name, '.*?([^\/]*)\.erb$', '\1')

  file {"${conf_dir}/${filename}":
    content => template($name),
    owner   => $owner,
    group   => $group,
    mode    => $mode,
  }

  if $service_name != 'UNSET' {
    File["${conf_dir}/${filename}"] ~> Service[$service_name]
  }

}
