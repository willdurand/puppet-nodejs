Puppet::Functions.create_function(:'nodejs::node_instances') do
  dispatch :default_impl do
    repeated_param 'Any', :args
  end

  def default_impl(*args)
    raise(Puppet::ParseError, 'node_instances(): too few arguments') if args.empty?

    install           = args[1]
    normalize         = args[0].map do |n, h|
      if h.is_a?(Hash) && h.key?('source') && !h['source'].empty?
        hash           = {}
        actual_version = h['source']
      else
        actual_version  = call_function('::nodejs::evaluate_version', install ? h['version'] : n)
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
