module Puppet::Parser::Functions
  newfunction(:ensure_uninstall, :type => :rvalue) do |args|
    raise(Puppet::ParseError, 'ensure_uninstall(): too few arguments!') if args.size < 1

    instances  = args[0]
    normalized = instances.map do |version|
      Puppet::Parser::Functions.function(:evaluate_version)
      actual_version = function_evaluate_version([version])
      [
        "nodejs-uninstall-custom-#{actual_version}",
        { :version => function_evaluate_version([version]) }
      ]
    end

    normalized.to_h
  end
end
