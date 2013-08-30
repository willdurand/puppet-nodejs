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

  ensure_packages([ 'wget', 'tar', 'curl' ])

  if $make_install {
    $node_filename       = "node-${node_version}.tar.gz"
    $node_unpack_folder = "${::nodejs::params::install_dir}/node-${node_version}"
    $node_fqv            = $node_version
    $node_symlink_target = "${node_unpack_folder}/node"
    $message             = "Installing Node.js ${node_version}"
  } else {
    $node_filename       = "node-${node_version}-${node_os}-${node_arch}.tar.gz"
    $node_unpack_folder = "${::nodejs::params::install_dir}/node-${node_version}-${node_os}-${node_arch}"
    $node_fqv            = "${node_version}-${node_os}-${node_arch}"
    $node_symlink_target = "${node_unpack_folder}/bin/node"
    $message             = "Installing Node.js ${node_version} built for ${node_os} ${node_arch}"
  }

  $node_symlink = "${node_target_dir}/node"

  notify { "nodejs-start-message-${node_version}":
    message => $message,
  }

  ensure_resource('file', "nodejs-install-dir-${node_version}", {
    ensure => 'directory',
    path   => $::nodejs::params::install_dir,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  })

  exec { "nodejs-download-${node_version}":
    command => "wget http://nodejs.org/dist/${node_version}/${node_filename}",
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    cwd     => $::nodejs::params::install_dir,
    user    => 'root',
    unless  => "test -f ${node_filename}",
    require => File["nodejs-install-dir-${node_version}"],
  }

  file { "nodejs-check-tar-${node_version}":
    ensure  => 'file',
    path    => "${::nodejs::params::install_dir}/${node_filename}",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Exec["nodejs-download-${node_version}"],
  }

  exec { "nodejs-unpack-${node_version}":
    command => "tar xzvf ${node_filename}",
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    cwd     => $::nodejs::params::install_dir,
    user    => 'root',
    unless  => "test -d ${node_unpack_folder}",
    require => File["nodejs-check-tar-${node_version}"],
  }

  file { "nodejs-check-unpack-${node_version}":
    ensure  => 'directory',
    path    => $node_unpack_folder,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Exec["nodejs-unpack-${node_version}"],
  }

  if $make_install {
    ensure_packages([ 'python', 'g++', 'make' ])

    exec { "nodejs-make-install-${node_version}":
      command => 'python configure && make install',
      path    => '/usr/bin:/bin:/usr/sbin:/sbin',
      cwd     => $node_unpack_folder,
      user    => 'root',
      unless  => "test -f ${node_symlink_target}",
      timeout => 0,
      require => File["nodejs-check-unpack-${node_version}"],
      before  => Exec["nodejs-symlink-bin-${node_version}"],
    }
  }

  exec { "nodejs-symlink-bin-${node_version}":
    command => "ln -f -s ${node_symlink_target} ${node_symlink}",
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    user    => 'root',
    require => File["nodejs-check-unpack-${node_version}"],
  }

  file { "nodejs-check-symlink-${node_version}":
    ensure  => 'link',
    path    => $node_symlink,
    target  => $node_symlink_target,
    require => Exec["nodejs-symlink-bin-${node_version}"],
  }

  exec { "nodejs-symlink-bin-with-version-${node_version}":
    command => "ln -f -s ${node_symlink_target} ${node_symlink}-${node_version}",
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    user    => 'root',
    require => File["nodejs-check-unpack-${node_version}"],
  }

  if ($with_npm) {
    exec { "npm-download-${node_version}":
      command => 'wget --no-check-certificate https://npmjs.org/install.sh',
      path    => '/usr/bin:/bin:/usr/sbin:/sbin',
      cwd     => $::nodejs::params::install_dir,
      user    => 'root',
      unless  => "test -f ${::nodejs::params::install_dir}/install.sh",
      require => File["nodejs-check-symlink-${node_version}"],
    }

    exec { "npm-install-${node_version}":
      command     => 'sh install.sh',
      path        => '/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin',
      cwd         => $::nodejs::params::install_dir,
      user        => 'root',
      environment => 'clean=yes',
      unless      => 'which npm',
      require     => Exec["npm-download-${node_version}"],
    }

    file { "npm-symlink-${node_version}":
      ensure  => 'link',
      path    => "${node_target_dir}/npm",
      require => Exec["npm-install-${node_version}"],
    }
  }
}
