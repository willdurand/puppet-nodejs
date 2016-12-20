Facter.add("available_nodejs_instances") do
  def is_instance(entry)
    return false unless File.directory?(File.join('/usr/local/node', entry))

    !['.', '..', 'node-default'].include?(entry)
  end

  setcode do
    return [] unless Dir.exist?('/usr/local/node')

    Dir.entries('/usr/local/node')
      .select { |entry| is_instance entry }
      .map { |entry| entry[5..-1] }
  end
end
