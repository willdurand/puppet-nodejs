# = Define: nodejs::install
#
# == Parameters:
#
# [*ensure*]
#   Whether to install or uninstall an instance.
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
# [*cpu_cores*]
#   Number of CPU cores to use for compiling nodejs. Will be used for parallel 'make' jobs.
#
# == Example:
#
#  class { 'nodejs':
#    version => 'v0.10.17',
#  }
#
#  nodejs::install { 'v0.10.17':
#    version => 'v0.10.17'
#  }
#
define nodejs::instance($ensure, $version, $target_dir, $make_install, $cpu_cores) {
  if $caller_module_name != $module_name {
    warning('nodejs::install is private!')
  }

  validate_integer($cpu_cores)
  validate_string($version)
  validate_string($target_dir)
  validate_bool($make_install)

  include ::nodejs::params

  $node_unpack_folder = "${::nodejs::params::install_dir}/node-${version}"

  if $ensure == present {
    $node_os = $::kernel ? {
      /(?i)(darwin)/ => 'darwin',
      /(?i)(linux)/  => 'linux',
      default        => 'linux',
    }

    $node_arch = $::hardwaremodel ? {
      /.*64.*/ => 'x64',
      default  => 'x86',
    }

    $node_filename = $make_install ? {
      true    => "node-${version}.tar.gz",
      default => "node-${version}-${node_os}-${node_arch}.tar.gz"
    }

    $node_symlink_target = "${node_unpack_folder}/bin/node"
    $node_symlink        = "${target_dir}/node-${version}"
    $npm_instance        = "${node_unpack_folder}/bin/npm"
    $npm_symlink         = "${target_dir}/npm-${version}"

    ensure_resource('file', 'nodejs-install-dir', {
      ensure => 'directory',
      path   => $::nodejs::params::install_dir,
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
    })

    ::nodejs::instance::download { "nodejs-download-${version}":
      source      => "https://nodejs.org/dist/${version}/${node_filename}",
      destination => "${::nodejs::params::install_dir}/${node_filename}",
      require     => File['nodejs-install-dir'],
    }

    file { "nodejs-check-tar-${version}":
      ensure  => 'file',
      path    => "${::nodejs::params::install_dir}/${node_filename}",
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      require => ::Nodejs::Instance::Download["nodejs-download-${version}"],
    }

    file { $node_unpack_folder:
      ensure  => 'directory',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      require => File['nodejs-install-dir'],
    }

    exec { "nodejs-unpack-${version}":
      command => "tar -xzvf ${node_filename} -C ${node_unpack_folder} --strip-components=1",
      path    => '/usr/bin:/bin:/usr/sbin:/sbin',
      cwd     => $::nodejs::params::install_dir,
      user    => 'root',
      unless  => "test -f ${node_symlink_target}",
      require => [
        File["nodejs-check-tar-${version}"],
        File[$node_unpack_folder],
        Package['tar'],
      ],
    }

    if $make_install {
      include ::gcc
      ensure_packages(['make'])

      notify { "Starting to compile NodeJS version ${version}":
        before  => Exec["nodejs-make-install-${version}"],
        require => Exec["nodejs-unpack-${version}"],
      }

      exec { "nodejs-make-install-${version}":
        command => "./configure --prefix=${node_unpack_folder} && make -j ${cpu_cores} && make -j ${cpu_cores} install",
        path    => "${node_unpack_folder}:/usr/bin:/bin:/usr/sbin:/sbin",
        cwd     => $node_unpack_folder,
        user    => 'root',
        unless  => "test -f ${node_symlink_target}",
        timeout => 0,
        require => [
          Exec["nodejs-unpack-${version}"],
          Class['::gcc'],
          Package['make'],
        ],
        before  => File["nodejs-symlink-bin-with-version-${version}"],
      }
    }

    file { "nodejs-symlink-bin-with-version-${version}":
      ensure => 'link',
      path   => $node_symlink,
      target => $node_symlink_target,
    }

    file { "npm-symlink-bin-with-version-${version}":
      ensure  => file,
      mode    => '0755',
      path    => $npm_symlink,
      content => template("${module_name}/npm.sh.erb"),
      require => [File["nodejs-symlink-bin-with-version-${version}"]],
    }
  } else {
    if $::nodejs_installed_version == $version {
      file { "${::nodejs::params::install_dir}/node-default":
        ensure => absent,
      }
    }

    file { $node_unpack_folder:
      ensure  => absent,
      force   => true,
      recurse => true,
    }

    file { "${target_dir}/node-${version}":
      ensure => absent,
    }
  }
}
