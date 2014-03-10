# = Define: nodejs::install
#
# == Parameters:
#
# [*version*]
#   The NodeJS version ('vX.Y.Z', 'latest' or 'stable').
#
# [*target_dir*]
#   Where to install the executables.
#
# [*with_npm*]
#   Whether to install NPM.
#
# [*make_install*]
#   If false, will install from nodejs.org binary distributions.
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
  $version      = undef,
  $target_dir   = undef,
  $with_npm     = true,
  $make_install = true,
) {

  include nodejs::params

  $node_version = $version ? {
    undef     => $::nodejs_stable_version,
    'stable'  => $::nodejs_stable_version,
    'latest'  => $::nodejs_latest_version,
    default   => $version
  }

  $node_target_dir = $target_dir ? {
    undef   => $::nodejs::params::target_dir,
    default => $target_dir
  }

  $node_os = $::kernel ? {
    /(?i)(darwin)/  => 'darwin',
    /(?i)(linux)/   => 'linux',
    default         => 'linux',
  }

  $node_arch = $::hardwaremodel ? {
    /.*64.*/ => 'x64',
    default  => 'x86',
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

  if !defined(Package['semver']){
    package { 'semver':
      ensure   => installed,
      provider => gem,
      before   => File["nodejs-symlink-bin-with-version-${node_version}"],
    }
  }

  $node_unpack_folder = "${::nodejs::params::install_dir}/node-${node_version}"

  if (!$make_install and !is_binary_download_available($node_version)) {
    fail("No binary download available for nodejs ${node_version}! Please run with make_install => true")
  }

  if $make_install {
    $node_filename       = "node-${node_version}.tar.gz"
    $node_fqv            = $node_version # TODO remove not used
    $message             = "Installing Node.js ${node_version}"
  } else {
    $node_filename       = "node-${node_version}-${node_os}-${node_arch}.tar.gz"
    $node_fqv            = "${node_version}-${node_os}-${node_arch}" # TODO remove not used
    $message             = "Installing Node.js ${node_version} built for ${node_os} ${node_arch}"
  }

  $node_symlink_target = "${node_unpack_folder}/bin/node"
  $node_symlink = "${node_target_dir}/node-${node_version}"

  ensure_resource('file', 'nodejs-install-dir', {
    ensure => 'directory',
    path   => $::nodejs::params::install_dir,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  })

  wget::fetch { "nodejs-download-${node_version}":
    source      => "http://nodejs.org/dist/${node_version}/${node_filename}",
    destination => "${::nodejs::params::install_dir}/${node_filename}",
    require     => File['nodejs-install-dir'],
  }

  file { "nodejs-check-tar-${node_version}":
    ensure  => 'file',
    path    => "${::nodejs::params::install_dir}/${node_filename}",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Wget::Fetch["nodejs-download-${node_version}"],
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
    'RedHat'   => 'gcc-c++',
    default    => 'g++',
  }

  if $make_install {
    ensure_packages([ 'python', $gplusplus_package, 'make' ])

    exec { "nodejs-make-install-${node_version}":
      command => "./configure --prefix=${node_unpack_folder} && make && make install",
      path    => "${node_unpack_folder}:/usr/bin:/bin:/usr/sbin:/sbin",
      cwd     => $node_unpack_folder,
      user    => 'root',
      unless  => "test -f ${node_symlink_target}",
      timeout => 0,
      require => [
        Exec["nodejs-unpack-${node_version}"],
        Package['python'],
        Package[$gplusplus_package],
        Package['make']
      ],
      before  => File["nodejs-symlink-bin-with-version-${node_version}"],
    }
  }

  file { "nodejs-symlink-bin-with-version-${node_version}":
    ensure  => 'link',
    path    => $node_symlink,
    target  => $node_symlink_target,
  }

  # automatic installation of npm is introduced since nodejs v0.6.3
  # so we just install npm for nodejs below v0.6.3
  if ($with_npm and !is_npm_provided($node_version)) {

    wget::fetch { "npm-download-${node_version}":
      source             => 'https://npmjs.org/install.sh',
      nocheckcertificate => true,
      destination        => "${node_unpack_folder}/install-npm.sh",
      require            => File["nodejs-symlink-bin-with-version-${node_version}"]
    }

    exec { "npm-install-${node_version}":
      command     => 'sh install-npm.sh',
      path        => ["${node_unpack_folder}/bin", '/bin', '/usr/bin'],
      cwd         => $node_unpack_folder,
      user        => 'root',
      environment => ['clean=yes', "npm_config_prefix=${node_unpack_folder}"],
      unless      => "test -f ${node_unpack_folder}/bin/npm",
      require     => [
        Wget::Fetch["npm-download-${node_version}"],
        Package['curl'],
      ],
    }
  }
}
