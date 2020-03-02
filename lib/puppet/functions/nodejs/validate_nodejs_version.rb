Puppet::Functions.create_function(:'nodejs::validate_nodejs_version') do
  dispatch :default_impl do
    repeated_param 'Any', :args
  end

  def default_impl(*args)
    raise Puppet::ParseError, 'All NodeJS 0.x-versions are not supported!' if args[0] =~ /^v?0/
  end
end
