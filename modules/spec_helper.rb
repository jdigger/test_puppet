require 'rspec-puppet'
require 'tmpdir'

RSpec.configure do |c|
  c.before :all do
    # Create a temporary puppet confdir area and temporary site.pp so
    # when rspec-puppet runs we don't get a puppet error.
    @puppetdir = Dir.mktmpdir("rspec-puppet")
    manifestdir = File.join(@puppetdir, "manifests")
    Dir.mkdir(manifestdir)
    FileUtils.touch(File.join(manifestdir, "site.pp"))
    Puppet[:confdir] = @puppetdir
  end

  c.after :all do
    FileUtils.remove_entry_secure(@puppetdir)
  end

  c.module_path = File.dirname(__FILE__)
end
