Puppet::Functions.create_function(:'nodejs::validate_nodejs_version') do
  dispatch :default_impl do
    repeated_param 'Any', :args
  end

  def default_impl(*args)
    if args[0].start_with?('v0')
      raise Puppet::ParseError, 'All NodeJS versions below `v0.12.0` are not supported!'
    end
  end
end
