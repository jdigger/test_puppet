require_relative '../../../spec_helper'

describe 'tcserver::instance' do

  let(:params) do
    {
      instance_name:  'my_app',
      owner:          'test-user',
      group:          'test-group',
      tomcat_version: '7.0.22.A.RELEASE',
    }
  end
  let(:facts) { {operatingsystem: 'CentOS'} }

  it "should install the package" do
    should contain_package('tc-server').with(
      name:   'vfabric-tc-server-developer',
      ensure: '2.6.2.RELEASE-1',
    )
  end

  it "should create an instance of my_app" do
    should contain_exec('create_tcserver_my_app').with(
      cwd:      '/opt/vfabric-tc-server-developer-2.6.2.RELEASE',
      command:  "export JAVA_HOME=/usr/java/jdk1.6.0_30 ; /opt/vfabric-tc-server-developer-2.6.2.RELEASE/tcruntime-instance.sh create --java-home /usr/java/jdk1.6.0_30 --version 7.0.22.A.RELEASE --instance-directory /opt/vfabric-tc-server-developer-2.6.2.RELEASE #{params[:instance_name]}",
      provider: :shell,
      user:     params[:owner],
      group:    params[:group],
    )
  end

end
