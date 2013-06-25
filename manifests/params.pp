# = Class: nodejs::params
#
# This class defines default parameters used by the main module class nodejs.
# Operating Systems differences in names and paths are addressed here.
#
# == Variables:
#
# Refer to nodejs class for the variables defined here.
#
# == Usage:
#
# This class is not intended to be used directly.
# It may be imported or inherited by other classes.
#
class nodejs::params {
  # linux, sunos, darwin
  $os = 'linux'

  # x86, x64
  $arch = 'x64'

  # For prebuilt installation, where to prefix the file extraction
  $prebuilt_dir_prefix = '/usr/local/'

  $install_dir = '/usr/local/node'
  $target_dir  = '/usr/local/bin'
}

