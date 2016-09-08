# = Define: nodejs::instance::pkgs
#
# Ensures that all packages will be installed properly.
#
# == Example:
#
# class { '::nodejs::instance::pkgs': }
#
class nodejs::instance::pkgs {
  if $caller_module_name != $module_name {
    warning('nodejs::instance::pkgs is private!')
  }

  ensure_packages(['curl', 'tar', 'git', 'ruby'], {
    ensure => installed,
  })
  ensure_packages(['semver'], {
    ensure   => installed,
    provider => gem,
    require  => Package['ruby'],
  })
}
