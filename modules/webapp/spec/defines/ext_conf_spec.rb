require_relative '../../../spec_helper'
require 'tempfile'

describe 'webapp::ext_conf' do
  
  before :each do
    @params = {
      sysproperty_name: "MYAPPCONFIG",
      conf_dir:         "/var/conf/#{title}",
      server_dir:       "/opt/vfabric-tc-server-developer-2.6.2.RELEASE/#{title}",
    }
  end

  let(:title) { 'my_app' }
  let(:params) { @params }
  let(:facts) { {operatingsystem: 'CentOS'} }

  it "should update the server's setenv.sh" do
    should contain_exec("update_external_conf_#{title}").with(
      cwd:     "#{params[:server_dir]}/bin",
      command: /^sed .*#{params[:sysproperty_name]}.* setenv.sh/,
      unless:  "grep #{params[:sysproperty_name]} setenv.sh",
    )
  end

  it do
    should contain_file(params[:conf_dir]).with(
      ensure:   :directory,
      owner: 'tc-server',
      group: 'tc-server',
      require: "Tcserver::Instance[#{title}]",
    )
  end

  describe "copy template file" do

    before(:each) do
      @tplfile = Tempfile.new(['template', '.erb'])
    end

    after(:each) do
      @tplfile.close
      @tplfile.unlink
    end

    let(:filename) { File.basename(@tplfile, '.erb') }
    let(:params) do
      @params[:template_file] = "#{File.absolute_path(@tplfile)}"
      @params
    end

    it "should copy the conf file" do
      should contain_file("#{params[:conf_dir]}/#{filename}")
    end
  end


  describe "copy template files" do

    before(:each) do
      @tplfiles = []
      (1..5).map {@tplfiles << Tempfile.new(['template', '.erb']) }
      @tplfilenames = @tplfiles.map{|f| File.absolute_path(f)}
      @filenames = @tplfiles.map{|f| File.basename(f, '.erb')}
    end

    after(:each) do
      @tplfiles.each do |file|
        file.close
        file.unlink
      end
    end

    let(:params) do
      @params[:template_files] = @tplfilenames
      @params
    end

    it "should copy the conf files" do
      @filenames.each do |fn|
        should contain_file("#{params[:conf_dir]}/#{fn}")
      end
    end
  end

end
