module Puppet::Parser::Functions
  newfunction(:ensure_uninstall, :type => :rvalue) do |args|
    raise(Puppet::ParseError, 'ensure_uninstall(): too few arguments!') if args.size < 1

    args[0].map {
      |version| ["nodejs-uninstall-custom-#{version}", { :version => version }]
    }.to_h
  end
end
