require File.join(File.dirname(__FILE__), 'nodejs_functions.rb')

module Puppet::Parser::Functions
  newfunction(:nodejs_stable_version, :type => :rvalue) do |args|
    value = get_cached_value('stable_version')
    if !value
      value = get_stable_version
      set_cached_value('stable_version', value)
    end
    value
  end
end
