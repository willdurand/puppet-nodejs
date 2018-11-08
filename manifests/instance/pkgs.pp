# = Define: nodejs::instance::pkgs
#
# Ensures that all packages will be installed properly.
#
# == Parameters:
#
# [*make_install*]
#   Whether or not to install all compiler-related dependencies.
#
# == Example:
#
# class { '::nodejs::instance::pkgs': }
#
class nodejs::instance::pkgs(Boolean $make_install = false) {
  if $caller_module_name != $module_name {
    warning('nodejs::instance::pkgs is private!')
  }

  ensure_packages(['tar', 'wget'])

  if $make_install {
    # inherited from https://github.com/puppetlabs/puppetlabs-gcc/blob/master/manifests/params.pp,
    # but the module is abandoned and only supports Puppet3.
    $gcc_packages = $::osfamily ? {
      'RedHat' => ['gcc', 'gcc-g++'],
      'Debian' => ['gcc', 'build-essential'],
      default  => fail("Class['::nodejs::instances::pkgs']: unsupported osfamily: ${::osfamily}")
    }

    ensure_packages($gcc_packages)
    ensure_packages(['make'])
  }
}
