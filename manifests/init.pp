# = Class: nodejs
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
#  include nodejs
#
#  class { 'nodejs':
#    version => 'v0.8.0',
#  }
#
class nodejs (
  $version    = 'UNDEF',
  $target_dir = 'UNDEF',
  $with_npm   = true
) {

  nodejs::install { "nodejs-${version}":
    version    => $version,
    target_dir => $target_dir,
    with_npm   => $with_npm,
  }

   nodejs::prebuilt { "nodejs-${version}-${os}-${arch}":
    version    => $version,
    target_dir_prefix => $target_dir_prefix,
	os => $os,
	arch => $arch
  }

}
