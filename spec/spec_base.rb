require 'rubygems'
require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec'


RSpec.configure do |config|
  config.after(:suite) do
    RSpec::Puppet::Coverage.report!
  end
end

$:.unshift File.join(File.dirname(__FILE__),  'fixtures', 'modules', 'stdlib', 'lib')
