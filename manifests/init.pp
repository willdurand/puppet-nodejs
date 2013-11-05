# = Class: nodejs
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
#  include nodejs
#
#  class { 'nodejs':
#    version  => 'v0.10.17'
#  }
#
class nodejs (
  $version      = 'stable',
  $target_dir   = '/usr/local/bin',
  $with_npm     = true,
  $make_install = true,
) {

  nodejs::install { "nodejs-${version}":
    version       => $version,
    target_dir    => $target_dir,
    with_npm      => $with_npm,
    make_install  => $make_install,
  }

  $node_version = $version ? {
    undef     => $::nodejs_stable_version,
    'stable'  => $::nodejs_stable_version,
    'latest'  => $::nodejs_latest_version,
    default   => $version
  }

  file { '/usr/local/node/node-current':
    ensure  => 'link',
    target  => "/usr/local/node/node-${$node_version}",
    require => Nodejs::Install["nodejs-${version}"],
  }

  file_line { 'node-bin-in-path':
    path  => '/etc/profile',
    line  => 'export PATH="/usr/local/node/node-current/bin:$PATH"'
  }

}
