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
# [*contain_ruby*]
#   Bool flag whether or not to install ruby.
#
# [*instances*]
#   List of instances to install.
#
# [*instances_to_remove*]
#   Instances to be removed.
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
  $version             = $::nodejs::params::version,
  $target_dir          = $::nodejs::params::target_dir,
  $make_install        = $::nodejs::params::make_install,
  $node_path           = $::nodejs::params::node_path,
  $cpu_cores           = $::nodejs::params::cpu_cores,
  $contain_ruby        = $::nodejs::params::contain_ruby,
  $instances           = $::nodejs::params::instances,
  $instances_to_remove = $::nodejs::params::instances_to_remove,
) inherits ::nodejs::params  {
  validate_string($node_path)
  validate_integer($cpu_cores)
  validate_string($version)
  validate_string($target_dir)
  validate_bool($make_install)
  validate_bool($contain_ruby)
  validate_hash($instances)
  validate_array($instances_to_remove)

  $node_version = evaluate_version($version)

  class { '::nodejs::instance::pkgs':
    contain_ruby => $contain_ruby,
    make_install => $make_install,
  }
  if count($instances) == 0 {
    nodejs::instance { "nodejs-${version}":
      ensure               => present,
      version              => $node_version,
      target_dir           => $target_dir,
      make_install         => $make_install,
      cpu_cores            => $cpu_cores,
      default_node_version => undef,
    }
  } else {
    create_resources('::nodejs::instance', node_instances($instances), {
      ensure               => present,
      target_dir           => $target_dir,
      make_install         => $make_install,
      cpu_cores            => $cpu_cores,
      default_node_version => undef,
    })
  }

  if count($instances_to_remove) > 0 {
    create_resources('::nodejs::instance', ensure_uninstall($instances_to_remove), {
      ensure               => absent,
      make_install         => false,
      cpu_cores            => 0,
      target_dir           => $target_dir,
      default_node_version => $node_version,
    })
  }

  $nodejs_version_path = "/usr/local/node/node-${$node_version}"
  $nodejs_default_path = '/usr/local/node/node-default'

  file { $nodejs_default_path:
    ensure  => link,
    target  => $nodejs_version_path,
    require => Nodejs::Instance["nodejs-custom-instance-${$node_version}"],
  }

  # TODO move this into its own class (`::nodejs::symlink` for instance)
  $node_default_symlink        = "${target_dir}/node"
  $node_default_symlink_target = "${nodejs_default_path}/bin/node"
  $npm_default_symlink         = "${target_dir}/npm"
  $npm_default_symlink_target  = "${nodejs_default_path}/bin/npm"

  file { $node_default_symlink:
    ensure  => link,
    target  => $node_default_symlink_target,
    require => File[$nodejs_default_path]
  }

  file { $npm_default_symlink:
    ensure  => link,
    target  => $npm_default_symlink_target,
    require => File[$nodejs_default_path]
  }

  # TODO remove!
  file { '/etc/profile.d/nodejs.sh':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/nodejs.sh.erb"),
    require => File[$nodejs_default_path],
  }
}
