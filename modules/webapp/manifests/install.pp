define webapp::install (
  $group_name = "com.canoeventures.${name}",
  $app_name = $name,
  $version,
  $conf_dir,
  $server_dir,
  $artifactory_username,
  $artifactory_password,
  $release = true) {

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
    path    => "/usr/bin:/bin:/opt/local/bin",
    cwd     => $server_dir,
    user    => 'tc-server',
    group   => 'tc-server',
    command => "wget --no-check-certificate ${credential_url}",
    require => Class['tcserver::instance'],
    unless  => "test -f ${filename}",
  }

  exec {"mv_${filename}_to_webapps":
    path    => "/usr/bin:/bin",
    cwd     => $server_dir,
    command => "mv ${filename} webapps/",
    unless  => "test -f ${server_dir}/webapps/${filename}",
    require => Exec["get_${filename}"],
    notify  => Service[$tcserver::instance::service_name],
  }

}
