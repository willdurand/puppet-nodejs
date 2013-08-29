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
# == Example:
#
#  nodejs::install { 'v0.10.17':
#    version => 'v0.10.17',
#  }
#
define nodejs::install (
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

  file { $::nodejs::params::install_dir:
    ensure => directory,
    owner  => root,
    group  => root,
    mode   => '0644',
  }

  $node_filename = "node-${node_version}.tar.gz"
  $node_download_command = "wget http://nodejs.org/dist/${node_version}/${node_filename}"
  $node_unpack_command = "tar xzvf ${node_filename}"

  exec { "node-download-${node_version}":
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
    require => Exec["node-download-${node_version}"];
  }

  exec { "node-unpack-${node_version}":
    command => $node_unpack_command,
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    cwd     => $::nodejs::params::install_dir,
    user    => 'root',
    unless  => "test -d node-${node_version}",
    require => File["${::nodejs::params::install_dir}/${node_filename}"],
  }

  file { "${::nodejs::params::install_dir}/node-${node_version}":
    ensure  => directory,
    owner   => root,
    group   => root,
    mode    => '0755',
    require => Exec["node-unpack-${node_version}"],
  }

  exec { "node-install-${node_version}":
    command => 'python configure && make install',
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    cwd     => "${::nodejs::params::install_dir}/node-${node_version}",
    user    => 'root',
    unless  => "test -f ${::nodejs::params::install_dir}/node-${node_version}/node",
    timeout => 0,
    require => File["${::nodejs::params::install_dir}/node-${node_version}"],
  }

  exec { "node-symlink-bin-${node_version}":
    command => "ln -f -s ${::nodejs::params::install_dir}/node-${node_version}/node ${node_target_dir}/node",
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    user    => 'root',
    require => Exec["node-install-${node_version}"],
  }

  file { "${node_target_dir}/node":
    ensure  => link,
    target  => "${::nodejs::params::install_dir}/node-${node_version}/node",
    require => Exec["node-symlink-bin-${node_version}"]
  }

  if ($with_npm) {

    exec { 'npm-download':
      command => 'wget --no-check-certificate https://npmjs.org/install.sh',
      path    => '/usr/bin:/bin:/usr/sbin:/sbin',
      cwd     => $::nodejs::params::install_dir,
      user    => 'root',
      unless  => "test -f ${::nodejs::params::install_dir}/install.sh",
      require => Exec["node-symlink-bin-${node_version}"],
    }

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
