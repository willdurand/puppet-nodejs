require 'net/http'
require 'yaml'
require 'fileutils'
require_relative 'nodejs_functions'


Facter.add("nodejs_stable_version") do
  setcode do
    value = get_cached_value('stable_version')
    if !value
      value = get_stable_version
      set_cached_value('stable_version', value)
    end    
    value
  end
end
