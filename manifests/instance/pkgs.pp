# = Define: nodejs::instance::pkgs
#
# Ensures that all packages will be installed properly.
#
# == Parameters:
#
# [*install_ruby*]
#   Whether or not to load all the ruby dependencies.
#
# [*make_install*]
#   Whether or not to install all compiler-related dependencies.
#
# == Example:
#
# class { '::nodejs::instance::pkgs': }
#
class nodejs::instance::pkgs($install_ruby = false, $make_install = false) {
  if $caller_module_name != $module_name {
    warning('nodejs::instance::pkgs is private!')
  }

  ensure_packages(['tar', 'git', 'wget'], {
    ensure => installed,
  })

  if $install_ruby {
    ensure_packages(['ruby'], { ensure =>  installed })
    ensure_packages(['semver'], {
      ensure   => installed,
      provider => gem,
      require  => Package['ruby'],
    })
  }

  if $make_install {
    include ::gcc
    ensure_packages(['make'])
  }
}
