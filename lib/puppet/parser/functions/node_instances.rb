module Puppet::Parser::Functions
  newfunction(:node_instances, :type => :rvalue) do |args|
    raise(Puppet::ParseError, 'node_instances(): too few arguments') if args.empty?

    Puppet::Parser::Functions.function(:evaluate_version)

    install           = args[1]
    normalize         = args[0].map do |n, h|
      if h.is_a?(Hash) && h.key?('source') && !h['source'].empty?
        hash           = {}
        actual_version = h['source']
      else
        evaluation_args = [install ? h['version'] : n]
        actual_version  = function_evaluate_version(evaluation_args)
        hash            = { 'version' => actual_version }
      end

      [
        install ? "nodejs-custom-instance-#{actual_version}" : "nodejs-uninstall-custom-#{actual_version}",
        install ? h.merge(hash) : hash
      ]
    end

    normalize.to_h
  end
end
