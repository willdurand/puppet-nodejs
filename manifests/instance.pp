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
# [*default_node_version*]
#   The default nodejs version. Required to ensure that the default version won't be uninstalled if $ensure = absent.
#
# [*timeout*]
#   Maximum download timeout.
#
# [*source*]
#   Which source to use instead of `nodejs.org/dist`. Optional parameter, `undef` by default.
#
define nodejs::instance(
  Pattern[/^present|absent$/] $ensure,
  String $version,
  String $target_dir,
  Boolean $make_install,
  Integer $cpu_cores,
  Optional[String] $default_node_version,
  Integer $timeout,
  String $install_dir,
  Optional[String] $source = undef,
) {
  if $caller_module_name != $module_name {
    warning('nodejs::instance is private!')
  }

  $node_unpack_folder = "${install_dir}/node-${version}"

  if $ensure == present {
    $node_os = $::kernel ? {
      /(?i)(darwin)/ => 'darwin',
      /(?i)(linux)/  => 'linux',
      default        => 'linux',
    }

    $node_arch = $::hardwaremodel ? {
      /.*64.*/ => 'x64',
      /(armv6l|armv7l)/ => $1,
      default  => 'x86',
    }

    $node_filename = $make_install ? {
      true  => "node-${version}.tar.gz",
      false => "node-${version}-${node_os}-${node_arch}.tar.gz"
    }

    $node_symlink_target = "${node_unpack_folder}/bin/node"
    $node_symlink        = "${target_dir}/node-${version}"
    $npm_instance        = "${node_unpack_folder}/bin/npm"
    $npm_symlink         = "${target_dir}/npm-${version}"

    ensure_resource('file', 'nodejs-install-dir', {
      ensure => 'directory',
      path   => $install_dir,
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
    })

    $download_source = $source ? {
      undef   => "https://nodejs.org/dist/${version}/${node_filename}",
      default => $source,
    }

    ::nodejs::instance::download { "nodejs-download-${version}":
      source      => $download_source,
      destination => "${install_dir}/${node_filename}",
      require     => File['nodejs-install-dir'],
      timeout     => $timeout,
    }

    file { "nodejs-check-tar-${version}":
      ensure  => 'file',
      path    => "${install_dir}/${node_filename}",
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
      path    => $::path,
      cwd     => $install_dir,
      user    => 'root',
      unless  => "test -f ${node_symlink_target}",
      require => [
        File["nodejs-check-tar-${version}"],
        File[$node_unpack_folder],
        Package['tar'],
      ],
    }

    if $make_install {
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
          Class['::nodejs::instance::pkgs'],
        ],
        before  => File["nodejs-symlink-bin-with-version-${version}"],
      }
    }

    $node_prefix = $target_dir
    file { "nodejs-npmrc-etc-dir-${version}":
      ensure => directory,
      path   =>  "${node_unpack_folder}/etc",
    } ->
    file { "nodejs-npmrc-${version}":
      ensure  => present,
      path    => "${node_unpack_folder}/etc/npmrc",
      content => template("${module_name}/npmrc")
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
    if $default_node_version == $version {
      fail('Can\'t remove the instance which is the default instance defined in the ::nodejs class!')
    }

    file { $node_unpack_folder:
      ensure  => absent,
      force   => true,
      recurse => true,
    } ->
    file { "${target_dir}/node-${version}":
      ensure => absent,
    } ->
    file { "${target_dir}/npm-${version}":
      ensure => absent,
    }
  }
}
