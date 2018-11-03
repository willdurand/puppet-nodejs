# = Class: nodejs
#
# == Parameters:
#
# [*version*]
#   The NodeJS version ('vX.Y.Z', 'latest', 'lts' or 'v6.x' (latest release from the NodeJS 6 branch)).
#
# [*target_dir*]
#   Where to install the executables.
#
# [*make_install*]
#   If false, will install from nodejs.org binary distributions.
#
# [*node_path*]
#   Value of the system environment variable (default: "/usr/local/node/node-default/lib/node_modules").
#
# [*cpu_cores*]
#   Number of CPU cores to use for compiling nodejs. Will be used for parallel 'make' jobs.
#
# [*instances*]
#   List of instances to install.
#
# [*instances_to_remove*]
#   Instances to be removed.
#
# [*download_timeout*]
#   Maximum download timeout.
#
# [*build_deps*]
#   Optional parameter whether or not to allow the module to installs its dependant packages.
#
# == Example:
#
#  include nodejs
#
#  class { 'nodejs':
#    version  => 'v0.10.17'
#  }
#
class nodejs(
  String $version                    = $::nodejs::params::version,
  String $target_dir                 = $::nodejs::params::target_dir,
  Boolean $make_install              = $::nodejs::params::make_install,
  String $node_path                  = $::nodejs::params::node_path,
  Integer $cpu_cores                 = $::nodejs::params::cpu_cores,
  Hash[String, Hash] $instances      = $::nodejs::params::instances,
  Array[String] $instances_to_remove = $::nodejs::params::instances_to_remove,
  Integer $download_timeout          = $::nodejs::params::download_timeout,
  Boolean $build_deps                = $::nodejs::params::build_deps,
) inherits ::nodejs::params  {
  $node_version        = evaluate_version($version)
  $nodejs_default_path = '/usr/local/node/node-default'

  if $build_deps {
    Anchor['nodejs::start'] ->
    class { '::nodejs::instance::pkgs':
      make_install => $make_install,
    } ->
    Class['::nodejs::instances']
  }
  anchor { 'nodejs::start': } ->
    class { '::nodejs::instances':
      instances           => $instances,
      node_version        => $node_version,
      target_dir          => $target_dir,
      make_install        => $make_install,
      cpu_cores           => $cpu_cores,
      instances_to_remove => $instances_to_remove,
      nodejs_default_path => $nodejs_default_path,
      download_timeout    => $download_timeout,
    } ->
    # TODO remove!
    file { '/etc/profile.d/nodejs.sh':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template("${module_name}/nodejs.sh.erb"),
      require => File[$nodejs_default_path],
    } ->
  anchor { 'nodejs::end': }
}
