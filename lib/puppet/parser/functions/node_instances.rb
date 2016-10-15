module Puppet::Parser::Functions
  newfunction(:node_instances, :type => :rvalue) do |args|
    raise(Puppet::ParseError, "node_instances(): too few arguments") if args.size < 1

    normalize = args[0].map do |n, h|
      Puppet::Parser::Functions.function(:evaluate_version)
      actual_version = function_evaluate_version([h["version"]])
      [
        "nodejs-custom-instance-#{actual_version}",
        h.merge({ "version" => actual_version })
      ]
    end

    normalize.to_h
  end
end
