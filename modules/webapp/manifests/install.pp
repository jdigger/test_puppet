define webapp::install (
  $version,
  $server_dir,
  $owner,
  $group,
  $artifactory_username,
  $artifactory_password,
  $group_name           = "com.canoeventures.${name}",
  $app_name             = $name,
  $service_name         = 'UNSET',
  $release              = true
) {

  $url_group_name = regsubst($group_name, '\.', '/', 'G')
  $filename       = "${app_name}-${version}.war"
  $relative_url   = "${url_group_name}/${version}/${filename}"
  $release_path   = $release ? {true => 'libs-releases-local', default => 'libs-snapshots-local'}

  $url            = "https://canoe-ventures.artifactoryonline.com/canoe_ventures/${release_path}/${relative_url}"
  $credential_url = regsubst($url, 'https://', "https://${artifactory_username}:${artifactory_password}@", '')

  info("Getting file from ${url}")
  debug("Getting file from cred ${credential_url}")

  if !defined(Package['wget']) {
    package { 'wget':
      ensure => installed,
    }
  }

  exec {"get_${filename}":
    path    => '/usr/bin:/bin:/opt/local/bin',
    cwd     => $server_dir,
    user    => $owner,
    group   => $group,
    command => "wget --no-check-certificate ${credential_url}",
    unless  => "test -f ${filename}",
    require => Package['wget'],
  }

  exec {"mv_${filename}_to_webapps":
    path    => '/usr/bin:/bin',
    cwd     => $server_dir,
    command => "mv ${filename} webapps/",
    unless  => "test -f ${server_dir}/webapps/${filename}",
    require => Exec["get_${filename}"],
  }

  if $service_name != 'UNSET' {
    Exec["mv_${filename}_to_webapps"] -> Service[$service_name]
  }

}
