# = Class: nodejs::instances
#
# == Parameters:
#
# [*instances*]
#   The list of nodejs instances to be installed.
#
# [*node_version*]
#   The evaluated node version which is either the only one or the default instance.
#
# [*target_dir*]
#   The target dir where to install the executables.
#
# [*make_install*]
#   Whether or not to compile from source.
#
# [*cpu_cores*]
#   How many CPU cores to use for the compile from source (only used when $make_install = true)
#
# [*instances_to_remove*]
#   The list of instances to remove.
#
class nodejs::instances($instances, $node_version, $target_dir, $make_install, $cpu_cores, $instances_to_remove) {
  if $caller_module_name != $module_name {
    warning('nodejs::instances is private!')
  }

  if count($instances) == 0 {
    nodejs::instance { "nodejs-custom-instance-${node_version}":
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
}