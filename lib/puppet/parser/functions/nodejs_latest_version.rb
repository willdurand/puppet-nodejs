require File.join(File.dirname(__FILE__), 'nodejs_functions.rb')

module Puppet::Parser::Functions
  newfunction(:nodejs_latest_version, :type => :rvalue) do |args|
    return get_latest_version
  end
end
