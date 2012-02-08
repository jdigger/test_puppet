Setup
=====

This is a valid Puppet configuration, so you could install it in `/etc/puppet` and do "normal Puppet."

To run the tests and other development, you'll want to set up the Ruby environment.

    $ gem install bundler --no-ri --no-rdoc
    $ bundle install --path vendor/gems
    $ bundle exec rake

Bootstrapping CentOS 5.5
=====

To bootstrap a CentOS 5.5 x86_64 box, run the following script:

    $ rpm -Uvh http://download.fedora.redhat.com/pub/epel/5/$(uname -i)/epel-release-5-4.noarch.rpm
    $ rpm -Uvh http://yum.puppetlabs.com/el/5/products/x86_64/puppetlabs-release-5-1.noarch.rpm
    $ yum install -y puppet-2.7.10 git
    $ rm -rf /etc/puppet
    $ git clone https://github.com/jdigger/test_puppet.git /etc/puppet
    $ cd /etc/puppet
    $ git submodule init
    $ git submodule update
    $ mv /usr/lib/ruby/site_ruby/1.8/puppet/util/instrumentation/listeners/process_name.rb\
         /usr/lib/ruby/site_ruby/1.8/puppet/util/instrumentation/listeners/process_name.rb.bck
    $ puppet apply --debug --verbose manifests/site.pp

What that does is:

1. Configure updated Yum (package) repositories
2. Install Puppet at Git
3. Install the project's manifests as the Puppet configuration
4. Populate the project's submodules
5. Fix a bug in Ruby 1.8.5 on CentOS 5.5
6. Apply the manifest


Discoveries
=====

* Test Driven Development is a Good Thing(tm).
  * Be sure to use RSpec to validate that modules are being configured as expected.
  * Use the ["smoke testing" technique](http://docs.puppetlabs.com/guides/tests_smoke.html) on each small piece to make sure it's wiring as expected.
  * Periodically validate your configuration against a snapshot of a VM that reflects what the manifests will be applied against.
    * There's a big difference between simple smoke testing and "actual" configuration.
* As much as possible, use the native package-management of the platform for installing software.
  * [Tar2Rpm](https://github.com/jdigger/tar2rpm) provides an easy way to convert a Gzippped-TAR to RPM format.
  * Artifactory Online has [built-in YUM support](http://wiki.jfrog.org/confluence/display/RTF/YUM+Repositories).
    * It has a 100MB limit on binaries.
* Do everything possible to "fail fast."
  * Validate the value of parameters
  * Use the graphing feature (--graph for the "apply" command, or in puppet.conf) to identify orphans and verify that everything would proceed in the expected order.
* Use custom "facts" to identify interesting "features" about a machine.
  * If a security vulnerability is discovered, for example, create a "fact" that identifies it so either reporting or a module can be written that fixes any affected machines.
* Any files that are "owned" by Puppet (i.e., Puppet will overwrite them if they change) should have a header in the file explicitly stating that.
* Follow the practices in [Best Practices](http://docs.puppetlabs.com/guides/best_practices.html) and the [Style Guidelines](http://docs.puppetlabs.com/guides/style_guide.html).
  * [Puppet-Lint](https://github.com/rodjek/puppet-lint) helps identify deviations from the standard.
* Use context to your advantage: Resources and variables are scoped, so use the most fine-grained scope possible.
  * Do not use "top-level" or "global" variables except for "facts."  Configuration should be handled by way of passing parameters or params.pp files.
