$crowd_username = 'web_portal'
$crowd_password = 'admin'
$crowd_server_url = 'http://10.13.18.56:9095/crowd/'

$logout_url = 'https://qa.accesscanoe.com/portal/logout/index'
$my_account_url = 'https://qa.accesscanoe.com/portal/account/profile'
$sysdata_url = 'https://qa.accesscanoe.com/sysdata'
$webportal_url = 'https://qa.accesscanoe.com/portal/'
$grails_server_url = 'http://localhost:8080/sysdata'
$webservice_base_url = 'http://localhost:8080/sysdata'

$datasource_url = 'jdbc:oracle:thin:@10.13.18.67:1522:caasit02'
$datasource_username = 'sysdata'
$datasource_password = 'secret'

$artifactory_username = 'yumclient'
$artifactory_password = 'p%4055w0rd'  # must (currently) be pre-urlencoded
# $artifactory_username = 'testclient'
# $artifactory_password = 'testpw'

class {"sysdata_web": 
  version => "1.4.2_7",
  conf_dir => '/tmp',
  server_dir => '/Users/JimMoore/Downloads/vfabric-tc-server-developer-2.6.2.RELEASE/myserver',
}
