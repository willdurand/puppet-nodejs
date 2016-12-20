module Puppet::Parser::Functions
  newfunction(:diff_nodejs_instances, :type => :rvalue) do |args|
    raise(Puppet::ParseError, "diff_nodejs_instances(): too few arguments") if args.size < 2

    args[0] - args[1]
  end
end
