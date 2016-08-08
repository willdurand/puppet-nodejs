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
# [*python_package*]
#   Python package name, defaults to python
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
define nodejs::install (
  $ensure         = present,
  $version        = undef,
  $target_dir     = undef,
  $make_install   = true,
  $python_package = 'python',
  $cpu_cores      = $::processorcount,
) {
  validate_integer($cpu_cores)

  include nodejs::params

  # TODO remove this. In #159 it's planned to make this private
  # and control the whole process in the `nodejs` class to simplify the logic here.
  $version_string = $version ? {
    undef   => 'latest', # install `latest` by default
    default => $version,
  }

  $node_version = evaluate_version($version_string)
  validate_nodejs_version($node_version)

  $node_target_dir = $target_dir ? {
    undef   => $::nodejs::params::target_dir,
    default => $target_dir
  }

  if !defined(Package['curl']) {
    package {'curl':
      ensure => installed
    }
  }

  if !defined(Package['tar']) {
    package {'tar':
      ensure => installed
    }
  }
  if !defined(Package['git']) {
    package {'git':
      ensure => installed
    }
  }

  if !defined(Package['ruby']){
    package { 'ruby':
      ensure => installed,
      before => Package['semver'],
    }
  }

  $node_unpack_folder = "${::nodejs::params::install_dir}/node-${node_version}"

  if !defined(Package['semver']){
    package { 'semver':
      ensure   => installed,
      provider => gem,
      before   => File[$node_unpack_folder],
    }
  }

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

    if $make_install {
      $node_filename = "node-${node_version}.tar.gz"
      $node_fqv      = $node_version # TODO remove not used
      $message       = "Installing Node.js ${node_version}"
    } else {
      $node_filename = "node-${node_version}-${node_os}-${node_arch}.tar.gz"
      $node_fqv      = "${node_version}-${node_os}-${node_arch}" # TODO remove not used
      $message       = "Installing Node.js ${node_version} built for ${node_os} ${node_arch}"
    }

    $node_symlink_target = "${node_unpack_folder}/bin/node"
    $node_symlink        = "${node_target_dir}/node-${node_version}"
    $npm_instance        = "${node_unpack_folder}/bin/npm"
    $npm_symlink         = "${node_target_dir}/npm-${node_version}"

    ensure_resource('file', 'nodejs-install-dir', {
      ensure => 'directory',
      path   => $::nodejs::params::install_dir,
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
    })

    ::nodejs::install::download { "nodejs-download-${node_version}":
      source      => "https://nodejs.org/dist/${node_version}/${node_filename}",
      destination => "${::nodejs::params::install_dir}/${node_filename}",
      require     => File['nodejs-install-dir'],
    }

    file { "nodejs-check-tar-${node_version}":
      ensure  => 'file',
      path    => "${::nodejs::params::install_dir}/${node_filename}",
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      require => ::Nodejs::Install::Download["nodejs-download-${node_version}"],
    }

    file { $node_unpack_folder:
      ensure  => 'directory',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      require => File['nodejs-install-dir'],
    }

    exec { "nodejs-unpack-${node_version}":
      command => "tar -xzvf ${node_filename} -C ${node_unpack_folder} --strip-components=1",
      path    => '/usr/bin:/bin:/usr/sbin:/sbin',
      cwd     => $::nodejs::params::install_dir,
      user    => 'root',
      unless  => "test -f ${node_symlink_target}",
      require => [
        File["nodejs-check-tar-${node_version}"],
        File[$node_unpack_folder],
        Package['tar'],
      ],
    }

    $gplusplus_package = $::osfamily ? {
      'RedHat' => 'gcc-c++',
      'Suse'   => 'gcc-c++',
      default  => 'g++',
    }

    if $make_install {

      if $::osfamily == 'Suse'{
        package { 'patterns-openSUSE-minimal_base-conflicts-12.3-7.10.1.x86_64':
          ensure => 'absent'
        }
      }

      ensure_packages([ $python_package, $gplusplus_package, 'make' ])

      exec { "nodejs-make-install-${node_version}":
        command => "./configure --prefix=${node_unpack_folder} && make -j ${cpu_cores} && make -j ${cpu_cores} install",
        path    => "${node_unpack_folder}:/usr/bin:/bin:/usr/sbin:/sbin",
        cwd     => $node_unpack_folder,
        user    => 'root',
        unless  => "test -f ${node_symlink_target}",
        timeout => 0,
        require => [
          Exec["nodejs-unpack-${node_version}"],
          Package[$python_package],
          Package[$gplusplus_package],
          Package['make']
        ],
        before  => File["nodejs-symlink-bin-with-version-${node_version}"],
      }
    }

    file { "nodejs-symlink-bin-with-version-${node_version}":
      ensure => 'link',
      path   => $node_symlink,
      target => $node_symlink_target,
    }

    file { "npm-symlink-bin-with-version-${node_version}":
      ensure  => file,
      mode    => '0755',
      path    => $npm_symlink,
      content => template("${module_name}/npm.sh.erb"),
      require => [File["nodejs-symlink-bin-with-version-${node_version}"]],
    }
  }
  else {
    if $::nodejs_installed_version == $node_version {
      file { "${::nodejs::params::install_dir}/node-default":
        ensure => absent,
      }
    }

    file { $node_unpack_folder:
      ensure  => absent,
      force   => true,
      recurse => true,
    }

    file { "${node_target_dir}/node-${node_version}":
      ensure => absent,
    }
  }
}
