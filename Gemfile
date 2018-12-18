source 'https://rubygems.org'

puppetVersion = ENV.key?('PUPPET_VERSION') ? ENV['PUPPET_VERSION'] : '~> 6.0.0'

group :devel do
  gem 'rake'

  gem 'puppet', puppetVersion
  gem 'puppet-lint'
  gem 'puppet-syntax'
  gem 'rspec-puppet'
  gem 'puppetlabs_spec_helper'
  gem 'iconv'

  gem 'webmock'
  gem 'puppet-blacksmith'

  gem 'coveralls', require: false

  gem 'rubocop'

  gem 'metadata-json-lint'
end

group :beaker do
  gem 'beaker'
  gem 'beaker-rspec'
  gem 'beaker-puppet'
  gem 'beaker-docker'
  gem 'beaker-puppet_install_helper'
  gem 'beaker-module_install_helper'
  gem 'serverspec'
end
