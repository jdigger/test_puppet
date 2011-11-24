require_relative '../../../spec_helper'

describe 'tcserver::install' do

  let(:facts) { {operatingsystem: 'CentOS'} }

  describe "with custom params" do
    let :params do
      {
        package_name: 'tc_server_package',
        version: 'tcs_version',
      }
    end

    it "should make sure Java is installed" do
      should contain_class('sun_jdk').with(
        jdk_version: '1.6.0_30',
      )
    end

    it "should install the package" do
      should contain_package('tc-server').with(
        name:'tc_server_package',
        ensure: 'tcs_version-1',
      )
      should contain_user('tc-server').with(
        home: "/opt/tc_server_package-tcs_version",
      )
    end
  end

  it "should have the user/group set up" do
    should contain_group('tc-server').with_ensure(:present)
    should contain_user('tc-server').with(
      ensure: :present,
      gid: 'tc-server',
      shell: '',
    )
  end

  it "should make sure the ownership is set correctly" do
    should contain_exec('set_tcserver_dir_ownership').with(
      command: 'chown -R tc-server.tc-server /opt/vfabric-tc-server-developer-2.6.2.RELEASE',
      unless: 'test `stat -c %U /opt/vfabric-tc-server-developer-2.6.2.RELEASE` = tc-server',
    )
  end

end
