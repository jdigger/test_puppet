require 'rake'
require 'rspec/core/rake_task'
require 'puppet-lint/tasks/puppet-lint'

task :default => :spec

desc "Run all module spec tests (Requires rspec-puppet gem)"
task :spec do
  system("rspec --tty -c -f d modules/*/spec/*/*_spec.rb 2>&1 | grep -v shellquote | grep -v \"puppet/provider\" | grep -v \"iconv will be deprecated\"")
end

desc "Run all module spec tests (Requires rspec-puppet gem)"
task :graph do
  system("/opt/local/bin/dot /var/lib/puppet/state/graphs/expanded_relationships.dot -Tpng -o expanded_relationships.png ")
  system("/opt/local/bin/dot /var/lib/puppet/state/graphs/relationships.dot -Tpng -o relationships.png ")
  system("/opt/local/bin/dot /var/lib/puppet/state/graphs/resources.dot -Tpng -o resources.png ")
end

PuppetLint.configuration.send("disable_80chars")

# desc "Build package"
# task :build do
#   system("puppet-module build")
# end
