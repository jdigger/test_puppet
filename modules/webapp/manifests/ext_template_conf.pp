define webapp::ext_template_conf (
  $conf_dir,
  $service_name = '',
  $template_file = $name) {

#  require stdlib
  validate_re($name, ['.erb$'])

  $filename = regsubst($name, '.*?([^\/]*)\.erb$', '\1')

  if $service_name == '' {
    file {"${conf_dir}/${filename}":
      content => template($name),
    }
  }
  else {
    file {"${conf_dir}/${filename}":
      content => template($name),
      notify  => Service[$service_name],
    }
  }

}
