require 'semver'

module Puppet::Parser::Functions
  newfunction(:validate_nodejs_version) do |args|
    version = SemVer.new(args[0])
    if version < SemVer.new('v0.10.0')
      raise Puppet::ParseError, ('All NodeJS versions below `v0.10.0` are not supported!')
    end
    if version < SemVer.new('v0.12.0')
      Puppet.warning('All NodeJS versions below `v0.12.0` do work, but are not recommended to use!')
    end
  end
end
