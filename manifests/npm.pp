# = Define: nodejs::npm
#
# == Parameters:
#
# [*npm_modules_array*]
#   ['mod1','mod2','etc']
#
# == Example:
#
#  nodejs::npm { 'forever' }
#
define nodejs::npm (
  $module_name = ''
) {

  include nodejs::params

  exec { "npm-module":
    command   => "npm install -g ${module_name}",
    path      => '/usr/bin:/bin:/usr/sbin:/sbin',
    user      => 'root',
    unless    => "test -d /usr/local/bin/node_modules/${module_ename}",
  }

}