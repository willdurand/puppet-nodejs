require File.join(File.dirname(__FILE__), 'nodejs_functions.rb')

module Puppet::Parser::Functions
  newfunction(:nodejs_stable_version, :type => :rvalue) do |args|
    return get_stable_version
  end
end
