Puppet::Functions.create_function(:'nodejs::source_filename') do
  dispatch :default_impl do
    repeated_param 'Any', :args
  end

  def default_impl(*args)
    raise(Puppet::ParseError, 'source_filename(): too few arguments') if args.empty?

    args[0].rpartition('/').last
  end
end
