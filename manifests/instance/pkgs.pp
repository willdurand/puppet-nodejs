# = Define: nodejs::instance::pkgs
#
# Ensures that all packages will be installed properly.
#
# == Parameters:
#
# [*contain_ruby*]
#   Whether or not to load all the ruby dependencies.
#
# == Example:
#
# class { '::nodejs::instance::pkgs': }
#
class nodejs::instance::pkgs($contain_ruby = false) {
  if $caller_module_name != $module_name {
    warning('nodejs::instance::pkgs is private!')
  }

  ensure_packages(['curl', 'tar', 'git'], {
    ensure => installed,
  })

  if $contain_ruby {
    ensure_packages(['ruby'], { ensure =>  installed })
    ensure_packages(['semver'], {
      ensure   => installed,
      provider => gem,
      require  => Package['ruby'],
    })
  }
}
