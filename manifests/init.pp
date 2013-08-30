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
  $version      = undef,
  $target_dir   = undef,
  $with_npm     = true,
  $make_install = true,
) {

  nodejs::install { "nodejs-${version}":
    version       => $version,
    target_dir    => $target_dir,
    with_npm      => $with_npm,
    make_install  => $make_install,
  }
}
