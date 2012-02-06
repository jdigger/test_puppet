require_relative '../../../spec_helper'

describe 'webapp::install' do

  let(:title) { 'my_app' }
  let(:params) do
    {
      group_name:           'test.group.myapp',
      version:              '1.2.3',
      artifactory_username: 'uname',
      artifactory_password: 'pw',
      owner:                'test-user',
      group:                'test-group',
      server_dir:           "/opt/vfabric-tc-server-developer-2.6.2.RELEASE/#{title}",
    }
  end
  let(:facts) {{operatingsystem: 'CentOS'}}

  it {should contain_package('wget')}

  let(:filename) { "#{title}-#{params[:version]}.war" }
  let(:url) do
    "https://#{params[:artifactory_username]}:#{params[:artifactory_password]}@canoe-ventures.artifactoryonline.com/canoe_ventures/libs-releases-local/test/group/myapp/#{params[:version]}/#{filename}"
  end

  it "should get the war from the artifact server" do
    should contain_exec("get_#{filename}").with(
      cwd:     params[:server_dir],
      command: "wget --no-check-certificate #{url}",
      unless:  "test -f #{filename}",
    )
  end

  it "should move the war into webapps" do
    should contain_exec("mv_#{filename}_to_webapps").with(
      cwd:     params[:server_dir],
      command: "mv #{filename} webapps/",
      unless:  "test -f #{params[:server_dir]}/webapps/#{filename}",
#      require: "[Exec[get_#{filename}], Class[tcserver::instance]]",
#      notify:  "Service[tcserver-#{title}]",
    )
  end

end
