require 'spec_base'
require 'beaker-rspec'
require 'beaker-puppet'
require 'beaker/puppet_install_helper'
require 'beaker/module_install_helper'

run_puppet_install_helper
install_ca_certs
install_module_on(hosts)
install_module_dependencies_on(hosts)
