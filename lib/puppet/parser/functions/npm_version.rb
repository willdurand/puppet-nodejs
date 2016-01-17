module Puppet::Parser::Functions
  newfunction(:npm_version, :type => :rvalue) do |args|
    node_unpack_folder = args.shift
    version            = `#{node_unpack_folder}/bin/npm -v`

    # the version will be extracted from the CLI.
    # the output contains a line break, but this line break causes weird
    # symlink names, so the version needs to be stripped.
    version.strip
  end
end
