Setup
=====

This is a valid Puppet configuration, so you could install it in `/etc/puppet` and do "normal Puppet."

To run the tests and other development, you'll want to set up the Ruby environment.

    $ gem install bundler --no-ri --no-rdoc
    $ bundle install --path vendor/gems
    $ bundle exec rake
