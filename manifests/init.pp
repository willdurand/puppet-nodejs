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
# [*build_from_source*]
#   If false, will install from nodejs.org binary distributions
#
# [*node_target_dir_prefix*]
#   For prebuilt installation, where to prefix the file extraction
#
# [*os*]
#   For prebuilt installation, OS type: linux, sunos, darwin
#
# [*arch*]
#   For prebuilt installation, Architecture type: x86, x64

# [*npm_modules*]
#   An array of modules to npm install globally
# == Example:
#
#  include nodejs
#
#  class { 'nodejs':
#    version     => 'v0.8.0',
#    npm_modules => ['forever', 'stuff']
#  }
#
class nodejs (
$version    = 'UNDEF',
$target_dir = 'UNDEF',
$with_npm   = true,
$build_from_source = false,
$target_dir_prefix = 'UNDEF',
$os = 'UNDEF',
$arch = 'UNDEF',
$npm_modules = undef
) {

  if $build_from_source {

    nodejs::install { "nodejs-${version}":
      version    => $version,
      target_dir => $target_dir,
      with_npm   => $with_npm
    }

  } else {

    nodejs::prebuilt { "nodejs-${version}-${os}-${arch}":
      version           => $version,
      target_dir_prefix => $target_dir_prefix,
      os                => $os,
      arch              => $arch
    }

  }

  if $npm_modules != undef {

    Package {
    ensure    => 'installed',
    provider  => 'npm'
    }

    package { $npm_modules: }

  }

}