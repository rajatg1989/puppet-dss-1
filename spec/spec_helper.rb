require 'rspec-puppet-utils'
require 'puppetlabs_spec_helper/module_spec_helper'


# This code is being added as a recommended workaround
# because of a known issue discussed here:
# https://github.com/puppetlabs/puppet/pull/3114
if Puppet.version < "4.0.0"
  fixture_path = File.join(File.dirname(__FILE__), 'fixtures')
  Dir["#{fixture_path}/modules/*/lib"].entries.each do |lib_dir|
    $LOAD_PATH << lib_dir
  end
end
