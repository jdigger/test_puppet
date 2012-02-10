require_relative '../../../spec_helper'

describe 'tcserver::install' do

  let :params do
    {
      package_name: 'tc_server_package',
      version:      'tcs_version',
      owner:        'test-user',
      group:        'test-group',
    }
  end

  let(:facts) { {operatingsystem: 'CentOS'} }

  it { should contain_class('sun_jdk') }

  it "should install the package" do
    should contain_package('tc-server').with(
      name:'tc_server_package',
      ensure: 'tcs_version-1',
    )
    should contain_user(params[:owner]).with(
      home: "/opt/#{params[:package_name]}-#{params[:version]}",
    )
  end

  it "should have the user/group set up" do
    should contain_group(params[:group]).with_ensure(:present)
    should contain_user(params[:owner]).with(
      ensure: :present,
      gid:    params[:group],
      shell:  '',
    )
  end

  it "should make sure the ownership is set correctly" do
    should contain_exec('set_tcserver_dir_ownership').with(
      command: "chown -R #{params[:owner]}.#{params[:group]} /opt/#{params[:package_name]}-#{params[:version]}",
      unless: "test `stat -c %U /opt/#{params[:package_name]}-#{params[:version]}` = #{params[:owner]}",
    )
  end

end
