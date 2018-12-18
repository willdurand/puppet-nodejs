module Puppet::Parser::Functions
  newfunction(:source_filename, :type => :rvalue) do |args|
    raise(Puppet::ParseError, 'source_filename(): too few arguments') if args.empty?

    args[0].rpartition('/').last
  end
end
