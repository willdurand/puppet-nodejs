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
    undef     => $::nodejs_version_stable,
    'stable'  => $::nodejs_version_stable,
    'latest'  => $::nodejs_version_latest,
    default   => $version
  }

  $node_target_dir = $target_dir ? {
    undef   => $::nodejs::params::target_dir,
    default => $target_dir
  }

  ensure_packages([ 'python', 'g++', 'make', 'wget', 'tar', 'curl' ])

  $node_os = $::kernel ? {
    /(?i)(darwin)/  => 'darwin',
    /(?i)(linux)/   => 'linux',
    default         => 'linux',
  }

  $node_arch = $::hardwaremodel ? {
    /.*64.*/ => 'x64',
    default  => 'x86',
  }

  if $make_install {
    $node_filename        = "node-${node_version}.tar.gz"
    $node_extract_folder  = "${::nodejs::params::install_dir}/node-${node_version}"
    $node_fqv             = "${node_version}"
    $node_symlink_target  = "${node_extract_folder}/node"
    $message              = "Installing Node.js ${node_version}"
  } else {
    $node_filename        = "node-${node_version}-${node_os}-${node_arch}.tar.gz"
    $node_extract_folder  = "${::nodejs::params::install_dir}/node-${node_version}-${node_os}-${node_arch}"
    $node_fqv             = "${node_version}-${node_os}-${node_arch}"
    $node_symlink_target  = "${node_extract_folder}/bin/node"
    $message              = "Installing Node.js ${node_version} built for ${node_os} ${node_arch}"
  }

  $node_symlink = "${node_target_dir}/node"

  notify { "nodejs-start-message-${version}":
    message => $message,
  }
  -> file { "nodejs-install-dir-${version}":
    ensure => directory,
    path   => $::nodejs::params::install_dir,
    owner  => root,
    group  => root,
    mode   => '0644',
  }
  -> exec { "nodejs-download-${version}":
    command   => "wget http://nodejs.org/dist/${node_version}/${node_filename}",
    path      => '/usr/bin:/bin:/usr/sbin:/sbin',
    cwd       => $::nodejs::params::install_dir,
    user      => 'root',
    unless    => "test -f ${node_filename}",
  }
  -> file { "nodejs-check-tar-${version}":
    ensure  => file,
    path    => "${::nodejs::params::install_dir}/${node_filename}",
    owner   => root,
    group   => root,
    mode    => '0644',
  }
  -> exec { "nodejs-unpack-${version}":
    command => "tar xzvf ${node_filename}",
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    cwd     => $::nodejs::params::install_dir,
    user    => 'root',
    unless  => "test -d ${node_extract_folder}",
  }
  -> file { "nodejs-check-extract-${version}":
    ensure  => directory,
    path    => "${node_extract_folder}",
    owner   => root,
    group   => root,
    mode    => '0755',
  }

  if $make_install {

    exec { "nodejs-make-install-${version}":
      command => 'python configure && make install',
      path    => '/usr/bin:/bin:/usr/sbin:/sbin',
      cwd     => "${node_extract_folder}",
      user    => 'root',
      unless  => "test -f ${node_symlink_target}",
      timeout => 0,
      require => File["nodejs-check-extract-${version}"],
      before  => Exec["nodejs-symlink-bin-${version}"],
    }

  }

  exec { "nodejs-symlink-bin-${version}":
    command => "ln -f -s ${node_symlink_target} ${node_symlink}",
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    user    => 'root',
    require => File["nodejs-check-extract-${version}"],
  }
  -> file { "nodejs-check-symlink-${version}":
    ensure  => link,
    path    => "${node_symlink}",
    target  => "${node_symlink_target}",
  }

  if ($with_npm) {

    exec { "npm-download-${version}":
      command => 'wget --no-check-certificate https://npmjs.org/install.sh',
      path    => '/usr/bin:/bin:/usr/sbin:/sbin',
      cwd     => $::nodejs::params::install_dir,
      user    => 'root',
      unless  => "test -f ${::nodejs::params::install_dir}/install.sh",
      require => File["nodejs-check-symlink-${version}"],
    }
    -> exec { "npm-install-${version}":
      command     => 'sh install.sh',
      path        => '/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin',
      cwd         => $::nodejs::params::install_dir,
      user        => 'root',
      environment => 'clean=yes',
      unless      => 'which npm',
    }
    -> file { "npm-symlink-${version}":
      ensure  => link,
      path    => "${node_target_dir}/npm",
    }

  }

}
