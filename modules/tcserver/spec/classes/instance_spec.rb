require_relative '../../../spec_helper'

describe 'tcserver::instance' do

  let(:params) do
    {
      name: 'my_app',
    }
  end
  let(:facts) { {operatingsystem: 'CentOS'} }

  it "should install the package" do
    should contain_package('tc-server').with(
      name:'vfabric-tc-server-developer',
      ensure: '2.6.2.RELEASE-1',
    )
  end

  it "should create an instance of my_app" do
    should contain_exec('create_tcserver_my_app').with(
      cwd: '/opt/vfabric-tc-server-developer-2.6.2.RELEASE',
      command: "/opt/vfabric-tc-server-developer-2.6.2.RELEASE/tcruntime-instance.sh create --java-home  --version  --instance-directory /opt/vfabric-tc-server-developer-2.6.2.RELEASE #{params[:name]}",
      provider: :shell,
      user: 'tc-server',
      group: 'tc-server',
    )
  end

end
