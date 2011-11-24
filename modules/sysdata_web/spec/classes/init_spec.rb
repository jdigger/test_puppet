require_relative '../../../spec_helper'

describe 'sysdata_web' do

  before :each do
    @params = {
      version:              '1.2.3',
      artifactory_username: 'uname',
      artifactory_password: 'pw',
      crowd_username:       'crowduser',
      crowd_password:       'crowdpw',
      crowd_server_url:     'https://crowd_server/',
      logout_url:           'http://server/logout',
      my_account_url:       'http://server/account',
      sysdata_url:          'http://sysdata/',
      webportal_url:        'http://webportal/',
      datasource_url:       'jdbc://oracle/',
      datasource_username:  'ds_uname',
      datasource_password:  'ds_pw',
      grails_server_url:    'http://server/',
      webservice_base_url:  'http://server/rest/',
      conf_dir:             '/the_conf_dir',
    }
  end

  let(:facts) { {operatingsystem: 'CentOS'} }

  describe "basic structural test" do

    let(:params) do
      @params
    end

    it do
      should contain_class("tcserver::instance")
    end

    it "should install the sysdata webapp" do
      should contain_webapp__install("sysdata").with(
        group_name:           'com.canoeventures.sysdata',
        version:              "#{params[:version]}",
        release:              true,
        artifactory_username: "#{params[:artifactory_username]}",
        artifactory_password: "#{params[:artifactory_password]}",
        conf_dir:             "#{params[:conf_dir]}",
      )
    end

    it "should set up the configuration files" do
      should contain_webapp__ext_conf('sysdata_web').with(
        sysproperty_name: 'SYSDATACONF',
        conf_dir:         "#{params[:conf_dir]}",
        template_files:   [
          'sysdata_web/crowd-ehcache.xml.erb',
          'sysdata_web/crowd.properties.erb',
          'sysdata_web/log4j.groovy.erb',
          'sysdata_web/navigation.groovy.erb',
          'sysdata_web/sysdata.properties.erb',
        ],
      )
    end

  end

end
