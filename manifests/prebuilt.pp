# = Define: nodejs::prebuilt
#
# == Parameters:
#
# [*version*]
#   The NodeJS version ('vX.Y.Z' or 'latest').
#
# [*node_target_dir_prefix*]
#   # For prebuilt installation, where to prefix the file extraction
#
# [*os*]
#   OS type: linux, sunos, darwin
#
# [*arch*]
#   Architecture type: x86, x64
#
# == Example:
#
#  nodejs::prebuilt { 'v0.10.12':
#    version => 'v0.10.12',
#  }
#
define nodejs::prebuilt (
  $version    = 'UNDEF',
  $target_dir_prefix = 'UNDEF',
  $os = 'UNDEF',
  $arch = 'UNDEF'
) {

  include nodejs::params

  $node_version = $version ? {
    'UNDEF' => 'v0.10.13',
    default => $version
  }

  $node_target_dir_prefix = $target_dir_prefix ? {
    'UNDEF' => $::nodejs::params::prebuilt_dir_prefix,
    default => $::nodejs::params::prebuilt_dir_prefix
  }

  $node_os = $os ? {
    'UNDEF' => $::nodejs::params::os,
    default => $os
  }

  $node_arch = $os ? {
    'UNDEF' => $::nodejs::params::arch,
    default => $arch
  }

  file { $::nodejs::params::install_dir:
    ensure => directory,
    owner  => root,
    group  => root,
    mode   => '0644',
  }

  $node_filename = "node-${node_version}-${node_os}-${node_arch}.tar.gz"
  $node_download_command = "wget http://nodejs.org/dist/${node_version}/${node_filename}"
  $node_unpack_command = "tar -xzf ${node_filename} -C ${node_target_dir_prefix} --strip-components=1"

  exec { "node-download-${node_version}-${node_os}-${node_arch}":
    command   => $node_download_command,
    path      => '/usr/bin:/bin:/usr/sbin:/sbin',
    cwd       => $::nodejs::params::install_dir,
    user      => 'root',
    unless    => "test -f ${node_filename}",
    require   => File[$::nodejs::params::install_dir],
  }

  ->

  exec { "node-unpack-${node_version}-${node_os}-${node_arch}":
    command => $node_unpack_command,
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    cwd     => $::nodejs::params::install_dir,
    user    => 'root',
    unless  => "test -f /usr/local/bin/node",
    require => Exec["node-download-${node_version}-${node_os}-${node_arch}"],
  }

  ->

  file { "/usr/bin/node":
    ensure  =>  "link",
    target  =>  "/usr/local/bin/node"
  }

  ->

  file { "/usr/bin/npm":
    ensure  =>  "link",
    target  =>  "/usr/local/bin/npm"
  }

}