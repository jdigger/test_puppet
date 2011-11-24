require_relative '../../../spec_helper'

describe 'sun_jdk' do

  let(:facts) { {operatingsystem: 'CentOS'} }

  ['1.5', '1.6._30', '1.7'].each do |version|
    describe "with version: #{version}" do
      let :params do
        {:jdk_version => version}
      end
      it { should contain_package('jdk').with_name('jdk').with_ensure("#{version}-fcs") }
    end
  end

end
