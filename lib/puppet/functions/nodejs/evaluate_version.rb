require_relative 'util/nodejs_functions'

Puppet::Functions.create_function(:'nodejs::evaluate_version') do
  # XXX we may want to do some better typing here.
  dispatch :default_impl do
    repeated_param 'Any', :args
  end

  def default_impl(*args)
    raise(Puppet::ParseError, 'evaluate_version(): too few arguments') if args.empty?

    version = args[0].dup
    return get_latest_version if version == 'latest'
    return get_lts_version if version == 'lts'

    if version =~ /^(?:(v)?)[0-9]+\.[0-9]+\.[0-9]+/
      # if the version is matched, but contains no `v` as prefix, it will
      # be added automatically
      return 'v' + version if version =~ /^[^v](.*)/

      # no v prefix needed
      return version
    end

    return get_version_from_branch version if version =~ /^(?:(v)?)[0-9]+\.([0-9]+|x)$/

    raise Puppet::ParseError, 'evaluate_version(): version must be `lts`, `latest` or look like `x.x.x`'
  end
end
