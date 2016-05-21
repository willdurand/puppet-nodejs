require File.join(File.dirname(__FILE__), 'nodejs_functions.rb')

module Puppet::Parser::Functions
  newfunction(:nodejs_latest_version, :type => :rvalue) do |args|
    value = get_cached_value('latest_version')
    if !value
      value = get_latest_version
      set_cached_value('latest_version', value)
    end
    value
  end
end
