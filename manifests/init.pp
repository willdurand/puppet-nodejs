# = Class: nodejs
#
# == Parameters:
#
# [*version*]
#   The NodeJS version ('vX.Y.Z', 'latest' or 'stable').
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
# == Example:
#
#  include nodejs
#
#  class { 'nodejs':
#    version  => 'v0.10.17'
#  }
#
class nodejs(
  $version      = 'lts',
  $target_dir   = '/usr/local/bin',
  $make_install = true,
  $node_path    = '/usr/local/node/node-default/lib/node_modules',
  $cpu_cores    = $::processorcount,
) {
  validate_string($node_path)
  validate_integer($cpu_cores)

  $node_version = evaluate_version($version)

  class { '::nodejs::instance::pkgs': } ->
  nodejs::instance { "nodejs-${version}":
    ensure       => present,
    version      => $node_version,
    target_dir   => $target_dir,
    make_install => $make_install,
    cpu_cores    => $cpu_cores,
  }

  $nodejs_version_path = "/usr/local/node/node-${$node_version}"
  $nodejs_default_path = '/usr/local/node/node-default'

  file { $nodejs_default_path:
    ensure  => link,
    target  => $nodejs_version_path,
    require => Nodejs::Instance["nodejs-${version}"],
  }

  $node_default_symlink = "${target_dir}/node"
  $node_default_symlink_target = "${nodejs_default_path}/bin/node"
  $npm_default_symlink = "${target_dir}/npm"
  $npm_default_symlink_target = "${nodejs_default_path}/bin/npm"

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

  file { '/etc/profile.d/nodejs.sh':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/nodejs.sh.erb"),
    require => File[$nodejs_default_path],
  }
}
