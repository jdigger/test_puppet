require_relative '../../../spec_helper'
require 'tempfile'

describe 'webapp::ext_template_conf' do

  before(:each) do
    @tplfile = Tempfile.new(['template', '.erb'])
    @filename = File.basename(@tplfile, '.erb')
    tplFilePath = File.absolute_path(@tplfile)
    @params = {
      conf_dir: "/var/conf/#{tplFilePath}",
      owner:    'test-user',
      group:    'test-group',
    }

  end

  after(:each) do
    @tplfile.close
    @tplfile.unlink
  end

  let(:title) { "#{File.absolute_path(@tplfile)}" }
  let(:facts) { {operatingsystem: 'CentOS'} }

  describe "with no service" do
    let(:params) do
      @params
    end

    it "should copy the conf file" do
      should contain_file("#{params[:conf_dir]}/#{@filename}").without_notify
    end
  end

  describe "with service" do
    let(:params) do
      @params[:service_name] = 'aservice'
      @params
    end

    it "should copy the conf file" do
      pending "Figure out how to verify this relationship"
      # should contain_file("#{params[:conf_dir]}/#{@filename}").with_notify("Service[aservice]")
    end
  end

end
