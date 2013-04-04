# = Define: nodejs::install
#
# == Parameters:
#
# [*version*]
#   The NodeJS version ('vX.Y.Z' or 'latest').
#
# [*target_dir*]
#   Where to install the executables.
#
# [*with_npm*]
#   Whether to install NPM.
#
# == Example:
#
#  nodejs::install { 'v0.8.0':
#    version => 'v0.8.0',
#  }
#
define nodejs::install (
  $version    = 'UNDEF',
  $target_dir = 'UNDEF',
  $with_npm   = true
) {

  include nodejs::params

  $node_version = $version ? {
    'UNDEF' => 'latest',
    default => $version
  }

  $node_target_dir = $target_dir ? {
    'UNDEF' => $::nodejs::params::target_dir,
    default => $target_dir
  }

  file { $::nodejs::params::install_dir:
    ensure => directory,
    owner  => root,
    group  => root,
    mode   => '0644',
  }

  $node_download_command = $node_version ? {
    'latest' => "wget http://nodejs.org/dist/node-${node_version}.tar.gz",
    default  => "wget http://nodejs.org/dist/${node_version}/node-${node_version}.tar.gz"
  }

  $node_unpack_command = $node_version ? {
    'latest' => "tar xzvf node-${node_version}.tar.gz && mv `ls -rd node-v*` node-${node_version}",
    default  => "tar xzvf node-${node_version}.tar.gz"
  }

  exec { "node-download-${node_version}":
    command   => $node_download_command,
    path      => '/usr/bin:/bin:/usr/sbin:/sbin',
    cwd       => $::nodejs::params::install_dir,
    user      => 'root',
    unless    => "test -f node-${node_version}.tar.gz",
    require   => File[$::nodejs::params::install_dir],
  }

  exec { "node-unpack-${node_version}":
    command => $node_unpack_command,
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    cwd     => $::nodejs::params::install_dir,
    user    => 'root',
    unless  => "test -d node-${node_version}",
    require => Exec["node-download-${node_version}"],
  }

  exec { "node-install-${node_version}":
    command => 'python configure && make install',
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    cwd     => "${::nodejs::params::install_dir}/node-${node_version}",
    user    => 'root',
    unless  => "test -f ${::nodejs::params::install_dir}/node-${node_version}/node",
    timeout => 0,
    require => Exec["node-unpack-${node_version}"],
  }

  exec { "node-symlink-bin-${node_version}":
    command => "ln -s ${::nodejs::params::install_dir}/node-${node_version}/node ${node_target_dir}/node-${node_version}",
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    user    => 'root',
    unless  => "test -L ${node_target_dir}/node-${node_version}",
    require => Exec["node-install-${node_version}"],
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
  }
}
