require 'puppet/provider/package'

# Extracted from: https://github.com/puppetlabs/puppetlabs-nodejs
# Improved to ensure 'npm' is installed before to install packages.
Puppet::Type.type(:package).provide :npm, :parent => Puppet::Provider::Package do
  desc 'npm is a package management for node.js. This provider only handles global packages.'

  # https://puppet.com/docs/puppet/5.3/types/package.html#package-attributes
  has_feature :versionable, :install_options, :uninstall_options

  has_command(:npm, 'npm') do
    is_optional
    environment :HOME => '/root'
  end

  def self.npmlist
    begin
      output = execute([command(:npm), 'list', '--json', '--global'], :combine => false)
      # ignore any npm output lines to be a bit more robust
      # set max_nesting to 100 so parsing will not fail if we have module with big dependencies tree
      output = PSON.parse(output.lines.select { |l| l =~ /^((?!^npm).*)$/ }.join("\n"), :max_nesting => 100)
      @npmlist = output['dependencies'] || {}
    rescue Exception => e
      Puppet.debug("Error: npm list --json command error #{e.message}")
      @npmlist = {}
    end
  end

  def npmlist
    self.class.npmlist
  end

  def self.instances
    @npmlist ||= npmlist
    @npmlist.collect do |k, v|
      new(:name => k, :ensure => v['version'], :provider => 'npm')
    end
  end

  def query
    list = npmlist

    if list.key?(resource[:name]) && list[resource[:name]].key?('version')
      version = list[resource[:name]]['version']
      { :ensure => version, :name => resource[:name] }
    else
      { :ensure => :absent, :name => resource[:name] }
    end
  end

  def latest(version)
    if /#{resource[:name]}@([\d\.]+)/ =~ npm('outdated', '--global', resource[:name])
      @latest = version
    else
      @property_hash[:ensure] unless @property_hash[:ensure].is_a? Symbol
    end
  end

  def update
    resource[:ensure] = @latest
    install
  end

  def install
    if resource[:ensure].is_a? Symbol
      package = resource[:name]
    else
      package = "#{resource[:name]}@#{resource[:ensure]}"
    end

    options = ['--global']
    options += join_options(resource[:install_options]) if resource[:install_options]

    if resource[:source]
      npm('install', *options, resource[:source])
    else
      npm('install', *options, package)
    end
  end

  def uninstall
    options = ['--global']
    options += join_options(resource[:uninstall_options]) if resources[:uninstall_options]
    npm('uninstall', *options, resource[:name])
  end
end
