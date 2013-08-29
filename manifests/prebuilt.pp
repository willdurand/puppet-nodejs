# = Define: nodejs::prebuilt
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
# == Example:
#
#  nodejs::install { 'v0.10.17':
#    version => 'v0.10.17',
#  }
#
define nodejs::prebuilt (
  $version    = undef,
  $target_dir = undef,
  $with_npm   = true
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

  file { $::nodejs::params::install_dir:
    ensure => directory,
    owner  => root,
    group  => root,
    mode   => '0644',
  }

  $node_filename = "node-${node_version}-${node_os}-${node_arch}.tar.gz"
  $node_download_command = "wget http://nodejs.org/dist/${node_version}/${node_filename}"
  $node_unpack_command = "tar -xzf ${node_filename}"

  exec { "node-download-${node_version}-${node_os}-${node_arch}":
    command   => $node_download_command,
    path      => '/usr/bin:/bin:/usr/sbin:/sbin',
    cwd       => $::nodejs::params::install_dir,
    user      => 'root',
    unless    => "test -f ${node_filename}",
    require   => File[$::nodejs::params::install_dir],
  }

  file { "${::nodejs::params::install_dir}/${node_filename}":
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0644',
    require => Exec["node-download-${node_version}-${node_os}-${node_arch}"];
  }

  exec { "node-unpack-${node_version}-${node_os}-${node_arch}":
    command => $node_unpack_command,
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    cwd     => $::nodejs::params::install_dir,
    user    => 'root',
    unless  => "test -d node-${node_version}-${node_os}-${node_arch}",
    require => File["${::nodejs::params::install_dir}/${node_filename}"],
  }

  file { "${::nodejs::params::install_dir}/node-${node_version}-${node_os}-${node_arch}":
    ensure  => directory,
    owner   => root,
    group   => root,
    mode    => '0755',
    require => Exec["node-unpack-${node_version}-${node_os}-${node_arch}"],
  }

  exec { "node-symlink-bin-${node_version}-${node_os}-${node_arch}":
    command => "ln -f -s ${::nodejs::params::install_dir}/node-${node_version}-${node_os}-${node_arch}/bin/node ${node_target_dir}/node",
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    user    => 'root',
    require => File["${::nodejs::params::install_dir}/node-${node_version}-${node_os}-${node_arch}"],
  }

  file { "${node_target_dir}/node":
    ensure  => link,
    target  => "${::nodejs::params::install_dir}/node-${node_version}-${node_os}-${node_arch}/bin/node",
    require => Exec["node-symlink-bin-${node_version}-${node_os}-${node_arch}"]
  }

  if ($with_npm) {

    exec { 'npm-download':
      command => 'wget --no-check-certificate https://npmjs.org/install.sh',
      path    => '/usr/bin:/bin:/usr/sbin:/sbin',
      cwd     => $::nodejs::params::install_dir,
      user    => 'root',
      unless  => "test -f ${::nodejs::params::install_dir}/install.sh",
      require => Exec["node-symlink-bin-${node_version}-${node_os}-${node_arch}"],
    }

    # caveats to upgrade npm
    exec { 'npm-install':
      command     => 'sh install.sh',
      path        => '/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin',
      cwd         => $::nodejs::params::install_dir,
      user        => 'root',
      require     => Exec['npm-download'],
      environment => 'clean=yes',
      unless      => 'which npm',
    }

    file { "${node_target_dir}/npm":
      ensure  => link,
      require => Exec["npm-install"],
    }

  }

}
