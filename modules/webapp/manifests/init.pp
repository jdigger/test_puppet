class webapp (
  $app_name,
  $version,
  $server_dir,
  $owner,
  $group,
  $artifactory_username,
  $artifactory_password,
  $conf_dir = 'UNSET',
  $sysproperty_name = '!UNSET!',
  $group_name = "com.canoeventures.${app_name}",
  $template_file = 'UNSET',
  $template_files = [],
  $release = true,
  $service_name = 'UNSET'
) {

  webapp::install { $app_name:
    group_name           => $group_name,
    version              => $version,
    server_dir           => $server_dir,
    owner                => $owner,
    group                => $group,
    artifactory_username => $artifactory_username,
    artifactory_password => $artifactory_password,
    release              => $release,
  }

  if $conf_dir != 'UNSET' {
    webapp::ext_conf { $app_name:
      sysproperty_name => $sysproperty_name,
      conf_dir         => $conf_dir,
      server_dir       => $server_dir,
      owner            => $owner,
      group            => $group,
      template_file    => $template_file,
      template_files   => $template_files,
      service_name     => $service_name,
      require          => File[$server_dir],
    }
  }

}
